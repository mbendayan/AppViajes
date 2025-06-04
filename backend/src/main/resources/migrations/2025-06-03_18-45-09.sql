CREATE TABLE travel_invitations (
    id SERIAL PRIMARY KEY,
    travel_id BIGINT NOT NULL,
    inviter_id BIGINT NOT NULL,
    invited_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_travel FOREIGN KEY (travel_id) REFERENCES travels(id),
    CONSTRAINT fk_inviter FOREIGN KEY (inviter_id) REFERENCES users(id),
    CONSTRAINT fk_invited FOREIGN KEY (invited_id) REFERENCES users(id)
);
