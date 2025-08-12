--- Index
--- Indexing helps query run in short time
--- We can do indexing on specific column / columns 
--- Doing indexing on all column is also not a great option 
--- index -- on column / columns
--- UNIQUE index -- on unique value columns
--- In Postgres we can do index on upto 32 columns.

CREATE UNIQUE INDEX index_name
ON table_name (col1, col2, .....)
CREATE INDEX index_name ON table_name [USING method]
(
column_name [ASC | DESC] [NULLS {1FIRST | LAST}],
);


CREATE INDEX idx_orders_order_date ON orders(order_date);

CREATE INDEX idx_orders_ship_city ON orders(ship_city);

CREATE INDEX idx_orders_customer_id_order_id ON orders(customer_id,order_id);

CREATE UNIQUE INDEX idx_u_products_product_id ON products (product_id);

CREATE UNIQUE INDEX idx_u_employees_employee_id ON employees (employee_id);

CREATE UNIQUE INDEX idx_u_orders_customer_id_order_id ON orders(customer_id,order_id);

CREATE UNIQUE INDEX idx_u_employees_employee_id_hire_date ON employees (employee_id, hire_date);

SELECT * FROM employees;

--- All indexes 
SELECT * FROM pg_indexes;

SELECT * FROM pg_indexes WHERE schemaname = 'public';

SELECT * FROM pg_indexes WHERE tablename = 'orders';

SELECT pg_size_pretty(pg_indexes_size('orders'));

--- applying indices on table will increase size of tables

SELECT pg_size_pretty(pg_indexes_size('suppliers'));   --- 16 KB

CREATE INDEX idx_suppliers_region ON suppliers(region);

SELECT pg_size_pretty(pg_indexes_size('suppliers'));   --- 32 KB

--- Adding indices may improve the speed of the data access but they add a COST to the data modification. 
--- Therefore it is important to understand if the index is used.

--- pg_stat_all_indexes
SELECT * FROM pg_stat_all_indexes;

SELECT * FROM pg_stat_all_indexes WHERE schemaname = 'public';
 
SELECT * FROM pg_stat_all_indexes WHERE relname = 'orders';

--- Drop indexes

DROP INDEX [CONCURRENTLY]
[IF EXISTS] index_name
[CASCADE | RESTRICT]     --- syntax

DROP INDEX idx_suppliers_region;

--- 	SQL statement stages
---    parser --> rewriter --> optimizer --> executor

--- optimizer  
--- nodes  --- available for every operations and access methods 
--- types of nodes  ,  nodes are stackable 
SELECT * FROM pg_am;

--- Seq Nodes
--- Sequential scan , when no valuable alternative available 
EXPLAIN SELECT * FROM region;

--- Index Nodes
--- Index scan, when we use indexing 
EXPLAIN SELECT * FROM orders WHERE order_id = 1;
--- Index only
EXPLAIN SELECT order_id FROM orders WHERE order_id = 1;
--- Bitmap 


--- Join Nodes , used when we do table join

--- Hash Join
--- Inner Table , Outer Table 
/*    
		SHOW work_mem

		Merge Join
*/

EXPLAIN SELECT * FROM customers NATURAL JOIN orders

--- By default if we create index , it uses Btree
/*
B-Tree Index
  	CREATE UNIQUE INDEX index_name
	1. Default Index
	2. self-balancing tree
	 - SELECT, INSERT, DELETE and sequential access in logarithmic time
	3. Can be used for most operators and column type
	4. Supports the UNIQUE condition and
	5. Normally used to build the primary key indexes
	6. Uses when columns involves following operators

    One drawback: copy the whole column(s)' values into the tree structure
*/

---- Hash index for equality operator 
CREATE INDEX index_name ON table_name 
USING hash (column_name);

CREATE INDEX idx_orders_order_date_on ON orders USING hash (order_date);

EXPLAIN SELECT * FROM orders ORDER BY order_date;


--- BRIN index
/*
1. block range indexes
2. data block -> min to max value
3. Smaller index
4. Less costly to maintain than btree index
5. Can be used on a large table vs btree index
6. used Linear sort order e.g. customers -> order_date
*/


--- GIN index
 /* 
1. generalized inverted indexes
2. Point to multiple tuples
3. Used with array type data
4. Used in full text-search
5. Useful when we have multiple values stored in a single column
*/

---- Explain Statement
EXPLAIN SELECT * FROM suppliers
WHERE supplier_id = 1;

EXPLAIN SELECT * FROM suppliers
ORDER BY company_name;

