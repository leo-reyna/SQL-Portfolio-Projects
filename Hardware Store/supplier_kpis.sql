-- ============================================================
-- SUPPLIER KPIs
-- ============================================================


----------------------------
-- DELIVERY PERFORMANCE   --
----------------------------
-- know what your data is saying
-- know what your audience needs to hear
-- know what your really want to say

-- Overall On-Time Delivery Rate
SELECT
    COUNT(*)  AS total_orders,
    COUNT(CASE WHEN status = 'Received' THEN 1 END) AS on_time_orders,
    COUNT(CASE WHEN status != 'Received' 
               AND expected_delivery_date < CURRENT_DATE 
               THEN 1 END
        )  AS late_orders,
    ROUND(
    COUNT(CASE WHEN status = 'Received' THEN 1 END) 
        * 100.0 / COUNT(*), 2
        ) AS on_time_rate_pct
FROM supplier_orders;




-- On-Time Delivery Rate by Supplier
SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(*)  AS total_orders,
    COUNT(CASE WHEN status = 'Received' THEN 1 END) AS on_time_orders,
    COUNT(CASE WHEN status != 'Received' 
               AND expected_delivery_date < CURRENT_DATE 
               THEN 1 END)  AS late_orders,
    ROUND(COUNT(CASE WHEN status = 'Received' THEN 1 END)  * 100.0 / COUNT(*), 2) AS on_time_rate_pct
FROM supplier_orders as so
JOIN suppliers AS s
    ON so.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.supplier_name, s.lead_time_days;


-- Average Lead Time by Supplier (actual vs promised)
SELECT
    s.supplier_id,
    s.supplier_name,
    s.lead_time_days as promised_lead_days,
    ROUND(AVG(so.expected_delivery_date -so.order_date), 1) as avg_actual_lead_time,
    ROUND(AVG((so.expected_delivery_date - so.order_date) - s.lead_time_days), 1) as variance_days
FROM supplier_orders as so
JOIN suppliers AS s
    ON so.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.supplier_name, s.lead_time_days
ORDER BY variance_days DESC; -- Puts the most delayed suppliers at the top

----------------------------
-- COST ANALYSIS          --
----------------------------

-- Cost Variance by Supplier
SELECT 
    s.supplier_name,
    ROUND(AVG(p.unit_cost),2) AS avg_current_cost,
    ROUND(AVG(soi.unit_cost_at_order),2) as avg_order_cost,
    ROUND(AVG(soi.unit_cost_at_order - p.unit_cost),2) as avg_cost_variance
FROM supplier_order_items as soi
JOIN products as p
ON soi.product_id = p.product_id
JOIN suppliers as s
ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY avg_cost_variance DESC;


-- Average Order Cost by Supplier
-- TODO




----------------------------
-- SUPPLIER DEPENDENCY    --
----------------------------

-- SKU Count by Supplier (how many products per supplier)
-- TODO


-- Supplier Dependency % (each supplier's share of total SKUs)
-- TODO


-- Single Supplier Risk (products sourced from only one supplier)
-- TODO