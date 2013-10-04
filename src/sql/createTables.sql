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

        RETURN ( distance / diffTime );
    END;
    $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION refreshCurrentPontoOnibus() RETURNS trigger AS $refreshCurrentPontoOnibus$
    DECLARE
        mrecord RECORD;

        cursor1 CURSOR FOR SELECT p.id_pontoonibus, st_line_locate_point(r.geom, p.geom) AS dist FROM rota r, pontoonibus p, pontoonibus_rota pr, onibus o WHERE o.id_onibus = NEW.id_onibus AND r.id_rota = o.id_rota AND pr.id_rota = r.id_rota AND pr.id_pontoonibus = p.id_pontoonibus ORDER BY dist DESC;

        position REAL;
        max REAL;
    BEGIN
        SELECT ST_Line_Locate_Point(r.geom, l.geom) INTO position
        FROM Rota r, Onibus o, LastLocalization l
        WHERE o.id_onibus = NEW.id_onibus AND o.id_onibus = l.id_onibus AND r.id_rota = o.id_rota;

        FOR mrecord IN cursor1 LOOP
            IF NOT FOUND THEN
                FETCH FIRST FROM cursor1 INTO mrecord;
                UPDATE Onibus SET current_pontoonibus = mrecord.id_pontoonibus WHERE id_onibus = NEW.id_onibus;
                EXIT;
            END IF;

            IF position > mrecord.dist THEN
                UPDATE Onibus SET current_pontoonibus = mrecord.id_pontoonibus WHERE id_onibus = NEW.id_onibus;
                EXIT;
            END IF;

        END LOOP;

        RETURN NEW;
    END;
    $refreshCurrentPontoOnibus$ LANGUAGE plpgsql;

CREATE TRIGGER refreshCurrentPontoOnibus AFTER INSERT ON Localization
    FOR EACH ROW EXECUTE PROCEDURE refreshCurrentPontoOnibus();


CREATE OR REPLACE FUNCTION getSubLineString(id INTEGER, idPontoOnibus INTEGER) RETURNS Geometry AS $$
    DECLARE
        posOnibus REAL;
        posPontoOnibus REAL;

        rotaGeom Geometry;
    BEGIN

        SELECT r.geom INTO rotaGeom
        FROM Rota r, Onibus o
        WHERE r.id_rota = o.id_rota AND o.id_onibus = id;

        SELECT ST_Line_Locate_Point(rotaGeom, l.geom) INTO posOnibus FROM Onibus o, LastLocalization l WHERE o.id_onibus = id AND o.id_onibus = l.id_onibus;

        SELECT ST_Line_Locate_Point(rotaGeom, p.geom) INTO posPontoOnibus FROM PontoOnibus p WHERE p.id_pontoonibus = idPontoOnibus;-- getIDNextPontoOnibus(id);

        IF posOnibus <= posPontoOnibus THEN
            RETURN ST_Line_SubString(rotaGeom, posOnibus, posPontoOnibus);
        ELSE
            RETURN ST_Union(ST_Line_SubString(rotaGeom, posOnibus, 1), ST_Line_SubString(rotaGeom, 0, posPontoOnibus));
        END IF;

    END;
    $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getSubLineString(id INTEGER) RETURNS Geometry AS $$
    DECLARE
        posOnibus REAL;
        posPontoOnibus REAL;

        rotaGeom Geometry;
    BEGIN

        SELECT r.geom INTO rotaGeom
        FROM Rota r, Onibus o
        WHERE r.id_rota = o.id_rota AND o.id_onibus = id;

        SELECT ST_Line_Locate_Point(rotaGeom, l.geom) INTO posOnibus FROM Onibus o, LastLocalization l WHERE o.id_onibus = id AND o.id_onibus = l.id_onibus;

        SELECT ST_Line_Locate_Point(rotaGeom, p.geom) INTO posPontoOnibus FROM PontoOnibus p WHERE p.id_pontoonibus = getIDNextPontoOnibus(id);

        IF posOnibus <= posPontoOnibus THEN
            RETURN ST_Line_SubString(rotaGeom, posOnibus, posPontoOnibus);
        ELSE
            RETURN ST_Union(ST_Line_SubString(rotaGeom, posOnibus, 1), ST_Line_SubString(rotaGeom, 0, posPontoOnibus));
        END IF;

    END;
    $$ LANGUAGE plpgsql;


CREATE OR REPLACE VIEW tempoToPontoOnibus AS
    SELECT o.id_onibus, p.id_pontoonibus, NOW() + (ST_Length( ST_Transform(getSubLineString(o.id_onibus, p.id_pontoonibus), 26986)) / getVelocidadeMedia(o.id_onibus))*'1 SECOND'::INTERVAL AS tempo
    FROM Onibus o, PontoOnibus p, Rota r, PontoOnibus_Rota pr
    WHERE o.id_rota = r.id_rota AND pr.id_rota = r.id_rota AND pr.id_pontoonibus = p.id_pontoonibus
    GROUP BY o.id_onibus, p.id_pontoonibus
    ORDER BY o.id_onibus, p.id_pontoonibus;

create or replace view viewsubstrings as select o.id_onibus, getsublinestring(o.id_onibus) as geom from onibus o where o.id_onibus = 25;

SELECT a.distance, a.velocidade, (a.distance/a.velocidade) AS tempo, NOW() + INTERVAL a.distance/a.velocidade SECOND
FROM ( SELECT ST_Length( ST_Transform(getSubLineString(25), 26986) ) AS distance, getVelocidadeMedia(25) AS velocidade ) a;