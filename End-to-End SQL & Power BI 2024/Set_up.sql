
/*
  End-to-End SQL & Power BI 2024 Project - Project Dashboard for Department Operations
  MSSQL Server
    Tables used:
            completed_projects.csv
            departments.csv
            employees.csv
            Head_Shots.csv
            projects.csv
            project_assignments.csv
            upcoming projects.csv
*/

-- Exploring the datasets
SELECT *
FROM employees;

SELECT *
FROM dbo.departments;

-- Projects status

/*
  End-to-End SQL & Power BI 2024 Project - HR datasets
  MSSQL Server
    Tables used:
            completed_projects.csv
            departments.csv
            employees.csv
            Head_Shots.csv
            projects.csv
            project_assignments.csv
            upcoming projects.csv
*/

-- Exploring the datasets
-- Projects status
WITH cte_Project_Status AS
(
SELECT 
    project_id,
    project_name,
    project_budget,
    'Upcoming' as Status -- labeling to verify status
FROM [upcoming projects]
    UNION ALL
SELECT 
    project_id,
    project_name,
    project_budget,
    'Completed' as Status -- labeling to verify status
 FROM [completed_projects]
)

-- Main Table 
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.job_title,
    e.salary,
    d.Department_Name,
    d.Department_Budget,
    d.Department_Goals,
    pa.project_id,
    p.project_name,
    p.project_budget,
    p.[Status]
FROM employees AS e
JOIN departments AS d
    ON e.department_id = d.Department_ID
JOIN project_assignments pa
    ON pa.employee_id = e.employee_id
JOIN cte_Project_Status as p
    ON p.project_id = pa.project_id

/*
  Import this table to PowerBI using the SQL Server connector
*/