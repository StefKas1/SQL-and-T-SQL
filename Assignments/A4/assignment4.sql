-- 1.
CREATE TABLE Person (
	person_id DECIMAL(12) NOT NULL PRIMARY KEY,
	first_name VARCHAR(32) NOT NULL,
	last_name VARCHAR(32) NOT NULL,
	username VARCHAR(20) NOT NULL
	);

CREATE TABLE Post (
	post_id DECIMAL(12) NOT NULL PRIMARY KEY,
	person_id DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Person(person_id),
	content VARCHAR(255) NOT NULL,
	created_on DATE NOT NULL,
	summary VARCHAR(13) NOT NULL,
	);

CREATE TABLE Likes (
	likes_id DECIMAL(12) NOT NULL PRIMARY KEY,
	person_id DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Person(person_id),
	post_id DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Post(post_id),
	liked_on DATE
	);

CREATE SEQUENCE person_seq START WITH 1;
CREATE SEQUENCE post_seq START WITH 1;
CREATE SEQUENCE likes_seq START WITH 1;

-- 2.
-- Inserts 5 people.
INSERT INTO Person (person_id, first_name, last_name, username) 
VALUES (NEXT VALUE FOR person_seq, 'Abby', 'Aoe', 'AA');
INSERT INTO Person (person_id, first_name, last_name, username) 
VALUES (NEXT VALUE FOR person_seq, 'Brian', 'Boe', 'BB');
INSERT INTO Person (person_id, first_name, last_name, username) 
VALUES (NEXT VALUE FOR person_seq, 'Charlie', 'Coe', 'CC');
INSERT INTO Person (person_id, first_name, last_name, username) 
VALUES (NEXT VALUE FOR person_seq, 'Daisy', 'Doe', 'DD');
INSERT INTO Person (person_id, first_name, last_name, username) 
VALUES (NEXT VALUE FOR person_seq, 'Elliott', 'Eoe', 'EE');

-- Inserts 8 posts.
DECLARE @content VARCHAR(255) = ''; 
-- Two posts by user AA.
SET @content = 'Australia is great.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='AA'),
	@content, '1/13/2022', SUBSTRING(@content, 1, 10) + '...');
SET @content = 'I like Argentina.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='AA'),
	@content, '1/13/2022', SUBSTRING(@content, 1, 10) + '...');
-- Two posts by user BB.
SET @content = 'Brazilian cuisine is the best.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='BB'),
	@content, '1/15/2022', SUBSTRING(@content, 1, 10) + '...');
SET @content = 'Belgium has three official languages.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='BB'),
	@content, '1/15/2022', SUBSTRING(@content, 1, 10) + '...');
-- Two posts by user CC.
SET @content = 'China is a country in East Asia.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='CC'),
	@content, '1/17/2022', SUBSTRING(@content, 1, 10) + '...');
SET @content = 'Canada is a country in North America.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='CC'),
	@content, '1/17/2022', SUBSTRING(@content, 1, 10) + '...');
-- One posts by user DD.
SET @content = 'Denmark is a Scandinavian country.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='DD'),
	@content, '1/19/2022', SUBSTRING(@content, 1, 10) + '...');
-- One posts by user EE.
SET @content = 'Ecuador has a diverse landscape.';
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, (SELECT person_id FROM Person WHERE username='EE'),
	@content, '1/21/2022', SUBSTRING(@content, 1, 10) + '...');

-- Inserts 4 likes.
INSERT INTO Likes (likes_id, person_id, post_id, liked_on) 
VALUES (NEXT VALUE FOR likes_seq,
	(SELECT person_id FROM Person WHERE username='AA'),
	(SELECT post_id FROM Post WHERE content LIKE '%Brazilian%'), '1/24/2022');
INSERT INTO Likes (likes_id, person_id, post_id, liked_on) 
VALUES (NEXT VALUE FOR likes_seq,
	(SELECT person_id FROM Person WHERE username='BB'),
	(SELECT post_id FROM Post WHERE content LIKE '%Canada%'), '1/25/2022');
INSERT INTO Likes (likes_id, person_id, post_id, liked_on) 
VALUES (NEXT VALUE FOR likes_seq,
	(SELECT person_id FROM Person WHERE username='CC'),
	(SELECT post_id FROM Post WHERE content LIKE '%Denmark%'), '1/26/2022');
