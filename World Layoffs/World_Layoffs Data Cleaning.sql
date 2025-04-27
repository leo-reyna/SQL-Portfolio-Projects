-- Objectives:
-- 1. Remove duplicates
-- 2. Standardize data and fix inconsistencies
-- 3. Handle blank values and NULL values
-- 4. Remmove unnecessary columns and rows
-- 5. Rename columns for clarity

USE World_Layoffs

-- Viewing the table
SELECT  * 
FROM layoffs;

-- Staging the raw data: Creating a staging table to work with the data without affecting the original table
SELECT * 
INTO layoffs_staging2
FROM layoffs;

-- Removing duplicates
WITH duplicate_cte as 
(SELECT *, 
    row_number() OVER (PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, [date], stage, country,
    funds_raised_millions ORDER BY [date] DESC) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Copying the structure of the original table to a new staging table
SELECT *
INTO layoffs_staging2
FROM layoffs_staging
WHERE 1 = 0;

-- Adding the new column 'row_num' to the staging table
ALTER TABLE layoffs_staging2
ADD row_num INT;

INSERT INTO layoffs_staging2
SELECT *, 
    row_number() OVER (PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, [date], stage, country,
    funds_raised_millions ORDER BY [date] DESC) as row_num
FROM layoffs_staging;

-- Checking for the items with row_num is greater than 1 to identify duplicates
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Removing duplicates from the staging table. Keep the first occurrence of each duplicate and remove the rest
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizing data and fixing inconsistencies
-- Deleting trailing spaces
SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2
ORDER BY TRIM(company);

-- Correcting the company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Locating Duplicates 
SELECT DISTINCT *
FROM layoffs_staging2   
WHERE Industry LIKE 'Crypto%'

-- Fixing inconsistencies
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'

SELECT DISTINCT location   
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE location LIKE '%eldorf%'

UPDATE layoffs_staging2
SET location = 'Düsseldorf'
WHERE location LIKE '%eldorf%'

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%'

UPDATE layoffs_staging2
SET country = REPLACE(country, '.', '')
WHERE country LIKE 'United States%'
-- or 

SELECT DISTINCT REPLACE(country, '.', '') AS country
FROM layoffs_staging2

SELECT company, FORMAT([date], 'MM-dd-yyyy') AS [date]
FROM layoffs_staging2

UPDATE layoffs_staging2
SET [date] = FORMAT([date], 'MM-dd-yyyy')

SELECT *
FROM layoffs_staging2

-- Fixed Date
ALTER TABLE layoffs_staging2
ALTER COLUMN [date] DATE;

-- Working with NULL values and blank values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL 

SELECT *
FROM layoffs_staging2
WHERE Industry IS NULL OR Industry = ''

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'

UPDATE layoffs_staging2
SET Industry = 'Travel'
WHERE company = 'Airbnb'

SELECT 
    t1.industry, 
    t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
    ON t1.company = t2.company and t1.[company] = t2.[company]
WHERE (t1.[industry] IS NULL or t1.[industry] = '') and t2.industry is not NULL

UPDATE t1
SET t1.[industry] = t2.[industry]
FROM layoffs_staging2 t1
INNER JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.[industry] IS NULL OR t1.[industry] = '') AND t2.industry IS NOT NULL

-- Removing unnecessary columns and rows
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off is NULL

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off is NULL

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;