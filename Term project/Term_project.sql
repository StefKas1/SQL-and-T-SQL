-- DROPS (to run queries multiple times).
DROP TABLE RentalPriceChange;
DROP TABLE Invoice;
DROP TABLE RentalAgreement;
DROP TABLE Scooter;
DROP TABLE Advertisement;
DROP TABLE Employee;
DROP TABLE CreditCard;
DROP TABLE [User]; -- [] indicates that keyword User is not meant, but an object with the name User.
DROP TABLE Person;
DROP TABLE Branch;
DROP TABLE AdvertisingAgency;
DROP SEQUENCE PersonSeq;
DROP SEQUENCE CreditCardSeq;
DROP SEQUENCE InvoiceSeq;
DROP SEQUENCE RentalAgreementSeq;
DROP SEQUENCE BranchSeq;
DROP SEQUENCE ScooterSeq;
DROP SEQUENCE AdvertisementSeq;
DROP SEQUENCE AdvertisingAgencySeq;
DROP SEQUENCE RentalPriceChangeSeq;
DROP PROCEDURE AddPersonAsUserOrEmployee;
DROP PROCEDURE AddBranch;
DROP PROCEDURE AddScooter;
DROP VIEW View_scooters_rented_per_branch_this_and_last_year


-- TABLES
CREATE TABLE Person (
	PersonID DECIMAL(12) NOT NULL PRIMARY KEY,
	FirstName VARCHAR(35) NOT NULL,
	LastName VARCHAR(35) NOT NULL,
	DateOfBirth DATE NOT NULL,
	StreetName VARCHAR(35) NOT NULL,
	HouseNumber VARCHAR(35) NOT NULL,
	ZipCode VARCHAR(10) NOT NULL,
	City VARCHAR(35) NOT NULL,
	TelephoneNumber VARCHAR(15) NOT NULL,
	EmailAddress VARCHAR(255) NOT NULL,
	IsUser BIT DEFAULT 0,
	IsEmployee BIT DEFAULT 0
	);

CREATE TABLE Branch (
	BranchID DECIMAL(12) NOT NULL PRIMARY KEY,
	StreetName VARCHAR(35) NOT NULL,
	HouseNumber VARCHAR(35) NOT NULL,
	ZipCode VARCHAR(10) NOT NULL,
	City VARCHAR(35) NOT NULL,
	TelephoneNumber VARCHAR(15) NOT NULL,
	EmailAddress VARCHAR(255) NOT NULL
	);

CREATE TABLE AdvertisingAgency (
	AdvertisingAgencyID DECIMAL(12) NOT NULL PRIMARY KEY,
	AdvertisingAgencyName VARCHAR(255) NOT NULL,
	TelephoneNumber VARCHAR(15) NOT NULL,
	EmailAddress VARCHAR(255) NOT NULL
	);

CREATE TABLE [User] (
	PersonID DECIMAL(12) NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Person(PersonID),
	RegistrationDate DATE NOT NULL,
	EncryptedPassword VARCHAR(255) NOT NULL
	);

CREATE TABLE CreditCard (
    CreditCardID DECIMAL(12) NOT NULL PRIMARY KEY,
    PersonID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES [User](PersonID),
    CardNumber VARCHAR(16) NOT NULL,
    CardholderFirstName VARCHAR(35) NOT NULL,
    CardholderLastName VARCHAR(35) NOT NULL,
    ExpiryDate DATE NOT NULL
	);

CREATE TABLE Employee (
    PersonID DECIMAL(12) NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Person(PersonID),
    BranchID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Branch(BranchID),
    Position VARCHAR(255) NOT NULL,
	HireDate DATE NOT NULL
	);

CREATE TABLE Advertisement (
	AdvertisementID DECIMAL(12) NOT NULL PRIMARY KEY,
    BranchID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Branch(BranchID),
    AdvertisingAgencyID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES AdvertisingAgency(AdvertisingAgencyID),
    Title VARCHAR(255) NOT NULL,
    Message VARCHAR(2048) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE, -- Can be unknown when creating an advertisement, therefore without NOT NULL constraint.
    Budget DECIMAL(9, 2) NOT NULL
	);

CREATE TABLE Scooter (
    ScooterID DECIMAL(12) NOT NULL PRIMARY KEY,
    BranchID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Branch(BranchID),
    ScooterName VARCHAR(255) NOT NULL,
    ScooterVendor VARCHAR(255) NOT NULL,
    MaximumRange DECIMAL(3) NOT NULL,
    MaximumSpeed DECIMAL(3) NOT NULL,
    ConstructionYear SMALLINT NOT NULL,
    HourlyRate DECIMAL(5, 2) NOT NULL,
	ScooterStatus VARCHAR(35) NOT NULL
	);

