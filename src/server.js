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

server.get('/admin', function(req, res) {
    res.render('admin.html');
});

server.get('/fugarota', function(req, res) {

    client.query("SELECT DISTINCT ON (f.id_onibus) o.id_onibus, o.placa, f.time FROM FugaRota f, Onibus o WHERE o.id_onibus = f.id_onibus AND resolvido = FALSE ORDER BY f.id_onibus, f.time DESC;", function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.render('fugarota.html', {result: result.rows});
    });
});

server.put('/fugarota', function(req, res) {
    var idOnibus = req.body.idOnibus;

    var query = "UPDATE FugaRota SET resolvido = TRUE WHERE id_onibus = " + idOnibus + " AND resolvido = FALSE";

    client.query (query, function(err, result) {
        if (err) {
            return console.log("Error runing query", err);
        }

        res.redirect('/fugarota');
    });

});

// Inicia o servidor na porta 3001.
server.listen(3001, function() {
    console.log("Server on.");
    console.log("http://localhost:3001");
});