--- Combining Queries Together 
--- for using UNION data type, order of column, number of column should be equal

SELECT * FROM left_products UNION SELECT * FROM right_products;

INSERT INTO right_products (product_id, product_name) VALUES (5,'Mics');

SELECT * FROM left_products;

SELECT * FROM right_products;

--- UNION ALL take all data with repeating entry too
SELECT * FROM left_products UNION ALL SELECT * FROM right_products;

--- All actor and director name 
SELECT 
	first_name,last_name,'Actor' AS "tablename"
	FROM actors
UNION
SELECT 
	first_name,last_name,'Director' AS "tablename"
	FROM directors;

--- column's data types should be same 
SELECT 
	first_name , last_name 
	FROM directors
	WHERE nationality IN ('American','Japanese','Chiense')
UNION
SELECT 
	first_name , last_name
	FROM actors
	WHERE gender = 'F';

--- select all directors and actors who born after 1990
SELECT 
	first_name , last_name , date_of_birth
	FROM actors 
	WHERE date_of_birth > '1989-12-31'
UNION
SELECT 
	first_name , last_name , date_of_birth
	FROM directors
	WHERE date_of_birth > '1989-12-31' ;

--- select all directors and actpr whoose name starts with A
SELECT 
	first_name , last_name 
	FROM actors
	WHERE first_name LIKE 'A%'
UNION
SELECT 
	first_name , last_name 
	FROM directors
	WHERE first_name LIKE 'A%';

--- we cant use combinig two queries who is ommiting two different number of column

--- For combining different number of column, assume NULL for lacking column in small table

SELECT first_name , last_name , 'Actor' as "tablename" FROM actors
UNION 
SELECT NULL as first_name , last_name , 'Director' as "tablename" FROM directors;

--- Intersaction returns common data record only 

SELECT * FROM left_products INTERSECT SELECT * FROM right_products;  --- we do not get duplicate value for intersaction

SELECT first_name , last_name  FROM actors
INTERSECT
SELECT first_name , last_name  FROM directors;

--- EXCEPT -> returns all the record which are available in first but not in second query 

SELECT * FROM right_products EXCEPT SELECT * FROM left_products;