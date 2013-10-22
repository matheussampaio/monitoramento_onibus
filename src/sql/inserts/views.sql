CREATE OR REPLACE VIEW rota555view AS SELECT id_rota, nome, ST_GeomFromText(ST_AsText(geom), 4291) AS geom FROM rota WHERE nome = '555';
CREATE OR REPLACE VIEW rota505view AS SELECT id_rota, nome, ST_GeomFromText(ST_AsText(geom), 4291) AS geom FROM rota WHERE nome = '505';
CREATE OR REPLACE VIEW rota500view AS SELECT id_rota, nome, ST_GeomFromText(ST_AsText(geom), 4291) AS geom FROM rota WHERE nome = '500';
CREATE OR REPLACE VIEW lastLocalization AS SELECT DISTINCT ON (id_onibus) id_onibus, lat AS Latitude, long AS Longitude, ST_GeomFromText('POINT ( ' || lat || ' ' || long || ')', 4291) AS geom FROM Localization ORDER BY id_onibus, time DESC;