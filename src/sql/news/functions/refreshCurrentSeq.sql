CREATE OR REPLACE FUNCTION refreshCurrentSeq() RETURNS TRIGGER AS $refreshCurrentSeq$
    DECLARE
        new_seq INTEGER;
    BEGIN

        SELECT h.seq INTO new_seq FROM Onibus o, Horario h WHERE o.id_onibus = NEW.id_onibus AND o.id_onibus = h.id_onibus AND (CAST(h.tempo AS TIME) - CAST(NOW() AS TIME)) >= CAST('00:00' AS TIME) ORDER BY (CAST(h.tempo AS TIME) - CAST(NOW() AS TIME)) LIMIT 1;

        IF new_seq IS NOT NULL THEN
            UPDATE Onibus SET current_seq = new_seq WHERE id_onibus = NEW.id_onibus;
        END IF;

        RETURN NEW;
    END;
    $refreshCurrentSeq$ LANGUAGE plpgsql;