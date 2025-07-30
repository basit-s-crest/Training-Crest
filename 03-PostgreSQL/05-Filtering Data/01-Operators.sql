--- 	Operators

--- ### Comparison
---		1. =
---		2. >
---		3. <
--- 	4. <=
---		5. >=
---		6. <>


--- ### Logical
---		AND , OR , BETWEEN


--- ### Airthmetic
---		+ , - , * , / , % 


--- AND
SELECT * FROM movies
WHERE 
	age_certificate = '18' 
	AND movie_lang = 'English'


--- OR
SELECT * FROM movies
WHERE
	movie_lang = 'Chinese'
	OR movie_lang = 'English'
ORDER BY 
	movie_lang;

SELECT * FROM movies
WHERE
	director_id = '18'
	AND movie_lang = 'English'


--- Combining OR and AND
--- Always use parantheses while using combine OR and AND 

SELECT * FROM movies
WHERE 
	(movie_lang = 'English' 
	OR movie_lang = 'Chinese')
	AND age_certificate = '12'  --- Order Matter with Parantheses

--- Hierarchy of query
--- SELECT FROM WHERE ORDER BY 

--- AND operation is process first then OR 

--- if we do not use parentheses then Postgre execute AND like Multiplication and
--- OR like Addition 7 * 7 + 1 = 50

--- We can not use name Alias in where clause 

SELECT 
	first_name,
	last_name AS surname
FROM actors
WHERE 
	surname = 'Allen'


SELECT 
	first_name,
	last_name AS surname
FROM actors
WHERE 
	last_name = 'Allen'

--- Using Logical Operator
SELECT movie_name
FROM movies
WHERE movie_length > 100
ORDER BY movie_length;

SELECT movie_name
FROM movies
WHERE movie_length >= 100
ORDER BY movie_length;

SELECT movie_name
FROM movies
WHERE movie_length = '100'

SELECT movie_name
FROM movies
WHERE movie_length <= 100
ORDER BY movie_length;

SELECT movie_name
FROM movies
WHERE movie_length < 100
ORDER BY movie_length;

SELECT * FROM movies WHERE release_date > '2000-01-01'

SELECT * FROM movies WHERE movie_lang > 'English'

SELECT * FROM movies WHERE movie_lang < 'English'

SELECT * FROM movies WHERE movie_lang <> 'English' ORDER BY movie_lang;

SELECT * FROM movies WHERE movie_length > '100' 
                                                  ---- Both are same , for Data Type Integer '' is optional
SELECT * FROM movies WHERE movie_length > 100

--- top 5 long movies
SELECT movie_name, movie_length FROM movies ORDER BY movie_length DESC LIMIT 5

--- oldest 10 directors
SELECT first_name || ' ' || last_name, date_of_birth FROM directors ORDER BY date_of_birth LIMIT 10

--- youngest top 10 actress 
SELECT first_name || ' ' || last_name, date_of_birth FROM actors
WHERE gender = 'F'
ORDER BY date_of_birth DESC LIMIT 10

--- most domestically profitable movie top 10
SELECT m2.movie_name , m1.revenues_domestic FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
ORDER BY m1.revenues_domestic DESC NULLS LAST LIMIT 10 

--- least profitable domestically 
SELECT m2.movie_name , m1.revenues_domestic FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
ORDER BY m1.revenues_domestic NULLS LAST LIMIT 10

--- List of 5 movies but after 4th movie by order of movies is
SELECT movie_id,movie_name FROM movies
ORDER BY movie_id
LIMIT 5 OFFSET 4

--- Top 5 highest domestically earned movie after above 5
SELECT m2.movie_name , m1.revenues_domestic FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
ORDER BY m1.revenues_domestic DESC NULLS LAST LIMIT 5 OFFSET 5


--- Using Fetch 

--- First row of movie table 
SELECT * 
FROM movies 
FETCH FIRST 5 ROW ONLY

--- Get top 5 movie by movie length
SELECT * 
FROM movies
ORDER BY movie_length DESC
FETCH FIRST 5 ROW ONLY


--- get top 5 oldest american directors
SELECT * FROM directors
WHERE nationality = 'American'
ORDER BY date_of_birth ASC
FETCH FIRST 5 ROW ONLY 

--- Get top 10 youngest actress
SELECT * FROM actors
WHERE gender = 'F'
ORDER BY date_of_birth DESC
FETCH FIRST 5 ROW ONLY

--- Get 5 movies after 5th record for longest movie rank
SELECT * FROM movies
ORDER BY movie_length DESC
FETCH FIRST 5 ROW ONLY 
OFFSET 5


--- IN and NOT IN

