--- User Defind Data types 

---- DOMAIN

CREATE DOMAIN addr VARCHAR(10) NOT NULL

CREATE DOMAIN positive_numeric INT NOT NULL CHECK(value > 0)

CREATE DOMAIN postal_code text CHECK ( value ~'^\d{3} \d{3}$')

CREATE DOMAIN email_address TEXT
CHECK (
    VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'    --- * -> for case insensitive inputs
);


CREATE DOMAIN selected_color VARCHAR(10)
CHECK (VALUE IN ('Red','Blue','Yellow'))


SELECT typname 
FROM pg_catalog.pg_type
JOIN pg_catalog.pg_namespace
ON pg_namespace.oid = pg_type.typnamespace
WHERE 
typtype = 'd' and nspname = 'public';



---- DROP a Domain Data Type

DROP DOMAIN addr --- CASCADE    already table which are using that data type , that table's data remain as it is 


CREATE TABLE unio(
  address 	addr,
  number1 positive_numeric,
  pin_code postal_code,
 email email_address,
 RGB selected_color
);

INSERT INTO unio(address,number1,pin_code,email,RGB)
VALUES ('abc',23,'345 678','abc@gmail.com','Red')

SELECT * FROM unio

--- CREATE DATATYPE

CREATE TYPE my_type AS (
	city VARCHAR(10),
	state VARCHAR(10)
);

CREATE TYPE direcctions AS ENUM ('North' , 'South' , 'West' , 'East')

ALTER TYPE direcctions RENAME TO dir

ALTER TYPE dir OWNER TO postgres

ALTER TYPE dir SET SCHEMA test_scm

ALTER TYPE test_scm.dir ADD ATTRIBUTE is_enable VARCHAR(30);

ALTER TYPE test_scm.dir ADD VALUE 'northeast';


SELECT n.nspname AS schema, t.typname AS type
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE t.typname = 'dir';


CREATE TYPE color AS ENUM ('Red','Blue','Yellow')

ALTER TYPE color RENAME VALUE 'Red'  TO 'Redd'

SELECT enum_range(NULL::color)

ALTER TYPE color ADD VALUE 'Grey' AFTER 'Redd'

SELECT enum_range(NULL::color)

ALTER TYPE color ADD VALUE 'Orange' BEFORE 'Blue'

CREATE TYPE motion AS ENUM ('done','running','working','standing')

CREATE TABLE jobs(
	job_id SERIAL PRIMARY KEY,
	job motion
);

INSERT INTO jobs (job)
VALUES ('done'), ('running') , ('running') , ('standing')

SELECT * FROM jobs

UPDATE jobs SET job = 'working' WHERE job = 'running'

ALTER TYPE motion RENAME TO motion_old

CREATE TYPE motion AS ENUM ('done','running','working')

UPDATE jobs SET job = 'done' WHERE job = 'standing'

ALTER TABLE jobs ALTER COLUMN job TYPE motion USING job::text::motion   --- if any of old entry of enum should not exist in table before assigning it a 
                                                                        --- a new enum , if new enum consist all old values then it's okay

DROP TYPE motion_old


DO
$$
BEGIN
  IF NOT EXISTS (
    SELECT *
    FROM pg_type typ
    INNER JOIN pg_namespace nsp
      ON nsp.oid = typ.typnamespace
    WHERE nsp.nspname = current_schema()
      AND typ.typname = 'ai'
  ) THEN

    CREATE TYPE ai AS (
      a text,
      i integer
    );

  END IF;
END;
$$
LANGUAGE plpgsql;