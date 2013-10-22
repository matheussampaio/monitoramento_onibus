CREATE TRIGGER refreshCurrentPontoOnibus AFTER INSERT ON Localization
    FOR EACH ROW EXECUTE PROCEDURE refreshCurrentPontoOnibus();