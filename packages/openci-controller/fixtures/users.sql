-- Add up migration script here
INSERT INTO users (name, email, role)
VALUES ('John Doe', 'john.doe@example.com', 'member'),
    ('Jane Smith', 'jane.smith@example.com', 'member'),
    (
        'Taro Yamada',
        'taro.yamada@example.com',
        'member'
    );