INSERT INTO Likes (likes_id, person_id, post_id, liked_on) 
VALUES (NEXT VALUE FOR likes_seq,
	(SELECT person_id FROM Person WHERE username='DD'),
	(SELECT post_id FROM Post WHERE content LIKE '%Ecuador%'), '1/27/2022');

-- 3.
-- Creates (or alters) stored procedure.
CREATE OR ALTER PROCEDURE add_michelle_stella
AS 
BEGIN 
  INSERT INTO Person (person_id, first_name, last_name, username)
  VALUES (NEXT VALUE FOR person_seq, 'Michelle', 'Stella', 'MS');
END; 
-- Executes stored procedure.
EXECUTE add_michelle_stella
-- Lists rows in Person table.
SELECT *
FROM Person;

-- 4.
-- Creates reusable stored procedure to add one person to Person table with each execution.
CREATE OR ALTER PROCEDURE add_person
   @first_name VARCHAR(32), -- Person's first name. 
   @last_name VARCHAR(32),  -- Person's last name.
   @username VARCHAR(20)    -- Person's username.
AS 
BEGIN 
  INSERT INTO Person (person_id, first_name, last_name, username)
  VALUES (NEXT VALUE FOR person_seq, @first_name, @last_name, @username);
END; 

EXECUTE add_person 'Frank', 'Foe', 'FF';

SELECT *
FROM Person;

-- 5.
CREATE OR ALTER PROCEDURE add_post
   -- Defines parameters.
   @person_id DECIMAL(12), -- Person's ID (ID of poster).
   @content VARCHAR(255),  -- Post's content. 
   @created_on DATE	       -- Post's date. 
AS 
BEGIN
  -- Defines variable (can only be accessed from within procedure).
  DECLARE @summary VARCHAR(13);
  -- Computes and assigns value to variable.
  SET @summary = SUBSTRING(@content, 1, 10) + '...';
  -- SQL query (or queries).
  INSERT INTO Post (post_id, person_id, content, created_on, summary) 
  VALUES (NEXT VALUE FOR post_seq, @person_id, @content, @created_on, @summary);
END;
GO -- GO after stored procedure is necessary to 'combine DDL (data definition language)
-- with DML (data manipulation language)'.

EXECUTE add_post 4, 'The Dominican Republic is a Caribbean nation', '1/19/2022';

SELECT *
FROM Post;

-- 6.
CREATE OR ALTER PROCEDURE add_like
   -- Defines parameters.
   @username VARCHAR(20), -- Username of person who likes post.
   @post_id DECIMAL(12),  -- Post's ID (of liked post). 
   @liked_on DATE	      -- Like's date. 
AS
BEGIN
  -- Defines variable.
  DECLARE @person_id DECIMAL(12);
  -- Gets person_id based upon username and assigns value to @person_id. 
  SET @person_id = (SELECT person_id FROM Person WHERE username=@username);
  -- SQL query (or queries).
  INSERT INTO Likes(likes_id, person_id, post_id, liked_on)
  VALUES (NEXT VALUE FOR likes_seq, @person_id, @post_id, @liked_on);
END;
GO

EXECUTE add_like 'EE', 1, '1/28/2022';

SELECT *
FROM Likes;

-- 7.
-- Creates trigger.
CREATE TRIGGER valid_summary_trigger 
ON Post AFTER INSERT, UPDATE -- Is trigger on table Post; trigger fires 'AFTER INSERT, UPDATE'.
AS 
BEGIN 
  DECLARE @inserted_content VARCHAR(255);
  DECLARE @inserted_summary VARCHAR(255);
  -- Uses INSERTED (pseudo table) to get last inserted (or updated) content and summary values.
  SET @inserted_content = (SELECT INSERTED.content FROM INSERTED); 
  SET @inserted_summary = (SELECT INSERTED.summary FROM INSERTED); 
  
  -- Checks if substring of @inserted_content (character 1 to 10, inclusive) + '...'
  -- is not equal to @inserted_summary:
  -- If True, rolls back transaction in‐progress and raises error;
  -- trigger is part of INSERT or UPDATE transaction in‐progress.
  IF (SUBSTRING(@inserted_content, 1, 10) + '...') <> @inserted_summary
  BEGIN 
    ROLLBACK;
	-- 14 and 1 are level and state shown in raised error message.
    RAISERROR('Summary is not first 10 characters of content followed by 3 dots', 14, 1);
  END; -- End if block.
END; -- End trigger block.

