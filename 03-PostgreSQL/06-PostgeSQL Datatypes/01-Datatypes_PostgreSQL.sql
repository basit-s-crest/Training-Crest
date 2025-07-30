--- Datatypes
CREATE TABLE boolean_data(
	id_no SERIAL PRIMARY KEY,
	is_available BOOLEAN NOT NULL
);

INSERT INTO boolean_data (is_available)
VALUES (TRUE),
	   (FALSE),
	   ('true'),
	   ('false'),
	   ('y'),
	   ('n'),
	   ('yes'),
	   ('no'),
	   ('1'),
	   ('0');

SELECT * FROM boolean_data   --- all give boolean output 


--- check condition on boolean column
SELECT * FROM boolean_data WHERE is_available = TRUE
SELECT * FROM boolean_data WHERE is_available = 'y'
SELECT * FROM boolean_data WHERE is_available = '0'
SELECT * FROM boolean_data WHERE is_available = 'yes'

SELECT * FROM boolean_data WHERE  	

ALTER TABLE boolean_data 
ALTER COLUMN is_available
SET DEFAULT FALSE

---CHARACTER(n) === CHAR(n) , DEFAULT VALUE 1, FIXED LEN
---CHARACTER VARRYING VARCHAR  , NO DEFAULT VALUE, NOT FIXED
---TEXT MAX CAPACITY 1 GB

SELECT 'Basit'::char(10) AS "NAME"
"Basit     "  -- WASTE OF SPACE  SAME FOR character(n)

SELECT 'Basit'::VARCHAR AS "NAME"
"Basit"  --NO WASTAGE

select 
(
  'Explanation: LOWER(actor_name): Converts the name to lowercase. ' ||
  'LENGTH(actor_name) = 5: Ensures only names with exactly 5 characters are selected. ' ||
  'If you are using PostgreSQL, it works the same way. ' ||
  'Let me know if your column or table name is different.'
)::text as "info";


CREATE TABLE char_exe(
	one CHAR(10),
	two VARCHAR(10),
	three TEXT
);

INSERT INTO char_exe (one,two,three)
VALUES ('abc','xyz','tts')

SELECT * FROM char_exe
"abc       "
"xyz"
"tts" -- text

--- Numeric Data types , Int and Float 
--- we can do airthmatic operation on it
--- take all value except NULL

--- INTEGER 
--- smallint 2 byte
--- integer 4 byte
--- bigint 8 byte

--- SAME FOR SERIAL BUT RANGE STARTING FROM 1

--- Decimal whole number and its fraction

--- Fixed Numbers  - size variable 
    --- numeric(10,2) 99999999.99  - fixed point 

--- Floating Numbers  
    --- real               - 4 byte  - floating point  - 6-8 decimal 
	--- double precision   - 8 byte  - floating point  - 15-17  decimal

CREATE TABLE ofcourse(
	one numeric(5,2),
	two real,
	three double precision
);

INSERT INTO ofcourse (one,two,three)
VALUES (132.2,1.231567745,13423456671.2315677)
VALUES (.9,.9,.9)


select * from ofcourse

---- DATE / TIME
--- date time timestamp timestampz interval
---  4    8     


CREATE TABLE date1 (
	ser_id SERIAL PRIMARY KEY,
	start1 date,
	end1 date,
	updated date DEFAULT CURRENT_DATE
);

INSERT INTO date1(start1,end1)
VALUES ('2014-01-01','2015-01-01')

SELECT * FROM date1

CREATE TABLE time (
	ser_id SERIAL PRIMARY KEY,
	start1 time,
	end1 time,
	updated time DEFAULT CURRENT_TIME
);

INSERT INTO time(start1,end1)
VALUES ('23:59:59','00:00:00')

SELECT * FROM time

SELECT  CURRENT_TIME;  -- Datatype is time with time zone
SELECT  CURRENT_DATE;

SELECT  CURRENT_TIME,LOCALTIME;  -- Datatype is time without time zone for LOCALTIME

