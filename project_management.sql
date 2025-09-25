-- a. creating a new database and then using it to make the new tables.
CREATE DATABASE Maniyar_Projektverwaltung;
USE Maniyar_Projektverwaltung;
-- b. Creating a table for departments where the department name is unique and serves as primary key.
CREATE TABLE abteilung (
    Abteilungsname VARCHAR(50) PRIMARY KEY,
    Kostenstelle INT NOT NULL CHECK (Kostenstelle >= 100),
    Abteilungsleiter VARCHAR(20) 
);
-- c. New tabel Personal where PersonalNr is a primary key. 
-- The hourly wage cannot be zero so not null is specified. 
-- A foreign key for the table Abteilung is added since the relation of abteilung to personal is 1:N.
CREATE TABLE personal (
	personalnr INT AUTO_INCREMENT PRIMARY KEY,
	vorname VARCHAR (50), 
    Nachname VARCHAR(50),
    Strasse VARCHAR(100),
    Plz VARCHAR(10),
    Ort VARCHAR(50),
    Land VARCHAR(10) DEFAULT 'AT',
    Email VARCHAR(100),
    Telefon VARCHAR(30),
    Geburtsdatum DATE,
    Eintrittsdatum DATE,
    Firmenauto BOOLEAN DEFAULT FALSE,
    Stundenlohn DECIMAL(8,2) NOT NULL,
    Abteilungsname VARCHAR(50),
    FOREIGN KEY (Abteilungsname) REFERENCES abteilung(Abteilungsname)
);
-- d. Creating a table called projekt with ProjektNr as primark key and other attributes as in the ER model. 
CREATE TABLE projekt (
	projektnr INT AUTO_INCREMENT PRIMARY KEY,
    Titel VARCHAR(100) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    Startdatum DATE,
    enddatum DATE
);
-- e. creating a new table for aufgabe where AufgabeNr is the primary key and projektnr is the Foreign key
CREATE TABLE aufgabe (
    aufgabenr INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Arbeitszeit DECIMAL(6,2) NOT NULL,
    Prioritaet VARCHAR(20) NOT NULL,
     projektnr INT NOT NULL,
    FOREIGN KEY (projektnr) REFERENCES projekt(projektnr)
);
-- e. a Zwischentabelle/intermediate table is made that connects the aufgabe table and personal table.
-- for individual employee working hours in relation to each task. 
CREATE TABLE personal_bearbeitet_aufgabe (
    personalnr INT NOT NULL,
    aufgabenr INT NOT NULL,
    aktuelle_arbeitszeit DECIMAL(6,2),
    PRIMARY KEY (personalnr, aufgabenr),
    FOREIGN KEY (personalnr) REFERENCES personal(personalnr),
    FOREIGN KEY (aufgabenr) REFERENCES aufgabe(aufgabenr)
);
-- f. Provided data is added in the abteilung table using keyword insert.
INSERT INTO abteilung (Abteilungsname, Kostenstelle) VALUES
('Verwaltung', 110),
('Softwareentwicklung', 220),
('Verkauf', 330);
-- g. My personal data is added to the personal table with adding value in all the fields. 
INSERT INTO personal (
Vorname, Nachname, Strasse, Plz, Ort,  Email, Telefon, Geburtsdatum, Eintrittsdatum, Firmenauto, Stundenlohn, Abteilungsname
) VALUES (
   'Rachita', 'Maniyar', 'Statteggerstraße 1', '8045', 'Graz','rachita@maniyar.at', '0660123456', '1996-08-21', '2025-03-01', FALSE, 25.50, 'Softwareentwicklung'
);
-- h. Making myself as abteilungsleiter of department softwareentwicklung in the table abteilung.
UPDATE abteilung
SET abteilungsleiter = (SELECT personalnr FROM personal WHERE nachname='Maniyar' AND vorname='Rachita')
WHERE abteilungsname = 'Softwareentwicklung';
-- i. Another employee data entry is done using provided information in the personal table.
INSERT INTO personal (
    Vorname, Nachname, Strasse, Plz, Ort, Email, Telefon, Geburtsdatum, Eintrittsdatum, Firmenauto, Stundenlohn, Abteilungsname
) VALUES (
   'Anna', 'Maier', 'Hauptstraße 11a', '1010', 'Wien', 'anna@maier.at', '066003329', '1985-02-11', '2020-01-02', TRUE, 79.5, 'Verkauf'
);
-- j. A new project is added to projekt table with the provided title.
INSERT INTO projekt (Titel, Budget, Startdatum) VALUES
('Campus02_APP', 50000.00, '2025-05-19');
-- k. 3 tasks are inserted in the aufgabe table and 
INSERT INTO aufgabe ( Name, Arbeitszeit, Prioritaet, ProjektNr) VALUES
('Datenbankmodellierung', 80.5, 'hoch', (SELECT projektnr FROM projekt WHERE titel='Campus02_APP')),
('Frontend Entwicklung', 120.0, 'hoch', (SELECT projektnr FROM projekt WHERE titel='Campus02_APP')),
('Graphic Designer', 50.0, 'hoch', (SELECT projektnr FROM projekt WHERE titel='Campus02_APP'));
-- Assigning 2 tasks to myself using the intermediate table.
INSERT INTO personal_bearbeitet_aufgabe (personalnr, aufgabenr, aktuelle_arbeitszeit)
VALUES
((SELECT personalnr FROM personal WHERE nachname='Maniyar' AND vorname='Rachita'),
 (SELECT aufgabenr FROM aufgabe WHERE name='Datenbankmodellierung'), 80.5),
((SELECT personalnr FROM personal WHERE nachname='Maniyar' AND vorname='Rachita'),
 (SELECT aufgabenr FROM aufgabe WHERE name='Frontend Entwicklung'), 120.0);
-- l. A request query is written where all the tasks under my name are displayed.
SELECT p.vorname, p.nachname, a.aufgabenr, a.name
FROM personal p
JOIN personal_bearbeitet_aufgabe pa ON p.personalnr = pa.personalnr
JOIN aufgabe a ON pa.aufgabenr = a.aufgabenr
WHERE p.personalnr = 1;
-- m. The hourly wage is increased by 4 % for all the employees in the Softwareentwicklung department.
UPDATE personal
SET stundenlohn = stundenlohn * 1.04
WHERE abteilungsname = 'Softwareentwicklung';
-- n. The personal table is dispolayed with last name sorted in ascending order. 
SELECT * FROM personal
ORDER BY Nachname ASC;
