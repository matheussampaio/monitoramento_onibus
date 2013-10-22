ALTER TABLE PontoOnibus_Rota ADD FOREIGN KEY (id_rota) REFERENCES Rota;
ALTER TABLE PontoOnibus_Rota ADD FOREIGN KEY (id_pontoonibus) REFERENCES PontoOnibus;
ALTER TABLE PontoOnibus_Rota ADD FOREIGN KEY (next_id_pontoonibus) REFERENCES PontoOnibus;
ALTER TABLE PontoOnibus_Rota ADD CONSTRAINT PontoOnibus_Rota_PK PRIMARY KEY (id_rota, id_pontoonibus, next_id_pontoonibus);