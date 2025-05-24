-- Exploratory Data Analysis (EDA) on World Layoffs Dataset
USE World_Layoffs

SELECT *
FROM layoffs_staging2;

SELECT max(total_laid_off) as max_laid_off, max(percentage_laid_off) as max_percentage_laid_off
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 -- companies that laid off 100% of their employees
ORDER BY total_laid_off DESC;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 -- companies that laid off 100% of their employees
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 AND industry ='Food' 
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off) as total_laid_off 
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

SELECT  MIN(date) as min_date, 
        MAX(date) as max_date
FROM layoffs_staging2;


SELECT industry, SUM(total_laid_off) as total_laid_off -- total number of layoffs by industry
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

