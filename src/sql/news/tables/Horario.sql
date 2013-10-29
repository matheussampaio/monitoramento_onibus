CREATE TABLE Horario (
    id_horario SERIAL PRIMARY KEY,
    id_onibus INTEGER NOT NULL,
    id_pontoonibus INTEGER NOT NULL,
    tempo TIME NOT NULL,
    seq INTEGER NOT NULL
);