CREATE TABLE RentalAgreement (
    RentalAgreementID DECIMAL(12) NOT NULL PRIMARY KEY,
    PersonID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES [User](PersonID),
    BranchID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Branch(BranchID),
    ScooterID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Scooter(ScooterID),
    StartDateTime DATETIME NOT NULL,
    EndDateTime DATETIME -- Can be NULL according to uses cases.
	);

CREATE TABLE Invoice (
    InvoiceID DECIMAL(12) NOT NULL PRIMARY KEY,
    RentalAgreementID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES RentalAgreement(RentalAgreementID),
    InvoiceDate DATE NOT NULL,
    PaymentDate DATE -- Can be NULL according to uses cases.
	);

CREATE TABLE RentalPriceChange ( -- History table.
    RentalPriceChangeID DECIMAL(12) NOT NULL PRIMARY KEY,
    ScooterID DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Scooter(ScooterID),
    OldHourlyRate DECIMAL(5, 2) NOT NULL,
    NewHourlyRate DECIMAL(5, 2) NOT NULL,
	ChangeDate DATE NOT NULL
	);


-- SEQUENCES
CREATE SEQUENCE PersonSeq START WITH 1;
CREATE SEQUENCE CreditCardSeq START WITH 1;
CREATE SEQUENCE InvoiceSeq START WITH 1;
CREATE SEQUENCE RentalAgreementSeq START WITH 1;
CREATE SEQUENCE BranchSeq START WITH 1;
CREATE SEQUENCE ScooterSeq START WITH 1;
CREATE SEQUENCE AdvertisementSeq START WITH 1;
CREATE SEQUENCE AdvertisingAgencySeq START WITH 1;
CREATE SEQUENCE RentalPriceChangeSeq START WITH 1;


--INDEXES
CREATE UNIQUE INDEX UserPersonIDIdx
ON [User](PersonID);
CREATE UNIQUE INDEX EmployeePersonIDIdx
ON Employee(PersonID);
CREATE INDEX EmployeeBranchIDIdx
ON Employee(BranchID);
CREATE INDEX CreditCardPersonIDIdx
ON CreditCard(PersonID);
CREATE UNIQUE INDEX InvoiceRentalAgreementIDIdx
ON Invoice(RentalAgreementID);
CREATE INDEX RentalAgreementPersonIDIdx
ON RentalAgreement(PersonID);
CREATE INDEX RentalAgreementBranchIDIdx
ON RentalAgreement(BranchID);
CREATE INDEX RentalAgreementScooterIDIdx
ON RentalAgreement(ScooterID);
CREATE INDEX ScooterBranchIDIdx
ON Scooter(BranchID);
CREATE INDEX AdvertisementBranchIDIdx
ON Advertisement(BranchID);
CREATE INDEX AdvertisementAdvertisingAgencyIDIdx
ON Advertisement(AdvertisingAgencyID);
CREATE INDEX RentalPriceChangeIDIdx
ON RentalPriceChange(RentalPriceChangeID);


--STORED PROCEDURES
-- Defines stored procedure.
CREATE OR ALTER PROCEDURE AddBranch
	@StreetName VARCHAR(35),
	@HouseNumber VARCHAR(35),
	@ZipCode VARCHAR(10),
	@City VARCHAR(35),
	@TelephoneNumber VARCHAR(15),
	@EmailAddress VARCHAR(255)
AS 
BEGIN
	-- Parameter validation.
	IF (@StreetName = '' OR @HouseNumber = '' OR @ZipCode = '' OR @City = '' OR
		@TelephoneNumber = '' OR @EmailAddress = '')
	BEGIN
		RAISERROR('Invalid parameter: none of the parameters can be an empty string.', 18, 0)
		RETURN
	END

	IF (@HouseNumber NOT LIKE '%[0-9]%')
	BEGIN
		RAISERROR('Invalid parameter: @HouseNumber must contain at least one number.', 18, 0)
		RETURN
	END

	IF (@TelephoneNumber LIKE '%[^0-9]%')
	BEGIN
		RAISERROR('Invalid parameter: @TelephoneNumber must only contain numbers.', 18, 0)
		RETURN
	END

		IF (@EmailAddress NOT LIKE '%@%')
	BEGIN
		RAISERROR('Invalid parameter: @EmailAddress must contain an @ sign.', 18, 0)
		RETURN
	END

  INSERT INTO Branch(BranchID, StreetName, HouseNumber, ZipCode, City, TelephoneNumber, EmailAddress)
  VALUES(NEXT VALUE FOR BranchSeq, @StreetName, @HouseNumber, @ZipCode, @City, @TelephoneNumber, @EmailAddress);
