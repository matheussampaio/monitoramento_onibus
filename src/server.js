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

//conta o número de rotas criadas
var contadorDeRota = 4;


// Configura o servidor.
server.configure(function(){
    server.set('views', __dirname + '/www/html/');
    server.engine('html', require('ejs').renderFile);
    server.use(express.bodyParser());
    server.use(express.methodOverride());
});

// Define o get para a pagina principal: apenas retorna o index
server.get('/', function(req, res){
    res.render('index.html',{result: new Array()});

});



server.get('/criar', function(req, res) {
  res.render('admin.html');
});


server.get('/verHorarios', function(req,res){
  var query = "SELECT t.id_onibus, t.id_pontoonibus, to_char(t.tempo, 'HH24:MM:SS DD/MM/YY') AS tempo, t.nome, o.placa FROM TempoToPontoOnibus t, Onibus o WHERE t.tempo IS NOT NULL AND t.id_onibus = o.id_onibus";

  client.query(query, function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.render('horarios.html', {result: result.rows});
    });
});

server.get('/filtrar', function(req,res){
  
  var filtro = req.body.filtro;
 
     var query = "SELECT id_onibus, id_pontoonibus, to_char(tempo, 'HH24:MM:SS DD/MM/YY') AS tempo, nome FROM TempoToPontoOnibus WHERE tempo IS NOT NULL AND nome ='"+filtro+"'";

  client.query(query, function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.render('horarios.html', {result: result.rows});
    });
});

//sai da pagina de error e vai para pagina de adicionar
server.get('/voltar', function(req, res) {
    res.render('admin.html');
});

//recebe dados para adicionar uma nova rota de ônibus
server.post('/addCoordsParaNovaRota', function(req, res) {
  var coordenadas = req.body.coords;
  var numOnibus = req.body.onibus;

  //checa os dados que vieram da UI, se não passar fica na mesma pagina
  if(isNaN(parseInt(coordenadas)) || coordenadas=="" || isNaN(parseInt(numOnibus)) || numOnibus==""){
    res.render('admin.html');

  // se passar tenta inserir no banco de dados e criar uma view
  }else{

    var inserir = "INSERT INTO Rota VALUES (DEFAULT, '"+numOnibus+"', ST_GeomFromText('LINESTRING ("+coordenadas+")', 4291), "+contadorDeRota+")";
    var view = "CREATE OR REPLACE VIEW rota"+numOnibus+"view AS SELECT id_rota, nome, ST_GeomFromText(ST_AsText(geom), 4291) AS geom FROM rota WHERE nome = '"+numOnibus+"'";
    contadorDeRota++;
    console.log(contadorDeRota);
    client.query(inserir, function(err, result) {
                if (err) {
                    res.render('error.html',{erro: err});                
                } else {
                    console.log('sem erro');
                    res.redirect('/');
                }
    }); 
    client.query(view ,function(err, result) {
                if (err) {
                    res.render('sem erro',{erro: err});                
                } else {
                    console.log('blz');
                    res.redirect('/');
                }
    }); 


    //ALGO PARA PUBLICA NO GEOSERVER
   /* client.query("SELECT nome FROM Rota", function(err,result){
    console.log(result.rows)
    res.render('index.html',{result: result.rows})*/
  }
});

//recebe dados para criar um novo ponto
server.post('/criarNovoPonto', function(req, res) {
  var coordenada = req.body.lati+" "+req.body.longi;
  var idPonto = req.body.idponto;

  //checa os dados que vieram da UI, se não passar fica na mesma pagina
  if(isNaN(parseInt(req.body.lati)) || req.body.lati=="" || isNaN(parseInt(req.body.longi)) || req.body.longi=="" || isNaN(parseInt(idPonto)) || idPonto==""){
    res.render('admin.html');

  //se passar tenta inserir no banco de dados
  }else{
    var inserir = "INSERT INTO PontoOnibus VALUES ("+idPonto+", DEFAULT, ST_GeomFromText('POINT ("+coordenada+")' ,4291))";
    client.query(inserir, function(err, result) {
                if (err) {
                  res.render('error.html',{erro: err});              
                } else {
                    console.log('sem erro');
                    res.redirect('/');
                }
    }); 
  }
});

