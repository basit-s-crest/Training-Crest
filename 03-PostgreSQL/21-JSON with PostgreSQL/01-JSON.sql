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

