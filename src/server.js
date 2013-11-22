try {
  var flash = require('connect-flash');
} catch(e) {
  console.error("Connect-Flash is not found. You should install: npm install connect-flash");
  process.exit(e.code);
}

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

var myArgs = process.argv.slice(2);

if (myArgs[0]) {
  geoserverIP = myArgs[0];
} else {
  geoserverIP = "localhost:8080";
}

var conString = "postgres://postgres@localhost:5432/gonibus";

var client = new pg.Client(conString);
client.connect();

var server = express();

// Configura o servidor.
server.configure(function(){
  server.set('views', __dirname + '/www/html/');
  server.engine('html', require('ejs').renderFile);
  server.use(express.bodyParser());
  server.use(express.methodOverride());
  server.use('/img',express.static(__dirname + '/public/img'));
  server.use('/js',express.static(__dirname + '/public/js'));
  server.use('/css',express.static(__dirname + '/public/css'));
  server.use(express.cookieParser('keyboard cat'));
  server.use(express.session({ cookie: { maxAge: 60000 }}));
  server.use(flash());
});

// Define o get para a pagina principal: apenas retorna o index
server.get('/', function(req, res) {
  res.redirect('/home');
});

server.get('/home', function(req, res){
  var query = "SELECT nome FROM Rota;";
  client.query(query, function(err, result) {
    if (err) {
      console.log(err);
    } else {
      res.render('index.html', {result: result.rows, geoIP: geoserverIP});
    }
  });
});