//adiciona um novo ônibus a uma rota
server.post('/adicionarOnibus', function(req, res) {
  var placa = req.body.placaOni;
  var numero = req.body.numLinha;

  //checa os dados que vieram da UI, se não passar fica na mesma pagina
  if(placa=="" || isNaN(parseInt(numero)) || numero==""){
    res.render('admin.html');

  //se passar tenta inserir no banco de dados
  }else{

    var inserir = "INSERT INTO Onibus VALUES (DEFAULT, (SELECT id_rota FROM Rota WHERE nome = '"+numero+"'), '"+placa+"')";
    
    client.query(inserir, function(err, result) {
                if (err) {
                  /*var msgErro = "";
                  if(err.severity == "ERROR") msgErro="esta linha não existe";*/
                  res.render('error.html',{erro: err});                
                } else {
                    console.log('sem erro');
                    res.redirect('/');
                }
    }); 

  }
});


//recebe dados para adicionar um ponto a uma rota
server.post('/addPontoRota', function(req, res) {
  var linha = req.body.numLinha;
  var idPonto1 = req.body.idponto1;
  var idPonto2 = req.body.idponto2;
  var idPonto3 = req.body.idponto3;

  //checa os dados que vieram da UI, se não passar fica na mesma pagina
  if(linha=="" || isNaN(parseInt(idPonto1)) || idPonto1=="" || isNaN(parseInt(idPonto2)) || idPonto2=="" || isNaN(parseInt(idPonto3)) || idPonto3==""){
    res.render('admin.html');

  //se passar tenta inserir no banco de dados
  }else{

    var inserir = "INSERT INTO PontoOnibus_Rota VALUES ((SELECT id_rota FROM Rota WHERE nome = '"+linha+"'), "+idPonto1+", "+idPonto3+")";
    client.query(inserir, function(err, result) {
                if (err) {
                  res.render('error.html',{erro: err});              
                } else {
                    console.log('sem erro');
                    res.redirect('/');
                }
    });
/*    "UPDATE PontoOnibus_Rota SET next_id_pontoonibus = "+idPonto1+" WHERE id_pontoonibus = "+idPonto2+""*/
    var atualiza =  "UPDATE PontoOnibus_Rota SET next_id_pontoonibus = "+idPonto1+" WHERE id_pontoonibus = "+idPonto2+"";
    client.query(atualiza, function(err, result) {
                if (err) {
                  res.render('error.html',{erro: err});              
                } else {
                    console.log('sem erro');
                    res.redirect('/');
                }
    });

  }
});


server.get('/fugarota', function(req, res) {

    client.query("SELECT f.id_fugarota, o.id_onibus, o.placa, to_char(f.horarioinicio, 'HH24:MM:SS DD/MM/YY') AS horarioInicio, to_char(f.horarioFinal, 'HH24:MM:SS DD/MM/YY') AS horarioFinal FROM FugaRota f, Onibus o WHERE o.id_onibus = f.id_onibus AND resolvido = FALSE ORDER BY f.id_onibus, f.horarioinicio DESC;", function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.render('fugarota.html', {result: result.rows});
    });
});

server.post('/fugarota', function(req, res) {
    var idFugaRota = req.body.idFugaRota;
    var idOnibus = req.body.idOnibus;

    var query1 = "UPDATE FugaRota SET resolvido = TRUE WHERE id_fugarota = " + idFugaRota + " AND resolvido = FALSE";
    var query2 = "UPDATE Onibus SET statusFuga = FALSE WHERE id_onibus = " + idOnibus;

    client.query (query1, function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        client.query(query2, function(err2, result2) {
            if (err2) {
                return console.log("Error runing query", err2);
            }

            res.redirect('/fugarota');
        });
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
