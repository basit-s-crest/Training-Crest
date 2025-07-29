--- Order By Clause
SELECT * FROM movies Order By release_date ASC

--- Order By is by default in ascending order

SELECT * FROM movies Order By release_date DESC


SELECT * FROM movies 
Order By 
	release_date DESC,
	movie_name ASC
;


--- After changing order of code 
SELECT * FROM movies 
Order By 
	movie_name ASC,
	release_date DESC
;


--- Aliasing with Group By
SELECT 
	first_name, 
	last_name AS "Surname" 
FROM actors
ORDER BY last_name;


--- In Order By section using Alias
SELECT 
	first_name, 
	last_name AS "Surname" 
FROM actors
ORDER BY "Surname";

--- LENGTH function
SELECT 
	first_name, 
	LENGTH(first_name) 
FROM actors

--- Ordering by length of name
SELECT 
	first_name, 
	LENGTH(first_name) AS "LENGTH"
FROM actors
ORDER BY "LENGTH";

--- Ordering via column number which is written in query itself
SELECT 
	first_name,
	last_name,
	date_of_birth
FROM actors
ORDER BY 
	1 ASC,
	3 DESC;

--- Order By with NUll values
CREATE TABLE demo_sorting(
	num INT
);


INSERT INTO demo_sorting
VALUES  (1),
		(2),
		(3),
		(4),
		(NULL);
SELECT * FROM demo_sorting

SELECT * FROM demo_sorting ORDER BY num

SELECT * FROM demo_sorting ORDER BY num NULLS LAST

SELECT * FROM demo_sorting ORDER BY num NULLS FIRST

SELECT * FROM demo_sorting ORDER BY num DESC

SELECT * FROM demo_sorting ORDER BY num DESC NULLS LAST

DROP TABLE demo_sorting