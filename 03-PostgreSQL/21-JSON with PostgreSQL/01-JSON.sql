--- JSON
--- Data in Key - Value pair 
--- "name" : "JAY"
--- "contact" : "123-456-7890" , "email" : "crest@infosystems.com"
--- array of JSON :- [{"contact" : "123-456-7890" , "email" : "crest@infosystems.com" } ,
					{"contact" : "098-765-4321" , "email" : "skillserve@infosystems.com"}]
--- String , Numbers , Boolean , nulls can be the part of JSON
--- JSON can contain nested JSON and nested ARRAY


--- How we can represent JSON in Postgres
SELECT '{"content" : "Matrix"}';

--- But We need to cast it into JSON
SELECT '{"content" : "Matrix"}'::json;

--- Can we preserve white spaces


--- if we do not want white space 
SELECT '{   "content" : "Matrix"    }'::json;



--- Table with JSONB data type
CREATE TABLE books(
	book_id SERIAL,
	book_info JSONB
);

--- Insert Data
INSERT INTO books(book_info)
VALUES
('
	{
       "title" : "Book1", 
	   "author" : "Author1"
	}
');

SELECT * FROM books;

--- We can use selectors too
SELECT book_info->'title' FROM books;

--- '->> this returns field as TEXT'
SELECT book_info->>'title' FROM books;

--- Update JSON data
INSERT INTO books(book_info)
VALUES
('
	{
       "title" : "Book2", 
	   "author" : "Author2"
	}
'),
('
	{
       "title" : "Book3", 
	   "author" : "Author3"
	}
'),
('
	{
       "title" : "Book4", 
	   "author" : "Author4"
	}
'),
('
	{
       "title" : "Book5", 
	   "author" : "Author5"
	}
');

--- Updating a record

UPDATE books 
SET book_info = book_info || '{"author" : "Meet"}'
WHERE book_info->>'author' = 'Author5';


UPDATE books 
SET book_info = book_info || '{"title" : "Crest"}'
WHERE book_info->>'title' = 'Book5';


--- Adding new feild
UPDATE books
SET book_info = book_info || '{"Best Seller" : true}'
WHERE book_info->>'title' = 'Book1';


UPDATE books
SET book_info = book_info || '{"Best Seller" : true}'
WHERE book_info->>'author' = 'Author2';

SELECT * FROM books;

--- Lets Add multiple key value pair 
UPDATE books
SET book_info = book_info || '{"Pages" : 100 , "Description" : "Hello!!"}'
WHERE book_info->>'author' = 'Author3';

--- Deleting Record  - '-' operator
UPDATE books
SET book_info = book_info - 'Best Seller'
WHERE book_info->>'author' = 'Author4';    --- Thoose record which doesnt have Best Seller feild will also return the query

UPDATE books
SET book_info = book_info - 'Best Seller'
WHERE book_info->>'author' = 'Author2';

--- Adding nested data like availibility location 
UPDATE books
SET book_info = book_info || '{"Availibility Location" : [
      	"New York" ,  "Oklahoma" , "San Jose" , "Baltimore"
]}' 
WHERE book_info->>'author' = 'Author2';

--- Delete array value using '#-'
UPDATE books
SET book_info = book_info #- '{"Availibility Location",1}' 
WHERE book_info->>'author' = 'Author2';


--- Table to JSON 
SELECT row_to_json(d) FROM director d;

SELECT row_to_json(t) FROM (
	SELECT first_name,
		last_name FROM director
)as t;




SELECT 
* , 
(
   SELECT json_agg(x) as "All Movies" FROM 
   (
		SELECT 
			movie_name
		FROM movies 
		WHERE director_id = directors.director_id  
   )as x
)
FROM directors;   


SELECT json_build_array(1,2,3,4);

SELECT json_build_array(1,2,3,4,'Hi');

SELECT json_build_object(1,2,3,4,5,'Hi');

--- json_object({key},{value})

SELECT json_object('{name,email}' ,'{Drake,a@b}')

CREATE TABLE directors_docs(
	id SERIAL,
	body JSONB
);

INSERT INTO directors_docs(body)
SELECT row_to_json(a)::jsonb FROM(
SELECT 
 	first_name,
	 last_name,
	 date_of_birth,
	 nationality,
	 (
	 		SELECT json_agg(x) FROM (
					SELECT
						movie_name
						FROM movies
						WHERE director_id = directors.director_id
			) x
	 )
	 FROM directors
) as a;

SELECT * FROM directors_docs;


INSERT INTO directors(first_name, last_name)
VALUES('David' , 'Santneir')


INSERT INTO directors_docs(body)
SELECT row_to_json(a)::jsonb FROM(
SELECT 
	director_id,
 	first_name,
	 last_name,
	 date_of_birth,
	 nationality,
	 (
	 		SELECT CASE COUNT(x) WHEN 0 THEN  '[]' ELSE json_agg(x) END as all_movies
			 FROM (
					SELECT
						movie_name
						FROM movies
						WHERE director_id = directors.director_id
			) x
	 )
	 FROM directors
) as a;

TRUNCATE directors_docs

--- In JSON, null is an actual value, and it is represented by a JSON literal ("null").


--- Length of JSON array
SELECT *,jsonb_array_length(body->'all_movies') as total_movies
FROM directors_docs;

SELECT jsonb_object_keys(body) FROM directors_docs;

SELECT j.key , j.value  FROM directors_docs, jsonb_each(body) j;


SELECT j.*  FROM directors_docs, jsonb_to_record(body) j(
	director_id INT,
	first_name VARCHAR(255),
	nationality VARCHAR(100)
);