--- Select all movies with english , chinese , portuguese language
SELECT * FROM movies
WHERE 
	movie_lang IN ('English','Chinese','Portuguese')

--- select all movie with age rating of PG and 18
SELECT * FROM movies
WHERE 
	age_certificate IN ('PG','18')


--- Director id not should be 10 or 13
SELECT * FROM directors
WHERE 
	director_id NOT IN ('10','13')


--- get all actors where actor id is not 1,2,3,4
SELECT * FROM actors
WHERE 
	actor_id NOT IN ('1','2','3','4')


--- BETWEEN and NOT BETWEEN

--- get all actors where birth year between 1991 to 1995
SELECT * FROM actors
WHERE 
	date_of_birth BETWEEN '1991-01-01' AND '1995-12-31'
ORDER BY date_of_birth

---get all movies between 1998 and 2004
SELECT * FROM movies
WHERE
	release_date BETWEEN '1998-01-01' AND '2004-12-31'
ORDER BY release_date

---get all movies whoose domestic revenue between 100 and 300
SELECT m2.movie_name , m1.revenues_domestic FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
WHERE m1.revenues_domestic BETWEEN '99' AND '301'
ORDER BY m1.revenues_domestic

---get all movies where movies length between 100 and 200
SELECT movie_name, movie_length FROM movies
WHERE movie_length BETWEEN '100' AND '200' 
ORDER BY movie_length
    --- Equivalent
SELECT movie_name , movie_length FROM movies
WHERE movie_length >= 100 AND movie_length <= 200

SELECT movie_name, movie_length FROM movies
WHERE movie_length NOT BETWEEN '100' AND '200' 
ORDER BY movie_length
	--- Equivalent
SELECT movie_name , movie_length FROM movies
WHERE movie_length >= 200 OR movie_length <= 100



--- LIKE and NOT LIKE pattern matching 
--- Examples 
     --- ' % '-> any number of char
	 --- ' _ ' -> only one single char
SELECT 'hello' LIKE '%llo'  -- true    
SELECT 'hello' LIKE '%ll'   -- false
SELECT 'hello' LIKE '_ello'  -- true 
SELECT 'hello' LIKE '%l_' -- true

--- Queries

---get all actors with starting name with a char a
SELECT first_name FROM actors WHERE first_name LIKE 'A%'  --- case sensetive

---get all actors with name ending with a char a
SELECT first_name FROM actors WHERE first_name LIKE '%a'

---get all actors name with five later name
SELECT * FROM actors WHERE first_name LIKE '_____'

---actors name with 'l' at second place in its name
SELECT * FROM actors WHERE first_name LIKE '_l%'

---for avoiding case sensetive we can use ILIKE 
SELECT * FROM actors WHERE first_name ILIKE 'tim' 



--- NULL and NOT NULL 
---find actors name with missing or null birth date
SELECT * FROM actors WHERE date_of_birth IS NULL

---find actors with missing name and missing birth date
SELECT * FROM actors WHERE first_name IS NULL OR date_of_birth IS NULL

---get all movies where domestic value is null
SELECT m2.movie_name , m1.revenues_domestic FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
WHERE m1.revenues_domestic IS NULL

---get all movies where either domestic or international revenues is null
SELECT m2.movie_name , m1.revenues_domestic , m1.revenues_international 
FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
WHERE m1.revenues_domestic IS NULL OR m1.revenues_international IS NULL

SELECT m2.movie_name , m1.revenues_domestic , m1.revenues_international 
FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
WHERE m1.revenues_domestic IS NULL AND m1.revenues_international IS NULL

---using NOT NULL
---movie whoose domestic revenues is not null
SELECT m2.movie_name , m1.revenues_domestic 
FROM movies_revenues as m1 
JOIN movies as m2 on m1.movie_id = m2.movie_id
WHERE m1.revenues_domestic IS NOT NULL 


---using = NULL   -- GIVING BLANK ROW
		 = 'NULL' -- NOT WORKING ERROR
		 = ''     -- NOT WORKING ERROR 
		 = ' '    -- NOT WORKING ERROR

--- concatenation
SELECT 'hello' || 'world'
SELECT CONCAT(first_name ,' ', last_name) AS fullname FROM actors
SELECT CONCAT_WS(',',first_name ,last_name ,date_of_birth) AS fullname FROM actors
		 
--- concatenation with NULL 
SELECT 'hello' || NULL ||'world'   --- WHOLE OUTPUT NULL

SELECT CONCAT(revenues_domestic ,' | ',revenues_international) 
AS Total FROM movies_revenues      --- NULL concatenation output ommit seprator

SELECT CONCAT_WS(' | ',revenues_domestic ,revenues_international) 
AS Total FROM movies_revenues      --- NULL concatenation output doesnt ommit seprator
