CREATE OR REPLACE VIEW TempoToPontoOnibus AS
    SELECT o.id_onibus, p.id_pontoonibus, NOW() + (ST_Length( ST_Transform(getSubLineString(o.id_onibus, p.id_pontoonibus), 26986)) / getVelocidadeMedia(o.id_onibus))*'1 SECOND'::INTERVAL AS tempo, r.nome
    FROM Onibus o, PontoOnibus p, Rota r, PontoOnibus_Rota pr
    WHERE o.id_rota = r.id_rota AND pr.id_rota = r.id_rota AND pr.id_pontoonibus = p.id_pontoonibus
    GROUP BY o.id_onibus, p.id_pontoonibus, r.nome
    ORDER BY o.id_onibus, p.id_pontoonibus;