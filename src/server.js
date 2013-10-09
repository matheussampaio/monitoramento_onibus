try {
    var express = require('express');
} catch(e) {
    console.error("Express is not found. You should install: npm install express");
    process.exit(e.code);
}

try {
    var pg = require('pg');
} catch(e) {
    console.error("pg is not found. You should install: npm install pg");
    process.exit(e.code);
}

var conString = "postgres://matheussampaio:sampaio@192.168.1.244:5432/gonibus";

var client = new pg.Client(conString);
client.connect();

var server = express();

// Configura o servidor.
server.configure(function(){
    server.set('views', __dirname + '/www/html/');
    server.engine('html', require('ejs').renderFile);
    server.use(express.bodyParser());
    server.use(express.methodOverride());
});

// Define o get para a pagina principal: apenas retorna o index
server.get('/', function(req, res){
    res.render('index.html');

});



 server.get('/adicionar', function(req, res) {
    res.render('admin.html');
 });

server.get('/verHorarios', function(req,res){
  client.query("SELECT * FROM TempoToPontoOnibus", function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.render('horarios.html', {result: result.rows});
    });
});

server.post('/addCoordsParaNovaRota', function(req, res) {
  
  var coordenadas = req.body.coords;
  var numOnibus = req.body.onibus;
  console.log(coordenadas);
  console.log(numOnibus);

  var inserir = "INSERT INTO Rota VALUES (DEFAULT, '"+numOnibus+"', ST_GeomFromText('LINESTRING("+coordenadas+")', 4291)";
  var view = "CREATE OR REPLACE VIEW rota"+numOnibus+"view AS SELECT id_rota, nome, ST_GeomFromText(ST_AsText(geom), 4291) AS geom FROM rota WHERE nome = '"+numOnibus+"'";
  client.query(inserir);
  client.query(view);
  res.redirect('/');
});

server.post('/adicionarNovoPonto', function(req, res) {
  var coordenada = req.body.lati+" "+req.body.longi;
  console.log(coordenada);
  var inserir = "INSERT INTO PontoOnibus VALUES (DEFAULT, NULL, ST_GeomFromText('POINT ("+coordenada+")' ,4291))"
  client.query(inserir);
  res.redirect('/');
});
  

server.post('/adicionarOnibus', function(req, res) {
  var placa = req.body.placaOni;
  var numero = req.body.numLinha;
  console.log(placa);
  console.log(numero);
  var inserir = "INSERT INTO Onibus VALUES (DEFAULT, (SELECT id_rota FROM Rota WHERE nome = '"+numero+"'), '"+placa+"');"
  client.query(inserir);
  res.redirect('/');
});


server.get('/fugarota', function(req, res) {

    client.query("SELECT DISTINCT ON (f.id_onibus) o.id_onibus, o.placa, f.time FROM FugaRota f, Onibus o WHERE o.id_onibus = f.id_onibus AND resolvido = FALSE ORDER BY f.id_onibus, f.time DESC;", function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.render('fugarota.html', {result: result.rows});
    });
});

server.post('/fugarota', function(req, res) {
    var idOnibus = req.body.idOnibus;

    var query = "UPDATE FugaRota SET resolvido = TRUE WHERE id_onibus = " + idOnibus + " AND resolvido = FALSE";

    client.query (query, function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.redirect('/fugarota');
    });

});

server.get('/onibus', function(req, res) {
    var placa = req.query.placa;

    var query = "SELECT * FROM Onibus WHERE placa = '" + placa + "'";

    client.query(query, function(err, result) {
        if (err) {
            res.send(err);
        } else {
            res.send(result.rows);
        }

    });
});

// Inicia o servidor na porta 3001.
server.listen(3001, function() {
    console.log("Server on.");
    console.log("http://localhost:3001");
});
