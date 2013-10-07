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





server.post('/addCoordsParaNovaRota', function(req, res) {
   
  console.log(req.body.coords);
  console.log(req.body.onibus);
  var coordenadas = req.body.coords;
  var numOnibus = req.body.onibus;
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





// Inicia o servidor na porta 3001.
server.listen(3001, function() {
    console.log("Server on.");
});
