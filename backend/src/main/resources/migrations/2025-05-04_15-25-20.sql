CREATE TABLE travels
(
    id            BIGSERIAL PRIMARY KEY,
    name          VARCHAR(50)  NOT NULL,
    destination   VARCHAR(100) NOT NULL,
    start_date    TIMESTAMPTZ  NOT NULL,
    end_date      TIMESTAMPTZ  NOT NULL,
    preferences   VARCHAR(150) NOT NULL,
    creation_date TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE travel_steps
(
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100)   NOT NULL,
    description     VARCHAR(500)   NOT NULL,
    travel_id       BIGINT REFERENCES travels (id) ON DELETE CASCADE,
    start_date      TIMESTAMPTZ    NOT NULL,
    end_date        TIMESTAMPTZ    NOT NULL,
    location        VARCHAR(150)   NOT NULL,
    cost            DECIMAL(10, 2) NOT NULL,
    recommendations VARCHAR(500)   NOT NULL
);