EXPLAIN SELECT * FROM suppliers
WHERE supplier_id = 1 ORDER BY company_name;

EXPLAIN (FORMAT JSON)SELECT FROM orders WHERE order_id = 1

"[
  {
    ""Plan"": {
      ""Node Type"": ""Index Only Scan"",
      ""Parallel Aware"": false,
      ""Async Capable"": false,
      ""Scan Direction"": ""Forward"",
      ""Index Name"": ""pk_orders"",
      ""Relation Name"": ""orders"",
      ""Alias"": ""orders"",
      ""Startup Cost"": 0.28,
      ""Total Cost"": 8.29,
      ""Plan Rows"": 1,
      ""Plan Width"": 0,
      ""Index Cond"": ""(order_id = 1)""
    }
  }
]"

EXPLAIN (FORMAT JSON)SELECT FROM orders WHERE order_id = 1
ORDER BY ship_name;

"[
  {
    ""Plan"": {
      ""Node Type"": ""Sort"",
      ""Parallel Aware"": false,
      ""Async Capable"": false,
      ""Startup Cost"": 8.30,
      ""Total Cost"": 8.31,
      ""Plan Rows"": 1,
      ""Plan Width"": 18,
      ""Sort Key"": [""ship_name""],
      ""Plans"": [
        {
          ""Node Type"": ""Index Scan"",
          ""Parent Relationship"": ""Outer"",
          ""Parallel Aware"": false,
          ""Async Capable"": false,
          ""Scan Direction"": ""Forward"",
          ""Index Name"": ""pk_orders"",
          ""Relation Name"": ""orders"",
          ""Alias"": ""orders"",
          ""Startup Cost"": 0.28,
          ""Total Cost"": 8.29,
          ""Plan Rows"": 1,
          ""Plan Width"": 18,
          ""Index Cond"": ""(order_id = 1)""
        }
      ]
    }
  }
]" 

--- Using EXPLAIN ANALYZE 
EXPLAIN ANALYZE SELECT * FROM orders WHERE order_id = 1 ORDER BY order_id;

"Index Scan using pk_orders on orders  (cost=0.28..8.29 rows=1 width=90) (actual time=1.052..1.053 rows=0 loops=1)"
"  Index Cond: (order_id = 1)"
"Planning Time: 0.129 ms"
"Execution Time: 1.074 ms"


CREATE TABLE t_big (id serial, name text);
INSERT INTO t_big (name)
SELECT 'Adam' FROM generate_series (1,2000000);
INSERT INTO t_big (name)
SELECT 'Linda' FROM generate_series (1,2000000);


EXPLAIN SELECT * FROM t_big WHERE id = 12345;

SHOW max_parallel_workers_per_gather;

SET max_parallel_workers_per_gather TO 0;

SELECT pg_relation_size('t_big') / 8192.0;

SHOW seq_page_cost;

SHOW cpu_tuple_cost;

SHOW cpu_operator_cost;

/*
pg_relation_size *
seq_page_cost +
total_number_of_table_records *
cpu_tuple_cost +  
5+ Łotal_number_of_table_records *
cpu_operator_cost
*/



SELECT
pg_size_pretty (pg_indexes_size('t_big'));

SELECT
pg_size_pretty(
pg_total_relation_size ('t_big'));

EXPLAIN ANALYZE SELECT FROM t_big WHERE id = 123456

CREATE INDEX idx_t_big_id 	ON t_big(id);

--- Insert
paraller index creation > btree index 
SHOW max_parallel_maintenance_workers


EXPLAIN SELECT * FROM orders WHERE order_id = 1

--- Indexes for sorted output
EXPLAIN SELECT * FROM t_big 
ORDER BY id
LIMIT 20;

EXPLAIN SELECT * FROM t_big 
ORDER BY name
LIMIT 20;

EXPLAIN SELECT min(id),
max(id)
FROM t_big;


ASC ........ lowest
DESC ........ highest


--- Using multiple indexes on a single query

EXPLAIN SELECT * FROM t_big
WHERE id = 20 OR id = 40;

--- scan 1 blocks pages of table
--- scan 2 blocks -pages of table


--- Execution Plans Depends on input values

CREATE INDEX idx_t_big_name ON t_big (name);
EXPLAIN SELECT * FROM t_big WHERE name = 'Adam'
LIMIT 10;

EXPLAIN SELECT FROM t_big
WHERE name = 'Adam'
OR name = 'Linda';

