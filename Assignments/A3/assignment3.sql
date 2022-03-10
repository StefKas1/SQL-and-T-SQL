-- 1.
CREATE TABLE Genre (
	genre_id DECIMAL(12) NOT NULL PRIMARY KEY,
	genre_name VARCHAR(64) NOT NULL
	);

CREATE TABLE Creator (
	creator_id DECIMAL(12) NOT NULL PRIMARY KEY,
	first_name VARCHAR(64) NOT NULL,
	last_name VARCHAR(64) NOT NULL
	);

CREATE TABLE Movie_series (
	movie_series_id DECIMAL(12) NOT NULL PRIMARY KEY,
	genre_id DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Genre(genre_id),
	creator_id DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Creator(creator_id),
	series_name VARCHAR(255) NOT NULL,
	suggested_price DECIMAL(8, 2) NULL,
	);

CREATE TABLE Movie (
	movie_id DECIMAL(12) NOT NULL PRIMARY KEY,
	movie_series_id DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Movie_series(movie_series_id),
	movie_name VARCHAR(64) NOT NULL,
	length_in_minutes DECIMAL(4)
	);

-- Genre (1): Fantasy. Creator (1): George Lucas. Series (1): Star Wars.
INSERT INTO Genre (genre_id, genre_name) 
VALUES (1, 'Fantasy');
INSERT INTO Creator (creator_id, first_name, last_name) 
VALUES (1, 'George', 'Lucas');
INSERT INTO Movie_series (movie_series_id, genre_id, creator_id, series_name, suggested_price) 
VALUES (1, 1, 1, 'Star Wars', 129.99);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (1, 1, 'Episode I: The Phantom Menace', 136);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (2, 1, 'Episode II: Attack of the Clones', 142);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (3, 1, 'Episode III: Revenge of the Sith', 140);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (4, 1, 'Episode IV: A New Hope', 121);

-- Genre (2): Family Film. Creator (2): John Lasseter. Series (2): Toy Story.
INSERT INTO Genre (genre_id, genre_name) 
VALUES (2, 'Family Film');
INSERT INTO Creator (creator_id, first_name, last_name) 
VALUES (2, 'John', 'Lasseter');
INSERT INTO Movie_series (movie_series_id, genre_id, creator_id, series_name, suggested_price) 
VALUES (2, 2, 2, 'Toy Story', 22.13);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (5, 2, 'Toy Story', 121);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (6, 2, 'Toy Story 2', 135);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (7, 2, 'Toy Story 3', 148);

-- Genre (1): Fantasy. Creator (3): John Tolkien. Series (3): Lord of the Rings.
INSERT INTO Creator (creator_id, first_name, last_name) 
VALUES (3, 'John', 'Tolkien');
INSERT INTO Movie_series (movie_series_id, genre_id, creator_id, series_name, suggested_price) 
VALUES (3, 1, 3, 'Lord of the Rings', NULL);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (8, 3, 'The Lord of the Rings: The Fellowship of the Ring', 228);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (9, 3, 'The Lord of the Rings: The Two Towers', 235);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (10, 3, 'The Lord of the Rings: The Return of the King', 200);

-- Genre (2): Family Film. Creator (4): Sergio Pablos. Series (4): Despicable Me.
INSERT INTO Creator (creator_id, first_name, last_name) 
VALUES (4, 'Sergio', 'Pablos');
INSERT INTO Movie_series (movie_series_id, genre_id, creator_id, series_name, suggested_price) 
VALUES (4, 2, 4, 'Despicable Me', 19.99);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (11, 4, 'Despicable Me', 95);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (12, 4, 'Despicable Me 2', 98);
INSERT INTO Movie (movie_id, movie_series_id, movie_name, length_in_minutes) 
VALUES (13, 4, 'Despicable Me 3', 96);

-- 2.
SELECT COUNT(movie_name) AS 'Count movies duration >= 135 minutes'
FROM Movie
WHERE length_in_minutes >= 135;

-- 3.
SELECT format(MAX(suggested_price), '$.00') AS 'Price most expensive series', 
	   format(MIN(suggested_price), '$.00') AS 'Price least expensive series'
FROM Movie_series;

-- 4.
SELECT series_name AS Series, COUNT(movie_name) AS 'Count movies per series'
FROM Movie_series
JOIN Movie ON Movie.movie_series_id = Movie_series.movie_series_id
GROUP BY series_name;

-- 5.
SELECT genre_name AS Genre, COUNT(movie_name) AS 'Count movies per genre - if >= 6 movies'
FROM Genre
JOIN Movie_series ON Movie_series.genre_id = Genre.genre_id
JOIN Movie ON Movie.movie_series_id = Movie_series.movie_series_id
GROUP BY genre_name
HAVING COUNT(movie_name) >= 6;

-- 6.
SELECT series_name AS Series, SUM(length_in_minutes) AS 'Series length in minutes - if >= 9 h'
FROM Movie_series
JOIN Movie ON Movie.movie_series_id = Movie_series.movie_series_id
GROUP BY series_name
HAVING SUM(length_in_minutes) >= 540;

-- 7.
-- Not part of final answer, just a helpful intermediate step for understanding.
SELECT first_name, last_name, genre_name, movie_name
FROM Creator
JOIN Movie_series ON Movie_series.creator_id = Creator.creator_id
LEFT JOIN Genre ON Genre.genre_id = Movie_series.genre_id AND Genre.genre_name = 'Fantasy'
JOIN Movie ON Movie.movie_series_id = Movie_series.movie_series_id;

-- Final answer.
SELECT first_name + ' ' + last_name AS Creators, COUNT(genre_name) AS 'Count fantasy movies created'
FROM Creator
JOIN Movie_series ON Movie_series.creator_id = Creator.creator_id
LEFT JOIN Genre ON Genre.genre_id = Movie_series.genre_id AND Genre.genre_name = 'Fantasy'
JOIN Movie ON Movie.movie_series_id = Movie_series.movie_series_id
GROUP BY genre_name, first_name, last_name
ORDER BY genre_name DESC;

-- 8.
-- a.
SELECT series_name AS 'Series name', format(suggested_price, '$.00') AS 'Suggested price', 
	COUNT(series_name) AS 'Total movies per series'
FROM Movie_series
JOIN Movie ON Movie.movie_series_id = Movie_series.movie_series_id
GROUP BY series_name, suggested_price;



-- x.
-- Not part of any answer.
SELECT genre_name AS Genre, first_name + ' ' + last_name AS Creator,
	series_name as Series, format(suggested_price, '$.00') as 'Suggested Price',
	movie_name as Movie, length_in_minutes as Length
FROM Genre
INNER JOIN Movie_series ON Movie_series.genre_id = Genre.genre_id
INNER JOIN Creator ON Creator.creator_id = Movie_series.creator_id
INNER JOIN Movie ON Movie.movie_series_id = Movie_series.movie_series_id
ORDER BY first_name ASC;

DROP TABLE Movie;
DROP TABLE Movie_series;
DROP TABLE Creator;
DROP TABLE Genre;