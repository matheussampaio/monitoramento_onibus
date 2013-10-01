var express = require('express');
var server = express();

// Configura o servidor.
server.configure(function(){
    server.set('views', __dirname + '/www/html/');
    server.set('view engine', 'ejs');
    server.set('view options', {layout: false});
    server.use(express.bodyParser());
    server.use(express.methodOverride());
});

// Define o get para a pagina principal: apenas retorna o index
server.get('/', function(req, res){
    res.render('index');
});

// Inicia o servidor na porta 3001.
server.listen(3001, function() {
    console.log("Server on.");
});