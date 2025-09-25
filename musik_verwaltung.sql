CREATE DATABASE musikverwaltung;
USE musikverwaltung;

CREATE TABLE musikrichtung (
    musikrichtung_id INT AUTO_INCREMENT PRIMARY KEY,
    kategorie VARCHAR(100) NOT NULL UNIQUE,
    ist_favorite BOOLEAN DEFAULT FALSE
);

CREATE TABLE interpret (
    interpret_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    webseite VARCHAR(255)
);

CREATE TABLE lied (
    lied_id INT AUTO_INCREMENT PRIMARY KEY,
    titel VARCHAR(150) NOT NULL,
    musikrichtung_id INT NOT NULL,
    ist_lieblingslied BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (musikrichtung_id) REFERENCES musikrichtung(musikrichtung_id)
);

CREATE TABLE lied_interpret (
    lied_id INT NOT NULL,
    interpret_id INT NOT NULL,
    erscheinungsjahr YEAR NOT NULL,
    laenge TIME NOT NULL,
    PRIMARY KEY (lied_id, interpret_id),
    FOREIGN KEY (lied_id) REFERENCES lied(lied_id),
    FOREIGN KEY (interpret_id) REFERENCES interpret(interpret_id)
);
INSERT INTO musikrichtung (kategorie, ist_favorite) VALUES
('Rock', TRUE),
('Pop', FALSE),
('Jazz', FALSE);

INSERT INTO interpret (name, webseite) VALUES
('The Beatles', 'https://www.thebeatles.com'),
('Miles Davis', 'https://www.milesdavis.com'),
('Adele', 'https://www.adele.com');

INSERT INTO lied (titel, musikrichtung_id, ist_lieblingslied) VALUES
('Hey Jude', 1, TRUE),
('So What', 3, FALSE),
('Hello', 2, TRUE);

INSERT INTO lied_interpret (lied_id, interpret_id, erscheinungsjahr, laenge) VALUES
(1, 1, 1968, '00:07:11'),  -- Hey Jude by The Beatles
(2, 2, 1959, '00:09:22'),  -- So What by Miles Davis
(3, 3, 2015, '00:04:55');  -- Hello by Adeleinterpretliedmitarbeiter
