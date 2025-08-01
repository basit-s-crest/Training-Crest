---- NOT NULL constraint 
CREATE TABLE email(
	em_id SERIAL PRIMARY KEY,
	email TEXT NOT NULL,
	email_n VARCHAR(10)
);

ALTER TABLE email ALTER COLUMN email_n SET NOT NULL

INSERT INTO email(email,email_n)
VALUES ---(NULL , 'DEF') , --- not POSSIBLE
		('' , '0')  --- give output blank cell and 0 

SELECT * FROM email

--- UNIQUE

CREATE TABLE ADDR(
	addr TEXT UNIQUE,
	letssee INT,
	oksee INT,
	--- UNIQUE(letssee,oksee)
);

ALTER TABLE ADDR
ADD CONSTRAINT unique_merge UNIQUE(letssee , oksee)


INSERT INTO ADDR (letssee , oksee)
VALUES (1,2),
(2,1)

SELECT * FROM ADDR

INSERT INTO ADDR(letssee,oksee)
VALUES (1,2)   ---- ERRor

ALTER  TABLE addr DROP CONSTRAINT unique_merge     --- Dropping CONSTRAINT 

--- DEFAULT 
CREATE TABLE uuu(
	id_q SERIAL,
	is_enable VARCHAR(1) DEFAULT 'Y'
);

ALTER TABLE uuu ALTER COLUMN is_enable SET DEFAULT ('N')
ALTER TABLE uuu ADD COLUMN new_column VARCHAR(10)
INSERT INTO uuu(new_column)    --- IF WE DO INPUT OF NULL IN DEFAULT SETTED COLUMN WE GOT OUTPUT OF [default]
VALUES ('Basit')

SELECT * FROM uuu


ALTER TABLE uuu ALTER COLUMN is_enable DROP DEFAULT

--- PRIMARY KEY 

CREATE TABLE prime(
	p_id SERIAL PRIMARY KEY,
	PRAY VARCHAR(10)
	--- PRIMARY KEY(p_id,PRAY)
);


ALTER TABLE prime DROP CONSTRAINT prime_pkey

--- MULTIPLE PRIMARY KEY

ALTER TABLE prime ADD PRIMARY KEY(p_id,PRAY)

INSERT INTO prime(p_id,PRAY)
VALUES (1,'BASDITR')
, (2,'BASDITR')

SELECT * FROM prime

INSERT INTO prime(p_id,PRAY) 
VALUES (1,'')


--- FOREIGN KEY
CREATE TABLE info1(
	ID_1 SERIAL,
	suppelier_id INT,
	room_id INT,
	FOREIGN KEY (suppelier_id) REFERENCES suppelier (suppelier_id)
);

CREATE TABLE suppelier(
	suppelier_id INT UNIQUE,
	info2 TEXT
);

INSERT INTO suppelier (suppelier_id,info2)
VALUES (1,'Duck')

INSERT INTO info1(suppelier_id,room_id)
VALUES (1,200)      ---- WHILE INSERTING MAKE SURE CHILD HAVE THAT DATA

DELETE FROM info1 WHERE suppelier_id = 1

DELETE FROM suppelier WHERE suppelier_id = 1   --- WHILE DELETING CHECK THAT PARENT TABLE DO NOT HAVE THAT FOREIGN KEY RECORD

--- YOU CAN UPDATE FOREIGN KET DATA TO AVAILABLE OTHER DATA IN SAME COLUMN , NOT OTHER


UPDATE info1 SET suppelier_id = 2 WHERE ID_1 = 1 --- WRONG

INSERT INTO suppelier (suppelier_id,info2)
VALUES (2,'Donk')

INSERT INTO info1 (suppelier_id,room_id)
VALUES (2,300)

UPDATE info1 SET suppelier_id = 2 WHERE ID_1 = 2

SELECT* FROM info1

ALTER TABLE info1 DROP CONSTRAINT info1_suppelier_id_fkey

INSERT INTO info1 (suppelier_id,room_id)
VALUES (4,500)   --- We remove the constraint that's why adding new record that isnt in child table giving no error

TRUNCATE info1
TRUNCATE suppelier

ALTER TABLE suppelier
ADD PRIMARY KEY (suppelier_id);

ALTER TABLE info1 ADD CONSTRAINT info1_suppelier_id_fkey FOREIGN KEY (suppelier_id) REFERENCES suppelier (suppelier_id)


--- adding CHECK

CREATE TABLE CHK (	
 	id_ch SERIAL PRIMARY KEY,
	 salary INT CHECK (salary > 0),
	 birth_date DATE CHECK(birth_date > '12-01-2000'),
	 joining_date DATE CHECK(joining_date > birth_date)
);

INSERT INTO CHK(){}

ALTER TABLE CHK ADD CONSTRAINT  X CHECK(
		salary > 0 AND
		birth_date > '12-01-2000'AND
		joining_date > birth_date
)

ALTER TABLE CHK RENAME CONSTRAINT X TO Y

