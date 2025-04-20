USE restaurant_db;

SELECT * FROM dbo.menu_items;

-- View the menu_items table and write a query to find the number of items on the menu 

SELECT count(*) AS number_of_items
FROM dbo.menu_items

-- What are the least and most expensive items on the menu? 
SELECT 
       MIN(price) AS least_expensive_item,
       MAX(price) AS most_expensive_item
FROM dbo.menu_items;

-- The following query uses Common Table Expressions (CTEs) to find the least and most expensive items on the menu.

WITH min_price_cte AS (
    SELECT item_name, price
    FROM dbo.menu_items
    WHERE price = (SELECT MIN(price) FROM dbo.menu_items)
),
max_price_cte AS (
    SELECT item_name, price
    FROM dbo.menu_items
    WHERE price = (SELECT MAX(price) FROM dbo.menu_items)
)
SELECT 
    min_price.item_name AS least_expensive_item,
    max_price.item_name AS most_expensive_item,
    min_price.price AS least_expensive_price,
    max_price.price AS most_expensive_price 
FROM min_price_cte AS min_price, max_price_cte AS max_price;

-- 1.3 How many Italian dishes are on the menu?  
SELECT count(*) AS number_of_items
FROM dbo.menu_items
WHERE category = 'Italian';

-- 1.3.1 What are the least and most expensive Italian dishes on the menu?
WITH min_price_cte AS (
    SELECT top 1 item_name, price
    FROM dbo.menu_items
    WHERE category = 'Italian' AND price = (SELECT MIN(price) FROM dbo.menu_items WHERE category = 'Italian')
),
max_price_cte AS (
    SELECT item_name, price
    FROM dbo.menu_items
    WHERE category = 'Italian' AND price = (SELECT MAX(price) FROM dbo.menu_items WHERE category = 'Italian')
)  
SELECT 
    min_price.item_name AS least_expensive_item,
    max_price.item_name AS most_expensive_item,
    min_price.price AS least_expensive_price,
    max_price.price AS most_expensive_price
FROM min_price_cte AS min_price, max_price_cte AS max_price;

-- How many dishes are in each category? What is the average dish price within each category?

SELECT category, COUNT(*) AS number_of_items, AVG(price) AS average_price
FROM dbo.menu_items
GROUP BY category
ORDER BY category;

-- TASK - 2
-- 2.1 View the order_details table. What is the date range of the table?

SELECT MIN(order_date) AS start_date, MAX(order_date) AS end_date
FROM dbo.order_details;

--2.2 How many orders were made within this date range? 
SELECT COUNT(DISTINCT order_id) AS number_of_orders
FROM dbo.order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-03-31';
