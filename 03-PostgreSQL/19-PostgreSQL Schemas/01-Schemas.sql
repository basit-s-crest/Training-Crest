--- Schemas

-- --- containing;
--      - tables,
-- 	 - views,
-- 	 - indexes,
-- 	 - data types,
-- 	 - functions,
-- 	 - stored procedures,
-- 	 - operators.


--- CREATE A SCHEMA 
CREATE SCHEMA  sales;
CREATE SCHEMA he;

--- Renaming schema 
ALTER SCHEMA sales RENAME TO programming;



--- Dropping Schema
DROP SCHEMA he;

--- hierchy 
--- host > cluster > database > schema > object name 
--- hr.programming.table_name

--- creating database test 

--- database.public.object_name 
SELECT * FROM employees

--- select table from other than public schema 
SELECT * FROM hr.programming.employee


--- move table to new schema 
ALTER TABLE programming.orders SET SCHEMA PUBLIC

--- SCHEMA search path , when we dont specify , postgre use it
--- select current schema
SELECT CURRENT_SCHEMA();

--- current search path 
SHOW search_path;

--- how to add new schema to search path 
SET search_path TO programming , public;  --- before it was user, public now it is programming, public

SET search_path TO '$user',programming , public;

SELECT * FROM employee   --- from programming schema

SET search_path TO '$user', public,programming;

SELECT * FROM employee;   --- from public schema

--- Show order of schema setup is matters 

--- Changing Schema ownership

ALTER SCHEMA programming OWNER TO "Basit"

--- creating database test data

--- adding table    --- error we need to change into test_data database 
CREATE TABLE test_data.public.songs(
		song_id SERIAL,
		song_title TEXT
);

INSERT INTO songs(song_title) VALUES ('ABC'),('XYZ')

--- dumpping all data of publiuc schema from test_data into one sql file

pg_dump -d test_schema -h loclahost -U postgres -n public > dump.sql

--- renaming current schema 

--- import back the dump file containg all data related to public schema

psql -h localhost -U postgres -d test_schema -f dump.sql

--- postgre's systen catalog schema containing all built in methods , which having names starting with "pg" so avoid usisng that name 

SELECT * FROM information_schema.schemata;

SELECT COALESCE (c1.table_name, c2.table_name) as table_name,
	COALESCE(c1.column_name, c2.column_name) as table_column,
	c1.column_name as schema1,
	c2.column_name as schema2
FROM
(
	SELECT table_name, column_name 
	FROM information_schema.columns c 
	WHERE c.table_schema = 'public'
) c1	
FULL JOIN	
(
	SELECT table_name, column_name
	FROM information_schema.columns c 
	WHERE c.table_schema = 'programming'
)c2
ON c1.table_name = c2.table_name AND c1.column_name = c2.column_name
WHERE c1.column_name is null OR c2.column_name is null
ORDER by table_name, table_column;

--- Schema Acessess level rights 
---   - USAGE   only can see data
---   - CREATE  even modify data

GRANT USAGE ON SCHEMA programming TO "Basit";

--- grant select 

GRANT SELECT ON ALL TABLES IN SCHEMA programming TO "Basit";

INSERT INTO programming.employee (emp_id,name) VALUES ('7fa7c25e-dfad-4b94-b257-7c8bb81c9f9e','ABC')

SELECT * FROM employee

GRANT SELECT ON ALL TABLES IN SCHEMA public TO "Basit";

GRANT CREATE ON SCHEMA programming TO "Basit";