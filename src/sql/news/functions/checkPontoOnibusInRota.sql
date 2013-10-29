CREATE OR REPLACE FUNCTION checkPontoOnibusInRota() RETURNS trigger AS $checkPontoOnibusInRota$
    DECLARE
    PontoInRota BOOLEAN;
    nextPontoInRota BOOLEAN;
    BEGIN
         SELECT ST_Intersects(r.geom, p.geom) INTO PontoInRota FROM Rota r, PontoOnibus p WHERE p.id_pontoonibus = NEW.id_pontoonibus AND r.id_rota = NEW.id_rota;

         IF (NOT PontoInRota) THEN
            RAISE EXCEPTION 'id_pontoonibus not in rota';
         END IF;

         SELECT ST_Intersects(r.geom, p.geom) INTO nextPontoInRota FROM Rota r, PontoOnibus p WHERE p.id_pontoonibus = NEW.next_id_pontoonibus AND r.id_rota = NEW.id_rota;

         IF (NOT nextPontoInRota) THEN
            RAISE EXCEPTION 'next_id_pontoonibus not in rota';
         END IF;

        RETURN NEW;
    END;
    $checkPontoOnibusInRota$ LANGUAGE plpgsql;