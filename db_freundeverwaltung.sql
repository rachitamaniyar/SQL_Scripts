-- first comment using 2 hyphen and a space. Created a new database
CREATE database Freundeverwaltung;

-- Choice for Database
USE Freundeverwaltung;

/* 
Creating a new table with pk idFreund with
consecutive numbering (Fortlaufender nummer)
Auto-increment begins automatically at 1.
*/
CREATE TABLE freund (
idFreund int auto_increment primary key,
vorname varchar (50) not null,
nachname varchar (50) not null,
geburtsdatum date,
bestfriend boolean DEFAULT false

);
INSERT INTO freund (vorname,nachname,geburtsdatum,bestfriend)
	VALUES('Franzi','Huber','1990-10-20', true);

    INSERT INTO freund (vorname,nachname,geburtsdatum)
	VALUES('Rosy','Sharma','1990-10-22'), ('Kirti','Mahesh','1988-04-20');
    select * From freund;
    Delete from freund where idFreund = 6;
    delete from freund;
    Update freund set nachname='Saboo' where idFreund=7;
