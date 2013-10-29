ALTER TABLE Onibus ADD FOREIGN KEY (id_rota) REFERENCES Rota;
ALTER TABLE Onibus ADD FOREIGN KEY (current_pontoonibus) REFERENCES PontoOnibus;
ALTER TABLE Onibus ADD CHECK (placa <> '');
ALTER TABLE Onibus ADD CONSTRAINT placa_unica_onibus UNIQUE (placa);