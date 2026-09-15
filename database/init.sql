CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(100) NOT NULL
);

INSERT INTO employees (name, email, role)
VALUES
    ('Indira', 'indira@example.com', 'DevOps Engineer'),
    ('Arun', 'arun@example.com', 'Backend Engineer'),
    ('Priya', 'priya@example.com', 'QA Engineer')
ON CONFLICT (email) DO NOTHING;