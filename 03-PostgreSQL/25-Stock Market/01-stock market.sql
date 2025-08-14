--- Stock Market

SELECT *
FROM stocks_prices
WHERE symbol_id = 1
ORDER BY price_date ASC
OFFSET 10
LIMIT 10;

---
SELECT 
    symbol_id,
    MIN(price_date) AS earliest_price_date
FROM stocks_prices
GROUP BY symbol_id;



---
SELECT 
    *
FROM stocks_prices
WHERE symbol_id = 8
ORDER BY price_date ASC;


---
SELECT 
    close_price,
    CBRT(close_price)
FROM stocks_prices
WHERE symbol_id = 1
ORDER BY price_date DESC;