EXPLAIN SELECT FROM t_big
WHERE name = 'Adam1'
OR name = 'Linda1';

--- Using Organized and Random Data
SELECT * FROM t_big ORDER BY id LIMIT 10;

EXPLAIN (ANALYZE true, BUFFERS true, TIMING true)
SELECT * FROM t_big WHERE id < 10000; 

ORDER BY random()

CREATE TABLE t_big_random AS SELECT * FROM t_big ORDER BY random();

CREATE INDEX idx_t_big_random_id ON t_big_random(id);

SELECT * FROM t_big_random LIMIT 10;

VACUUM ANALYZE table_name;

VACUUM ANALYZE t_big_random;

EXPLAIN (analyze true, buffers true, timing true)
SELECT FROM t_big_random WHERE id < 10000;

pg_stats

SELECT
tablename,
attname, correlation
FROM pg_stats
WHERE
tablename IN ('t_big','t_big_random')
ORDER BY 1,2;

--- Try using index only scan
EXPLAIN ANALYZE SELECT * FROM t_big where id = 123456 
---- "Planning Time: 0.109 ms" + "Execution Time: 0.122 ms"

EXPLAIN ANALYZE SELECT id FROM t_big where id = 123456 
---- "Planning Time: 0.119 ms" + "Execution Time: 0.061 ms"

--- Partial Index
/*Partial index:
to improve the performance of the query while reducing the index size.
*/
CREATE INDEX index_name ON table_name
WHERE conditions

SELECT
pg_size_pretty (pg_indexes_size('customers'));

DROP INDEX idx_t_big_name;

CREATE INDEX idx_p_t_big_name ON t_big(name)

CREATE INDEX index_name
ON table_name (expression);

CREATE TABLE t_dates AS
SELECT d, repeat (md5(d::text), 10) AS padding
FROM generate_series (timestamp '1800-01-01',
						timestamp '2100-01-011',
						interval '1 day') s(d);

VACUUM ANALYZE t_dates;

SELECT COUNT(*) FROM t_dates;

EXPLAIN ANALYZE SELECT * FROM t_dates WHERE d BETWEEN '2001-01-01' AND '2001-01-31';

ANALYZE t_dates;

EXPLAIN ANALYZE SELECT FROM t_dates WHERE EXTRACT (day FROM d) = 1;

CREATE INDEX idx_expr_t_dates ON t_dates (EXTRACT (day FROM d));

ANALYZE t_dates;

EXPLAIN ANALYZE SELECT FROM t_dates WHERE EXTRACT (day FROM d) = 1;

--- Adding Data while indexing 
CREATE INDEX CONCURRENTLY 

CREATE INDEX CONCURRENTLY idx_t_big_name2 on t_big (name);

SELECT oid, relname, relpages, reltuples,
		i.indisunique, i.indisclustered, i.indisvalid,
		pg_catalog.pg_get_indexdef (i.indexrelid, 0, true)
		FROM pg_class c JOIN pg_index i on c.oid = i.indrelid
WHERE c.relname = 't_big';

---Invalidating an index.
--- Lets view all indexes for a table
SELECT oid, relname, relpages, reltuples,
i.indisunique, i.indisclustered, i.indisvalid, 
pg_catalog.pg_get_indexdef (i.indexrelid, 0, true) 
FROM pg_class c JOIN pg_index i on c.oid  = i.indrelid
WHERE c.relname = 'orders'; 

-- Lets run a query to see what the query optimizer uses

SELECT * FROM orders;

EXPLAIN SELECT * FROM orders where ship_country = 'USA' ;

-- Lets create a new index on orders > ship_country

CREATE INDEX idx_orders_ship_country ON orders (ship_country);

EXPLAIN SELECT * FROM orders where ship_country = 'USA' ;

-- Lets disallow the query optimizer to use our index

UPDATE pg_index
SET indisvalid = false
WHERE indexrelid = (SELECT oid FROM pg_class
                    WHERE relkind = 'i'
                    AND relname = 'idx_orders_ship_country');

-- Lets reset the value

UPDATE pg_index
SET indisvalid = true
WHERE indexrelid = (SELECT oid FROM pg_class
                    WHERE relkind = 'i'
                    AND relname = 'idx_orders_ship_country');


-- Rebuilding an index (REINDEX)
-- #############################

REINDEX [ ( VERBOSE ) ] { INDEX | TABLE | SCHEMA | DATABASE | SYSTEM } [ CONCURRENTLY ] name

REINDEX (VERBOSE) TABLE CONCURRENTLY orders ;

