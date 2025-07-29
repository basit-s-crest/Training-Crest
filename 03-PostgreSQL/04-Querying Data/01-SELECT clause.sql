SELECT * FROM movies

SELECT * FROM actors

--- case - insensitive
select * from directors

--- operation gets execute from select to from (right to left)
--- using * to fetch entire data from database is costly operation in many cases
--- use explicit column name

SELECT first_name FROM actors

SELECT first_name , last_name FROM actors

SELECT movie_name , movie_lang FROM movies

--- Make Aliases 

SELECT movie_name as MOVIENAME FROM movies

SELECT movie_name as "MOVIE NAME" FROM movies

SELECT first_name as "ACTOR NAME" FROM actors

SELECT 
	movie_name AS "Movie Name",
	movie_lang AS "Language"
FROM movies


--- AS keyword is optional

SELECT 
	movie_name "Movie Name",
	movie_lang "Language"
FROM movies

--- We can not use single quotes ('') for aliasing

--- Combining two column using '||'

SELECT first_name || last_name FROM actors

SELECT first_name || ' ' || last_name FROM actors

SELECT first_name || ' ' || last_name AS "FULL NAME" FROM actors

--- expression using SELECT

SELECT 2 * 2