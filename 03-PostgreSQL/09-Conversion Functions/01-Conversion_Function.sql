--- Conversion Function 
--- TO_CHAR()

--- Can Convert timestamp, integer, interval, numeric value, double precision to string

SELECT TO_CHAR(123456,'9999999')

SELECT release_date, TO_CHAR(release_date, 'DD-MM-YYYY') FROM movies

SELECT release_date, TO_CHAR(release_date, 'Day') FROM movies

SELECT TO_CHAR(TIMESTAMP '20-08-2004 13:00:55', 'HH24,MI,MM,YYYY,dd')

SELECT TO_CHAR(revenues_domestic,'$99999D99') FROM movies_revenues 