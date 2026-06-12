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


-- Average Lead Time by Supplier (actual vs promised)
-- TODO




----------------------------
-- COST ANALYSIS          --
----------------------------

-- Cost Variance by Supplier
-- hint: compare unit_cost_at_order vs current products.unit_cost
-- TODO


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