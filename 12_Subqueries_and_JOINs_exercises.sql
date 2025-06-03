-- 01 Employee Address
SELECT 
    e.employee_id, e.job_title, a.address_id, a.address_text
FROM
    employees e
        JOIN
    addresses a ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;

-- 02 Addresses with Towns
SELECT 
    e.first_name, e.last_name, t.name AS town, a.address_text
FROM
    employees e
        JOIN
    addresses a ON e.address_id = a.address_id
        JOIN
    towns t ON a.town_id = t.town_id
ORDER BY e.first_name , e.last_name
LIMIT 5;

-- 03 Sales Employee
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.name AS department_name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- 04 Employee Department
SELECT 
    e.employee_id,
    e.first_name,
    e.salary,
    d.name AS department_name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- 05 Employees Without Project
SELECT 
    e.employee_id, e.first_name
FROM
    employees e
        LEFT JOIN
    employees_projects ep ON e.employee_id = ep.employee_id
WHERE
    ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

-- 06 Employees Hired After
SELECT 
    e.first_name, e.last_name, e.hire_date, d.name AS dept_name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.hire_date > '1999-01-01'
        && (d.name IN ('Finance' , 'Sales'))
ORDER BY e.hire_date;

-- 07 Employees with Project
SELECT 
    e.employee_id, e.first_name, p.name AS project_name
FROM
    employees e
        LEFT JOIN
    employees_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    ep.project_id IS NOT NULL
        && date(p.start_date) > '2002-08-13'
        && p.end_date IS NULL
ORDER BY e.first_name , p.name
LIMIT 5;

-- 08 Employee 24
SELECT 
    e.employee_id,
    e.first_name,
    CASE
        WHEN YEAR(p.start_date) >= 2005 THEN NULL
        ELSE p.name
    END AS project_name
FROM
    employees e
        JOIN
    employees_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    e.employee_id = 24
ORDER BY project_name
LIMIT 5;

-- 09 Employee Manager
SELECT 
    e.employee_id,
    e.first_name,
    e.manager_id,
    (SELECT 
            first_name
        FROM
            employees
        WHERE
            employee_id = e.manager_id) AS manager_name
FROM
    employees e
WHERE
    e.manager_id = 3 || e.manager_id = 7
ORDER BY e.first_name;

-- 10 Employee Summary
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    (SELECT 
            CONCAT(first_name, ' ', last_name) AS manager_name
        FROM
            employees
        WHERE
            employee_id = e.manager_id) AS manager_name,
    d.name AS department_name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.manager_id IS NOT NULL
ORDER BY e.employee_id
LIMIT 5;

-- 11 Min Average Salary
SELECT 
    AVG(salary) AS avg_salary
FROM
    employees
GROUP BY department_id
ORDER BY avg_salary
LIMIT 1;

-- 12 Highest Peaks in Bulgaria 
SELECT 
    c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM
    countries c
        JOIN
    mountains_countries mc ON c.country_code = mc.country_code
        JOIN
    mountains m ON mc.mountain_id = m.id
        JOIN
    peaks p ON m.id = p.mountain_id
WHERE
    p.elevation > 2835
        && c.country_code = 'BG'
ORDER BY p.elevation DESC;

-- 13 Count Mountain Range
SELECT 
    c.country_code, COUNT(m.mountain_range) AS mountain_range
FROM
    countries c
        JOIN
    mountains_countries mc ON c.country_code = mc.country_code
        JOIN
    mountains m ON mc.mountain_id = m.id
WHERE
    c.country_code IN ('BG' , 'US', 'RU')
GROUP BY c.country_code
ORDER BY mountain_range DESC;

-- 14 Countries with Rivers
SELECT 
    c.country_name, r.river_name
FROM
    countries c
        LEFT JOIN
    countries_rivers cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers r ON cr.river_id = r.id
WHERE
    c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- 15 Continents and Currencies
SELECT 
    c.continent_code,
    c.currency_code,
    COUNT(*) AS currency_usage
FROM
    countries c
GROUP BY c.continent_code , c.currency_code
HAVING COUNT(*) > 1
    AND (c.continent_code , COUNT(*)) IN (SELECT 
        continent_code, MAX(currency_count)
    FROM
        (SELECT 
            continent_code, currency_code, COUNT(*) AS currency_count
        FROM
            countries
        GROUP BY continent_code , currency_code
        HAVING COUNT(*) > 1) AS SubQueryCounts
    GROUP BY continent_code)
ORDER BY c.continent_code , c.currency_code;

-- 16 Countries Without Any Mountains
SELECT 
    COUNT(*)
FROM
    countries c
        LEFT JOIN
    mountains_countries mc ON c.country_code = mc.country_code
        LEFT JOIN
    mountains m ON mc.mountain_id = m.id
WHERE
    m.id IS NULL;
    
-- 17 Highest Peak and Longest River by Country
SELECT 
    c.country_name,
    MAX(p.elevation) AS highest_peak_elevation,
    MAX(r.length) AS longest_river_length
FROM
    countries c
        LEFT JOIN
    mountains_countries mc ON c.country_code = mc.country_code
        LEFT JOIN
    mountains m ON mc.mountain_id = m.id
        LEFT JOIN
    peaks p ON m.id = p.mountain_id
        LEFT JOIN
    countries_rivers cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers r ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC , longest_river_length DESC , c.country_name
LIMIT 5;
