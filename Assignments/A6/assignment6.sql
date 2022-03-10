DROP TABLE Menu_item_selection;
DROP TABLE Party;
DROP TABLE Meal_date;
DROP TABLE Menu_item;
DROP TABLE Restaurant; 
DROP SEQUENCE party_id_seq;
DROP SEQUENCE meal_date_id_seq;
DROP SEQUENCE menu_item_id_seq;
DROP SEQUENCE restaurant_id_seq;

-- 2. c) and 3. b)
CREATE TABLE Party (
party_id DECIMAL(12) NOT NULL PRIMARY KEY,
number_in_party DECIMAL(3) NOT NULL,
party_name VARCHAR(64));

CREATE TABLE Meal_date (
meal_date_id DECIMAL(12) NOT NULL PRIMARY KEY,
meal_date DATE NOT NULL,
year DECIMAL(4) NOT NULL,
month DECIMAL(2) NOT NULL,
day_of_month DECIMAL(2) NOT NULL);

CREATE TABLE Menu_item (
menu_item_id DECIMAL(12) NOT NULL PRIMARY KEY,
item_category VARCHAR(32) NOT NULL,
item_name VARCHAR(32) NOT NULL,
item_price DECIMAL(6,2));

CREATE TABLE Restaurant (
restaurant_id DECIMAL(12) NOT NULL PRIMARY KEY,
name VARCHAR(64) NOT NULL,
street1 VARCHAR(64) NOT NULL,
city VARCHAR(64) NOT NULL,
state VARCHAR(64) NOT NULL,
postal_code VARCHAR(64) NOT NULL);

CREATE TABLE Menu_item_selection (
party_id DECIMAL(12) NOT NULL,
meal_date_id DECIMAL(12) NOT NULL,
menu_item_id DECIMAL(12) NOT NULL,
restaurant_id DECIMAL(12) NOT NULL,
total_quantity INT NOT NULL,
FOREIGN KEY (party_id) REFERENCES Party(party_id),
FOREIGN KEY (meal_date_id) REFERENCES Meal_date(meal_date_id),
FOREIGN KEY (menu_item_id) REFERENCES Menu_item(menu_item_id),
FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id));

-- 3. c)
CREATE SEQUENCE party_id_seq START WITH 1;
CREATE SEQUENCE meal_date_id_seq START WITH 1;
CREATE SEQUENCE menu_item_id_seq START WITH 1;
CREATE SEQUENCE restaurant_id_seq START WITH 1;

INSERT INTO Party(party_id, number_in_party, party_name)
VALUES(NEXT VALUE FOR party_id_seq, 5, 'Party A');
INSERT INTO Party(party_id, number_in_party, party_name)
VALUES(NEXT VALUE FOR party_id_seq, 10, 'Party B');
INSERT INTO Party(party_id, number_in_party, party_name)
VALUES(NEXT VALUE FOR party_id_seq, 15, 'Party C');
INSERT INTO Party(party_id, number_in_party, party_name)
VALUES(NEXT VALUE FOR party_id_seq, 20, 'Party D');
INSERT INTO Party(party_id, number_in_party, party_name)
VALUES(NEXT VALUE FOR party_id_seq, 25, 'Party E');

INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/01/2022', 2022, 1, 1);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/02/2022', 2022, 1, 2);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/03/2022', 2022, 1, 3);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/04/2022', 2022, 1, 4);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/05/2022', 2022, 1, 5);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/06/2022', 2022, 1, 6);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/07/2022', 2022, 1, 7);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/08/2022', 2022, 1, 8);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/09/2022', 2022, 1, 9);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/10/2022', 2022, 1, 10);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/11/2022', 2022, 1, 11);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/12/2022', 2022, 1, 12);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/13/2022', 2022, 1, 13);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/14/2022', 2022, 1, 14);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '01/15/2022', 2022, 1, 15);

INSERT INTO Menu_item(menu_item_id, item_category, item_name, item_price)
VALUES(NEXT VALUE FOR menu_item_id_seq, 'Entree', 'Item 1', 24.99);
INSERT INTO Menu_item(menu_item_id, item_category, item_name, item_price)
VALUES(NEXT VALUE FOR menu_item_id_seq, 'Entree', 'Item 2', 36.99);
INSERT INTO Menu_item(menu_item_id, item_category, item_name, item_price)
VALUES(NEXT VALUE FOR menu_item_id_seq, 'Side', 'Item 3', 4.99);
INSERT INTO Menu_item(menu_item_id, item_category, item_name, item_price)
VALUES(NEXT VALUE FOR menu_item_id_seq, 'Side', 'Item 4', 5.99);
INSERT INTO Menu_item(menu_item_id, item_category, item_name, item_price)
VALUES(NEXT VALUE FOR menu_item_id_seq, 'Dessert', 'Item 5', 6.99);
INSERT INTO Menu_item(menu_item_id, item_category, item_name, item_price)
VALUES(NEXT VALUE FOR menu_item_id_seq, 'Dessert', 'Item 6', 7.99);

INSERT INTO Restaurant(restaurant_id, name, street1, city, state, postal_code)
VALUES(NEXT VALUE FOR restaurant_id_seq, 'Restaurant 1', '2368 Clover Drive', 'Salida', 'Colorado', '81201');
INSERT INTO Restaurant(restaurant_id, name, street1, city, state, postal_code)
VALUES(NEXT VALUE FOR restaurant_id_seq, 'Restaurant 2', '4249 Gorby Lane', 'Barlow', 'Mississippi', '39083');

INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(1, 1, 1, 1, 10);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(2, 2, 2, 1, 20);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(3, 3, 3, 1, 30);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(4, 4, 4, 2, 20);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(5, 5, 5, 2, 10);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(1, 6, 1, 1, 10);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(2, 7, 2, 1, 20);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(3, 8, 3, 1, 30);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(4, 9, 4, 2, 40);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(5, 10, 5, 2, 50);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(1, 11, 1, 1, 10);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(2, 12, 2, 1, 20);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(3, 13, 3, 1, 30);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(4, 14, 4, 2, 40);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(5, 15, 5, 2, 50);

-- To check inserts.
SELECT * FROM Party;
SELECT * FROM Meal_date;
SELECT * FROM Menu_item;
SELECT * FROM Restaurant;
SELECT * FROM Menu_item_selection;

-- 3. d)
SELECT name, party_name, SUM(total_quantity) AS total_quantity
FROM Menu_item_selection
JOIN Party ON Party.party_id = Menu_item_selection.party_id
JOIN Restaurant ON Restaurant.restaurant_id = Menu_item_selection.restaurant_id
GROUP BY ROLLUP(party_name), Restaurant.restaurant_id, name
ORDER BY name, party_name; 

-- 4. a)
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '04/01/2021', 2022, 4, 1);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '04/01/2021', 2022, 4, 1);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '04/01/2021', 2022, 4, 1);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '04/01/2021', 2022, 4, 1);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '04/01/2021', 2022, 4, 1);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '04/01/2021', 2022, 4, 1);
INSERT INTO Meal_date(meal_date_id, meal_date, [year], [month], day_of_month)
VALUES(NEXT VALUE FOR meal_date_id_seq, '04/01/2021', 2022, 4, 1);

INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(1, 16, 1, 1, 20);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(1, 17, 1, 1, 25);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(2, 18, 2, 1, 30);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(3, 19, 3, 2, 35);
INSERT INTO Menu_item_selection(party_id, meal_date_id, menu_item_id, restaurant_id, total_quantity)
VALUES(4, 20, 4, 2, 40);

SELECT Party.party_name, Menu_item.item_category, Menu_item.item_name 
FROM   Menu_item_selection
JOIN   Meal_date ON Meal_date.meal_date_id = Menu_item_selection.meal_date_id 
JOIN   Menu_item ON Menu_item.menu_item_id = Menu_item_selection.menu_item_id
JOIN   Party ON Party.party_id = Menu_item_selection.party_id
WHERE  Meal_date.meal_date = CAST('01-APR-2021' AS DATE)
ORDER BY Party.party_id;

-- 5. a)
DROP TABLE Person;
DROP SEQUENCE person_id_seq;

CREATE SEQUENCE person_id_seq START WITH 1;

CREATE TABLE Person (
	person_id DECIMAL(12) NOT NULL PRIMARY KEY,
	first_name VARCHAR(35) NOT NULL,
	last_name VARCHAR(35) NOT NULL,
	height_inches DECIMAL(3) NOT NULL,
	age DECIMAL(3) NOT NULL
);

INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Abby', 'Aoe', 60, 78);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Brian', 'Boe', 63, 51);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Charlie', 'Coe', 67, 20);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Doe', 'Doe', 69, 31);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Elliott', 'Eoe', 72, 21);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Finley', 'Foe', 70, 34);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Graham', 'Goe', 68, 43);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Hudson', 'Hoe', 74, 53);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Isabella', 'Ioe', 64, 61);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Jessica', 'Joe', 63, 53);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Katie', 'Koe', 70, 48);
INSERT INTO Person(person_id, first_name, last_name, height_inches, age) 
VALUES(NEXT VALUE FOR person_id_seq, 'Liam', 'Loe', 64, 22);

SELECT * FROM Person;

-- 5. b)
-- Defines views.
CREATE OR ALTER VIEW View_age_younger_30 AS
SELECT * FROM Person WHERE age < 30;

CREATE OR ALTER VIEW View_age_between_30_and_60 AS
SELECT * FROM Person WHERE age >= 30 AND age <= 60;

CREATE OR ALTER VIEW View_age_older_60 AS
SELECT * FROM Person WHERE age > 60;

-- Uses views.
SELECT * FROM View_age_younger_30;
SELECT * FROM View_age_between_30_and_60;
SELECT * FROM View_age_older_60;

-- 5. c)
SELECT * FROM View_age_younger_30
UNION
SELECT * FROM View_age_between_30_and_60
UNION
SELECT * FROM View_age_older_60;

-- 6. a)
-- Defines views.
CREATE OR ALTER VIEW View_names AS
SELECT person_id, first_name, last_name FROM Person;

CREATE OR ALTER VIEW View_heights_and_ages AS
SELECT person_id, height_inches, age FROM Person;

-- Uses views.
SELECT * FROM View_names;
SELECT * FROM View_heights_and_ages;

-- 6. b)
SELECT View_names.person_id, first_name, last_name, height_inches, age FROM View_names
JOIN View_heights_and_ages ON View_heights_and_ages.person_id = View_names.person_id;
