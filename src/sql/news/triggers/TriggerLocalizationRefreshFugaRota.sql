CREATE TRIGGER refreshFugaRota AFTER INSERT ON Localization
    FOR EACH ROW EXECUTE PROCEDURE refreshFugaRota();