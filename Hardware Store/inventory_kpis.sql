-- ============================================================
-- INVENTORY KPIs
-- ============================================================


-------------------
-- STOCK LEVELS  --
-------------------

-- Checking tables
-- Quick table checks (explicit columns to avoid SELECT *)
SELECT product_id, quantity_on_hand FROM inventory
LIMIT 15;

SELECT product_id, product_name, unit_cost, department_id, is_discontinued, reorder_point FROM products
LIMIT 15;

SELECT department_id, name FROM departments;
-- Current Stock by Department

SELECT  d.name as department_name,
        SUM(COALESCE(i.quantity_on_hand,0)) as on_hand,
        SUM(COALESCE(i.quantity_on_hand,0) * COALESCE(p.unit_cost,0)) as total_stock_value
FROM inventory as i
JOIN products as p
    ON i.product_id = p.product_id
JOIN departments as d 
    ON d.department_id = p.department_id
WHERE p.is_discontinued = FALSE
GROUP BY d.name
ORDER BY d.name;


-- Inventory Health Status (Out of Stock / Below Reorder / Overstocked / Normal)
-- Creating a view to make my life easier when calling it for the rest of this analysis
CREATE OR REPLACE VIEW vw_common_stock AS 
    SELECT
        p.product_id,
        p.product_name,
        d.name as dept_name,
        COALESCE(i.quantity_on_hand, 0) AS quantity_on_hand,
        COALESCE(i.quantity_on_order, 0) AS quantity_on_order,
        COALESCE(p.reorder_point, 0) AS reorder_point,
        COALESCE(p.unit_cost, 0) AS unit_cost,
        CASE
            WHEN (COALESCE(i.quantity_on_hand,0) = 0) THEN 'Out of Stock'
            WHEN (COALESCE(i.quantity_on_hand,0) < COALESCE(p.reorder_point,0)) THEN 'Below Reorder'
            WHEN (COALESCE(i.quantity_on_hand,0) > COALESCE(p.reorder_point,0) * 8) THEN 'Overstocked'
            ELSE 'Normal'
        END AS stock_status
    FROM inventory as i
    JOIN products as p
        ON i.product_id = p.product_id
    JOIN departments as d 
        ON d.department_id = p.department_id
    WHERE p.is_discontinued = FALSE;

-- All products
SELECT * FROM vw_common_stock ORDER BY product_id;

-- Products Below Reorder Point
SELECT product_id, product_name, dept_name, quantity_on_hand, reorder_point, stock_status
FROM vw_common_stock
WHERE quantity_on_hand > 0
    AND quantity_on_hand < reorder_point
ORDER BY quantity_on_hand ASC;


-- Products Out of Stock
SELECT product_id, product_name, dept_name, quantity_on_hand, reorder_point, stock_status
FROM vw_common_stock
WHERE quantity_on_hand = 0;


-- Products Overstocked
SELECT product_id, product_name, dept_name, quantity_on_hand, reorder_point, stock_status
FROM vw_common_stock
WHERE quantity_on_hand > reorder_point * 8;


-------------------
-- REORDER        --
-------------------

-- Products Needing Reorder (on_hand < reorder_point AND nothing on order)
-- TODO


-- Total Units Currently on Order by Supplier
-- TODO




-------------------
-- TURNOVER       --
-------------------

-- Units Sold per Product (base for turnover)
-- TODO


-- Inventory Turnover Rate per Product
-- hint: units_sold / avg_quantity_on_hand
-- TODO


-- Days of Inventory on Hand per Product
-- hint: 365 / turnover_rate
-- TODO




-------------------
-- SUPPLIER LINK  --
-------------------

-- Stock Value by Supplier (quantity_on_hand * unit_cost)
-- TODO


-- Products at Risk by Supplier (below reorder point grouped by supplier)
-- TODO