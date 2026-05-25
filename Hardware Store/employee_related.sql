-- PostgreSQL
--
-- Basic Information about the dataset

SELECT * FROM employees;
SELECT * FROM departments;


-- department managers
SELECT
    d.department_id,
    e.first_name || ' ' || e.last_name AS manager_name,
    d.name  AS department_name
FROM departments AS d
LEFT JOIN employees AS e
    ON d.manager_employee_id = e.employee_id
ORDER BY d.name;

-- cashiers
SELECT
    e.first_name || ' ' || e.last_name AS cashier_name,
    d.name  AS department_name
FROM departments AS d
INNER JOIN employees AS e
    ON d.department_id = e.department_id
WHERE e.role = 'Cashier'
ORDER BY e.first_name, e.last_name, d.name;