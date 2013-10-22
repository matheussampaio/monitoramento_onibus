CREATE TABLE Localization (
    id_localization SERIAL PRIMARY KEY,
    id_onibus INTEGER NOT NULL,
    lat TEXT NOT NULL,
    long TEXT NOT NULL,
    time TIMESTAMP NOT NULL
);