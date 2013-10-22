ALTER TABLE Horario ADD FOREIGN KEY (id_onibus) REFERENCES Onibus;
ALTER TABLE Horario ADD FOREIGN KEY (id_pontoonibus) REFERENCES PontoOnibus;