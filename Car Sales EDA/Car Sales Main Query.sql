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

-- Investigating the Data
SELECT make FROM car_listings;

-- Mapping Table 
-- Creating a reference table of known incorrect and correct values, then join and update in bulk.

CREATE TABLE make_corrections (
  incorrect_make VARCHAR(50),
  correct_make VARCHAR(50)
);

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

-- Checking listings
SELECT DISTINCT make FROM car_listings;
SELECT DISTINCT model FROM car_listings;

