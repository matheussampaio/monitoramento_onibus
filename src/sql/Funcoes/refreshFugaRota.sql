CREATE OR REPLACE FUNCTION refreshFugaRota() RETURNS trigger AS $refreshFugaRota$
    DECLARE
        isNewCoordIn BOOLEAN;
        isCurrentOut BOOLEAN;
    BEGIN
        SELECT ST_Intersects(r.geom, l.geom) INTO isNewCoordIn FROM LastLocalization l, Rota r, Onibus o WHERE o.id_onibus = NEW.id_onibus AND l.id_onibus = o.id_onibus AND r.id_rota = o.id_rota;
        SELECT o.statusFuga INTO isCurrentOut FROM Onibus o WHERE o.id_onibus = NEW.id_onibus;

        IF NOT isCurrentOut AND NOT isNewCoordIn THEN
            INSERT INTO FugaRota VALUES (DEFAULT, NEW.id_onibus, FALSE, DEFAULT, NULL);
            UPDATE Onibus SET statusFuga = TRUE WHERE id_onibus = NEW.id_onibus;
        END IF;

        IF isCurrentOut AND isNewCoordIn THEN
            UPDATE FugaRota SET horarioFinal = NOW() WHERE id_onibus = NEW.id_onibus AND horarioFinal IS NULL;
            UPDATE Onibus SET statusFuga = FALSE WHERE id_onibus = NEW.id_onibus;
        END IF;

        RETURN NEW;
    END;
    $refreshFugaRota$ LANGUAGE plpgsql;