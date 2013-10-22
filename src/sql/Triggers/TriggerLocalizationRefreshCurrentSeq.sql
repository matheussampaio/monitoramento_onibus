CREATE TRIGGER refreshCurrentSeq AFTER INSERT ON Localization
    FOR EACH ROW EXECUTE PROCEDURE refreshCurrentSeq();