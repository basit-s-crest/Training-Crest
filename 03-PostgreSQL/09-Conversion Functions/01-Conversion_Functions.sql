-- to_char()
-- ################
/*
  1. PostgreSQL TO_CHAR() function converts
     - a timestamp,
     - an interval,
     - an integer,
     - a double precision, or
     - a numeric value

     to a string.

  2. TO_CHAR(expression, format)

*/


SELECT TO_CHAR(100870,'9,99999');

-- lets view movie release data in DD-MM-YYYY formaat

SELECT
    release_date,
    TO_CHAR(release_date, 'DD-MM-YYYY'),
    TO_CHAR(release_date, 'Dy, MM, YYYY')
FROM movies;


-- converting timestamp literal to a string

SELECT 
    TO_CHAR(
        TIMESTAMP '2020-01-01 10:30:59',
        'HH24:MI:SS'
    );

-- Adding currency symbol to say movies revenues

SELECT
    movie_id,
    revenues_domestic,
    TO_CHAR(revenues_domestic, '$99999D99')
FROM movies_revenues;


-- to_number()
-- ################

-- Convert a string to a number

SELECT TO_NUMBER(
    '1420.89',
    '9999.'
);

SELECT 
    TO_NUMBER(
        '10,625.78-',
        '99G999D99S'
    );

-- formatting
SELECT TO_NUMBER(
    '$1,420.64',
    'L9G999D99'
);

SELECT 
    TO_NUMBER(
        '1,234,567.89',
        '9G999G999'
    );

SELECT 
    TO_NUMBER(
        '1,234,567.89',
        '9G999G999D99'
    );

-- Converting say money number

SELECT 
    TO_NUMBER(
        '$1,978,299.78',
        'L9G999G999.99'
    );


-- to_date()
-- ################

-- string to date

SELECT TO_DATE(
    '2020/10/22',
    'YYYY/MM/DD'
);

SELECT TO_DATE(
    '022199',
    'MMDDYY'
);

SELECT TO_DATE(
    'March 07, 2019',
    'Month DD, YYYY'
);

-- error handling

SELECT TO_DATE(
    '2020/02/30',
    'YYYY/MM/DD'
);

-- to_timestamp()
-- ################

-- 1. Basic TO_TIMESTAMP usage
SELECT TO_TIMESTAMP(
  '2020-10-28 10:30:25', 
  'YYYY-MM-DD HH:MI:SS'
);

-- 2. TO_TIMESTAMP can skip certain spaces (be cautious)
SELECT TO_TIMESTAMP(
  '2020 May', 
  'YYYY MON'
);

-- 3. Minimal error checking: this will fail (invalid time)
SELECT TO_TIMESTAMP(
  '2020-01-01 32:8:00', 
  'YYYY-MM-DD HH24:MI:SS'
);

-- 4. This is valid: single-digit minutes are accepted
SELECT TO_TIMESTAMP(
  '2020-01-01 23:8:00', 
  'YYYY-MM-DD HH24:MI:SS'
);
