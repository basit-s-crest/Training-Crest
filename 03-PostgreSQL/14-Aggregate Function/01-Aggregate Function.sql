--- Aggregate Function

--- COUNT 

SELECT COUNT(*) FROM movies

SELECT COUNT(movie_lang) FROM movies

SELECT COUNT(DISTINCT(movie_lang)) FROM movies

SELECT COUNT(DISTINCT(first_name)) FROM directors

--- Count all english movie
  
SELECT COUNT(*) FROM movies
WHERE movie_lang = 'English'

SELECT COUNT(revenues_international) FROM movies_revenues  --- NULL entries 

--- SUM

SELECT SUM(revenues_domestic) FROM movies_revenues

--- sum of all domestic earning where movie individual earning is greater than 200

SELECT SUM(revenues_domestic) FROM movies_revenues WHERE revenues_domestic > 200

--- find total movie length of all english movies

SELECT SUM(movie_length) FROM movies WHERE movie_lang = 'English'

--- can we sum all movie name

SELECT SUM(movie_name) FROM movies --- Error this function is not fot character vayring data types

--- to check which is duplicate record
SELECT 
m.revenues_domestic
FROM movies_revenues m JOIN 
movies_revenues n ON m.revenues_domestic = n.revenues_domestic
AND m.revenue_id < n.revenue_id

SELECT SUM(DISTINCT(revenues_domestic)) FROM movies_revenues


--- MAX and MIN function

--- Select longest movie length 
SELECT MAX(movie_length) FROM movies

--- select minium movie length
SELECT movie_length 
SELECT MIN(movie_length) FROM movies

SELECT movie_length
FROM movies
ORDER BY movie_length ASC NULLS LAST
LIMIT 1

--- select longest movie of english langauge 

SELECT movie_name , movie_length FROM movies
WHERE movie_length = (SELECT MAX(movie_length) FROM movies)
AND movie_lang = 'English'

--- latest relaese movie

SELECT movie_name , release_date FROM movies
WHERE release_date = (SELECT MAX(release_date) FROM movies WHERE movie_lang = 'English') 

--- What was the first movie relaese in chinese language
SELECT movie_name, release_date FROM movies
WHERE release_date = (SELECT MIN(release_date) FROM movies WHERE movie_lang = 'Chinese') 

--- Greatest and Least
SELECT GREATEST(1,3,4)

SELECT LEAST(-10,9,0)

--- Greatest and Least revenue

SELECT GREATEST(revenues_domestic,revenues_international) AS "Greatest",
LEAST(revenues_domestic,revenues_international) AS "Least"
FROM movies_revenues