END;

-- Uses stored procedure.
BEGIN TRANSACTION AddBranch;
EXECUTE AddBranch 'Dorotheenplatz', '1A', '70173', 'Stuttgart', '071120702009', 'hub@scooterrent.com';
COMMIT TRANSACTION AddBranch;

BEGIN TRANSACTION AddBranch;
EXECUTE AddBranch 'Motorstraße', 38, 70499, 'Stuttgart', '071189989083', 'info@scooterrent.com';
COMMIT TRANSACTION AddBranch;

BEGIN TRANSACTION AddBranch;
EXECUTE AddBranch 'Mercedesstraße', 120, 70372, 'Stuttgart', '0711170', 'info@scooterrent.com';
COMMIT TRANSACTION AddBranch;

-- Defines stored procedure.
CREATE OR ALTER PROCEDURE AddPersonAsUserOrEmployee
	-- Person.
	@FirstName VARCHAR(35),
	@LastName VARCHAR(35),
	@DateOfBirth DATE,
	@StreetName VARCHAR(35),
	@HouseNumber VARCHAR(35),
	@ZipCode VARCHAR(10),
	@City VARCHAR(35),
	@TelephoneNumber VARCHAR(15),
	@EmailAddress VARCHAR(255),
	@IsUser BIT,
	@IsEmployee BIT,
	-- User.
	@RegistrationDate DATE,
	@EncryptedPassword VARCHAR(255),
	-- Employee.
    @BranchID DECIMAL(12),
    @Position VARCHAR(255),
	@HireDate DATE
AS 
BEGIN
	-- Parameter validation.
	IF (@FirstName = '' OR @LastName = '' OR @StreetName = '' OR @HouseNumber = '' OR
		@ZipCode = '' OR @City = '' OR @TelephoneNumber = '' OR @EmailAddress = '')
	BEGIN
		RAISERROR('Invalid parameter: none of the parameters can be an empty string.', 18, 0)
		RETURN
	END

		IF (@HouseNumber NOT LIKE '%[0-9]%')
	BEGIN
		RAISERROR('Invalid parameter: @HouseNumber must contain at least one number.', 18, 0)
		RETURN
	END

	IF (@TelephoneNumber LIKE '%[^0-9]%')
	BEGIN
		RAISERROR('Invalid parameter: @TelephoneNumber must only contain numbers.', 18, 0)
		RETURN
	END

	IF (@EmailAddress NOT LIKE '%@%')
	BEGIN
		RAISERROR('Invalid parameter: @EmailAddress must contain an @ sign.', 18, 0)
		RETURN
	END

	IF (DATEDIFF(YEAR, @DateOfBirth, GETDATE()) > 120)
	BEGIN
		RAISERROR('Invalid parameter: @DateOfBirth; person cannot be older than 120 years.', 18, 0)
		RETURN
	END
 
	DECLARE @PersonID DECIMAL(12);
	SET @PersonID = NEXT VALUE FOR PersonSeq;
	-- Inserts Person.
	INSERT INTO Person(PersonID, FirstName, LastName, DateOfBirth, StreetName, HouseNumber, ZipCode,
		City, TelephoneNumber, EmailAddress, IsUser, IsEmployee) 
	VALUES(@PersonID, @FirstName, @LastName, @DateOfBirth, @StreetName, @HouseNumber, @ZipCode,
		@City, @TelephoneNumber, @EmailAddress, @IsUser, @IsEmployee);
	-- Inserts User.
	IF (@IsUser = 1)
	BEGIN
		IF (@RegistrationDate < '01/01/2019')
		BEGIN
			RAISERROR('Invalid parameter: @RegistrationDate must be after ScooterRent was created on 01/01/2019.', 18, 0)
			RETURN
		END
		INSERT INTO [User](PersonID, RegistrationDate, EncryptedPassword) VALUES(@PersonID, @RegistrationDate, @EncryptedPassword);
	END
	-- Inserts Employee.
	IF (@IsEmployee = 1)
	BEGIN
		IF (@HireDate < '01/01/2018')
		BEGIN
			RAISERROR('Invalid parameter: @HireDate must be after ScooterRent was founded on 01/01/2018.', 18, 0)
			RETURN
		END
		INSERT INTO Employee(PersonID, BranchID, Position, HireDate) VALUES(@PersonID, @BranchID, @Position, @HireDate);
	END
