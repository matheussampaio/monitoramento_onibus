CREATE TRIGGER checkPontoOnibusInRota BEFORE INSERT ON PontoOnibus_Rota
    FOR EACH ROW EXECUTE PROCEDURE checkPontoOnibusInRota();