-- ============================================================
-- INVENTORY KPIs
-- ============================================================


-------------------
-- STOCK LEVELS  --
-------------------

-- Checking tables
SELECT * FROM inventory
LIMIT 15;

SELECT * FROM products
LIMIT 15;

SELECT * FROM departments;
-- Current Stock by Department

SELECT  d.name as department_name,
        SUM(i.quantity_on_hand) as on_hand,
        SUM(i.quantity_on_hand * p.unit_cost) as total_stock_value
FROM inventory as i
JOIN products as p
    ON i.product_id = p.product_id
JOIN departments as d 
    ON d.department_id = p.department_id
WHERE p.is_discontinued = FALSE
GROUP BY d.name
ORDER BY d.name


-- Inventory Health Status (Out of Stock / Below Reorder / Overstocked / Normal)
SELECT
    p.product_id,
    p.product_name,
    d.name as dept_name,
    i.quantity_on_hand,
    p.reorder_point,
    CASE
        WHEN (i.quantity_on_hand = 0) THEN 'Out of Stock'
        WHEN (i.quantity_on_hand < p.reorder_point) THEN 'Below Reorder'
        WHEN (i.quantity_on_hand > p.reorder_point * 8) THEN 'Overstocked'
        ELSE 'Normal'
    END AS stock_status
FROM inventory as i
JOIN products as p
    ON i.product_id = p.product_id
JOIN departments as d 
    ON d.department_id = p.department_id
WHERE p.is_discontinued = FALSE
ORDER BY p.product_id, p.product_name, d.name, i.quantity_on_hand;


-- Products Below Reorder Point
-- TODO


-- Products Out of Stock
-- TODO


-- Products Overstocked
-- TODO




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