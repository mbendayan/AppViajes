CREATE TYPE travel_status AS ENUM ('in_progress', 'finished', 'cancelled');

CREATE TABLE travels
(
    id            BIGSERIAL PRIMARY KEY,
    name          VARCHAR(50)  NOT NULL,
    type          VARCHAR(100) NOT NULL,
    destination   VARCHAR(100) NOT NULL,
    creation_date TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE travel_steps
(
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100),
    description     VARCHAR(500),
    travel_id       BIGINT REFERENCES travels (id) ON DELETE CASCADE,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    location        VARCHAR(150),
    cost            DECIMAL(10, 2),
    recommendations VARCHAR(500)
);