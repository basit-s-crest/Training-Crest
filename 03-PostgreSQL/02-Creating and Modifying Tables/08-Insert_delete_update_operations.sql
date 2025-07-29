create table customers(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(150),
	age INT
);



INSERT INTO customers(first_name,last_name,email,age)
VALUES  ('Basit' , 'Sachinwala' , 'a@b' , 21)


INSERT INTO customers(first_name,last_name)
VALUES
('Vraj','Patel'),
('Priyam' , 'Vyas'),
('Meet','Radadiya');

--- Entring Data which have quote in it


INSERT INTO customers(first_name)
VALUES ('Bill''o Sullivan')  -- By using two quotes 


INSERT INTO customers(first_name)
VALUES ('Adam') RETURNING * -- Using Returning Clause  
 

INSERT INTO customers(first_name)
VALUES ('Adam') RETURNING customer_id -- Returning Particular Column 

UPDATE customers
SET
age = 90
WHERE first_name = 'Vraj'


UPDATE customers
SET
age = 10,
email = 'hem@123',
last_name = 'oz'
WHERE customer_id = 5 RETURNING *; -- Updating Returning


UPDATE customers
SET 
is_enable = 'Y'


DELETE FROM customers 
WHERE customer_id = 5
RETURNING *; 


DELETE FROM customers;  -- Deleting all Rows


SELECT * FROM customers
