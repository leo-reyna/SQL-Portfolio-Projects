


-- Work in progress - Oct 2025

-- Creating Database
CREATE DATABASE car_sales

USE car_sales;

-- Creating Customer Inquiries tables
CREATE TABLE customer_inquiries (
  inquiry_id INT PRIMARY KEY,
  listing_id INT,
  customer_name VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(50),
  message TEXT,
  inquiry_date DATE
);
-- Creating Dealers Table
CREATE TABLE dealers (
  dealer_id INT PRIMARY KEY,
  dealer_name VARCHAR(100),
  city VARCHAR(100),
  rating VARCHAR(20),
  phone VARCHAR(50),
  active VARCHAR(5)
);

CREATE TABLE car_listings (
  listing_id INT PRIMARY KEY,
  make VARCHAR(50),
  model VARCHAR(50),
  year INT,
  price VARCHAR(20),
  mileage VARCHAR(50),
  seller_type VARCHAR(20),
  city VARCHAR(100),
  posted_date DATE,
  fuel_type VARCHAR(50)
);


-- CLEANING DATA
-- Checking the Car Listings tables
-- Investigating the Data / Checking car listings
SELECT make FROM car_listings;

SELECT DISTINCT make FROM car_listings;
SELECT DISTINCT model FROM car_listings;


-- Mapping Table 
-- Creating a reference table of known incorrect and correct values, then join and update in bulk.
-- PHASE 1: Fix Inconsistent Values (Car Makes, Models, Dates) -- Using car_listings table
-- Fixing Car Makes & Models. Inconsistent casing, typos, or extra spaces can break grouping and aggregations.

CREATE TABLE make_corrections (
  incorrect_make VARCHAR(50),
  correct_make VARCHAR(50)
);
-- Correcting Brand Names Process
INSERT INTO make_corrections VALUES
  ('Nssn', 'Nissan'),
  ('Nissn', 'Nissan'),
  ('Toyta', 'Toyota'),
  ('Hondaa', 'Honda'),
  ('Forrd', 'Ford'),
  ('Chevy', 'Chevrolet');

-- Update using a join
UPDATE car_listings AS cl  
JOIN make_corrections as mc
  ON cl.make = mc.incorrect_make
SET cl.make = mc.correct_make

-- Fixing seller_type
UPDATE car_listings
SET seller_type = 'Dealer'
WHERE seller_type = 'dealer';

UPDATE car_listings
SET seller_type = 'Private'
WHERE seller_type = 'private';

UPDATE car_listings
SET city = 'Philadelphia'
WHERE city = 'Philly';

-- Fixing unknowns and n/a's in milaee column
UPDATE car_listings
SET mileage = NULL
WHERE mileage IN ('null', 'N/A');

UPDATE car_listings
SET price = NULL
WHERE price = 'unknown';

-- Fixing mileage
UPDATE car_listings
SET mileage = TRIM(REPLACE(mileage, 'mi', ''))
WHERE mileage LIKE '%mi%';

-- Dealing with missing/empty values
UPDATE car_listings
SET mileage = NULL
WHERE TRIM(mileage) = '';

UPDATE car_listings
SET mileage = NULL
WHERE mileage = 'unknown';

-- Fuel types fixed
UPDATE car_listings
SET fuel_type = 'Gasoline'
WHERE fuel_type = '';

UPDATE car_listings
SET price = '$18,500'
WHERE listing_id = 60

-- Converting mileage to integers
ALTER TABLE car_listings
MODIFY mileage INT;

-- Fixing models: the model names are not correct for the brand name
CREATE TABLE valid_make_model(
  make VARCHAR(50),
  model VARCHAR(50),
  PRIMARY KEY (make, model)
);
-- Inserting correct  values
INSERT INTO valid_make_model VALUES
  ('Honda', 'Civic'), ('Honda', 'Accord'), ('Honda', 'Elantra'), ('Honda', 'CR-V'),
  ('Toyota', 'Camry'), ('Toyota', 'Corolla'), ('Toyota', 'RAV4'), ('Toyota', 'Highlander'),
  ('Nissan', 'Altima'), ('Nissan', 'Sentra'), ('Nissan', 'Rogue'), ('Nissan', 'Pathfinder'),
  ('Chevrolet', 'Malibu'), ('Chevrolet', 'Cruze'), ('Chevrolet', 'Silverado'),
  ('Ford', 'F-150'), ('Ford', 'Fusion'), ('Ford', 'Escape'), ('Ford', 'Explorer'),
  ('Hyundai', 'Elantra'), ('Hyundai', 'Sonata'), ('Hyundai', 'Tucson'), ('Hyundai', 'Santa Fe'),
  ('Tesla', 'Model 3'), ('Tesla', 'Model S'), ('Tesla', 'Model X'), ('Tesla', 'Model Y'),
  ('Kia', 'Sorento'), ('Kia', 'Sportage'), ('Kia', 'Optima'), ('Kia', 'Elantra'),
  ('BMW', '3 Series'), ('BMW', '5 Series'), ('BMW', 'X5'),
  ('Mercedes', 'C-Class'), ('Mercedes', 'E-Class'), ('Mercedes', 'GLC');

