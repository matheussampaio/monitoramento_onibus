CREATE TRIGGER refreshStatusOnibus AFTER INSERT ON Localization
    FOR EACH ROW EXECUTE PROCEDURE refreshStatusOnibus();