CREATE TABLE urls (
id SERIAL PRIMARY KEY,
site_name VARCHAR(100) NOT NULL,
url VARCHAR(400) NOT NULL,
shortened VARCHAR(20)
);
