CREATE TABLE
    github_repositories
(
    id          SERIAL PRIMARY KEY,
    external_id BIGINT NOT NULL UNIQUE
);
