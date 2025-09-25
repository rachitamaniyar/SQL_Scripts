CREATE DATABASE customer;
USE customer;
CREATE TABLE customerinfo (KundenNr int AUTO_INCREMENT PRIMARY KEY,
Vorname varchar (70) NOT NULL,
Nachname varchar (70) NOT NULL,
Straße varchar (120), 
PLZ varchar (20),
Ort varchar (100),
EMail varchar (150),
Geburtsdatum date,
Stammkunde boolean,
Kundenbeschreibung text,
Skonto decimal (3,2) DEFAULT 0
);
ALTER TABLE customerinfo ADD hausnummer varchar (20);

INSERT INTO customerinfo (Vorname, Nachname, Straße, PLZ,Ort,EMail,Geburtsdatum,Stammkunde,Kundenbeschreibung,Skonto)
	VALUES ('Franz', 'Huber', 'Grazerstrasse 11', '8010','Graz', 'franz@huber.at', '1985-10-08', true, 'langer infotext', 2.5),
    ('Tim', 'Kindermann', 'Stattegger strasse 63', '8045', 'Graz', 'tim@kind.com','1996-01-21', true, 'Regular customer for Radler', 3.45),
    ('Sam','Saul', 'Pfefferstrasse, 01', '2115', 'Gmunden', 'somebodycall@saul.com', '2021-07-30', true, 'Nothing to say', 1.25);
    Select * from customerinfo;
INSERT INTO customerinfo (Vorname, Nachname, Straße, PLZ,Ort,EMail,Geburtsdatum,Stammkunde,Kundenbeschreibung)
	VALUES ('Anita', 'Meier', 'Hofstrasse, 34a', '5782', 'Innsbruck', 'meier@meier.at', '1965-11-19', false, 'Sweet old lady');
    Insert INTO customerinfo(
	vorname, nachname, Straße, hausnummer, plz, ort, email, geburtsdatum, stammkunde, kundenbeschreibung, skonto)
VALUES
	('Roman', 'Maier', 'Hofstraße', '11A Top1', 1010, 'Wien', 'r.maier@gmx.at', '1999-04-21', true, 'Infotext', 2.5);

    
Insert INTO customerinfo(
	vorname, nachname, Straße, hausnummer, plz, ort, email, geburtsdatum, stammkunde, kundenbeschreibung, skonto)
VALUES
	('Anna', 'Huber', 'Grazerstrasse', '11', 8010, 'Graz', 'anna@huber.at', '1992-11-21', false, 'Infotext 2', 1.0);
UPDATE customerinfo
SET email = 'f.huber@gmx.at'
WHERE Kundennr =1;
SELECT * FROM customerinfo WHERE plz = 8010;
SELECT kundennr, vorname, nachname, skonto
FROM customerinfo
WHERE skonto >= 2;
DELETE FROM customerinfo WHERE kundennr = 3;

-- erstellen der weiteren Tabelle bestellungen 1:N Beziehung zur Elterntabelle kunden
-- kundennr = Foreign Key
CREATE TABLE bestellungen(
    bestellnr int AUTO_INCREMENT PRIMARY KEY,
    rechnungsnr char(9) NOT NULL UNIQUE,
    bestellsumme decimal(8,2) not null,
    datum datetime not null,
    zahlungsart tinyint CHECK(zahlungsart<=10),
    versand boolean default true,
    bestellinfo text,
    kundennr int,
    FOREIGN KEY (kundennr) REFERENCES customerinfo(kundennr)
);




-- now() Funktion um das aktuelle Datum und die Zeit hinzuzufügen
INSERT INTO bestellungen (rechnungsnr,bestellsumme,datum,zahlungsart,versand,bestellinfo,kundennr)
    VALUES('2024-0001',512.22,now(),1,true,'bitte noch vor Ostern liefern',1);
     
INSERT INTO bestellungen (rechnungsnr,bestellsumme,datum,zahlungsart,versand,bestellinfo,kundennr)
    VALUES('2024-0002',101.50,now(),2,true,'bitte noch vor Ostern liefern',1);
    

