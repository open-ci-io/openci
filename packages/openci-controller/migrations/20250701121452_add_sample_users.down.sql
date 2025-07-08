-- Add down migration script here
DELETE FROM users
WHERE email IN ('john.doe@example.com', 'jane.smith@example.com');