DECLARE @content VARCHAR(255) = '1234567890ABC'; 
-- Valid insert - will have summary length of 10 plus '...' at end ('1234567890...').
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, 5, @content, '1/21/2022', SUBSTRING(@content, 1, 10) + '...');
-- Invalid insert - will have summary length of 11 and no '...' at the end ('1234567890A')
INSERT INTO Post (post_id, person_id, content, created_on, summary) 
VALUES (NEXT VALUE FOR post_seq, 5, @content, '1/21/2022', SUBSTRING(@content, 1, 11));

SELECT *
FROM Post;

-- 8.
CREATE TRIGGER cross_table_validation_trigger 
ON Likes AFTER INSERT, UPDATE -- Trigger on table Likes; trigger fires 'AFTER INSERT, UPDATE'.
AS 
BEGIN
  -- Declares local variables (local to trigger).
  DECLARE @liked_on_date DATE;
  DECLARE @created_on_date DATE;
  -- Joins Likes and Post tables on post_id to get Post.created_on date;
  -- assigns INSERTED.liked_on to @liked_on_date and Post.created_on to @created_on_date.
  SELECT @liked_on_date = INSERTED.liked_on, 
         @created_on_date = Post.created_on 
  FROM   Post  
  JOIN   INSERTED ON INSERTED.post_id = Post.post_id; 
  
  -- Checks if @liked_on_date date is before @created_on_date.
  -- If True, rolls back transaction in‐progress and raises error.
  IF @liked_on_date < @created_on_date
  BEGIN 
    ROLLBACK;
    RAISERROR('liked_on date cannot be before created_on date of post', 14, 1);
  END;
END;

-- Post with post_id 1 was created 1/13/2022.
-- Valid like.
EXECUTE add_like 'FF', 1, '1/13/2022';
-- Invalid like.
EXECUTE add_like 'FF', 1, '1/12/2022';

SELECT *
FROM Likes;

-- 9.
-- Creates history table:
-- with foreign key to Post which has been changed;
-- old_content which will hold content before change; 
-- new_content which will hold content after change; and change_date.
CREATE TABLE post_content_history (
	post_id DECIMAL(12) NOT NULL FOREIGN KEY REFERENCES Post(post_id),
	old_content VARCHAR(255) NOT NULL,
	new_content VARCHAR(255) NOT NULL,
	change_date DATE NOT NULL
	);

-- Creates history trigger.
CREATE TRIGGER post_content_history_trigger 
ON Post AFTER UPDATE -- Trigger on table Post; trigger fires 'AFTER UPDATE'.
AS 
BEGIN
  -- Declares local variables and assigns:
  -- post_id (of changed row; gets value from pseudo table INSERTED),
  -- content before change (gets value from pseudo table DELETED), and 
  -- content after change (gets value from pseudo table INSERTED).
  DECLARE @post_id DECIMAL(12) = (SELECT post_id FROM INSERTED); 
  DECLARE @old_content VARCHAR(255) = (SELECT content FROM DELETED); 
  DECLARE @new_content VARCHAR(255) = (SELECT content FROM INSERTED); 
 
 -- If old and new content differ, then content was changed and content value 
 -- before change and content value after change are recoreded in history table 
 -- with corresponding post_id (foreign key) and current date (GETDATE()).
  IF @old_content <> @new_content
  BEGIN 
    INSERT INTO post_content_history (post_id, old_content, new_content, change_date) 
    VALUES(@post_id, @old_content, @new_content, GETDATE()); 
  END; 
END;

-- Change - history trigger will fire.
DECLARE @content VARCHAR(255) = 'Update'; 
UPDATE Post
SET content = @content, summary = (SUBSTRING(@content, 1, 10) + '...')
WHERE post_id = 1;

SELECT *
FROM post_content_history;

SELECT *
FROM Post;

-- x.
-- Not part of any answer.
SELECT *
FROM Person
LEFT JOIN Post ON Post.person_id = Person.person_id
LEFT JOIN Likes ON Likes.post_id = Post.post_id;
--ORDER BY first_name ASC;

DELETE FROM Post WHERE post_id=11;

ALTER SEQUENCE post_seq  
RESTART WITH 11;

DROP TABLE Likes;
DROP TABLE Post;
DROP TABLE Person;

DROP SEQUENCE person_seq;
DROP SEQUENCE post_seq;
DROP SEQUENCE likes_seq;

DROP PROCEDURE add_michelle_stella;

DROP TRIGGER valid_summary_trigger;