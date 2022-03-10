-- 1.
CREATE TABLE Pizza (
	pizza_id DECIMAL(12) NOT NULL PRIMARY KEY,
	name VARCHAR(32) NOT NULL,
	date_available DATE NOT NULL,
	price DECIMAL(4, 2) NOT NULL
	);

CREATE TABLE Topping (
	topping_id DECIMAL(12) NOT NULL PRIMARY KEY,
	topping_name VARCHAR(64) NOT NULL,
	pizza_id DECIMAL(12) FOREIGN KEY REFERENCES Pizza(pizza_id)
	);

-- or alternative solution to 1. with ALTER TABLE
CREATE TABLE Pizza (
	pizza_id DECIMAL(12) NOT NULL,
	name VARCHAR(32) NOT NULL,
	date_available DATE NOT NULL,
	price DECIMAL(4, 2) NOT NULL
	);

ALTER TABLE Pizza 
ADD CONSTRAINT pizza_id_pk
PRIMARY KEY(pizza_id);

CREATE TABLE Topping (
	topping_id DECIMAL(12) NOT NULL,
	topping_name VARCHAR(64) NOT NULL,
	pizza_id DECIMAL(12)
	);

ALTER TABLE Topping
ADD CONSTRAINT topping_id_pk
PRIMARY KEY(topping_id);

ALTER TABLE Topping 
ADD CONSTRAINT pizza_id_fk
FOREIGN KEY(pizza_id) REFERENCES Pizza(pizza_id);

-- 2.
-- Pizzas
INSERT INTO Pizza (pizza_id, name, date_available, price) 
VALUES (1, 'Plain', '6/13/2020', 9.89);

INSERT INTO Pizza (pizza_id, name, date_available, price) 
VALUES (2, 'Downtown Masterpiece', '9/23/2020', 10.79);

INSERT INTO Pizza (pizza_id, name, date_available, price) 
VALUES (3, 'Baby Spinach and Onions', '6/13/2021', 12.89);

INSERT INTO Pizza (pizza_id, name, date_available, price) 
VALUES (4, 'Bell Pepper and Mushroom', '3/14/2020', 8.79);

-- Toppings
--- Pizza 1 has no toppings.
--- Pizza 2 has two toppings.
INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (1, 'Baby Spinach', 2);

INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (2, 'Mushroom', 2);

--- Pizza 3 has two topping.
INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (3, 'Baby Spinach', 3);

INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (4, 'Onions', 3);

--- Pizza 4 has two topping.
INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (5, 'Bell Pepper', 4);

INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (6, 'Mushroom', 4);

-- Add-on topping - not included in any pizza’s standard toppings.
INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (7, 'Artichoke', NULL);

SELECT *
FROM Pizza

SELECT *
FROM Topping;

-- 3. will fail - pizza 5 does not exist.
INSERT INTO Topping (topping_id, topping_name, pizza_id) 
VALUES (8, 'Baby Spinach', 5);

-- 4.
SELECT name, topping_name
FROM Pizza
INNER JOIN Topping ON Pizza.pizza_id = Topping.pizza_id;

-- 5.
SELECT name, date_available, topping_name
FROM Pizza
LEFT JOIN Topping ON Pizza.pizza_id = Topping.pizza_id
ORDER BY date_available ASC;

-- or instead of above query, following query can be used
SELECT name, date_available, topping_name
FROM Pizza
FULL JOIN Topping ON Pizza.pizza_id = Topping.pizza_id
WHERE name IS NOT NULL
ORDER BY date_available ASC;

-- 6.
SELECT topping_name, name
FROM Pizza
RIGHT JOIN Topping ON Pizza.pizza_id = Topping.pizza_id
ORDER BY topping_name DESC;

-- or instead of above query, following query can be used
SELECT topping_name, name
FROM Pizza
FULL JOIN Topping ON Pizza.pizza_id = Topping.pizza_id
WHERE topping_name IS NOT NULL
ORDER BY topping_name DESC;

-- 7.
SELECT name, topping_name
FROM Pizza
FULL JOIN Topping ON Pizza.pizza_id = Topping.pizza_id
ORDER BY name, topping_name;

-- 8.
SELECT name, FORMAT(price, '$.00') AS price_formatted
FROM Pizza;

-- 9.
SELECT name, FORMAT(price - 1.75, '$.00') AS discounted_price_formatted
FROM Pizza;

-- 10.
SELECT topping_name + ' (' + name + ' - ' + FORMAT(price, '$.00') + ')' AS promotion_entries
FROM Pizza
RIGHT JOIN Topping ON Pizza.pizza_id = Topping.pizza_id
WHERE name is NOT NULL
ORDER BY topping_name;

-- 11.
-- No query needed.

-- 12.
-- a)
SELECT name, FORMAT(price, '$.00') AS price
FROM Pizza
WHERE name <> 'Plain' AND date_available >= '5/1/2020' AND price >= 9.55;

-- b)
SELECT name, FORMAT(price, '$.00') AS price
FROM Pizza
WHERE name LIKE '%Baby Spinach%' AND date_available >= '3/13/2018' AND price >= 12.15;

-- 13.
-- a)
ALTER TABLE Pizza
ADD special_price AS (price - 2);

SELECT name, FORMAT(price, '$.00') AS regular_price, special_price
FROM Pizza;

-- b)
ALTER TABLE Pizza
ADD is_signature AS
(CASE 
   WHEN name <> 'Plain' AND date_available >= '5/1/2020' AND price >= 9.55 THEN 1 
   ELSE 0 
END);

SELECT name, FORMAT(price, '$.00') AS price
FROM Pizza
WHERE is_signature = 1;
