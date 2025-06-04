-- 1. Crear la tabla preferences
CREATE TABLE preferences (
    id SERIAL PRIMARY KEY,
    presupuesto VARCHAR(50),
    monto_personalizado DOUBLE PRECISION,
    tipo_viaje VARCHAR(50),
    tipo_alojamiento VARCHAR(50),
    tipo_transporte VARCHAR(50)
);

-- 2. Agregar columna preferencias_id a la tabla users
ALTER TABLE users
ADD COLUMN preferencias_id BIGINT;

-- 3. Crear la foreign key entre users y preferences
ALTER TABLE users
ADD CONSTRAINT fk_users_preferencias
FOREIGN KEY (preferencias_id)
REFERENCES preferences(id);
