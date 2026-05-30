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
ORDER BY gross_margin ASC
LIMIT 10;


-- Bottom 10 Low Margin Products (Loss Leaders)




--------------------------
-- MARGIN BY DEPARTMENT --
--------------------------

-- Gross Profit by Department



-- Gross Margin % by Department





--------------------------
-- PRODUCT MIX ANALYSIS --
--------------------------

-- High Margin vs Low Margin Product Count



-- Products with High Revenue but Low Margin (Loss Leaders)
