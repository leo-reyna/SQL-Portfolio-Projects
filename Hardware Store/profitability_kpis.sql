-- ============================================================
-- PROFITABILITY KPIs
-- ============================================================

-------------------------
-- MARGIN BY PRODUCT   --
-------------------------

-- Gross Profit by Product & Gross Margin % by Product

with gp_product_cte as (SELECT 
    p.product_id,
    p.product_name,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) as revenue,
    SUM(soi.quantity * p.unit_cost) as cogs
FROM sales_order_items as soi
JOIN products as p
    ON soi.product_id = p.product_id
JOIN departments as d
    ON d.department_id = p.department_id
GROUP BY p.product_id,
    p.product_name
)
SELECT 
    product_name,
    (revenue - cogs) as gross_profit,
    ROUND(((revenue - cogs) / NULLIF(revenue, 0)) * 100, 2) as gross_margin
FROM gp_product_cte
ORDER BY gross_profit DESC;


-- Top 10 High Margin Products
with gm_product_cte as (SELECT 
    p.product_id,
    p.product_name,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) as revenue,
    SUM(soi.quantity * p.unit_cost) as cogs
FROM sales_order_items as soi
JOIN products as p
    ON soi.product_id = p.product_id
GROUP BY p.product_id,
    p.product_name
)
SELECT 
    product_id,
    product_name,
    revenue,
    cogs,
    (revenue - cogs) as gross_profit,
    ROUND(((revenue - cogs) / NULLIF(revenue, 0)) * 100, 2) as gross_margin
FROM gm_product_cte
ORDER BY gross_margin DESC
LIMIT 10;


-- Bottom 10 Low Margin Products (Loss Leaders)
with gm_product_cte as (SELECT 
    p.product_id,
    p.product_name,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) as revenue,
    SUM(soi.quantity * p.unit_cost) as cogs
FROM sales_order_items as soi
JOIN products as p
    ON soi.product_id = p.product_id
GROUP BY p.product_id,
    p.product_name
)
SELECT 
    product_id,
    product_name,
    revenue,
    cogs,
    (revenue - cogs) as gross_profit,
    ROUND(((revenue - cogs) / NULLIF(revenue, 0)) * 100, 2) as gross_margin
FROM gm_product_cte
ORDER BY gross_margin ASC
LIMIT 10;



--------------------------
-- MARGIN BY DEPARTMENT --
--------------------------

-- Gross Profit and Gross Margin % by Department
with gp_dept_cte as(
SELECT 
    d.department_id,
    d.name as dept_name,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) as revenue,
    SUM(soi.quantity * p.unit_cost) as cogs
FROM sales_order_items as soi
JOIN products as p
    ON soi.product_id = p.product_id
JOIN departments as d
    ON d.department_id = p.department_id
GROUP BY d.department_id, d.name
)
SELECT 
    department_id,
    dept_name,
    (revenue - cogs) as gross_profit,
    ROUND(((revenue - cogs) / NULLIF(revenue, 0)) * 100, 2) as gross_margin
FROM gp_dept_cte
ORDER BY gross_profit DESC;


--------------------------
-- PRODUCT MIX ANALYSIS --
--------------------------

-- High Margin vs Low Margin Product Count

with gm_product_cte as (SELECT 
    p.product_id,
    p.product_name,
    SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) as revenue,
    SUM(soi.quantity * p.unit_cost) as cogs
FROM sales_order_items as soi
JOIN products as p
    ON soi.product_id = p.product_id
GROUP BY p.product_id,
    p.product_name
)
SELECT 
    product_id,
    product_name,
    revenue,
    cogs,
    (revenue - cogs) as gross_profit,
    ROUND(((revenue - cogs) / NULLIF(revenue, 0)) * 100, 2) as margin_percent,
    CASE 
    WHEN ROUND(((revenue - cogs) / NULLIF(revenue, 0)) * 100, 2) >= 40 THEN 'High Margin' 
    WHEN ROUND(((revenue - cogs) / NULLIF(revenue, 0)) * 100, 2) >= 30 THEN 'Mid Margin' 
    ELSE 'Low Margin'
    END AS margin_type
FROM gm_product_cte
ORDER BY margin_percent DESC;

-- Creating a summary for it too! using cte
WITH gm_product_cte AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue,
        SUM(soi.quantity * p.unit_cost) AS cogs
    FROM sales_order_items AS soi
    JOIN products AS p
        ON soi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
),
prod_margin_cte AS (
    SELECT 
        product_id,
        product_name,
        revenue,
        cogs,
        (revenue - cogs) AS gross_profit,
        ROUND((revenue - cogs) / NULLIF(revenue, 0) * 100, 2) AS margin_percent
    FROM gm_product_cte
),
prod_classified_cte AS (
    SELECT *,
        CASE 
            WHEN margin_percent >= 40 THEN 'High Margin'
            WHEN margin_percent >= 30 THEN 'Mid Margin'
            ELSE 'Low Margin'
        END AS margin_type
    FROM prod_margin_cte
),
prod_summary_cte AS (
    SELECT 
        margin_type,
        COUNT(*) AS prod_count
    FROM prod_classified_cte
    GROUP BY margin_type
)
SELECT margin_type, prod_count
FROM prod_summary_cte
ORDER BY prod_count DESC;

-- Products with High Revenue but Low Margin (Loss Leaders)

WITH gm_product_cte AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM((soi.quantity * soi.unit_price_at_sale) - soi.discount_amount) AS revenue,
        SUM(soi.quantity * p.unit_cost) AS cogs
    FROM sales_order_items AS soi
    JOIN products AS p
        ON soi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
),
prod_margin_cte AS (
    SELECT 
        product_id,
        product_name,
        revenue,
        cogs,
        (revenue - cogs) AS gross_profit,
        ROUND((revenue - cogs) / NULLIF(revenue, 0) * 100, 2) AS margin_percent
    FROM gm_product_cte
),
prod_classified_cte AS (
    SELECT *,
        CASE 
            WHEN margin_percent >= 40 THEN 'High Margin'
            WHEN margin_percent >= 30 THEN 'Mid Margin'
            ELSE 'Low Margin'
        END AS margin_type
    FROM prod_margin_cte
),
prod_summary_cte AS (
    SELECT 
        margin_type,
        COUNT(*) AS prod_count
    FROM prod_classified_cte
    GROUP BY margin_type
),
high_rev_low_margin as(
    SELECT *
    FROM prod_margin_cte
    WHERE revenue > (SELECT avg(revenue) FROM prod_margin_cte)
    AND margin_percent < 30
)
SELECT * FROM high_rev_low_margin;