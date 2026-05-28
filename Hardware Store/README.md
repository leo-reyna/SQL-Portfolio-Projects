# LK Hardware Store: PostgreSQL Analytics Project

This repository contains a fully modeled PostgreSQL database simulating a mid-sized hardware store,
built for practicing SQL analytics and KPI development.

## 📚 Project Overview

This database includes:

- A relational schema with **foreign keys**, **normalized tables**, and **realistic business logic**
    
- Dummy data with **seasonality**, **price variation**, **bulk discounts**, and **inventory dynamics**
    
- Support for advanced KPIs across **sales**, **inventory**, **profitability**, **suppliers**, and **customers**
    
- A foundation for BI dashboards (Tableau, Power BI, Looker, Metabase)
    
# ERD

```mermaid
erDiagram
  departments {
    int department_id PK
    varchar name
    int manager_employee_id FK
  }
  employees {
    int employee_id PK
    varchar first_name
    varchar last_name
    varchar role
    date hire_date
    int department_id FK
    numeric hourly_rate
  }
  suppliers {
    int supplier_id PK
    varchar supplier_name
    varchar contact_name
    varchar phone
    varchar email
    int lead_time_days
  }
  products {
    int product_id PK
    varchar product_name
    int department_id FK
    int supplier_id FK
    varchar sku
    numeric unit_cost
    numeric unit_price
    int reorder_point
    boolean is_special_order
    boolean is_discontinued
  }
  inventory {
    int inventory_id PK
    int product_id FK
    int quantity_on_hand
    int quantity_on_order
    date last_restock_date
  }
  customers {
    int customer_id PK
    varchar first_name
    varchar last_name
    varchar customer_type
    varchar email
    varchar phone
    date join_date
  }
  sales_orders {
    int order_id PK
    int customer_id FK
    int employee_id FK
    timestamp order_date
    varchar payment_method
    numeric order_total
  }
  sales_order_items {
    int order_item_id PK
    int order_id FK
    int product_id FK
    int quantity
    numeric unit_price_at_sale
    numeric discount_amount
  }
  supplier_orders {
    int supplier_order_id PK
    int supplier_id FK
    int employee_id FK
    date order_date
    date expected_delivery_date
    varchar status
  }
  supplier_order_items {
    int supplier_order_item_id PK
    int supplier_order_id FK
    int product_id FK
    int quantity_ordered
    numeric unit_cost_at_order
  }

  departments ||--o{ employees : "has"
  employees }o--|| departments : "manages"
  departments ||--o{ products : "contains"
  suppliers ||--o{ products : "supplies"
  products ||--|| inventory : "tracked in"
  customers ||--o{ sales_orders : "places"
  employees ||--o{ sales_orders : "processes"
  sales_orders ||--|{ sales_order_items : "contains"
  products ||--o{ sales_order_items : "appears in"
  suppliers ||--o{ supplier_orders : "receives"
  employees ||--o{ supplier_orders : "raises"
  supplier_orders ||--|{ supplier_order_items : "contains"
  products ||--o{ supplier_order_items : "ordered in"
```

## Files
- `hardware_store.sql` — full schema + dummy data
- `sales_kpis.sql` — sales analytics queries
- `inventory_kpis.sql` — inventory analytics queries
- 
# 📊 KPI Coverage

The dataset is intentionally designed to support a wide range of business KPIs.

## 🛒 **Sales KPIs**

- **Total revenue**
    
- **Revenue by department**
    
- **Revenue by product**
    
- **Revenue by customer type** (Homeowner, Contractor, Business)
    
- **Average order value (AOV)**
    
- **Top 10 products by sales**
    
- **Seasonal sales trends** (Spring lumber spikes, Summer paint, Winter heating, etc.)
    
- **Employee sales performance**
    

## 📦 **Inventory KPIs**

- **Stockout rate**
    
- **Overstock rate**
    
- **Inventory turnover**
    
- **Days of inventory on hand (DOH)**
    
- **Reorder point breaches**
    
- **Supplier lead time accuracy**
    

## 🧮 **Profitability KPIs**

- **Gross margin by product**
    
- **Gross margin by department**
    
- **Loss leaders**
    
- **High‑margin vs low‑margin product mix**
    

## 🛠️ **Supplier KPIs**

- **On‑time delivery rate**
    
- **Cost variance over time**
    
- **Supplier dependency**
    
    - % of SKUs sourced from each supplier
        

## 🧑‍🤝‍🧑 **Customer KPIs**

- **Customer lifetime value (CLV)**
    
- **Repeat purchase rate**
    
- **Contractor vs homeowner revenue mix**
    
- **Basket composition**
    
    - Frequent item combinations (market basket analysis)
        

# 🔍 Special Analytical Features

The dummy data includes realistic business behaviors to make analysis meaningful:

✔ **Seasonal demand patterns**
    
✔ **Price changes over time**
    
✔ **Discontinued products still appearing in historical orders**
    
✔ **Special‑order items with long supplier lead times**
    
✔ **Contractors receiving bulk discounts**
    
✔ **Inventory shortages triggering supplier orders**
    
✔ **Employee performance variance**
    
✔ **High‑sales / low‑margin items**
    
✔ **Low‑sales / high‑margin items**
    

These features allow analysts to explore real‑world scenarios such as forecasting, anomaly detection, and profitability optimization.

# 🧱 Schema Summary

The database includes the following core tables:

- **departments**
    
- **employees**
    
- **suppliers**
    
- **products**
    
- **inventory**
    
- **customers**
    
- **sales_orders**
    
- **sales_order_items**
    
- **supplier_orders**
    
- **supplier_order_items**
    

Each table includes primary keys, foreign keys, and realistic data types.
