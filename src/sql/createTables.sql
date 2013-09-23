CREATE TABLE Rota (
    id_rota SERIAL PRIMARY KEY,
    nome text NOT NULL,
);

SELECT AddGeometryColumn('','Rota','geom','4291','MULTILINESTRING',2);

ALTER TABLE Rota ADD CONSTRAINT nome_unico_rota UNIQUE (nome);

CREATE TABLE Onibus (
    id_onibus SERIAL PRIMARY KEY,
    id_rota integer NOT NULL,
    placa text NOT NULL
);

ALTER TABLE Onibus ADD FOREIGN KEY (id_rota) REFERENCES Rota;
ALTER TABLE Onibus ADD CHECK (placa <> '');
ALTER TABLE Onibus ADD CONSTRAINT placa_unica_onibus UNIQUE (placa);

CREATE TABLE Localization (
    id_localization SERIAL PRIMARY KEY,
    id_onibus integer NOT NULL,
    lat text NOT NULL,
    long text NOT NULL,
    time timestamp NOT NULL
);

ALTER TABLE Localization ADD FOREIGN KEY (id_onibus) REFERENCES Onibus;

CREATE OR REPLACE VIEW lastLocalization AS SELECT DISTINCT ON (id_onibus) id_onibus, lat AS Latitude, long AS Longitude, ST_GeomFromText('POINT ( ' || lat || ' ' || long || ')', 4291) AS geom FROM Localization ORDER BY id_onibus, time DESC;