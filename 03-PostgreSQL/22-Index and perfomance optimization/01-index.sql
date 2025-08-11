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
