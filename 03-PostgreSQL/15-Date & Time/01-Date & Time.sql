--- Date & Time
SHOW datestyle

SET datestyle = 'ISO,MDY'

SET datestyle = 'ISO,DMY'

SELECT TO_DATE('230999','DDMMYY')

SELECT TO_DATE('30-04-04','dd-mm-yy')

SELECT TO_DATE('30th May,2004','ddth Month,YYYY')

SELECT TO_TIMESTAMP('10-09-2004 09:34:44' , 'dd-mm-yyyy hh:mi:ss')

SELECT TO_TIMESTAMP('10-09-2004 09','dd-mm-yyyy hh')


SELECT TO_TIMESTAMP('10-09-2004 19:34:44' , 'dd-mm-yyyy hh24:mi:ss')

SELECT TO_TIMESTAMP('2','MS')

SELECT CURRENT_TIMESTAMP

SELECT TO_CHAR('10-09-2004 19:34:44'::TIMESTAMP , 'Day')

SELECT TO_CHAR('10-09-2004 19:34:44'::TIMESTAMP , 'Date Month YYYY')

SELECT TO_CHAR('10-09-2004T19:34:44-6:00'::TIMESTAMPTZ , 'Date Month YYYY')

SELECT TO_CHAR(release_date,'Month DDth YYYY') FROM movies

SELECT TO_CHAR(release_date,'Month DDth YYYY hh:mi:ss tz') FROM movies

--- Date & Time Construction Function

SELECT MAKE_DATE(1999,3,23)

SELECT MAKE_TIME(2,3,45.05)

SELECT MAKE_TIMESTAMP(2020,3,22,2,3,4.5)

SELECT MAKE_INTERVAL(2020,03,1,1,1,1,1),
MAKE_INTERVAL(2020,03,2,1,1,1,1),
MAKE_INTERVAL(2020,03,3,1,1,1,1),
MAKE_INTERVAL(2020,03,4,1,1,1,1),
MAKE_INTERVAL(2020,03,5,1,1,1,1)

SELECT 	MAKE_INTERVAL(days => 10)
SELECT MAKE_INTERVAL(months=> 3, days=> 20)

SELECT MAKE_INTERVAL(weeks => 5)

SELECT MAKE_TIMESTAMPTZ(2000,2,2,10,00,30)

SELECT pg_typeof(MAKE_TIMESTAMPTZ(2000,2,2,10,00,30))

SELECT * FROM pg_timezone_names

SELECT MAKE_TIMESTAMPTZ(2000,2,2,10,00,30,'GMT')

SELECT MAKE_TIMESTAMPTZ(2000,2,2,10,00,30,'NZ')

SELECT MAKE_TIMESTAMP(2000,2,2,10,00,30)

SELECT pg_typeof(MAKE_TIMESTAMP(2000,2,2,10,00,30))

--- Date value extraction function
SELECT 
	EXTRACT('Day' FROM CURRENT_TIMESTAMP),
	EXTRACT('Month' FROM CURRENT_TIMESTAMP),
	EXTRACT('Year' FROM CURRENT_TIMESTAMP)

SELECT
	EXTRACT('CENTURY' FROM INTERVAL'500 years')

--- Uisn math operation on date

SELECT DATE '2020-01-01' + 40;

SELECT '2020-01-01'::date + 40;

SELECT TIME '10:01:30' + INTERVAL '2 hours';

SELECT TIME '10:01:30' + '15:2:2';

SELECT CURRENT_TIMESTAMP , CURRENT_TIMESTAMP + '10:10:10';

SELECT DATE '2020-01-01' + TIME '12:30:00';

SELECT TIMESTAMP '2020-01-01 01:01:00' + TIME '12:30:00';

SELECT CURRENT_TIMESTAMP - INTERVAL '2 hours' AS "2 HOURS ago";

SELECT INTERVAL '30 minutes' + INTERVAL '30 minutes';

SELECT INTERVAL '30 minutes' - INTERVAL '30 minutes';

SELECT INTERVAL '30 minutes' + INTERVAL '1 day';

SELECT interval '2:00' / 2 ;
 
--- Overlaps

SELECT (DATE '2000-01-01',DATE '2005-12-31') OVERLAPS (DATE '2006-01-01',DATE '2008-12-31');

