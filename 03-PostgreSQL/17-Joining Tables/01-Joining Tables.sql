--- Joining Table

--- Joining Movies and directors table 

SELECT * FROM movies m JOIN directors d ON m.director_id = d.director_id ;

SELECT m.* FROM movies m JOIN directors d ON m.director_id = d.director_id ;

SELECT  m.movie_name , mr.revenues_domestic FROM movies m JOIN movies_revenues mr 
ON m.movie_id = mr.movie_id 
WHERE mr.revenues_domestic > 200
ORDER BY mr.revenues_domestic DESC;


--- for smaller syntax we can use USING 

SELECT m.* FROM movies m JOIN directors d USING (director_id);

--- joining more than two tables 

SELECT m.* FROM movies m 
JOIN directors d USING (director_id)
JOIN movies_revenues mr USING (movie_id);

--- Select all directors name , domestic revenue , movie name where movies language is japanese 
SELECT movies.movie_name, 
directors.first_name || ' ' || directors.last_name,
movies_revenues.revenues_domestic 
FROM movies JOIN directors USING (director_id)
JOIN movies_revenues USING (movie_id)
WHERE movies.movie_lang = 'Japanese';

SELECT movies.movie_name, 
directors.first_name || ' ' || directors.last_name
---,movies_revenues.revenues_domestic 
FROM movies JOIN directors USING (director_id)
JOIN movies_revenues USING (movie_id)
WHERE movies.movie_lang IN ('Japanese','English','Chinese')
AND movies_revenues.revenues_domestic > 100;


--- Top 5 total earning movie's name. director name and language 

SELECT m.movie_name, 
d.first_name || ' ' || d.last_name,
m.movie_lang,
--- mr.revenues_domestic + mr.revenues_international
FROM movies m
JOIN directors d USING (director_id)
JOIN movies_revenues mr USING (movie_id)
ORDER BY (mr.revenues_domestic + mr.revenues_international) DESC 
NULLS LAST LIMIT 5;

--- Top 10 profitable movies between 2005 and 2008 , print movie_name and director_name

SELECT 
m.movie_name, d.first_name || ' ' || d.last_name 
FROM movies m JOIN movies_revenues mr USING (movie_id)
JOIN directors d USING (director_id)
WHERE m.release_date BETWEEN '2004-12-31' AND '2009-01-01'
ORDER BY (mr.revenues_domestic + mr.revenues_international) DESC
NULLS LAST LIMIT 10;

--- How to do join on column which have different data type 
CREATE TABLE join1(
 	DEF1 INT NOT NULL
);

CREATE TABLE join2(
	DEF VARCHAR(10) NOT NULL
);

SELECT * FROM 
join1 JOIN join2 
ON join1.DEF1 = CAST(join2.DEF AS INT); 

--- Left Join 
CREATE TABLE left_products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100)
);

CREATE TABLE right_products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100)
);

INSERT INTO left_products (product_id, product_name) VALUES
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(5, 'Mics');
INSERT INTO right_products (product_id, product_name) VALUES
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(4, 'Pen'),
(7, 'Papers');


SELECT * FROM right_products
LEFT JOIN left_products
USING (product_id);

--- List all movies Directors
INSERT INTO directors (first_name, last_name, date_of_birth, nationality) VALUES
('James', 'David', '2010-01-01', 'American');   --- TO GET NULL VALUE
 
SELECT m.movie_name , d.first_name || ' ' || d.last_name
FROM directors d LEFT JOIN movies m  USING (director_id);

--- Applying WHERE condition
SELECT m.movie_name , d.first_name || ' ' || d.last_name
FROM directors d LEFT JOIN movies m  USING (director_id)
WHERE m.movie_lang IN ('Japanese','English')

--- Count all movie for each directors 
SELECT d.first_name || ' ' || d.last_name,COUNT(m.movie_name)
FROM movies m LEFT JOIN directors d USING (director_id) ;
GROUP BY d.director_id

--- get all movie name with age certificate and nationalities like English , Japanese , Chinese
SELECT m.movie_name , m.age_certificate
FROM movies m LEFT JOIN directors d USING (director_id) 
WHERE m.movie_lang IN ( 'English' , 'Japanese' , 'Chinese');


--- each director's movie's total earning
SELECT d.first_name || ' ' || d.last_name,
SUM(COALESCE (mr.revenues_domestic,0) + COALESCE (mr.revenues_international,0)) AS "Total Earning of Director"
FROM movies m JOIN directors d USING (director_id)
JOIN movies_revenues mr USING (movie_id)
GROUP BY d.director_id ORDER BY "Total Earning of Director" DESC;

--- Right Join
SELECT j1.product_id , j1.product_name, j2.product_name
FROM left_products j1 RIGHT JOIN right_products j2 USING (product_id);  --- Include all entries from right table

--- Include all directors name and movie name 
SELECT m.movie_name , d.first_name || ' ' || d.last_name
FROM movies m RIGHT JOIN directors d USING (director_id);   --- For james david we dont have any movies so we got null as we use right join

--- Reverse the process
SELECT m.movie_name , d.first_name || ' ' || d.last_name
FROM directors d RIGHT JOIN movies m USING (director_id);  --- only get 53 records as per old data

--- we can add where and group with right join just like left join 

--- each director's movie's total earning [using RIGHT  & LEFT join]
SELECT d.first_name || ' ' || d.last_name,
SUM(COALESCE (mr.revenues_domestic,0) + COALESCE (mr.revenues_international,0)) AS "Total Earning of Director"
FROM movies m LEFT JOIN directors d USING (director_id)
RIGHT JOIN movies_revenues mr USING (movie_id)
GROUP BY d.director_id ORDER BY "Total Earning of Director" DESC;

--- Full Joins (consider both table no matter foreign key matched or not)

SELECT * FROM 
left_products FULL JOIN right_products 
USING (product_id);

--- Joining Multiple tables
SELECT d.first_name || ' ' || d.last_name,
SUM(COALESCE (mr.revenues_domestic,0) + COALESCE (mr.revenues_international,0)) AS "Total Earning of Director"
FROM movies m 
JOIN directors d USING (director_id)
JOIN movies_revenues mr USING (movie_id)
GROUP BY d.director_id ORDER BY "Total Earning of Director" DESC;


--- in multiple join order of joining matters when we print all data 

--- join movie actor , movie , director together 

SELECT m.movie_id , m.movie_name , 
a.first_name || ' ' || a.last_name AS "Actor Name", 
d.first_name || ' ' || d.last_name AS "Director Name"
FROM movies m 
JOIN movies_actors ma USING (movie_id)
JOIN actors a USING (actor_id)
JOIN directors d USING (director_id);

--- Self Join , comparing column in the same tables

SELECT * FROM  
left_products l1 INNER JOIN left_products l2 USING (product_id);


