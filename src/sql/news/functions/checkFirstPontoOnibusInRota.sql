CREATE OR REPLACE FUNCTION checkFirstPontoOnibusInRota() RETURNS trigger AS $checkFirstPontoOnibusInRota$
    DECLARE
    FirstPontoInRota BOOLEAN;
    BEGIN
         SELECT ST_Intersects(NEW.geom, p.geom) INTO FirstPontoInRota FROM PontoOnibus p WHERE p.id_pontoonibus = NEW.first_pontoonibus;

         IF (NOT FirstPontoInRota) THEN
            RAISE EXCEPTION 'first_pontoonibus not in rota';
         END IF;

        RETURN NEW;
    END;
    $checkFirstPontoOnibusInRota$ LANGUAGE plpgsql;