create database projekte;
USE projekte;
CREATE TABLE mitarbeiter (
    mitarbeiternr INT PRIMARY KEY AUTO_INCREMENT,
    vorname VARCHAR(50) NOT NULL,
    nachname VARCHAR(50) NOT NULL,
    geburtsdatum DATE NOT NULL,
    SVNR VARCHAR(11) UNIQUE NOT NULL,
    gehalt DECIMAL(10, 2),
    telefonnummer VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE projekte (
    projektnr INT PRIMARY KEY AUTO_INCREMENT,
    titel VARCHAR(100) NOT NULL,
    startdatum DATE,
    enddatum DATE,
    beschreibung TEXT NOT NULL
);

-- @block: 1
DROP TABLE IF EXISTS mitarbeiter_bearbeitet_projekte;
drop TABLE projekte;

-- @block: 2
CREATE TABLE mitarbeiter_bearbeitet_projekte (
    mitarbeiternr INT,
    projektnr INT,
    hours_worked INT,
    PRIMARY KEY (mitarbeiternr, projektnr),
    FOREIGN KEY (mitarbeiternr) REFERENCES mitarbeiter(mitarbeiternr),
    FOREIGN KEY (projektnr) REFERENCES projekte(projektnr)
);

-- @block: 3
INSERT INTO mitarbeiter (vorname, nachname, geburtsdatum, SVNR, gehalt, telefonnummer, email) VALUES
('Franz', 'Meyer', '1970-11-23', '3231', 2100.50, '004366433332211', 'franz.meyer@gmail.com'),
('Anna', 'Schmidt', '1985-05-15', '3232', 2500.00, '004366433332212', 'anna.schmidt@company.at'),
('Peter', 'Müller', '1990-08-30', '3233', 3000.00, '004366433332213', 'mueller.peter@nononsense.com');
INSERT INTO projekte (titel, startdatum, enddatum, beschreibung) VALUES
('Webshop Zalando Shoes', '20230620', '20240620', 'Neue Version des mobilen Shops'),
('Webshop Amazon Fashion', '20241205', '20251111', 'Neue Version des Amazon Shops'),
('Webshop Mediamarkt Electronics', '20240731', '20260630', 'Neue Version des Mediamarkt');

-- @block: 4
SELECT * FROM mitarbeiter;
SELECT * FROM projekte;
