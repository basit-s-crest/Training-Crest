----------- String Functions -------------

--- Capital 
SELECT UPPER('From')
SELECT UPPER(first_name) , UPPER(last_name) FROM directors

--- Small latter
SELECT LOWER('TO')
SELECT LOWER(first_name) , LOWER(last_name) FROM actors

--- Intial Capital 
SELECT INITCAP('hello world today is monday')

--- Left
SELECT LEFT('ABCDEFG',3)  --- ABC
SELECT LEFT('ABCDEFG',-3)  --- 	ABCD

SELECT LEFT(first_name,1) , COUNT(*) FROM directors GROUP BY 1 ORDER BY 1   	

SELECT LEFT(movie_name,6) FROM movies

--- Right
SELECT RIGHT('ABCDEFG',3)  --- 	EFG
SELECT RIGHT('ABCDEFG',-3)  --- DEFG

SELECT last_name FROM directors WHERE RIGHT(last_name,2) = 'on'

--- Reverse 
SELECT REVERSE('MADMAN')

--- Split Part
SELECT SPLIT_PART('1,2,3',',',2)
SELECT SPLIT_PART('ONE.TWO.THREE','.',3)
SELECT SPLIT_PART('12-23-45','-',1)

SELECT movie_name , release_date , SPLIT_PART(release_date::text,'-',1) AS Release_Year
FROM movies 

--- Trim
SELECT 
		TRIM(LEADING FROM '  Hello Postgre'),  --- "Hello Postgre"
		TRIM(TRAILING FROM 'Hello Postgre  '),  --- "Hello Postgre"
		TRIM(BOTH FROM '  Hello Postgre  ')   --- "Hello Postgre"	

SELECT LTRIM('yummy','y')

SELECT RTRIM('yummy','y')

SELECT BTRIM('yummy','y')

SELECT LTRIM('    HIJKLMN') --- "HIJKLMN"

SELECT RTRIM('HIJKLMN    ')  --- "HIJKLMN"

SELECT BTRIM('   HIJKLMN   ')  --- "HIJKLMN"

--- Padding

SELECT LPAD('ABC',6,'1')  

SELECT RPAD('ABC',6,'1')

SELECT mv.movie_name, R.REVENUES_DOMESTIC,
       LPAD('*',CAST(TRUNC(r.revenues_domestic/10)AS INT) + 1,'*')
FROM movies mv JOIN 
	 movies_revenues r ON mv.movie_id = r.movie_id  
ORDER BY 2 DESC
NULLS LAST

--- Length

SELECT LENGTH('SALVATION')

SELECT CHAR_LENGTH('SALVATION')

SELECT CHAR_LENGTH('') --- 0

SELECT CHAR_LENGTH(' ') --- 1

SELECT (first_name || ' ' || last_name) ,
		LENGTH(first_name || ' ' || last_name) AS "Combined Length"
FROM actors

--- Postion of substring in string

SELECT POSITION('amazing' IN 'amazing spiderman')

SELECT POSITION('Hello' IN 'World Hello')

SELECT POSITION('B' IN 'Let''s see')  --- 0 for no string match

SELECT POSITION('C' IN 'ABCDEFCHIJKC') --- For repetation first index returns

--- strpos

SELECT strpos('State Bank' , 'Bank')

SELECT first_name , last_name 
FROM directors
WHERE strpos(last_name,'on') > 0


--- Substring

SELECT substring('A to z, I am Hello' FROM 8 FOR 10)


SELECT substring('A to z, I am Hello' FROM 8 FOR 2)

SELECT substring('A to z, I am Hello' FOR 10)

SELECT first_name, last_name, SUBSTRING(first_name,1,1) FROM directors ORDER BY last_name

--- Repeat

SELECT REPEAT('A',10)  --- "AAAAAAAAAA"

SELECT REPEAT(' ',10)  --- "          "

--- Replace

SELECT REPLACE('ABC XYZ' , 'X' , '1') --- "ABC 1YZ"

SELECT REPLACE('11122223333' , '2' , 'B')

--- Exmaple
UPDATE SET col1 = REPLACE(col1 , '1' , '2') 