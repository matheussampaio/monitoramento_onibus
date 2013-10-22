CREATE OR REPLACE FUNCTION refreshStatusOnibus() RETURNS TRIGGER AS $refreshStatusOnibus$
    DECLARE
        diffAdiantado BOOLEAN;
        diffAtrasado BOOLEAN;
        diffTempo TEXT;
    BEGIN
        SELECT CAST(h.tempo AS TIME) - CAST(t.tempo AS TIME), (CAST(h.tempo AS TIME) - CAST(t.tempo AS TIME) > TIME '00:05'), (CAST(h.tempo AS TIME) - CAST(t.tempo AS TIME) < -(TIME '00:05')) INTO diffTempo, diffAdiantado, diffAtrasado FROM Onibus o, Horario h, TempoToPontoOnibus t WHERE o.id_onibus = NEW.id_onibus AND o.id_onibus = h.id_onibus AND o.id_onibus = t.id_onibus AND h.id_pontoonibus = t.id_pontoonibus AND o.current_seq = h.seq;

        IF (diffAdiantado) THEN
            UPDATE Onibus SET current_status = 'adiantado', tempo = diffTempo WHERE id_onibus = NEW.id_onibus;
        ELSEIF (diffAtrasado) THEN
            UPDATE Onibus SET current_status = 'atrasado', tempo = diffTempo WHERE id_onibus = NEW.id_onibus;
        ELSE
            UPDATE Onibus SET current_status = 'normal', tempo = diffTempo WHERE id_onibus = NEW.id_onibus;
        END IF;

        RETURN NEW;
    END;
    $refreshStatusOnibus$ LANGUAGE plpgsql;