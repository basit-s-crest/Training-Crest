--- Group By

--- get total count of all movies according to thier language 
SELECT movie_lang , COUNT(movie_name) FROM movies GROUP BY movie_lang ORDER BY COUNT(movie_name) DESC;


--- get average movie length by movie language
SELECT movie_lang , ROUND(AVG(movie_length),2) FROM movies GROUP BY movie_lang ORDER BY AVG(movie_length) DESC;


--- get total movie number as per movie age certificate
SELECT age_certificate , COUNT(movie_id) FROM movies GROUP BY age_certificate;


--- List maximum and minimum length movie by movie language 
SELECT movie_lang, MAX(movie_length), MIN(movie_length) FROM movies GROUP BY movie_lang;


--- if we use GROUP BY without aggregate function then it will remove duplicates 

--- get average movie length group by movie language and age certificate

SELECT movie_lang, age_certificate, ROUND(AVG(movie_length),2) 
FROM movies 
GROUP BY movie_lang , age_certificate   --- HERE whatever column i use with select i need to take it in group by
ORDER BY AVG(movie_length) DESC;


--- same query with where clause 
SELECT movie_lang,age_certificate, ROUND(AVG(movie_length),2) 
FROM movies 
WHERE movie_length > 100
GROUP BY movie_lang , age_certificate 
ORDER BY AVG(movie_length) DESC;


--- Get movie average length group by movie age certificate where age certificate is 10
SELECT age_certificate, ROUND(AVG(movie_length),2) 
FROM movies 
WHERE age_certificate = '12'
GROUP BY age_certificate;

--- directors count as per nationality 
SELECT nationality ,COUNT(director_id) 
FROM directors
GROUP BY nationality;

--- total length of each movie language and age certificate combiantion
SELECT movie_lang,age_certificate, SUM(movie_length) 
FROM movies 
GROUP BY movie_lang , age_certificate ;


--- Execution order 
FROM 

WHERE

GROUP BY 

HAVING 

SELECT 

DISTINCT 

ORDER BY

LIMIT 

--- HAVING

--- WE CAN NOT USE ALLIAS IN HAVING CLAUSE

--- list all movie language whoose total movie lenght is less than 200
SELECT movie_lang , SUM(movie_length) 
FROM movies 
GROUP BY movie_lang
HAVING SUM(movie_length) > 200;


--- list all directors with thier sum of movie_length
SELECT d.first_name || ' ' || d.last_name, SUM(m.movie_length)
FROM movies m JOIN directors d
ON m.director_id = d.director_id 
GROUP BY d.director_id
HAVING SUM(m.movie_length) > 200
ORDER BY SUM(m.movie_length);

--- we can't use alias with HAVING clause

--- where vs having
--- having works on the resulting data

--- get all movies with thier lenghth sum is greater than 200 but with languge grouping
SELECT movie_lang , SUM(movie_length)
FROM movies 
GROUP BY movie_lang
HAVING SUM(movie_length) > 200;

SELECT movie_lang , SUM(movie_length)   --- Error , not returning anything 
FROM movies 
WHERE SUM(movie_length) > 200
GROUP BY movie_lang 
---HAVING SUM(movie_length) > 200;


--- How 'having' handle NULLS value
CREATE TABLE employee (
	employee_id SERIAL NOT NULL,
	department TEXT,
	salary INT
)

INSERT INTO employee(department,salary)
VALUES ('Engg',200),('Engg',300),(NULL,400),(NULL,300),('IT',900),('IT',1000)

SELECT COALESCE(department,'*Not mentioned*') , SUM(salary)
FROM employee 
GROUP BY department
