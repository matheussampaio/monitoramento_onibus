INSERT INTO FugaRota VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0001'), false, DEFAULT, NOW(), (SELECT TIME '11:00'));
INSERT INTO FugaRota VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0001'), false, DEFAULT, NOW(), (SELECT TIME '12:00'));


