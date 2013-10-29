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