CREATE TABLE PontoOnibus ( 
    id_pontoonibus SERIAL PRIMARY KEY,
    nome text NOT NULL DEFAULT ''
);

SELECT AddGeometryColumn('','pontoonibus','geom','4291','POINT',2);

CREATE TABLE Rota (
    id_rota SERIAL PRIMARY KEY,
    nome text NOT NULL,
    first_pontonibus INTEGER NOT NULL
);

SELECT AddGeometryColumn('','rota','geom','4291','LINESTRING',2);

ALTER TABLE Rota ADD FOREIGN KEY (first_pontoonibus) REFERENCES PontoOnibus;
ALTER TABLE Rota ADD CONSTRAINT nome_unico_rota UNIQUE (nome);

CREATE TABLE PontoOnibus_Rota (
    id_rota INTEGER NOT NULL,
    id_pontoonibus INTEGER NOT NULL,
    next_id_pontoonibus INTEGER NOT NULL
);

ALTER TABLE PontoOnibus_Rota ADD FOREIGN KEY (id_rota) REFERENCES Rota;
ALTER TABLE PontoOnibus_Rota ADD FOREIGN KEY (id_pontoonibus) REFERENCES PontoOnibus;

CREATE TYPE status AS ENUM ('normal', 'atrasado', 'garagem', 'indeterminado');

CREATE TABLE Onibus (
    id_onibus SERIAL PRIMARY KEY,
    id_rota integer NOT NULL,
    placa text NOT NULL,
    current_status status NOT NULL,
    current_pontoonibus INTEGER NOT NULL
);

ALTER TABLE Onibus ADD FOREIGN KEY (id_rota) REFERENCES Rota;
ALTER TABLE Onibus ADD FOREIGN KEY (current_pontoonibus) REFERENCES PontoOnibus;
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


CREATE OR REPLACE FUNCTION getIDNextPontoOnibus (id INTEGER) RETURNS INTEGER AS $$
DECLARE
    result INTEGER;
BEGIN
    SELECT next_id_pontoonibus INTO result FROM pontoonibus_rota p, onibus o WHERE o.id_onibus = id AND o.id_rota = p.id_rota AND o.current_pontoonibus = p.id_pontoonibus;

    RETURN result;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getVelocidadeMedia (id INTEGER) RETURNS REAL AS $$
DECLARE
    pointA Geometry;
    pointB Geometry;

    timeA timestamp;
    timeB timestamp;

    result INTEGER;

    distance REAL;
    diffTime REAL;

    points CURSOR FOR SELECT ST_GeomFromText('POINT (' || lat || ' ' || long || ')', 4291) AS geom, time FROM localization WHERE id_onibus = id ORDER BY time DESC LIMIT 2;
BEGIN
    OPEN points;
    FETCH points INTO pointA, timeA;
    FETCH points INTO pointB, timeB;
    CLOSE points;

    distance = ST_Distance(ST_Transform(pointA, 26986), ST_Transform(pointB, 26986));

    diffTime = EXTRACT(EPOCH FROM (timeA - timeB));

    RETURN ( distance / diffTime ) * 3.6;
END;
$$ LANGUAGE plpgsql;