SELECT LOCALTIME,LOCALTIME(4);

--- airthmatic operation

SELECT  time '10:00' - time '04:00' AS "RESULT"  --- Datatype INTERVAL

--- using interval
interval 'n type'

n = number 
type = second, minute, hours, day, month, year.....

SELECT 
CURRENT_TIME, 	
CURRENT_TIME + interval  '-2 hours' AS "RESULT"


---- timestamp & timestamptz 
SHOW TIMEZONE

SET TIMEZONE = "Asia/Calcutta"

SELECT TIMEOFDAY();

SELECT TIMEZONE('Asia/Singapore','2025-06-30 10:00:00')

CREATE TABLE time_stamp (
	ser_id SERIAL PRIMARY KEY,
	start1 timestamp,
	end1 timestamptz,
	updated time DEFAULT CURRENT_TIME
);

SELECT * FROM time_stamp

INSERT INTO time_stamp (start1,end1)
VALUES ('2025-06-30 10:00:00-07','2025-06-30 10:00:00-07') ---TIMESTAMPTZ works on local time or system time


--- UUID 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT uuid_generate_v1();
"dc015d16-6d22-11f0-9e7d-038d1c094262"   --- not totally unique , last factor is fixed on device and current time stamp

SELECT uuid_generate_v4();               --- totally unique
"ab38b24b-fc59-468f-90cf-ccf5b050b6e0"

CREATE TABLE uuid(
	product_id UUID DEFAULT uuid_generate_v4(),
	product_name varchar(200) 
);

INSERT INTO uuid(product_name)
VALUES ('ABC')

SELECT * FROM uuid



--- Array

CREATE TABLE mobile_register(
	mb_id SERIAL,
	mobile text[]
);

INSERT INTO mobile_register (mobile)
VALUES ('{12345-67890,12345-67890,12345-67890}'),
       ('{12345-67890,12345-67890,12345-67890}')

SELECT * FROM mobile_register

SELECT mobile[1] FROM mobile_register

--- hstore

CREATE EXTENSION IF NOT EXISTS "hstore";

CREATE TABLE library1(
	book_id SERIAL,
	book_info hstore
);

INSERT INTO library1 (book_info)
VALUES ('
			"book_name" => "xyz",
			"author_name" => "zxy",
			"price" => "100"
'),('
			"book_name" => "abc",
			"author_name" => "cba",
			"price" => "200"
');

SELECT * FROM library1

SELECT book_info->'book_name' FROM library1

--- JSON
--- we have normal JSON and JSONB for binary data
--- JSON supports white spaces and identation but not JSONB
--- JSONB supports fast searching and indexing 

CREATE TABLE json(
	id serial primary key,
	docs JSON
);

INSERT INTO json(docs)
VALUES 
	('[1,2,3,4,5]'),
	('[2,3,4,5,6]'),
	('{"Key" : "Value"}')

SELECT * FROM json

SELECT * FROM json
WHERE docs @> '2'    --- not working cause we have data type JSON its working in JSONB

ALTER TABLE json
ALTER COLUMN docs TYPE JSONB;

SELECT * FROM json
WHERE docs @> '{"Key":"Vlaue"}'   

CREATE INDEX ON json USING GIN (docs jsonb_path_ops );

--- NETWORK ADRESSES
--- cidr -> ipv4 and ipv6 networks
--- inet -> ipv4 and ipv6 with host 
--- macaddr  -> mac adresses
--- macaddr8  -> mac adresses EUI-64 format 


CREATE TABLE ip(
	id SERIAL,
	ip INET
);

INSERT INTO	 ip(ip)
VALUES ('4.234.22.245'),
		('192.34.5.6')

SELECT * FROM ip

SELECT ip, set_masklen(ip,24)  AS "Masked" FROM ip  --- denote masked bits at the end 

SELECT ip, set_masklen(ip,24) AS "Masked", 
			set_masklen(ip::cidr,24) AS "CIDR" ,
			ip::cidr   --- By default masked bits 32
FROM ip

