-- Active: 1745290413437@@127.0.0.1@3306@car_sales
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

-- Converting mileage to integers
ALTER TABLE car_listings
MODIFY mileage INT;

-- Fixing models, the model are not correct for the brand name
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
select * from valid_make_model

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


SELECT DISTINCT model from car_listings;

SELECT * from customer_inquiries;
SELECT * from car_listings;
SELECT * from dealers;

