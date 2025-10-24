# 🧹 MySQL Data Cleaning & EDA Project – Used Car Listings

## 📘 Overview
This project demonstrates how to perform **data cleaning and exploratory data analysis (EDA)** using **MySQL**.  
The dataset simulates a **used car marketplace**, complete with messy, inconsistent, and missing data.

---

## 🗂️ Dataset Description

### 1. `car_listings.csv`
Contains car listing information with intentional inconsistencies:
- Duplicates and misspelled car makes (`"Toyta"`, `"Hondaa"`)
- Mixed date formats
- Prices stored as strings (e.g., `"$15,000"`, `"unknown"`)
- Inconsistent seller types (`"Dealer"`, `"dealer"`, `"Private"`, `"private"`)

### 2. `customer_inquiries.csv`
Represents customer inquiries for listed vehicles:
- Invalid email formats
- Inconsistent phone number formats
- Some inquiries reference non-existent listings

### 3. `dealers.csv`
Information about registered dealers:
- Ratings stored as text (`"85%"`, `"4.2/5"`)
- Inconsistent `active` flags (`"Yes"`, `"No"`, `"Y"`, `"N"`)
- Dealer names with trailing spaces or duplicate entries

---

## 🧠 Objectives
- Clean and normalize messy data directly in MySQL  
- Practice data type conversions, deduplication, and validation  
- Join multiple tables to uncover business insights  
- Conduct exploratory queries (e.g., price trends, inquiries per dealer, outlier detection)

---

## 🧰 Tools Used
- **MySQL Workbench / VSCode / DBeaver**
- **SQL (DDL + DML)**