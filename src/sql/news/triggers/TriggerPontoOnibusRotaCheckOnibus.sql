CREATE TRIGGER checkPontoOnibusInRota BEFORE INSERT AND UPDATE ON PontoOnibus_Rota
    FOR EACH ROW EXECUTE PROCEDURE checkPontoOnibusInRota();