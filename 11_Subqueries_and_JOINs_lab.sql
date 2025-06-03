-- 01 Managers
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.department_id,
    d.name AS deparment_name
FROM
    employees e
        INNER JOIN
    departments d ON e.employee_id = d.manager_id
ORDER BY e.employee_id
LIMIT 5;

-- 02 Town and Addresses
SELECT 
    t.town_id, t.name AS town_name, a.address_text
FROM
    towns t
        INNER JOIN
    addresses a ON t.town_id = a.town_id
WHERE
    t.name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY t.town_id , a.address_id;

-- 03 Employees Without Managers
SELECT 
    employee_id, first_name, last_name, department_id, salary
FROM
    employees
WHERE
    manager_id IS NULL;

-- 04 Higher Salary
SELECT 
    COUNT(*)
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(s.salary)
        FROM
            employees s);

