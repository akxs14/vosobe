CREATE TABLE users
(id BIGSERIAL PRIMARY KEY,
 first_name VARCHAR(30),
 last_name VARCHAR(30),
 alias VARCHAR(30),
 email VARCHAR(30),
 admin BOOLEAN,
 last_login TIME,
 is_active BOOLEAN,
 pass VARCHAR(100));