SELECT (DATE '2000-02-02', INTERVAL '30 days') OVERLAPS (DATE '2000-02-15',DATE '2000-03-31');

--- Date Time functions
SELECT CURRENT_DATE,
	   CURRENT_TIME,
	   CURRENT_TIME(2),
	   CURRENT_TIMESTAMP,
	   LOCALTIME,
	   LOCALTIME(3),
	   LOCALTIMESTAMP,
	   LOCALTIMESTAMP(3);

--- Postgre Date time function
SELECT NOW(),
		TRANSACTION_TIMESTAMP(), --- Same as NOW()
		STATEMENT_TIMESTAMP(), --- Time of Query Execution
		CLOCK_TIMESTAMP();
SELECT TIMEOFDAY();  --- Return as a string

--- AGE
SELECT AGE('2025-08-05','2004-08-20');

SELECT AGE(timestamp '2004-08-20');

SELECT AGE(CURRENT_DATE , timestamp '2004-08-20');

--- What if date is interchange like order wise
SELECT AGE( timestamp '2004-08-20',CURRENT_DATE);  --- answer comes out in negative

SELECT CURRENT_DATE

SELECT CURRENT_DATE - 1

SELECT CURRENT_DATE + 1

CREATE TABLE time_update(
 	id SERIAL NOT NULL,
	 update_on_date DATE DEFAULT CURRENT_DATE,
	 add_time TIME DEFAULT CURRENT_TIME,
	 entry TEXT
);

INSERT INTO time_update (entry)
VALUES ('ABC') , ('XYZ');

SELECT * FROM time_update;

--- EPOCH --> AGE IS good for subtracting dates but EPOCH is far better 
SELECT (EXTRACT(EPOCH FROM TIMESTAMPTZ '2020-02-01') - EXTRACT(EPOCH FROM TIMESTAMPTZ '2020-01-01')) / 60 / 60 / 24 --- Double precision
, TIMESTAMP '2020-02-01' - TIMESTAMP '2020-01-01' , AGE(TIMESTAMP '2020-02-01',TIMESTAMP '2020-01-01');


INSERT INTO time_update (update_on_date,add_time,entry)
VALUES ('epoch','allballs','ABC');


INSERT INTO time_update (update_on_date,add_time,entry)
VALUES ('-infinity','allballs','ABC');

SELECT * FROM time_update;



---- SETTING UP TIMEZONE

SELECT * FROM pg_timezone_names;

SELECT * FROM pg_timezone_abbrevs;

SHOW TIME ZONE;

SET TIME ZONE 'America/New_York';

ALTER TABLE time_update ADD COLUMN end_timestamp TIMESTAMP WITH TIME ZONE;

ALTER TABLE time_update ADD COLUMN end_time TIME WITH TIME ZONE;

INSERT INTO time_update (end_timestamp,end_time) VALUES
('2020-01-20 11:30:00 US/Pacific','11:30:00+6')

SELECT * FROM time_update

SELECT 
	date_part('year',TIMESTAMP '2017-01-01'),
	date_part('month',TIMESTAMP '2017-05-01'),
	date_part('quarter',TIMESTAMP '2017-12-01'),
	date_part('decade',TIMESTAMP '2017-01-01'),
	date_part('century',TIMESTAMP '2017-01-01');

SELECT 
	date_part('week',TIMESTAMP '2017-01-01'),
	date_part('dow',TIMESTAMP '2017-05-01'),
	date_part('doy',TIMESTAMP '2017-12-01'),
	date_part('day',TIMESTAMP '2017-01-01'),
	date_part('hour',TIMESTAMP '2017-01-01 10:20:30'),
	date_part('min',TIMESTAMP '2017-01-01 10:20:30'),
	date_part('sec',TIMESTAMP '2017-01-01 10:20:30');


--- Date trunc

SELECT date_trunc('hour',TIMESTAMP '2017-01-01 10:20:30'),
	date_trunc('min',TIMESTAMP '2017-01-01 10:20:30'),
	date_trunc('sec',TIMESTAMP '2017-01-01 10:20:30');

SELECT 
	date_trunc('month',release_date) "release month",
	COUNT(movie_id)
FROM 
	movies
GROUP BY 
	"release month"
ORDER BY 
	2 DESC;
	
