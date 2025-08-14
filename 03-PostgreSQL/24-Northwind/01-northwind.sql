
--- Order shiped to France and USA
SELECT * FROM orders 
WHERE ship_country IN ('France' , 'USA')
ORDER BY ship_country

--- Count number of total orders for above query
SELECT ship_country,COUNT(*) FROM orders 
WHERE ship_country IN ('France' , 'USA')
GROUP BY ship_country 
ORDER BY ship_country

--- Order shipping into latin america
SELECT * FROM orders WHERE ship_country IN ('Argentina',
'Belize',
'Bolivia',
'Brazil',
'Chile',
'Colombia',
'Costa Rica',
'Cuba',
'Dominican Republic',
'Ecuador',
'El Salvador',
'Guatemala',
'Honduras',
'Mexico',
'Nicaragua',
'Panama',
'Paraguay',
'Peru',
'Uruguay',
'Venezuela'
)


--- 	Total Order Amount
SELECT order_id , product_id , 
ROUND((unit_price * quantity - discount)::integer,2) 
AS Total_Amount
FROM order_detail

--- Find the oldest and latest order date 

SELECT * FROM orders
ORDER BY order_date ASC LIMIT 1;

SELECT * FROM orders
ORDER BY order_date DESC LIMIT 1;

--- total products in each category
SELECT c.category_name,COUNT(p.product_id) AS "count" 
FROM products p JOIN categories c USING(category_id) 
GROUP BY c.category_name
ORDER BY "count" DESC

--- lists products that need reordering
SELECT * FROM products
WHERE units_in_stock <= reorder_level

--- Top 5 highest freight charges 
SELECT ship_country , ROUND(AVG(freight)::integer,2) FROM orders 
GROUP BY ship_country 
ORDER BY 2 
DESC LIMIT 5

---In 1997
SELECT ship_country , ROUND(AVG(freight)::integer,2) 
FROM orders
WHERE order_date 
BETWEEN '1996-12-31' AND '1998-01-01'
GROUP BY ship_country 
ORDER BY 2 
DESC LIMIT 5

SELECT
    ship_country,
    AVG(freight)
FROM orders
WHERE
    EXTRACT('Y' FROM order_date) = EXTRACT('Y' FROM (SELECT max(order_date) FROM orders))
GROUP BY ship_country
ORDER BY 2 DESC
LIMIT 5


--- Customer With no orders
SELECT l.customer_id 
FROM customers l LEFT JOIN orders r USING (customer_id) WHERE r.customer_id IS NULL


--- Top 5 order with total amount 
SELECT c.company_name , SUM(ROUND(((od.unit_price * od.quantity) - od.discount)::integer,2))
FROM orders o JOIN customers c USING(customer_id)
JOIN order_details od USING(order_id)
GROUP BY c.company_name
ORDER BY 2 DESC

--- Order with many order lines
SELECT order_id, COUNT(*) FROM order_details
GROUP BY order_id 
ORDER BY 2 DESC

--- Orders with double entry line - HAVING QUANTITY OF SAME PRODUCT TWICE
SELECT 
order_id, quantity FROM order_details WHERE quantity > 60
GROUP BY 
order_id , quantity
HAVING 
COUNT(*) > 1


--- Late shipped orders  with customer name
SELECT order_id, required_date , shipped_date
FROM orders
WHERE required_date < shipped_date


--- employee of late orders 
SELECT DISTINCT e.first_name , e.last_name  FROM orders o JOIN employees e USING(employee_id)
WHERE o.required_date < o.shipped_date


--- also find number of total late orders 

WITH total_orders AS (
	SELECT employee_id,COUNT(order_id) as total_orders
	FROM orders
	GROUP BY employee_id
),
missed_order AS(
	SELECT employee_id,COUNT(order_id) as missed_order
	FROM orders
	WHERE required_date < shipped_date
	GROUP BY employee_id 
)
SELECT 
	e.first_name || ' ' || e.last_name AS full_name,
	total_orders.employee_id ,
	total_orders.total_orders,
	missed_order.missed_order
FROM total_orders
JOIN missed_order  
    ON total_orders.employee_id = missed_order.employee_id
JOIN employees e 
	ON total_orders.employee_id = e.employee_id;


----
SELECT DISTINCT country
	FROM customers
UNION 
SELECT DISTINCT country
FROM suppliers;


---- USIGN CTE
WITH countries_suppliers AS
(
    SELECT DISTINCT country FROM suppliers
),
countries_customers AS
(
    SELECT DISTINCT country FROM customers
)
SELECT 
    countries_suppliers.country AS country_suppliers,
    countries_customers.country AS country_customers
FROM countries_suppliers
FULL JOIN countries_customers 
    ON countries_customers.country = countries_suppliers.country;



---- Window functions
WITH next_order_date AS
(
    SELECT
        customer_id,
        order_date,
        LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY customer_id, order_date) AS next_order_date
    FROM orders
)
SELECT
    customer_id,
    order_date,
    next_order_date,
    (next_order_date - order_date) AS days_between_orders
FROM next_order_date
WHERE
    (next_order_date - order_date) <= 4;


---
WITH orders_by_country AS
(
    SELECT
        ship_country,
        order_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY ship_country ORDER BY ship_country, order_date DESC) country_row_number
    FROM orders
)
SELECT
    ship_country,
    order_id,
    order_date
FROM orders_by_country
WHERE
    country_row_number = 1;
