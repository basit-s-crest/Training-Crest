--- Postgre Sequences

CREATE SEQUENCE IF NOT EXISTS seq_fir

SELECT nextval('seq_fir')

SELECT currval('seq_fir')

SELECT setval('seq_fir',100)

SELECT setval('seq_fir',200,false)

CREATE SEQUENCE IF NOT EXISTS seq_fir2 START WITH 100

SELECT nextval('seq_fir2')

ALTER SEQUENCE seq_fir2 RESTART WITH 200

SELECT nextval('seq_fir2')

ALTER SEQUENCE  seq_fir2 RENAME TO seq_2

CREATE SEQUENCE IF NOT EXISTS seq_fir3 
INCREMENT 20
MINVALUE 100
MAXVALUE 200
START WITH 150

SELECT nextval('seq_fir3')

--- We can also define data type of sequences 

--- By default it is in bigint


CREATE SEQUENCE IF NOT EXISTS seq_4 AS INT 

CREATE SEQUENCE IF NOT EXISTS seq_5 AS SMALLINT

CREATE SEQUENCE IF NOT EXISTS seq_fir6
INCREMENT -20
MINVALUE 100
MAXVALUE 2000
START WITH 1980
CYCLE;

SELECT nextval('seq_fir6')

SELECT setval('seq_fir6',200)  --- cycle is working  

DROP SEQUENCE seq_fir3

--- CHANGING SERIAL SEQUENCE TO OUR CUSTOM MADE SEQUENCE

CREATE TABLE table_1(
	table_1_id SERIAL PRIMARY KEY,
	info1 TEXT
);

ALTER SEQUENCE  table_1_table_1_id_seq RESTART WITH 100

INSERT INTO table_1 (info1) VALUES ('ABC')

SELECT * FROM table_1

--- Method two without setting SERIAL intially 

CREATE TABLE table_2(
	table_2_id INT PRIMARY KEY,
	info2 TEXT
);

--- creating sequence 
CREATE SEQUENCE table_2_table_2_id 
START WITH 100 OWNED BY table_2.table_2_id

--- assignig to table's next val
ALTER TABLE table_2 ALTER COLUMN table_2_id SET DEFAULT nextval('table_2_table_2_id' )

INSERT INTO table_2 (info2) VALUES ('ABC')

SELECT * FROM table_2

--- Sharing sequences between two Tables

CREATE TABLE apple(
 apple_id INT DEFAULT nextval('seq_2'),
 entry TEXT
);


CREATE TABLE banana(
 banana_id INT DEFAULT nextval('seq_2'),
 entry TEXT
);

INSERT INTO apple(entry) VALUES ('ABC')

SELECT * FROM apple

INSERT INTO banana(entry) VALUES ('XYZ')

SELECT * FROM banana   --- two tables are sharing one sequence


---- Alpha numeric sequence 
CREATE SEQUENCE alpha_seq
CREATE TABLE contact_detail(
	id_con VARCHAR(10) NOT NULL DEFAULT  ('id' || nextval('alpha_seq')),
	contact TEXT
);

ALTER SEQUENCE alpha_seq OWNED BY contact_detail.contact

INSERT INTO contact_detail (contact)
VALUES ('hello monday')

SELECT * FROM contact_detail


