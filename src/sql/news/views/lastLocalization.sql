CREATE OR REPLACE VIEW lastLocalization AS SELECT DISTINCT ON (l.id_onibus) l.id_onibus, l.lat AS Latitude, l.long AS Longitude, o.placa, ST_GeomFromText('POINT ( ' || l.lat || ' ' || l.long || ')', 4291) AS geom FROM Localization l, Onibus o WHERE l.id_onibus = o.id_onibus ORDER BY id_onibus, time DESC;