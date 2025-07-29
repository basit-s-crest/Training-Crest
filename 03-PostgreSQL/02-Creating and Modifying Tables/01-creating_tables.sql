CREATE TABLE actors(
	actor_id SERIAL PRIMARY KEY,
	first_name VARCHAR(150),
	last_name VARCHAR(150) not null,
	gender VARCHAR(1),
	dat_of_birth DATE,
	add_date DATE,
	update_date DATE
);
ALTER TABLE actors RENAME COLUMN dat_of_birth TO date_of_birth;



CREATE TABLE director(
	director_id SERIAL PRIMARY KEY,
	first_name VARCHAR(150),
	last_name VARCHAR(150),
	date_of_birth DATE,
	nationality VARCHAR(20),
	add_date DATE,
	update_date DATE
);

ALTER TABLE directos RENAME TO directors;


CREATE TABLE movies(
	movie_id SERIAL PRIMARY KEY,
	movie_name VARCHAR(150) NOT NULL,
	movie_length INT,
	movie_lang VARCHAR(20),
	age_certificate VARCHAR(10),
	release_date DATE,
	director_id INT REFERENCES director (director_id)
);

CREATE TABLE movies_revenues(
	revenue_id SERIAL PRIMARY KEY,
	movie_id INT REFERENCES  movies (movie_id),
	revenues_domestic  NUMERIC (10,2),
	revenues_international  NUMERIC (10,2)
	
);