END;

-- Uses stored procedure.
BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Abby', 'Aoe', '06/22/1990', 'Sonnenallee', '94', '86074', 'Augsburg', '0821794234', 'AA@gmail.com', 1, 0,
	'05/24/2020', 'qQuQ8VI60eZzJQt1sJhm', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Brian', 'Boe', '06/26/1989', 'Mohrenstrasse', '51', '72178', 'Waldachtal', '07443251328', 'BB@gmail.com', 1, 0,
	'04/26/2020', 'ln6JQvyV4NXzopzO0VIB', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Charlie', 'Coe', '06/18/1958', 'Heinrich Heine Platz', '63', '99878', 'Waltershausen', '03622978462', 'CC@gmail.com', 1, 0,
	'10/01/2020', 'mNf7KZ2Zkj0bfHy5w7Oq', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Daisy', 'Doe', '02/25/1986', 'Michaelkirchstr.', '93', '31707', 'Heeßen', '05722567962', 'DD@gmail.com', 1, 0, 
	'04/03/2020', 'IPrTw5Ml58VtppeKzifx', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Elliott', 'Eoe', '06/26/1980', 'Gruenauer Strasse', '95', '21698', 'Brest', '04166391948', 'EE@gmail.com', 1, 0,
	'06/15/2020', '9MCrlVmv3u3Ug0Oa5DuB', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Finley', 'Foe', '06/20/1956', 'Gotzkowskystrasse', '43', '56477', 'Waigandshain', '02664623798', 'FF@gmail.com', 1, 0,
	'07/26/2020', 'M06cK5PEe3nsztdzXAQI', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Graham', 'Goe', '06/10/1994', 'Los-Angeles-Platz', '35', '22047', 'Hamburg', '040261144', 'GG@gmail.com', 1, 0,
	'11/10/2020', 'dQdFDq3T3I1bpFHgWnwZ', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Hudson', 'Hoe', '12/07/1976', 'Kieler Strasse', '39', '94049', 'Hauzenberg', '08586630884', 'HH@gmail.com', 1, 0,
	'01/19/2021', 'DAdhBTW7xC6l5AVuug6p', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Isabella', 'Ioe', '12/19/1960', 'Unter den Linden', '67', '19001', 'Schwerin', '0385662046', 'II@gmail.com', 1, 0,
	'06/11/2020', 'noBGguefASm0maUb8lKx', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Jessica', 'Joe', '03/12/1967', 'Hedemannstasse', '22', '79650', 'Schopfheim', '07622825290', 'JJ@gmail.com', 1, 0,
	'01/16/2021', 'ojJlaNRXd0xG8WCJ80he', NULL, NULL, NULL;
COMMIT TRANSACTION AddPersonAsUserOrEmployee;


BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Katie', 'Koe', '02/28/1987', 'Kronprinzstraße', '11', '70173', 'Stuttgart', '071165626187', 'KK@gmail.com', 0, 1,
	NULL, NULL, 1, 'Operations manager', '07/27/2019';
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Liam', 'Loe', '07/27/2003', 'Wächterstraße', '2', '70182', 'Stuttgart', '0711232222', 'LL@gmail.com', 0, 1,
	NULL, NULL, 1, 'HR manager', '02/28/2019';
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Mia', 'Moe', '03/29/1996', 'Rosensteinstraße', '9', '70191', 'Stuttgart', '071125377277', 'MM@gmail.com', 0, 1,
	NULL, NULL, 2, 'Operations manager', '05/02/2019';
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Noah', 'Noe', '05/02/1984', 'Rotebühlpl', '1', '70178', 'Stuttgart', '07116159115', 'NN@gmail.com', 0, 1,
	NULL, NULL, 2, 'Marketing manager', '03/29/2019';
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee 'Olivia', 'Ooe', '08/28/1992', 'Bolzstraße', '10', '70173', 'Stuttgart', '071190715969', 'OO@gmail.com', 0, 1,
	NULL, NULL, 3, 'Operations manager', '05/02/2019';
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

BEGIN TRANSACTION AddPersonAsUserOrEmployee;
EXECUTE AddPersonAsUserOrEmployee  'Parker', 'Poe', '05/02/1991', 'Neckarstraße', '122', '70190', 'Stuttgart', '0711260117', 'PP@gmail.com', 0, 1,
	NULL, NULL, 3, 'Accounting manager', '08/28/2019';
COMMIT TRANSACTION AddPersonAsUserOrEmployee;

