-- 01 Find All Information About Departments
SELECT 
    *
FROM
    departments
ORDER BY department_id;

-- 02 Find all Department Names
SELECT 
    name
FROM
    departments
ORDER BY department_id;

-- 03 Find Salary of Each Employee
SELECT 
    first_name, last_name, salary
FROM
    employees
ORDER BY employee_id;

-- 04 Find Full Name of Each Employee
SELECT 
    first_name, middle_name, last_name
FROM
    employees
ORDER BY employee_id;

-- 05 Find Email Address of Each Employee
SELECT 
    CONCAT(first_name,
            '.',
            last_name,
            '@softuni.bg') AS full_email_address
FROM
    employees;
    
-- 06 Find All Different Employee’s Salaries
SELECT DISTINCT
    salary
FROM
    employees
ORDER BY salary;

-- 07 Find all Information About Employees
SELECT 
    *
FROM
    employees
WHERE
    job_title = 'Sales Representative'
ORDER BY employee_id;

-- 08 Find Names of All Employees by Salary in Range
SELECT 
    first_name, last_name, job_title
FROM
    employees
WHERE
    salary >= 20000 && salary <= 30000
ORDER BY employee_id;

-- 09 Find Names of All Employees
SELECT 
    CONCAT(first_name,
            ' ',
            middle_name,
            ' ',
            last_name) AS `Full Name`
FROM
    employees
WHERE
    salary = 25000 || salary = 14000
        || salary = 12500
        || salary = 23600;
        
-- 10 Find All Employees Without Manager
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    manager_id IS NULL;
    
-- 11 Find All Employees with Salary More Than
SELECT 
    first_name, last_name, salary
FROM
    employees
WHERE
    salary > 50000
ORDER BY salary DESC;

-- 12 Find 5 Best Paid Employees
SELECT 
    first_name, last_name
FROM
    employees
ORDER BY salary DESC
LIMIT 5;

-- 13 Find All Employees Except Marketing
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    department_id != 4;
    
-- 14 Sort Employees Table
SELECT 
    *
FROM
    employees
ORDER BY salary DESC , first_name , last_name DESC , middle_name;

-- 15 Create View Employees with Salaries
CREATE VIEW v_employees_salaries AS
    SELECT 
        first_name, last_name, salary
    FROM
        employees;

-- 16 Create View Employees with Job Titles
CREATE VIEW v_employees_job_titles AS
    SELECT 
        CONCAT(first_name,
                COALESCE(CONCAT(' ', middle_name), ''),
                ' ',
                last_name) AS `full_name`,
        job_title
    FROM
        employees;
        
-- 17 Distinct Job Titles
SELECT DISTINCT
    job_title
FROM
    employees
ORDER BY job_title;

-- 18 Find First 10 Started Projects
SELECT DISTINCT
    *
FROM
    projects
ORDER BY start_date , name , project_id
LIMIT 10;

-- 19 Last 7 Hired Employees
SELECT DISTINCT
    first_name, last_name, hire_date
FROM
    employees
ORDER BY hire_date DESC
LIMIT 7;

-- 20 Increase Salaries
UPDATE employees 
SET 
    salary = salary * 1.12
WHERE
    department_id = 1 || department_id = 2
        || department_id = 4
        || department_id = 11;

SELECT 
    salary
FROM
    employees;
    
-- 21 All Mountain Peaks
SELECT 
    peak_name
FROM
    peaks
ORDER BY peak_name;

-- 22 Biggest Countries by Population
SELECT 
    country_name, population
FROM
    countries
WHERE
    continent_code = 'EU'
ORDER BY population DESC , country_name ASC
LIMIT 30;

-- 23 Countries and Currency (Euro / Not Euro)
SELECT 
    country_name,
    country_code,
    CASE
        WHEN currency_code = 'EUR' THEN 'Euro'
        ELSE 'Not Euro'
    END AS currency
FROM
    countries
ORDER BY country_name;

-- 24 All Diablo Characters
SELECT 
    name
FROM
    characters
ORDER BY name;

