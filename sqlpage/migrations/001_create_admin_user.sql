-- Creates an initial user called 'admin'
-- with a password hash that was generated using the 'generate_password_hash.sql' page.
INSERT INTO user_info (username, activation, nom, prenom, groupe)
VALUES ('duer_admin', '54321', 'Admin', 'admin',3);
