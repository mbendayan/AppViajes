CREATE TABLE users
(
    id            BIGSERIAL PRIMARY KEY,
    username      VARCHAR(50) UNIQUE NOT NULL,
    email         VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255)       NOT NULL,
    creation_date DATE DEFAULT now() NOT NULL
);

CREATE TYPE travel_type AS ENUM (
    'leisure',
    'adventure',
    'business',
    'cultural',
    'romantic',
    'nature'
);

CREATE TYPE transport_type AS ENUM (
    'car',
    'train',
    'plane',
    'bus',
    'bicycle',
    'boat',
    'walking'
);

CREATE TABLE preferences
(
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT UNIQUE REFERENCES users (id) ON DELETE CASCADE,
    budget          DECIMAL(10, 2),
    travel_types    travel_type[],
    accommodation   VARCHAR(100),
    transport_types transport_type[]
);

CREATE TYPE travel_status AS ENUM ('in_progress', 'finished', 'cancelled');

CREATE TABLE travel
(
    id             BIGSERIAL PRIMARY KEY,
    name           VARCHAR(50)        NOT NULL,
    attendee_count INTEGER            NOT NULL,
    type           VARCHAR(100)       NOT NULL,
    destination    VARCHAR(100)       NOT NULL,
    code           VARCHAR(20) UNIQUE NOT NULL,
    is_public      BOOLEAN            NOT NULL DEFAULT FALSE,
    creation_date  TIMESTAMPTZ        NOT NULL DEFAULT now(),
    status         travel_status      NOT NULL,
    creator_id     BIGINT             REFERENCES users (id) ON DELETE SET NULL,
    preferences_id BIGINT             REFERENCES preferences (id) ON DELETE SET NULL
);


CREATE TABLE users_travel
(
    user_id   BIGINT REFERENCES users (id) ON DELETE CASCADE,
    travel_id BIGINT REFERENCES travel (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, travel_id)
);

CREATE TABLE step
(
    id              BIGSERIAL PRIMARY KEY,
    travel_id       BIGINT REFERENCES travel (id) ON DELETE CASCADE,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    location        VARCHAR(150),
    name            VARCHAR(100),
    cost            DECIMAL(10, 2),
    recommendations TEXT
);