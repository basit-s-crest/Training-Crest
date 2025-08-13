--- views
-- When store a query for reuse we use views
-- dont repeate your self


--- CREATE VIEW

CREATE OR REPLACE VIEW v_movie_quick AS 
SELECT 
	movie_name,
	movie_length,
	release_date 
FROM movies;

--- mix two columns from two different table and put it into vies

CREATE OR REPLACE VIEW v_movies_directors AS
SELECT
d.first_name , d.last_name 
FROM
movies m
JOIN  directors d USING (director_id)
WHERE m.movie_lang = 'English';


-- SELECT * FROM movies

-- How to use views 
SELECT * FROM v_movie_quick;
SELECT * FROM v_movies_directors;

--- change the name 
ALTER VIEW v_movie_quick RENAME TO v_movie_quick1

--- Deleting view 
DROP VIEW v_movies_quick;

--- 
CREATE OR REPLACE VIEW v_movies_after_1997 AS
SELECT * FROM movies
WHERE release_date >= '1997-12-31'
ORDER BY release_date DESC;

---
CREATE OR REPLACE VIEW v_movie_english AS 
SELECT movie_name FROM movies
WHERE movie_lang = 'English' AND release_date >= '1997-12-31';

---  Same but using HALF VIEW
SELECT movie_name FROM v_movies_after_1997
WHERE movie_lang = 'English';

--- Select all movies with directors of american and japanese naitionality
CREATE OR REPLACE VIEW v_american_japanese_director_movie AS
SELECT m.movie_name FROM movies m 
JOIN directors d USING(director_id)
WHERE d.nationality IN ('English','Japanese');  --- That's how we reduce join query into view

SELECT * FROM v_american_japanese_director_movie;

--- In views we do not need to give table aliases as a prefix like JOINS queries
CREATE OR REPLACE VIEW  v_people AS 
SELECT first_name , last_name , 'ACTORS' AS "PEOPLE" FROM actors 
UNION 
SELECT first_name , last_name ,'DIRECTORS' AS "PEOPLE" FROM directors;

SELECT * FROM v_people
WHERE "PEOPLE"= 'ACTORS';


--- Connecting Multiple Tables
CREATE OR REPLACE VIEW v_movie_director_revenues AS 
SELECT mv.movie_name , d.first_name, d.last_name , r.revenues_domestic , r.revenues_international 
FROM movies mv JOIN directors d USING (director_id)
JOIN movies_revenues r USING(movie_id)

SELECT * FROM v_movie_director_revenues;

--- How to re-arrange column in existing view
---- One method is to delete that view and modifying it


--- Can we delete column from existing view? - NO , postgres do not support that


--- Can we add column into exisiting view??

CREATE OR REPLACE VIEW v_movies_directors AS
SELECT
d.first_name , d.last_name , d.nationality
FROM
movies m
JOIN  directors d USING (director_id)
WHERE m.movie_lang = 'English';

--- So we can add column to existing view but can not rearrange it.
--- like we can not add column in between of existing view column but we can add columns at end.

--- Regular views are dynamic

SELECT * FROM v_people;

INSERT INTO actors (first_name,last_name) VALUES ('test1' , 'test2')

SELECT * FROM v_people WHERE first_name = 'test1';

--- What is an updatable view

CREATE OR REPLACE VIEW uv_director AS 
SELECT first_name, last_name FROM directors;

--- Adding values in view 
INSERT INTO uv_director (first_name) VALUES ('dir1'),('dir2');

--- Inseritng data into view also insert data into main table
SELECT * FROM uv_director;
SELECT * FROM directors; 

DELETE FROM directors WHERE first_name = 'dir1';

DELETE FROM directors WHERE first_name = 'dir2';


--- create table for countries
CREATE TABLE countries(
	country_id SERIAL PRIMARY KEY,
	country_code VARCHAR(4),
	city_name VARCHAR(100)
);

INSERT INTO countries (country_code,city_name) VALUES
('US','New York'),('US','Huston'),('UK','London');

