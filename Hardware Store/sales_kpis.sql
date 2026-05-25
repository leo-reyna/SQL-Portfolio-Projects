-- ============================================================
--  SALES KPI QUERIES 
--  LK Hardware Store Analytics
--  PostgreSQL 
--  ============================================================ 

SELECT * FROM sales_orders
LIMIT 500

/*
The sales data is split across two tables:
sales_orders --> the transaction header
sales_order_items --> the actual money
Think of it like a receipt: sales_orders is the top of the receipt — who bought, when, how they paid
sales_order_items is the line items — what they bought, how many, at what price
*/

-------------
-- REVENUE --
-------------

-- Total Revenue
SELECT SUM(order_total) AS total_revenue
FROM sales_orders;


-- Total Revenue by Department
SELECT
    d.department_id,
    d.name AS department,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN products AS p  
    ON p.product_id = soi.product_id
JOIN departments AS d  
    ON d.department_id = p.department_id
GROUP BY d.department_id, d.name
ORDER BY revenue DESC;

-- Total Revenue by Product
SELECT
    p.product_id,
    d.name as department_name,
    p.product_name,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN products AS p  
    ON p.product_id = soi.product_id
JOIN departments as d
    on p.department_id = d.department_id
GROUP BY d.name, p.product_id, p.product_name
ORDER BY revenue DESC;



-- Total Revenue by Customer Type
SELECT
    c.customer_type,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN sales_orders as so
    ON soi.order_id = so.order_id
JOIN customers as c
    on c.customer_id = so.customer_id
GROUP BY c.customer_type
ORDER BY revenue DESC;


-- Monthly Revenue Trend
SELECT
    EXTRACT(YEAR FROM so.order_date) AS year_sold,
    EXTRACT(MONTH FROM so.order_date) AS month_sold,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN sales_orders as so
    ON soi.order_id = so.order_id
GROUP BY 
    year_sold, 
    month_sold
ORDER BY 
    year_sold, 
    month_sold;

-- With month names instead of "1, 2 .."
SELECT
    EXTRACT(YEAR FROM so.order_date) AS year_sold,
    TO_CHAR(so.order_date, 'FMMonth') AS month_sold,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN sales_orders as so
    ON soi.order_id = so.order_id
GROUP BY 
    EXTRACT(YEAR FROM so.order_date), 
    TO_CHAR(so.order_date, 'FMMonth')
ORDER BY 
    year_sold ASC, 
    EXTRACT(MONTH FROM MIN(so.order_date)) ASC;

-----------
-- ORDERS --
-----------

-- Total Orders
SELECT COUNT(*) AS total_orders
FROM sales_orders;


-- Total Orders by Customer Type
SELECT 
    c.customer_type,
    COUNT(*) AS total_orders
FROM sales_orders
JOIN customers as c ON c.customer_id = so.customer_id
GROUP BY c.customer_type
ORDER BY total_orders DESC;


-- Average Order Value (overall)
SELECT 
     AVG(order_total) as avg_order_total
FROM sales_orders;

SELECT * from sales_orders;
-- Average Order Value by Customer Type
SELECT 
    c.customer_type,
    AVG(order_total) as order_avg_by_type
FROM sales_orders as so
JOIN customers as c ON c.customer_id = so.customer_id
GROUP BY c.customer_type
ORDER BY order_avg_by_type DESC;


-- Total Orders by Month (bonus)

SELECT
    EXTRACT(YEAR  FROM order_date) AS year_sold,
    EXTRACT(MONTH FROM order_date) AS month_num,
    TO_CHAR(order_date, 'FMMonth') AS month_name,
    COUNT(*) AS total_orders
FROM sales_orders
GROUP BY year_sold, month_num, month_name
ORDER BY year_sold, month_num;

-----------------
-- PERFORMANCE --
-----------------

-- Top 10 Products by Revenue
SELECT
    p.product_id,
    d.name as department_name,
    p.product_name,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN products AS p  
    ON p.product_id = soi.product_id
JOIN departments as d
    on p.department_id = d.department_id
GROUP BY d.name, p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 Products by Quantity Sold
SELECT
    p.product_id,
    d.name as department_name,
    p.product_name,
    SUM(soi.quantity) AS total_units_sold
FROM sales_order_items AS soi
JOIN products AS p  
    ON p.product_id = soi.product_id
JOIN departments as d
    on p.department_id = d.department_id
GROUP BY d.name, p.product_id, p.product_name
ORDER BY total_units_sold DESC
LIMIT 10;


-- Employee Sales Performance
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.role,
    d.name AS department,
    COUNT(DISTINCT so.order_id) AS total_orders,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS total_revenue
FROM sales_order_items AS soi
JOIN sales_orders AS so  ON so.order_id = soi.order_id
JOIN employees AS e      ON e.employee_id = so.employee_id
JOIN departments AS d    ON d.department_id = e.department_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.role, d.name
ORDER BY total_revenue DESC;




--------------------
-- CUSTOMER STATS --
--------------------

-- Revenue by Customer Type
SELECT
    c.customer_type,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN sales_orders as so
    ON soi.order_id = so.order_id
JOIN customers as c
    on c.customer_id = so.customer_id
GROUP BY c.customer_type
ORDER BY revenue DESC;



-- Average Order Value by Customer Type
SELECT 
    c.customer_type,
    AVG(order_total) as order_avg_by_type
FROM sales_orders as so
JOIN customers as c ON c.customer_id = so.customer_id
GROUP BY c.customer_type
ORDER BY order_avg_by_type DESC;


-- Top 10 Customers by Revenue
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name as fullname,
    c.customer_type,
    COUNT(DISTINCT so.order_id) AS total_orders,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue
FROM sales_order_items AS soi
JOIN sales_orders as so
    ON soi.order_id = so.order_id
JOIN customers as c
    on c.customer_id = so.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.customer_type
ORDER BY revenue DESC
LIMIT 10;