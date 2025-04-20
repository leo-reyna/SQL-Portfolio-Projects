USE restaurant_db;

-- TASK - 1 
-- 1. View the menu_items table. 
SELECT * FROM dbo.menu_items
ORDER BY price DESC;

-- 2. Write a query to find the number of items on the menu 
SELECT count(*) AS number_of_items
FROM dbo.menu_items;


-- 3. What are the least and most expensive items on the menu? 
SELECT 
       MIN(price) AS least_expensive_item,
       MAX(price) AS most_expensive_item
FROM dbo.menu_items;

SELECT 
    item_name, 
    price
FROM dbo.menu_items
WHERE price = (SELECT MAX(price) FROM dbo.menu_items)

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
    min_price.price AS least_expensive_price,
    max_price.item_name AS most_expensive_item,
    max_price.price AS most_expensive_price 
FROM min_price_cte AS min_price, max_price_cte AS max_price;

-- 4. How many Italian dishes are on the menu?  
SELECT count(*) AS number_of_items
FROM dbo.menu_items
WHERE category = 'Italian';

-- 5 What are the least and most expensive Italian dishes on the menu?
-- Displaying the table in descending order of price to find the most expensive item.
SELECT *
FROM dbo.menu_items
WHERE category = 'Italian'
ORDER BY price DESC;

-- Checking just the least expensive item and the most expensive item in the Italian category.
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
    min_price.price AS least_expensive_price,
    max_price.item_name AS most_expensive_item,
    max_price.price AS most_expensive_price
FROM min_price_cte AS min_price, max_price_cte AS max_price;

--6.  How many dishes are in each category? 
SELECT category, COUNT(menu_item_id) AS number_of_dishes_
FROM dbo.menu_items
GROUP BY category;

-- also, what is the average dish price within each category?
SELECT category, COUNT(*) AS number_of_items, AVG(price) AS average_price
FROM dbo.menu_items
GROUP BY category
ORDER BY category;

-- TASK - 2 // Exploratory Data Analysis (EDA) on the order_details table.
-- 1. View the order_details table.
SELECT * FROM dbo.order_details

-- 2. What is the date range of the table?
SELECT MIN(order_date) AS start_date, MAX(order_date) AS end_date
FROM dbo.order_details;

-- 3. How many orders were made within this date range? 
SELECT COUNT(DISTINCT order_id) AS number_of_orders
FROM dbo.order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-03-31';

-- 4. How many items were ordered in total withing this date range?
SELECT COUNT(*) AS number_of_items_ordered
FROM dbo.order_details;

-- 5. Which orders had the most number of items?
SELECT order_id, count(item_id) AS number_of_items_ordered
FROM dbo.order_details
GROUP BY order_id
ORDER BY number_of_items_ordered DESC;

--How many orders had more than 12 items?
WITH num_orders AS (
    SELECT order_id, COUNT(item_id) AS number_of_items_ordered
    FROM dbo.order_details
    GROUP BY order_id
    HAVING COUNT(item_id) > 12
)
SELECT count(*) AS number_of_orders_with_more_than_12_items
FROM num_orders;

-- Viewing the orders with more than 12 items.
WITH num_orders AS (
    SELECT order_id, COUNT(item_id) AS number_of_items_ordered
    FROM dbo.order_details
    GROUP BY order_id
    HAVING COUNT(item_id) > 12
)
SELECT * FROM num_orders;

-- TASK - 3 // Analyzing customer behavior.
SELECT * FROM dbo.menu_items
SELECT * FROM dbo.order_details

-- 1. Combining the menu_items and order_details tables into a single table.
SELECT 
    od.order_id,
    od.order_date,
    mi.menu_item_id,
    mi.item_name,
    mi.category,
    mi.price
FROM  order_details AS od -- fact table
LEFT JOIN menu_items AS mi
ON od.item_id = mi.menu_item_id

-- 2 What wre the least and most expensive items ordered? what categories were they in?
SELECT 
    item_name,
    count(order_details_id) AS number_of_purchases
FROM  order_details AS od -- fact table
LEFT JOIN menu_items AS mi
    ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY number_of_purchases DESC;

-- 3. Categorizing the items ordered into their respective categories.
SELECT 
    item_name,
    category,
    count(order_details_id) AS number_of_purchases
FROM  order_details AS od -- fact table
LEFT JOIN menu_items AS mi
    ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY number_of_purchases DESC;

-- 4. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(PRICE) AS TOTAL_SPENT
FROM order_details AS od -- fact table
LEFT JOIN menu_items AS mi
    ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spent DESC

SELECT TOP 5 order_id, SUM(PRICE) AS TOTAL_SPENT
FROM order_details AS od -- fact table
LEFT JOIN menu_items AS mi
    ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spent DESC

-- 4. View the details of the highest spend order. What insight can you draw from this?
SELECT  category, count(order_details_id) AS number_of_purchases, SUM(price) AS total_spent
FROM order_details AS od -- fact table
LEFT JOIN menu_items AS mi
    ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category;

-- 5. Viewthe details of the top 5 spend orders. What insight can you draw from this?
SELECT order_id, category, count(item_id) AS num_of_items_ordered
FROM order_details AS od -- fact table
LEFT JOIN menu_items AS mi
    ON od.item_id = mi.menu_item_id
WHERE order_id in (440, 2075, 1957, 330, 2675)
GROUP BY category, order_id

-- End of the SQL code.