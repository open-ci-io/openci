CREATE TABLE
    api_keys (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
        name VARCHAR(255) NOT NULL,
        hashed_key VARCHAR(255) NOT NULL UNIQUE,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
        last_used_at TIMESTAMPTZ,
        prefix VARCHAR(8) NOT NULL UNIQUE
    );

CREATE INDEX idx_api_keys_user_id ON api_keys (user_id);

CREATE INDEX idx_api_keys_prefix ON api_keys (prefix);