-- 01 Departments Info
SELECT 
    department_id, COUNT(*) AS `Number of employees`
FROM
    employees
GROUP BY department_id
ORDER BY department_id;

-- 02 Average Salary
SELECT 
    department_id, ROUND(AVG(salary), 2) as `Average Salary`
FROM
    employees
GROUP BY department_id
ORDER BY department_id;

-- 03 Min Salary
SELECT 
    department_id, ROUND(MIN(salary), 2) AS `Min Salary`
FROM
    employees
GROUP BY department_id
HAVING `Min Salary` > 800
ORDER BY department_id;

-- 04 Appetizers Count
SELECT 
    COUNT(*) AS `All appetizers`
FROM
    products
WHERE
    price > 8
GROUP BY category_id
HAVING category_id = 2;

-- 05 Menu Prices
SELECT 
    category_id,
    ROUND(AVG(price), 2) AS `Average Price`,
    ROUND(MIN(price), 2) AS `Cheapest Product`,
    ROUND(MAX(price), 2) AS `Most Expensive Product`
FROM
    products
GROUP BY category_id
ORDER BY category_id;
    



