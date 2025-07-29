--- Distinct

SELECT 
	DISTINCT movie_lang
FROM movies
ORDER BY 1;

SELECT 
	DISTINCT movie_lang, director_id
FROM movies
ORDER BY 1;

SELECT 
	DISTINCT *
FROM movies
ORDER BY movie_id ASC;