-- Extracting the valid rows
SELECT * FROM valid_make_model

-- Filter out invalid rows
SELECT  
        cl.make,
        cl.model,
        vm.make as correct_make,
        vm.model as correct_model
FROM    car_listings as cl
JOIN    valid_make_model as vm
ON cl.make = vm.make

SELECT  
        cl.make,
        cl.model
FROM    car_listings as cl
LEFT JOIN    valid_make_model as vm 
ON      cl.make = vm.make AND
        cl.model = vm.model
WHERE vm.make is NULL;

-- fixing the models 
UPDATE car_listings AS cl
JOIN valid_make_model AS vm
  ON cl.make = vm.make AND cl.model != vm.model
SET cl.model = vm.model;

-- Cleaning Mixed date formatsin car_listing
ALTER TABLE car_listings
ADD clean_date DATE;

SELECT posted_date
FROM car_listings
WHERE posted_date IS NOT NULL
  AND STR_TO_DATE(REPLACE(REPLACE(TRIM(posted_date), ' ', ''), '–', '-'), '%m-%d-%Y') IS NULL
  AND STR_TO_DATE(REPLACE(REPLACE(TRIM(posted_date), ' ', ''), '–', '-'), '%d/%m/%Y') IS NULL;
  
UPDATE car_listings
SET clean_date = CASE
  -- Already in ISO format: YYYY-MM-DD
  WHEN posted_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN
    STR_TO_DATE(posted_date, '%Y-%m-%d')
  -- DD/MM/YYYY format
  WHEN posted_date LIKE '%/%/%' THEN
    STR_TO_DATE(REPLACE(REPLACE(TRIM(posted_date), ' ', ''), '--', '-'), '%d/%m/%Y')
  -- MM-DD-YYYY format
  WHEN posted_date LIKE '%-%-%' THEN
    STR_TO_DATE(REPLACE(REPLACE(TRIM(posted_date), ' ', ''), '--', '-'), '%m-%d-%Y')
  ELSE NULL
END;

-- Removing the posted_date for the clean_date
ALTER TABLE car_listings 
DROP COLUMN posted_date;
ALTER TABLE car_listings 
CHANGE clean_date posted_date DATE;

-- Fixing the price column: Adding a new numerical column to fix it
ALTER TABLE car_listings
ADD clean_price DECIMAL (10,2); 

SELECT 
        DATE_FORMAT(posted_date, '%Y-%m') AS month,
        make,
        COUNT(*) AS listings,
        SUM(price) AS total_price
FROM    car_listings
GROUP BY month, make
ORDER BY month, make;

-- Removing dollar signs from the price column
UPDATE car_listings
SET price = REPLACE(REPLACE(price, '$', ''), ',', '')
WHERE price IS NOT NULL;

-- Changing the format
ALTER TABLE car_listings
MODIFY COLUMN price DECIMAL(10,2);

-- To check if any rows still contain non-numeric characters
SELECT price
FROM car_listings
WHERE price REGEXP '[^0-9.]';

-- Counting listings per make in car_listings table
SELECT  make,  
        COUNT(*) AS listings 
FROM car_listings
GROUP BY make
ORDER BY listings DESC;


SELECT * from customer_inquiries;
SELECT * from car_listings;
SELECT * from dealers;


-- Checking a sample
SELECT COUNT(make), model, price
from car_listings
WHERE price >= 50000 AND make ="Toyota"
GROUP BY make, model, price;

-- Binning by 10,000 price
WITH CTE1 AS(SELECT 
listing_id, price, make, FLOOR(price / 10000) * 10000 AS price_bin
FROM car_listings)
select make, price_bin, count(*) as make_count
from CTE1
GROUP by price_bin, make
order by price_bin DESC, make;