server.get('/admin', function(req, res) {
  client.query("SELECT f.id_fugarota, o.id_onibus, o.placa, to_char(f.horarioinicio, 'HH24:MI:SS DD/MM/YY') AS horarioInicio, to_char(f.horarioFinal, 'HH24:MI:SS DD/MM/YY') AS horarioFinal FROM FugaRota f, Onibus o WHERE o.id_onibus = f.id_onibus AND resolvido = FALSE ORDER BY f.id_onibus, f.horarioinicio DESC;", function(err, result) {
    if (err) {
      res.render('error.html', {erro: err});
    } else {
      client.query("SELECT f.id_fugarota, o.id_onibus, o.placa, to_char(f.horarioinicio, 'HH24:MI:SS DD/MM/YY') AS horarioInicio, to_char(f.horarioFinal, 'HH24:MI:SS DD/MM/YY') AS horarioFinal FROM FugaRota f, Onibus o WHERE o.id_onibus = f.id_onibus AND resolvido ORDER BY f.id_onibus, f.horarioinicio DESC;", function(err2, result2) {
        if (err2) {
          res.render('error.html', {erro: err2});
        } else {
          client.query("SELECT o.id_onibus, o.placa, o.current_status, o.statusfuga, r.nome FROM Onibus o, Rota r WHERE o.id_rota = r.id_rota ORDER BY o.placa;", function(err3, result3) {
            if (err3) {
              res.render('error.html', {erro: err3});
            } else {
              client.query("SELECT id_rota, nome, first_pontoonibus FROM rota;", function(err4, result4) {
                if (err4) {
                  res.render('error.html', {erro: err4});
                } else {
                  client.query("SELECT id_pontoonibus, nome, ST_AsText(geom) AS pos FROM PontoOnibus;", function(err5, result5) {
                    if (err5) {
                      res.render('error.html', {erro: err5});
                    } else {
                      client.query("SELECT o.placa, h.* FROM Horario h, Onibus o WHERE h.id_onibus = o.id_onibus;", function(err6, result6) {
                        if (err6) {
                          res.render('error.html', {erro: err6});
                        } else {
                          client.query("SELECT * FROM PontoOnibus_Rota;", function(err7, result7) {
                            if (err7) {
                              res.render('error.html', {erro: err7});
                            } else {
                              res.render('admin.html', {fugarota: result.rows, fugarotahistorico: result2.rows, onibus: result3.rows, rotas: result4.rows, pontoonibus: result5.rows, horarios: result6.rows, pontoonibusrota: result7.rows , messageSuccess: req.flash('success'), messageError: req.flash('error'), inPage: req.flash('page')});
                            }
                          });
                        }
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
    }
  });
});

// Recebe dados para adicionar uma nova rota de ônibus
server.post('/adicionarRotaOnibus', function(req, res) {
  var coordenadas = req.body.coordenadas;
  var novaRota = req.body.novaRota;
  var pontoInicial = req.body.pontoInicial;

  var inserir = "INSERT INTO Rota VALUES (DEFAULT, '"+novaRota+"', "+pontoInicial+", ST_GeomFromText('LINESTRING ("+coordenadas+")', 4291) )";
  var inserirPontoNaRota = "INSERT INTO PontoOnibus_Rota VALUES ((SELECT id_rota FROM Rota WHERE nome = '" + novaRota + "'), " + pontoInicial + ", " + pontoInicial + ")";
  var view = "CREATE OR REPLACE VIEW rota"+novaRota+"view AS SELECT id_rota, nome, ST_GeomFromText(ST_AsText(geom), 4291) AS geom FROM rota WHERE nome = '"+novaRota+"'";

  client.query(inserir, function(err1, result1) {
    if (err1) {
      var msgErro = "";

      if(err1 == 'error: duplicate key value violates unique constraint "nome_unico_rota"') {
        msgErro = "Este linha já existe, escolha outro identificador";
      } else if (err1 == 'error: insert or update on table "rota" violates foreign key constraint "rota_first_pontoonibus_fkey"') {
        msgErro = "O ponto de ônibus passado deve ser de um ponto já existente";
      } else if (err1 == 'error: geometry requires more points') {
        msgErro = "Insira ao menos duas coordenadas para início e fim de rota";
      } else if (err1 == 'error: parse error - invalid geometry') {
        msgErro = "A coordenadas passadas são inválidas";
      }else if (err1 == 'error: first_pontoonibus not in rota'){
        msgErro = "O primeiro ponto de ônibus deve pertencer a rota.";
      }
      else{
        msgErro = err1.error;
      }

      req.flash('page', 'rota');
      req.flash('error', msgErro);
      res.redirect('/admin');
    } else {
      client.query(inserirPontoNaRota,function(err2, result2) {
        if (err2) {
          req.flash('page', 'rota');
          req.flash('error', "Ponto de Ônibus não pertence a Rota.");
          res.redirect('/admin');
        } else {
           client.query(view ,function(err3, result3) {
            if (err3) {
              req.flash('page', 'rota');
              req.flash('error', err3.detail);
              res.redirect('/admin');
            } else {
              req.flash('page', 'rota');
              req.flash('success', 'Rota adicionada com sucesso.');
              res.redirect('/admin');
            }
          });
        }
      });
    }
  });
});

//Remover rota
server.post('/removerRota',function(req,res) {
  var idRota = req.body.idRota;

  var deleteEmOnibus = "DELETE FROM Onibus WHERE id_rota = '" + idRota + "';";
  var deleteEmPontoRota = "DELETE FROM PontoOnibus_Rota WHERE id_rota = '" + idRota + "';";
  var deleteRota = "DELETE FROM Rota WHERE id_rota = '" + idRota + "';";

  client.query (deleteEmOnibus, function(err, result) {
    if (err) {
      req.flash('page', 'rota');
      req.flash('error', err);
      res.redirect('/admin');
    } else {
      client.query (deleteEmPontoRota, function(err2, result2) {
        if (err2) {
          req.flash('page', 'rota');
          req.flash('error', err2);
          res.redirect('/admin');
        } else {
          client.query (deleteRota, function(err3, result3) {
            if (err3) {
              req.flash('page', 'rota');
              req.flash('error', err3);
              res.redirect('/admin');
            } else {
              req.flash('page', 'rota');
              req.flash('success', 'Rota removida com sucesso.');
              res.redirect('/admin');
            }
          });
        }
      });
    }
  });
});

//Remover o ponto de uma rota de ônibus
server.post('/removerPontoRota',function(req,res) {
  var idPonto = req.body.idPonto;
  var nomeRota = req.body.nomeRota;
  var idRota = req.body.idRota;
  var anterior = "";
  var proximo = "";

  var verificaPrimeiro = "SELECT * FROM Rota WHERE first_pontoonibus = '" + idPonto + "' AND nome = '" + nomeRota + "';";
  var pegaAnterior = "SELECT id_pontoonibus FROM PontoOnibus_Rota WHERE next_id_pontoonibus = '" + idPonto + "' AND id_rota = '" + idRota + "';";
  var pegaProximo = "SELECT next_id_pontoonibus FROM PontoOnibus_Rota WHERE id_pontoonibus = '"+ idPonto + "' AND id_rota = '" + idRota + "';";
  var deleteEmPontoRota = "DELETE FROM PontoOnibus_Rota WHERE id_pontoonibus = '" + idPonto + "';";

  client.query (verificaPrimeiro, function(err1, result1) {
    if(err1){
      req.flash('page', 'rota');
      req.flash('error', err2);
      res.redirect('/admin');
    }else{
      if (result1.rowCount == 1 ) {
        req.flash('page', 'rota');
        req.flash('error', "Este Ponto de Ônibus é o inicial e não pode ser deletado.");
        res.redirect('/admin');
      } else {
        client.query (pegaAnterior, function(err2, result2) {
          if (err2) {
            req.flash('page', 'rota');
            req.flash('error', err2);
            res.redirect('/admin');
          } else {
            anterior = result2.rows[0].id_pontoonibus.toString();
            client.query (pegaProximo, function(err3, result3) {
              if (err3) {
                req.flash('page', 'rota');
                req.flash('error', err3);
                res.redirect('/admin');
              } else {
                proximo = result3.rows[0].next_id_pontoonibus.toString();
                var atualiza = "UPDATE PontoOnibus_Rota SET next_id_pontoonibus = '" + proximo + "' WHERE id_pontoonibus = '" + anterior + "' AND id_rota = '" + idRota + "';";
                client.query (atualiza, function(err4, result4) {
                  if (err4) {
                    if(err4 == 'error: duplicate key value violates unique constraint "pontoonibus_rota_pk"'){
                      client.query ("DELETE FROM PontoOnibus_Rota WHERE id_pontoonibus = '" + idPonto + "' AND id_rota = '" + idRota + "';", function(err5, result5) {
                        if (err5) {
                          req.flash('page', 'rota');
                          req.flash('error', err5);
                          res.redirect('/admin');
                        } else {
                          req.flash('page', 'rota');
                          req.flash('success', 'Ponto de Ônibus removido da Rota com sucesso.');
                          res.redirect('/admin');
                        }
                      });
                    }
                  } else {
                    client.query (deleteEmPontoRota, function(err7, result7) {
                      if (err7) {
                        req.flash('page', 'rota');
                        req.flash('error', err7);
                        res.redirect('/admin');
                      } else {
                        req.flash('page', 'rota');
                        req.flash('success', 'Ponto de Ônibus removido da Rota com sucesso.');
                        res.redirect('/admin');
                      }
                    });
                  }
                });
              }
            });
          }
        });
      }
    }
  });
});

//recebe dados para adicionar um ponto a uma rota
server.post('/adicionarPontoRota', function(req, res) {
  var numeroRota = req.body.numeroRota;
  var pontoNovo = req.body.pontoNovo;
  var pontoAnterior = req.body.pontoAnterior;
  var pontoPosterior = req.body.pontoPosterior;
  var atualiza =  "UPDATE PontoOnibus_Rota SET next_id_pontoonibus = " + pontoNovo + " WHERE id_pontoonibus = " + pontoAnterior + " AND id_rota = (SELECT id_rota FROM Rota WHERE nome = '" + numeroRota + "'AND next_id_pontoonibus = " + pontoPosterior + ");";

  client.query(atualiza, function(err1, result1) {
    if (err1) {
      var msgErro = "";
      if (err1 == 'error: next_id_pontoonibus not in rota') {
        msgErro = "O novo ponto está fora da rota";
      } else {
        msgErro = err1.detail;
      }
      req.flash('page', 'rota');
      req.flash('error', msgErro);
      res.redirect('/admin');
    } else  {
      if (result1.rowCount == 0) {
        req.flash('page', 'rota');
        req.flash('error', "Caminho de " + pontoAnterior + " para " + pontoPosterior + " não pertence a Rota.");
        res.redirect('/admin');
      } else {
        var inserir = "INSERT INTO PontoOnibus_Rota VALUES ((SELECT id_rota FROM Rota WHERE nome = '" + numeroRota + "'), " + pontoNovo + ", " + pontoPosterior + ")";
        client.query(inserir, function(err2, result2) {
          if (err2) {
            var msgErro = "";
            if (err2 == 'error: null value in column "id_rota" violates not-null constraint') {
              msgErro = "Esta linha não está cadastrada";
            } else if (err2 == 'error: id_pontoonibus not in rota') {
              msgErro = "Este ponto está fora da rota da linha";
            } else if (err2 == 'error: next_id_pontoonibus not in rota') {
              msgErro = "O ponto a frente está fora da rota da linha";
            } else if (err2 == 'error: duplicate key value violates unique constraint "pontoonibus_rota_pk"') {
              msgErro = "Já existe essta sequência na roda de ônibus";
            } else {
              msgErro = err2.detail;
            }
            req.flash('page', 'rota');
            req.flash('error', msgErro);
            res.redirect('/admin');
          } else {
            req.flash('page', 'rota');
            req.flash('success', 'Ponto adicionado a Rota com sucesso.');
            res.redirect('/admin');
          }

        });
      }
    }
  });
});

// Tela Horários
server.get('/horarios', function(req,res){
  var query = "SELECT t.id_onibus, t.id_pontoonibus, to_char(t.tempo, 'HH24:MI:SS DD/MM/YY') AS tempo, t.nome, o.placa FROM TempoToPontoOnibus t, Onibus o WHERE t.tempo IS NOT NULL AND t.id_onibus = o.id_onibus";

  client.query(query, function(err, result) {
    if (err) {
      return console.log("Error runing query", err);
    }
    res.render('horarios.html', {result: result.rows});
  });
});

// Adicionar um Horário a um Ônibus
server.post('/adicionarHorario', function(req, res) {
  var idOnibus = req.body.idOnibus;

  var index = 0;
  var idAdcPontoOnibus = "";
  var tempoAdcHorario = "";
  var query = "INSERT INTO Horario (id_horario, id_onibus, id_pontoonibus, tempo, seq) VALUES ";

  while (true) {
    index++;
    idAdcPontoOnibus = req.body["idAdcPontoOnibus" + index];
    tempoAdcHorario = req.body["tempoAdcHorario" + index];

    if (!idAdcPontoOnibus || !tempoAdcHorario) {
      break;
    } else {
      query += "(DEFAULT, " + idOnibus + ", " + idAdcPontoOnibus + ", (SELECT TIME '" + tempoAdcHorario + "'), " + index + "),";
    }
  }

  query = query.slice(0, -1) + ";";

  queryDelete = "DELETE FROM Horario WHERE id_onibus = " + idOnibus + ";";

  client.query(queryDelete, function(err, result) {
    if (err) {
      req.flash('page', 'horario');
      req.flash('error', err);
      res.redirect('/admin');
    } else {
      client.query(query, function(err1, result1) {
        if (err1) {
          req.flash('page', 'horario');
          req.flash('error', err1);
          res.redirect('/admin');
        } else {
          req.flash('page', 'horario');
          req.flash('success', "Horário adicionado com sucesso.");
          res.redirect('/admin');
        }
      });
    }
  });
});

// Atualizar Fuga de Rota como resolvido
server.post('/fugarota', function(req, res) {
  var idFugaRota = req.body.idFugaRota;
  var idOnibus = req.body.idOnibus;

  var query1 = "UPDATE FugaRota SET resolvido = TRUE WHERE id_fugarota = " + idFugaRota + " AND resolvido = FALSE";
  var query2 = "UPDATE Onibus SET statusFuga = FALSE WHERE id_onibus = " + idOnibus;

  client.query (query1, function(err, result) {
    if (err) {
      req.flash('page', 'fugarota');
      req.flash('error', err);
      res.redirect('/admin');
    } else {
      client.query(query2, function(err2, result2) {
        if (err2) {
          req.flash('page', 'fugarota');
          req.flash('error', err2);
          res.redirect('/admin');
        } else {
          req.flash('page', 'fugarota');
          req.flash('success', 'Fuga de Rota resolvida.');
          res.redirect('/admin');
        }
      });
    }
  });
});

// Adicionar um Ponto de Ônibus
server.post('/adicionarPontoOnibus', function(req, res) {
  var coordenada = req.body.latitude + " " + req.body.longitude;
  var nome = req.body.nomePontoOnibus;

  var inserir = "INSERT INTO PontoOnibus VALUES (DEFAULT, '" + nome + "', ST_GeomFromText('POINT (" + coordenada + ")' ,4291))";

  client.query(inserir, function(err, result) {
    if (err) {
      req.flash('page', 'pontoonibus');
      req.flash('error', err.detail);
      res.redirect('/admin');
    } else {
      req.flash('page', 'pontoonibus');
      req.flash('success', "Ponto de Ônibus criado com sucesso.");
      res.redirect('/admin');
    }
  });
});

// Remover um Ponto de Ônibus
server.post('/removerPontoOnibus', function(req, res) {
  var idPontoOnibus = req.body.idPontoOnibus;

  var query = "DELETE FROM PontoOnibus WHERE id_pontoonibus = " + idPontoOnibus + ";";

  client.query (query, function(err, result) {
    if (err) {
      var msgErro = "";

      if (err.detail.indexOf("rota") != -1) {
        msgErro = "Este Ponto de Ônibus está sendo usado em uma Rota.";
      } else if (err.detail.indexOf("horario") != -1) {
        msgErro = "Este Ponto de Ônibus está sendo usado em um Horário.";
      } else if (err.detail.indexOf("onibus") != -1) {
        msgErro = "Este Ponto de Ônibus está sendo usado em um Ônibus.";
      } else {
        msgErro = err.detail;
      }

      req.flash('page', 'pontoonibus');
      req.flash('error', msgErro);
      res.redirect('/admin');
    } else {
      req.flash('page', 'pontoonibus');
      req.flash('success', 'Ponto de Ônibus removido com sucesso.');
      res.redirect('/admin');
    }
  });
});

// Adicionar um Ônibus
server.post('/adicionarOnibus', function(req, res) {
  var placa = req.body.placaOnibusAdicionar;
  var numero = req.body.numeroRota;

  var inserir = "INSERT INTO Onibus VALUES (DEFAULT, (SELECT id_rota FROM Rota WHERE nome = '" + numero + "'), '" + placa + "', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '" + numero + "'), DEFAULT)";

  client.query(inserir, function(err, result) {
    if (err) {
      var msgErro = "";
      if (err == 'error: duplicate key value violates unique constraint "placa_unica_onibus"') {
        msgErro = "Esta placa de ônibus já existe.";
      } else if (err == 'error: null value in column "id_rota" violates not-null constraint') {
        msgErro = "A rota que você passou não existe";
      }

      req.flash('page', 'onibus');
      req.flash('error', msgErro);
      res.redirect('/admin');
    } else {
      req.flash('page', 'onibus');
      req.flash('success', "Ônibus criado com sucesso.");
      res.redirect('/admin');
    }
  });
});

// Remover um Ônibus
server.post('/removerOnibus', function(req, res) {
  var idOnibus = req.body.idOnibus;

  var deleteHorario = "DELETE FROM Horario WHERE id_onibus = '" + idOnibus + "';";
  var deleteFugaRota = "DELETE FROM FugaRota WHERE id_onibus = '" + idOnibus + "';";
  var deleteLocalization = "DELETE FROM Localization WHERE id_onibus = '" + idOnibus + "';";
  var deleteOnibus = "DELETE FROM Onibus WHERE id_onibus = '" + idOnibus + "';";

  client.query (deleteHorario, function(err, result) {
    if (err) {
      req.flash('page', 'onibus');
      req.flash('error', err);
      res.redirect('/admin');
    } else {
      client.query (deleteFugaRota, function(err2, result2) {
        if (err2) {
          req.flash('page', 'onibus');
          req.flash('error', err2);
          res.redirect('/admin');
        } else {
          client.query (deleteLocalization, function(err3, result3) {
            if (err3) {
              req.flash('page', 'onibus');
              req.flash('error', err3);
              res.redirect('/admin');
            } else {
              client.query (deleteOnibus, function(err4, result4) {
                if (err4) {
                  req.flash('page', 'onibus');
                  req.flash('error', err4);
                  res.redirect('/admin');
                } else {
                  req.flash('page', 'onibus');
                  req.flash('success', 'Ônibus removido com sucesso.');
                  res.redirect('/admin');
                }
              });
            }
          });
        }
      });
    }
  });
});


server.get('/web-api/horarios', function(req, res) {
  var query = "SELECT * FROM (SELECT DISTINCT ON (id_pontoonibus) t.id_onibus, t.id_pontoonibus, to_char(t.tempo, 'HH24:MI:SS DD/MM/YY') AS tempo, t.nome, o.placa FROM tempotopontoonibus t, Onibus o WHERE t.id_onibus = o.id_onibus ORDER BY id_pontoonibus, tempo) AS subquery ORDER BY subquery.tempo;";

  var queryRotas = "SELECT DISTINCT ON (nome) nome FROM TempoToPontoOnibus;";

  var queryPontoOnibus = "SELECT DISTINCT ON (id_pontoonibus) id_pontoonibus FROM TempoToPontoOnibus;";

  client.query(query, function(err, result) {
    if (err) {
      res.send(err);
    } else {
      client.query(queryRotas, function(err2, result2) {
        if (err2) {
          res.send(err2);
        } else {

          result["rotas"] = result2.rows;

          client.query(queryPontoOnibus, function(err3, result3) {
            if (err3) {
              res.send(err3);
            } else {
              result["id_pontoonibus"] = result3.rows;
              res.send(result);
            }
          });
        }
      });
    }
  });
});


server.get('/web-api/onibus', function(req, res) {

    var query = "SELECT * FROM Onibus;";

    client.query(query, function(err, result) {
        if (err) {
            res.send(err);
        } else {
            res.send(result);
        }
    });
});

// Inicia o servidor na porta 3001.
server.listen(3001, function() {
  console.log('Server on.');
  console.log('http://localhost:3001');
});
