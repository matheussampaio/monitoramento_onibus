CREATE OR REPLACE FUNCTION getIDNextPontoOnibus (id INTEGER) RETURNS INTEGER AS $$
    DECLARE
        result INTEGER;
    BEGIN
        SELECT next_id_pontoonibus INTO result FROM pontoonibus_rota p, onibus o WHERE o.id_onibus = id AND o.id_rota = p.id_rota AND o.current_pontoonibus = p.id_pontoonibus;

        RETURN result;
    END;
    $$ LANGUAGE plpgsql;