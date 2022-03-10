-- 1.
CREATE TABLE PetStore (
	Name VARCHAR(64),
	Breed VARCHAR(32),
	BirthDate DATE,
	Price DECIMAL(6, 2)
	);

-- 2.
INSERT INTO PetStore (Name, Breed, BirthDate, Price) 
VALUES ('Angel', 'Golden Retriever', '3/1/2019', 89.99);

-- 3.
SELECT *  
FROM PetStore;

-- 4.
UPDATE PetStore 
SET Price = 99.99;

SELECT *  
FROM PetStore;

-- 5.
DELETE FROM PetStore;

SELECT *  
FROM PetStore;

-- 6.
DROP TABLE PetStore;

SELECT *  
FROM PetStore;

-- 7.
CREATE TABLE Vacation (
	VacationId DECIMAL(12) PRIMARY KEY,
	Location VARCHAR(64) NOT NULL,
	Description VARCHAR(1024),
	StartedOn DATE NOT NULL,
	EndedOn DATE NOT NULL
	);

-- 8.
INSERT INTO Vacation (VacationId, Location, Description, StartedOn, EndedOn) 
VALUES (1, 'Costa Rica', 'Relaxing Hot Springs', '1/13/2019', '1/21/2019');

INSERT INTO Vacation (VacationId, Location, Description, StartedOn, EndedOn) 
VALUES (2, 'Bora Bora', 'Exciting Snorkeling', '3/5/2019', '3/15/2019');

INSERT INTO Vacation (VacationId, Location, Description, StartedOn, EndedOn) 
VALUES (3, 'Jamaica', NULL, '12/10/2018', '12/28/2018');

SELECT *  
FROM Vacation;

-- 9. will not work, violates Location's NOT NULL constraint.
INSERT INTO Vacation (VacationId, Location, Description, StartedOn, EndedOn) 
VALUES (4, NULL, 'Experience the Netherlands No Other Way', '1/1/2020', '1/10/2020');

-- 10.
INSERT INTO Vacation (VacationId, Location, Description, StartedOn, EndedOn) 
VALUES (4, 'Netherlands', 'Experience the Netherlands No Other Way', '1/1/2020', '1/10/2020');

-- 11.
SELECT Location, Description 
FROM Vacation
WHERE VacationId = 2;

-- 12.
UPDATE Vacation 
SET Description = 'Aquatic Wonders'
WHERE Location = 'Jamaica';

SELECT *
FROM Vacation;

-- 13.
UPDATE Vacation 
SET Description = NULL
WHERE Location = 'Jamaica';

SELECT *
FROM Vacation;

-- 14.
DELETE FROM Vacation
WHERE StartedOn > '6/1/2019';

SELECT *
FROM Vacation;

-- 15. a)
CREATE TABLE DogStore (
	Name VARCHAR(64),
	Breed VARCHAR(32),
	Price DECIMAL(6)
	);

-- 15. b)
INSERT INTO DogStore (Name, Breed, Price) 
VALUES ('Charlie', 'Labrador Retriever', 1222);

INSERT INTO DogStore (Name, Breed, Price) 
VALUES ('Charlie', 'Labrador Retriever', 1111);

INSERT INTO DogStore (Name, Breed, Price) 
VALUES ('Oakley', 'American Bulldog', 1200);

INSERT INTO DogStore (Name, Breed, Price) 
VALUES ('Toby', 'Siberian Husky', 1100);

SELECT *
FROM DogStore;

-- 15. c)
DELETE FROM DogStore
WHERE Name = 'Charlie' AND Breed = 'Labrador Retriever';

SELECT *
FROM DogStore;