CREATE TABLE FugaRota (
    id_fugarota SERIAL PRIMARY KEY,
    id_onibus INTEGER NOT NULL,
    resolvido BOOLEAN NOT NULL,
    horarioInicio TIMESTAMP NOT NULL DEFAULT NOW(),
    horarioFinal TIMESTAMP
);