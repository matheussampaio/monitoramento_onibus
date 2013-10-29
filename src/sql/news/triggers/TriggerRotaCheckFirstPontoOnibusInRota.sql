CREATE TRIGGER checkFirstPontoOnibusInRota BEFORE INSERT ON Rota
    FOR EACH ROW EXECUTE PROCEDURE checkFirstPontoOnibusInRota();