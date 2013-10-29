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