-- Defines stored procedure.
CREATE OR ALTER PROCEDURE AddScooter
    @BranchID DECIMAL(12),
    @ScooterName VARCHAR(255),
    @ScooterVendor VARCHAR(255),
    @MaximumRange DECIMAL(3),
    @MaximumSpeed DECIMAL(3),
    @ConstructionYear SMALLINT,
    @HourlyRate DECIMAL(5, 2),
	@ScooterStatus VARCHAR(35)
AS 
BEGIN
	-- Parameter validation.
	IF (@ScooterName = '' OR @ScooterVendor = '' OR @ScooterStatus = '')
	BEGIN
		RAISERROR('Invalid parameter: @ScooterName, @ScooterVendor or @ScooterStatus cannot be an empty string.', 18, 0)
		RETURN
	END

	IF (@MaximumRange <= 0 OR @MaximumSpeed <= 0)
	BEGIN
		RAISERROR('Invalid parameter: @MaximumRange or @MaximumSpeed must be greater than zero.', 18, 0)
		RETURN
	END

	IF (@ConstructionYear <= 1999)
	BEGIN
		RAISERROR('Invalid parameter: @ConstructionYear must be after 1999.', 18, 0)
		RETURN
	END

		IF (@HourlyRate <= 0)
	BEGIN
		RAISERROR('Invalid parameter: @HourlyRate must be greater than zero.', 18, 0)
		RETURN
	END
  INSERT INTO Scooter(ScooterID, BranchID, ScooterName, ScooterVendor, MaximumRange, MaximumSpeed, ConstructionYear, HourlyRate, ScooterStatus)
  VALUES(NEXT VALUE FOR ScooterSeq, @BranchID, @ScooterName, @ScooterVendor, @MaximumRange, @MaximumSpeed, @ConstructionYear, @HourlyRate, @ScooterStatus);
END;

-- Uses stored procedure.
BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 1, 'TVS iQube Electric', 'TVS', 75, 78, 2022, 19.99, 'Operational';
COMMIT TRANSACTION AddScooter;

BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 1, 'Revolt RV400', 'TVS', 150, 130, 2021, 34.99, 'Operational';
COMMIT TRANSACTION AddScooter;

BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 1, 'Ola S1', 'Espano', 180, 75, 2021, 22.99, 'Operational';
COMMIT TRANSACTION AddScooter;

BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 1, 'Ola S2 iX', 'Espano', 195, 80, 2021, 24.99, 'Operational';
COMMIT TRANSACTION AddScooter;

BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 1, 'Nova Motors eRetro Star li Premium 50', 'Nova', 135, 45, 2022, 19.99, 'Operational';
COMMIT TRANSACTION AddScooter;

BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 1, 'Inoa Sli4 50', 'Nova', 135, 45, 2022, 19.99, 'Operational';
COMMIT TRANSACTION AddScooter;

BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 1, 'Horwin EK3', 'Nova', 180, 95, 2022, 29.99, 'Operational';
COMMIT TRANSACTION AddScooter;

BEGIN TRANSACTION AddScooter;
EXECUTE AddScooter 2, 'Ola S1 AB1', 'Espano', 160, 75, 2021, 22.99, 'Operational';
EXECUTE AddScooter 2, 'Ola S2 XGi', 'Espano', 170, 76, 2021, 23.99, 'Operational';
EXECUTE AddScooter 3, 'Ola S3 iX3', 'Espano', 190, 77, 2021, 24.99, 'Operational';
EXECUTE AddScooter 3, 'Ola S4 iX4', 'Espano', 200, 78, 2021, 25.99, 'Operational';
EXECUTE AddScooter 3, 'Ola S4 iXX', 'Espano', 210, 79, 2021, 29.99, 'Operational';
COMMIT TRANSACTION AddScooter;

--INSERTS
BEGIN TRANSACTION;  
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Marcis', '01724060569', 'contact@marcis.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Unger', '0711250170', 'contact@unger.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Agency Anmut', '071121955150', 'contact@anmut.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Trendalo', '071146052023', 'contact@trendalo.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Liganova', '0711652200', 'contact@liganova.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Oddity', '071124849160', 'contact@oddity.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Panama', '07112489240', 'contact@panama.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'The Crew', '0711135450', 'contact@crew.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Mosaiq', '071183948480', 'contact@mosaiq.com');
INSERT INTO AdvertisingAgency (AdvertisingAgencyID, AdvertisingAgencyName, TelephoneNumber, EmailAddress) 
VALUES (NEXT VALUE FOR AdvertisingAgencySeq, 'Artismedia', '0711239120', 'contact@artismedia.com');
COMMIT TRANSACTION; 

