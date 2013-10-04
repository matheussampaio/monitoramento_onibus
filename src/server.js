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



server.post('/enviarNovoPonto', function(req, res) {
   var coordenada = req.body.lati+" "+req.body.longi
   var inserir = "INSERT INTO PontoOnibus VALUES (DEFAULT, NULL, ST_GeomFromText('POINT ("+coordenada+")' ,4291))"
   client.query(inserir);
   res.redirect('/');
});
  

// var coordenadas = new Array();  
// var indice = 0

// server.post('/enviarNovaRota', function(req, res) {
//    var latitude = req.body.lati;
//    var longitude = req.body.longi;

//    console.log(latitude+" "+ longitude);


//     res.render('index.html');
// });

// Inicia o servidor na porta 3001.
server.listen(3001, function() {
    console.log("Server on.");
});
