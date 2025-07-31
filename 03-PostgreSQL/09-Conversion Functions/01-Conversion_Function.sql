--- Conversion Function 
--- TO_CHAR()

--- Can Convert timestamp, integer, interval, numeric value, double precision to string

SELECT TO_CHAR(123456,'9999999')

SELECT release_date, TO_CHAR(release_date, 'DD-MM-YYYY') FROM movies

SELECT release_date, TO_CHAR(release_date, 'Day') FROM movies

SELECT TO_CHAR(TIMESTAMP '20-08-2004 13:00:55', 'HH24,MI,MM,YYYY,dd')

SELECT TO_CHAR(revenues_domestic,'$99999D99') FROM movies_revenues 

--- String to Date

SELECT TO_DATE('20/08/2004','DD/MM/YYYY') 

SELECT TO_DATE('062014','ddyyyy')

SELECT TO_DATE('May 2004' , 'Month yyyy')

SELECT TO_DATE('27/02/2021' , 'DD/MM/YYYY')  -- Error handling for date that not exist 

--- TO_NUMBER

SELECT TO_NUMBER ('22,22.222' , '99G99D999')
---- G for groups , D for decimals and S for symbols

SELECT TO_NUMBER ('22,22-222' , '99G99S999')

--- TO_TIMESTAMP
SELECT TO_TIMESTAMP ('22-12-2004 2:00:00','dd-mm-yyyy hh:mi:ss')

SELECT TO_TIMESTAMP ('May 2004','MON YYYY')



