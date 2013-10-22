CREATE TABLE Onibus (
    id_onibus SERIAL PRIMARY KEY,
    id_rota INTEGER NOT NULL,
    placa TEXT NOT NULL,
    current_status status NOT NULL DEFAULT 'indeterminado',
    current_pontoonibus INTEGER NOT NULL,
    statusFuga BOOLEAN NOT NULL DEFAULT FALSE,
    current_seq INTEGER NOT NULL DEFAULT 1,
    tempo TIME
);