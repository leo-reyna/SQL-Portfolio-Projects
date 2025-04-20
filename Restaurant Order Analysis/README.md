# Restaurant Order Analysis

## Maven Analytics Guided Project

Analyze order data to identify the most and least popular menu items and types of cuisine. A quarter's worth of orders from a fictitious international cuisine restaurant. This project can be found at [Maven Analytics](https://app.mavenanalytics.io/guided-projects/d7167b45-6317-49c9-b2bb-42e2a9e9c0bc)

### The Dataset

| # of records | # of fields|
|--------------|------------|
| 12,266       |     8      |

Original code was for MySQL but I modified the query to be used in MSSQL Management Studio. This is an exploratory analysis of this dataset. It has 3 different objectives.

---

### Objective 1: Explore the items table

Your first objective is to better understand the items table by finding the number of rows in the table, the least and most expensive items, and the item prices within each category.

### Objectives 1 Tasks

* View the menu_items table and write a query to find the number of items on the menu
* What are the least and most expensive items on the menu?
* How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
* How many dishes are in each category? What is the average dish price within each category?

---

### Objective 2: Explore the orders table

Your second objective is to better understand the orders table by finding the date range, the number of items within each order, and the orders with the highest number of items.

### Objectives 2 Tasks

* View the order_details table. What is the date range of the table?
* How many orders were made within this date range? How many items were ordered within this date range?
* Which orders had the most number of items?
* How many orders had more than 12 items?

---

### Objective 3: Analyze customer behavior

Your final objective is to combine the items and orders tables, find the least and most ordered categories, and dive into the details of the highest spend orders.

### Objectives 3 Tasks

* Combine the menu_items and order_details tables into a single table
* What were the least and most ordered items? What categories were they in?
* What were the top 5 orders that spent the most money?
* View the details of the highest spend order. Which specific items were purchased?
* BONUS: View the details of the top 5 highest spend orders
