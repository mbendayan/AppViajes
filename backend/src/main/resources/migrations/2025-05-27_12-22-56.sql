CREATE TABLE user_saved_travels (
    user_id BIGINT NOT NULL,
    travel_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, travel_id),
    CONSTRAINT fk_user_saved_travels_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_user_saved_travels_travel FOREIGN KEY (travel_id) REFERENCES travels(id)
);
