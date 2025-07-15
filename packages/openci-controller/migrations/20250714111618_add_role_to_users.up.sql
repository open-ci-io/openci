ALTER TABLE users
ADD COLUMN role VARCHAR(50) NOT NULL DEFAULT 'member' CHECK (role IN ('admin', 'member'));