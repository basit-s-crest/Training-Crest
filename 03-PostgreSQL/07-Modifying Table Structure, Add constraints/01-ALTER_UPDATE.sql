-- Database: learning

-- DROP DATABASE IF EXISTS learning;

CREATE DATABASE learning
    WITH
    OWNER = "Basit"
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


CREATE TABLE learning(
	ID SERIAL,
	first_name VARCHAR(20)
);

--- Adding Column in Table 

ALTER TABLE learning
ADD COLUMN is_enable VARCHAR(1),
ADD COLUMN rank integer not null

SELECT * FROM learning 

--- Adding input range constrain on column

ALTER TABLE learning
ADD CHECK (is_enable IN ('Y','N'))

INSERT INTO learning (is_enable)
VALUES ('Y')

--- Adding unique constaint on email

ALTER TABLE learning 
ADD COLUMN email VARCHAR(100)

ALTER TABLE learning 
ADD CONSTRAINT uniqueness UNIQUE(email)

--- Modify table name 
ALTER TABLE learning
RENAME to learning1

--- Rename Column
ALTER TABLE learning1
RENAME COLUMN email to email1


--- Drop a column 
ALTER TABLE learning1 
ADD COLUMN mail VARCHAR(100)

ALTER TABLE learning1
DROP COLUMN mail

--- Change Datatype of column
ALTER TABLE learning1
ALTER COLUMN email1 TYPE varchar(50),
USING email1::varchar(50);   ---- using casting is safe when we change datatype from int to char , etc

---Set a default value
ALTER TABLE learning1 
ALTER COLUMN email1 SET DEFAULT 'abc@xyz'

SELECT * FROM learning1