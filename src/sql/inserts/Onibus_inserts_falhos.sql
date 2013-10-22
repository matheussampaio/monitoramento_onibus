INSERT INTO Onibus VALUES (1, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0001', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, 4, 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (156, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, "1", 'ABC-0001', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 0001, 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'Erro', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', "1", DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), "Erro", 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, "1", NULL)
INSERT INTO Onibus VALUES (NULL, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, NULL, 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), NULL, 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', NULL, (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', NULL, DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), NULL, 1, NULL)
INSERT INTO Onibus VALUES (10, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, NULL, NULL)
INSERT INTO Onibus VALUES ((SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (10, 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (1, (SELECT id_rota FROM Rota WHERE nome = '500'), 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (1, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (1, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', DEFAULT, 1, NULL)
INSERT INTO Onibus VALUES (1, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), 1, NULL)
INSERT INTO Onibus VALUES (1, (SELECT id_rota FROM Rota WHERE nome = '500'), 'ABC-0010', 'indeterminado', (SELECT first_pontoonibus FROM Rota WHERE nome = '500'), DEFAULT, NULL)




