-- Fehler Check - bestellung mit gleicher Rechnungsnummer
-- Error Code: 1062. Duplicate entry '2024-00002-a' for key 'rechnungsnr'
INSERT INTO bestellungen (rechnungsnr,bestellsumme,datum,zahlungsart,versand,bestellinfo,kundennr)
    VALUES('2024-0002',101.50,now(),'r',true,'bitte noch vor Ostern liefern',1);
    
    
-- select Abfrage 
select * from bestellungen;


-- Fehler Check - bestellung mit kundennr die es nicht gibt
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`kundenverwaltung`.`bestellungen`, CONSTRAINT `FK_bestellung_kunde` FOREIGN KEY (`kundennr`) REFERENCES `kunden` (`kundennr`))
INSERT INTO bestellungen (rechnungsnr,bestellsumme,datum,zahlungsart,versand,bestellinfo,kundennr)
    VALUES('2024-0003',512.22,now(),3,true,'Bitte erst in zwei Wochenl liefern!',100);

-- man kann keinen kunden löschen, wo es noch offene bestellungen gibt
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`kundenverwaltung`.`bestellungen`, CONSTRAINT `FK_bestellung_kunde` FOREIGN KEY (`kundennr`) REFERENCES `kunden` (`kundennr`))
delete from kunden WHERE kundennr = 1;


-- select Abfrage über mehrere Tabellen mit WHERE
select * from customerinfo, bestellungen
WHERE customerinfo.kundennr = bestellungen.kundennr;

-- select Abfrage über mehrere Tabellen mit INNER JOIN
select * from customerinfo
INNER JOIN bestellungen ON
customerinfo.kundennr = bestellungen.kundennr;

-- select Abfrage mit ausgewählten Attributen
select customerinfo.kundennr, customerinfo.vorname, customerinfo.nachname, bestellungen.rechnungsnr, bestellungen.datum
from customerinfo, bestellungen
WHERE customerinfo.kundennr = bestellungen.kundennr;

CREATE TABLE produkte (
    produktnr INT AUTO_INCREMENT PRIMARY KEY,
    preis INT NOT NULL,
    rabatt DECIMAL(3,1) DEFAULT 0,  -- percentage, e.g., 10.50%
    namen VARCHAR(100) NOT NULL,
    gewicht DECIMAL(4,1),          -- e.g., in kg or g, adjust as needed
    beschreibung TEXT NOT NULL,
    seriennummer INT NOT NULL UNIQUE,
    kategorie ENUM('kleidung', 'kosmetik', 'geschenk') NOT NULL,
    laenge DECIMAL(4,1),            -- Länge (length)
    breite DECIMAL(4,1),            -- Breite (width)
    hoehe DECIMAL(4,1),             -- Höhe (height)
    versandmerkmal ENUM('zerbrechlich', 'gekühlt', 'standard') DEFAULT 'standard',
    versandart ENUM('express', 'standard') DEFAULT 'standard',
    size varchar (100) NOT NULL,
    lagerbestand INT DEFAULT 0
) ;
CREATE TABLE bestellung_produkte (
    bestellnr INT,
    Produktnr INT,
    anzahl INT NOT NULL DEFAULT 1,          -- quantity of the product in the order
   --  einzelpreis DECIMAL(10,2) NOT NULL,    -- price per product at the time of order
    PRIMARY KEY (bestellnr, Produktnr),
    FOREIGN KEY (bestellnr) REFERENCES bestellungen(bestellnr), -- ON DELETE CASCADE . It ensures that if an order or product is deleted, related rows in this table are also deleted.
    FOREIGN KEY (Produktnr) REFERENCES produkte(Produktnr) -- ON DELETE CASCADE . It ensures that if an order or product is deleted, related rows in this table are also deleted.
);
drop table bestellung_produkte;

INSERT INTO produkte (preis, rabatt, namen, gewicht, beschreibung, seriennummer, kategorie, laenge, breite, hoehe, versandmerkmal, versandart, size, lagerbestand)
VALUES
(100, 10.00, 'T-Shirt', 0.25, 'Cotton T-shirt', 101, 'kleidung', 30.0, 20.0, 2.0, 'standard', 'standard', 'm', 50),
(25, 0, 'Lipstick', 0.05, 'Red lipstick', 102, 'kosmetik', 10.0, 3.0, 3.0, 'zerbrechlich', 'express', NULL, 100);
