ALTER TABLE Rota ADD FOREIGN KEY (first_pontoonibus) REFERENCES PontoOnibus;
ALTER TABLE Rota ADD CONSTRAINT nome_unico_rota UNIQUE (nome);