BEGIN TRANSACTION;
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 1, 1, 'Good, better, ScooterRent', 'Looking for an affordable electric scooter, Scooter Rent.', '3/25/2022', '4/25/2022', 10000);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 1, 1, 'Wow', 'The cheapest electric scooter renting app, ScooterRent.', '3/25/2022', '4/25/2022', 1000);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 1, 2, 'Hello, flash', 'Choose an electric scooter that is right for you.', '4/25/2022', '5/25/2022', 8000);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 1, 3, 'Cool electric scooter', 'We are constantly innovating new features.', '7/25/2022', '8/25/2022', 500);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 2, 4, 'Whizz', 'Electric scooters for teens and adults. There is an electric scooter for you at ScooterRent.', '1/11/2022', '1/31/2022', 10000);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 2, 5, 'Electric scooter at ...', 'Whether you are looking for a way to get to work in Stuttgart ...', '7/25/2022', '8/25/2022', 15000);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 2, 6, 'Outdoor action', 'Rethink your ride with ScooterRent.', '8/25/2022', '9/25/2022', 3000);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 2, 7, 'ScooterRent', 'Electric scooter rentals from ScooterRent.', '6/25/2022', '8/25/2022', 2500);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 2, 7, 'Unlock life', 'Looking to rental an electric scooter?', '10/25/2022', '11/25/2022', 10000);
INSERT INTO Advertisement(AdvertisementID, BranchID, AdvertisingAgencyID, Title, Message, StartDate, EndDate, Budget) 
VALUES (NEXT VALUE FOR AdvertisementSeq, 3, 8, 'Noise free', 'OUR MISSION: NO EMISSION, ScooterRent.', '11/25/2022', '12/25/2022', 13000);
COMMIT TRANSACTION; 

BEGIN TRANSACTION;
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'AA@gmail.com'), '4779444357410324', 'Abby', 'Aoe', '08/31/2027');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'BB@gmail.com'), '4406354345867074', 'Brian', 'Boe', '07/31/2026');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'CC@gmail.com'), '4920442908996328', 'Charlie', 'Coe', '01/31/2030');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'DD@gmail.com'), '4543041485585574', 'Daisy', 'Doe', '10/31/2027');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'EE@gmail.com'), '4920446450543933', 'Elliott', 'Eoe', '05/31/2028');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'FF@gmail.com'), '4168367570782154', 'Finley', 'Foe', '07/31/2027');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'GG@gmail.com'), '5446915467784708', 'Graham', 'Goe', '04/30/2030');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'HH@gmail.com'), '5130206121730274', 'Hudson', 'Hoe', '07/31/2023');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'II@gmail.com'), '5375039410116424', 'Isabella', 'Ioe', '10/31/2024');
INSERT INTO CreditCard(CreditCardID, PersonID, CardNumber, CardholderFirstName, CardholderLastName, ExpiryDate) 
VALUES (NEXT VALUE FOR CreditCardSeq, (SELECT PersonID FROM Person WHERE EmailAddress = 'JJ@gmail.com'), '5446915150417152', 'Jessica', 'Joe', '12/31/2028');
COMMIT TRANSACTION; 

BEGIN TRANSACTION;
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 1, 1,  '2021-12-02T13:00:00', '2021-12-03T17:38:00');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 1, 1,  '2021-12-03T13:00:00', '2021-12-04T17:38:00');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 2, 1,  '2021-12-04T13:00:00', '2021-12-05T17:38:00');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 2, 1,  '2021-12-05T13:00:00', '2021-12-06T17:38:00');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 2, 1,  '2021-12-06T13:00:00', '2021-12-07T17:38:00');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 2, 1,  '2021-12-07T13:00:00', '2021-12-08T17:38:00');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 3, 1,  '2021-12-08T13:00:00', '2021-12-09T17:38:00');

INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 1, 1,  '2022-01-02T13:00:00', '2022-01-08T17:38:00');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 2, 1, 2,  '2022-01-08T13:59:59', '2022-01-09T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 3, 1, 3,  '2022-01-10T13:59:59', '2022-01-11T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 4, 1, 4,  '2022-01-12T13:59:59', '2022-01-13T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 5, 1, 5,  '2022-01-14T13:59:59', '2022-01-15T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 6, 1, 6,  '2022-01-16T13:59:59', '2022-01-17T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 7, 1, 7,  '2022-01-18T13:59:59', '2022-01-19T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 8, 2, 8,  '2022-01-20T13:59:59', '2022-01-21T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 9, 2, 9,  '2022-01-22T13:59:59', '2022-01-23T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 10, 2, 8,  '2022-01-24T13:59:59', '2022-01-25T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 1, 3, 10,  '2022-01-26T13:59:59', '2022-01-27T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 2, 3, 11,  '2022-01-28T13:59:59', '2022-01-29T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 3, 3, 12,  '2022-01-30T13:59:59', '2022-01-31T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 4, 3, 10,  '2022-02-01T13:59:59', '2022-02-02T17:59:59');
INSERT INTO RentalAgreement(RentalAgreementID, PersonID, BranchID, ScooterID, StartDateTime, EndDateTime) 
VALUES (NEXT VALUE FOR RentalAgreementSeq, 5, 3, 11,  '2022-02-03T13:59:59', '2022-02-04T17:59:59');
COMMIT TRANSACTION; 

BEGIN TRANSACTION;
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 1, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 1),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 1));
	INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 2, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 2),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 2));
	INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 3, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 3),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 3));
	INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 4, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 4),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 4));
	INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 5, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 5),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 5));
	INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 6, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 6),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 6));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 7, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 7),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 7));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 8, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 8),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 8));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 9, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 9),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 9));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 10, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 10),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 10));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 11, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 11),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 11));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 12, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 12),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 12));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 13, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 13),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 13));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 14, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 14),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 14));
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 15, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 15),
	(SELECT DATEADD(DD, 2, EndDateTime) FROM RentalAgreement WHERE RentalAgreementID = 15));

INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 16, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 16), NULL);
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 17, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 17), NULL);
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 18, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 18), NULL);
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 19, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 19), NULL);
INSERT INTO Invoice(InvoiceID, RentalAgreementID, InvoiceDate, PaymentDate) 
VALUES (NEXT VALUE FOR InvoiceSeq, 20, (SELECT EndDateTime FROM RentalAgreement WHERE RentalAgreementID = 20), NULL);
COMMIT TRANSACTION; 

-- Selects to check the inserts.
SELECT * FROM Branch;
SELECT * FROM Scooter;
SELECT * FROM AdvertisingAgency;
SELECT * FROM Advertisement;
SELECT * FROM Person;
SELECT * FROM [User];
SELECT * FROM Employee;
SELECT * FROM CreditCard;
SELECT * FROM RentalAgreement;
SELECT * FROM Invoice;


--QUERIES
-- With which 10 users did scooter rent achieve the highest annual revenue in 2022?
SELECT TOP 10 FORMAT(SUM(DATEDIFF(MINUTE, StartDateTime, EndDateTime) / 60.0 * HourlyRate), '#,0. €') AS 'Total annual revenue in 2022 per user',
	Person.PersonID AS 'User ID', FirstName AS 'First name', LastName AS 'Last name', EmailAddress AS 'Email address'
FROM RentalAgreement
JOIN Scooter ON Scooter.ScooterID = RentalAgreement.ScooterID
JOIN [User] ON [User].PersonID = RentalAgreement.PersonID
JOIN Person ON Person.PersonID = RentalAgreement.PersonID
WHERE YEAR(EndDateTime) = 2022
GROUP BY Person.PersonID, FirstName, LastName, EmailAddress
ORDER BY LEN(SUM(DATEDIFF(MINUTE, StartDateTime, EndDateTime) / 60.0 * HourlyRate)) DESC, 'Total annual revenue in 2022 per user' DESC;

-- Which invoices have been overdue for how many days and for what amount? 
SELECT InvoiceID, InvoiceDate AS 'Invoice date', DATEDIFF(DAY, InvoiceDate, GETDATE()) - 10 AS 'Days overdue',
	FORMAT(DATEDIFF(MINUTE, StartDateTime, EndDateTime) / 60.0 * HourlyRate, '.00 €') AS 'Amount overdue',
	FirstName AS 'First name', LastName AS 'Last name', EmailAddress AS 'Email address'
FROM Invoice
JOIN RentalAgreement ON RentalAgreement.RentalAgreementID = Invoice.RentalAgreementID
JOIN Scooter ON Scooter.ScooterID = RentalAgreement.ScooterID
JOIN [User] ON [User].PersonID = RentalAgreement.PersonID
JOIN Person ON  Person.PersonID = [User].PersonID
WHERE PaymentDate IS NULL AND DATEDIFF(DAY, InvoiceDate, GETDATE()) > 10;