CREATE OR REPLACE VIEW v_us_cities AS
SELECT 
	*
FROM countries 
WHERE country_code = 'US';

SELECT * FROM v_us_cities;

--- Insert into view 
INSERT INTO v_us_cities (country_code, city_name)
VALUES  ('US','California');


CREATE OR REPLACE VIEW v_us_cities AS
SELECT 
	*
FROM countries 
WHERE country_code = 'US'
WITH CHECK OPTION;


INSERT INTO v_us_cities (country_code, city_name)
VALUES  ('UK','Manchaster');  --- gives error

--- Updating Country code 
UPDATE v_us_cities 
SET country_code = 'UK' 
WHERE city_name = 'New York'   --- New row violates CHECK OPTION 

--- Inserting into tables will dynamically insert that specific data into views if constraint alings
INSERT INTO v_us_cities (country_code, city_name)
VALUES  ('US','Dallas'); 

SELECT * FROM v_us_cities;

--- Use LOCAL and CASCADE option with CHECK option

CREATE OR REPLACE VIEW v_cities_c AS
SELECT 
	*
FROM countries 
WHERE city_name LIKE 'C%';

SELECT * FROM v_cities_c;

CREATE OR REPLACE VIEW v_cities_c_us AS
SELECT 
	country_id,
	country_code,
	city_name
FROM v_cities_c
WHERE country_code = 'US'
WITH LOCAL CHECK OPTION;

INSERT INTO v_cities_c_us(country_code,city_name) VALUES
('US','Florida');

SELECT * FROM v_cities_c_us;

INSERT INTO v_cities_c_us(country_code,city_name) VALUES
('US','Connecticut');

--- Local checks local condition  
SELECT * FROM v_cities_c_us;  ---nested views with option check will check condition one by one

SELECT * FROM countries;

--- CASCADE check 
CREATE OR REPLACE VIEW v_cities_c_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM
	v_cities_c
WHERE
	country_code = 'US'
WITH CASCADED CHECK OPTION;


INSERT INTO v_cities_c_us(country_code,city_name) VALUES
('US','Florida');  --- check local even after condition also


---- Materialized view
--- this stores output of heavy queries and we can use that output without even eunning that query


CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors AS
SELECT 
	first_name,
	last_name
FROM 
	directors
	WITH DATA;
	
SELECT * FROM mv_directors;

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors_nodata AS
SELECT 
	first_name,
	last_name
FROM 
	directors
	WITH NO DATA;

SELECT * FROM mv_directors_nodata;

REFRESH MATERIALIZED VIEW mv_directors_nodata;

DROP MATERIALIZED VIEW mv_directors_nodata;

--- Chnaging materialized data

--- we can not change data directly into tables
INSERT INTO mv_directors_nodata(first_name) VALUES('David')

--- We can not do INSERT , UPDATE whatever CRUD operation we have to do on Underlying base table


--- How to check that materialized view is polulized or not 

SELECT relispopulated FROM pg_class WHERE relname = 'mv_directors_nodata'

--- Refresh data in materialized view
CREATE MATERIALIZED VIEW mv_directors_us AS
SELECT * FROM directors WHERE nationality = 'American' 
WITH NO DATA;

SELECT * FROM mv_directors_us;

REFRESH MATERIALIZED VIEW mv_directors;


--- CONCURRENTLY allows update in materialized view without locking 
--- for using CONCURRENTlY we have to do unique indexing on view

CREATE UNIQUE INDEX idx_u_mv_directors_us_director_id ON mv_directors_us (director_id);

REFRESH MATERIALIZED VIEW mv_directors_us;

SELECT * FROM mv_directors_us;

--- materialized view refresh it self without blocking any other thing

--- CONCURRENTLY

--- TABLE VS MATERIALIZED VIEW

--- downside of materialized view

SELECT oid::regclass::text
FROM pg_class
WHERE relkind = 'm'
ORDER BY 1



 
