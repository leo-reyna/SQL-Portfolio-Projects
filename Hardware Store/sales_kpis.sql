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
Think of it like a receipt:
sales_orders is the top of the receipt — who bought, when, how they paid
sales_order_items is the line items — what they bought, how many, at what price

*/


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