-- How many scooters were rented this and last year per branch?
-- Defines view.
CREATE OR ALTER VIEW View_scooters_rented_per_branch_this_and_last_year AS 
SELECT BranchID, COUNT(RentalAgreementID) AS 'Number of rented scooters per branch', YEAR(GETDATE()) AS 'Year'
FROM RentalAgreement
WHERE YEAR(StartDateTime) = YEAR(GETDATE())
GROUP BY BranchID
UNION
SELECT BranchID, COUNT(RentalAgreementID) AS 'Number of rented scooters per branch', YEAR(GETDATE()) - 1 AS 'Year'
FROM RentalAgreement
WHERE YEAR(StartDateTime) = YEAR(GETDATE()) - 1
GROUP BY BranchID;

-- Uses view.
SELECT *
FROM View_scooters_rented_per_branch_this_and_last_year
ORDER BY BranchID, [Year] DESC;


--TRIGGERS
CREATE OR ALTER TRIGGER RentalPriceChangeTrigger 
ON Scooter 
AFTER UPDATE 
AS 
BEGIN 
	DECLARE @OldHourlyRate DECIMAL(5, 2) = (SELECT HourlyRate FROM DELETED); 
	DECLARE @NewHourlyRate DECIMAL(5, 2) = (SELECT HourlyRate FROM INSERTED); 
   
	IF (@OldHourlyRate <> @NewHourlyRate) 
		INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
		VALUES(NEXT VALUE FOR RentalPriceChangeSeq, (SELECT ScooterID FROM INSERTED), @OldHourlyRate, @NewHourlyRate, GETDATE()); 
END;


-- Changes hourly rates.
UPDATE Scooter SET HourlyRate = 24.99 WHERE ScooterID = 1;
UPDATE Scooter SET HourlyRate = 26.99 WHERE ScooterID = 2;
UPDATE Scooter SET HourlyRate = 34.99 WHERE ScooterID = 3;
UPDATE Scooter SET HourlyRate = 14.99 WHERE ScooterID = 4;
UPDATE Scooter SET HourlyRate = 54.99 WHERE ScooterID = 5;
UPDATE Scooter SET HourlyRate = 64.99 WHERE ScooterID = 5;
UPDATE Scooter SET HourlyRate = 74.99 WHERE ScooterID = 5;

SELECT * FROM RentalPriceChange;


--QUERIES
-- Adds values ​​to the history table to have 3 different dates in the history table. 
-- Note: like below, no values ​​should be added to the history table. It was only done this way so as not
-- to have to wait 3 days to create a meaningful visualization of the history table.
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 1, 24.99, 14.99, DATEADD(DD, -1, CAST(GETDATE() AS DATE)));
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 2, 26.99, 16.99, DATEADD(DD, -1, CAST(GETDATE() AS DATE))); 
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 3, 34.99, 14.99, DATEADD(DD, -1, CAST(GETDATE() AS DATE))); 
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 5, 74.99, 14.99, DATEADD(DD, -1, CAST(GETDATE() AS DATE)));

INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 1, 14.99, 84.99, DATEADD(DD, -2, CAST(GETDATE() AS DATE)));
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 2, 16.99, 96.99, DATEADD(DD, -2, CAST(GETDATE() AS DATE))); 
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 3, 14.99, 64.99, DATEADD(DD, -2, CAST(GETDATE() AS DATE))); 
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 4, 14.99, 54.99, DATEADD(DD, -2, CAST(GETDATE() AS DATE)));
INSERT INTO RentalPriceChange(RentalPriceChangeID, ScooterID, OldHourlyRate, NewHourlyRate, ChangeDate)
VALUES(NEXT VALUE FOR RentalPriceChangeSeq, 5, 14.99, 94.99, DATEADD(DD, -2, CAST(GETDATE() AS DATE))); 

-- 1) Query history table RentalPriceChange.
SELECT ChangeDate, FORMAT(AVG(NewHourlyRate - OldHourlyRate), '0.00 €') AS AverageHourlyRateChange,
	COUNT(RentalPriceChangeID) AS NumberChanges
FROM RentalPriceChange
GROUP BY ChangeDate;

-- 2) Query number of scooters rented per branch and total revenue per branch in 2022
SELECT RentalAgreement.BranchID, COUNT(RentalAgreementID) AS 'Number of scooters rented per branch in 2022',
	FORMAT(SUM(DATEDIFF(MINUTE, StartDateTime, EndDateTime) / 60.0 * HourlyRate), '#,0. €') AS 'Total revenue per branch in 2022'
FROM RentalAgreement
JOIN Scooter ON Scooter.ScooterID = RentalAgreement.ScooterID
WHERE YEAR(StartDateTime) = 2022
GROUP BY RentalAgreement.BranchID;
