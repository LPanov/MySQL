
-- 01. Select Employee Information
select id, first_name, last_name, job_title from employees
order by id;

-- 02. Select Employees with Filter
select id, concat(first_name, ' ', last_name) as full_name, job_title, salary 
from employees
where salary > 1000.00
order by id;

-- 03. Update Salary and Select
UPDATE employees
SET salary = salary + 100
where job_title = 'Manager';

SELECT salary
FROM employees;

-- 04. Top Paid Employee
SELECT *
FROM employees
order by salary desc
limit 1;

-- 05. Select Employees by Multiple Filters
SELECT *
FROM employees
where department_id = 4 && salary >= 1000
order by id;

-- 06. Delete from Table
delete from employees
where department_id = 1 || department_id = 2;

select * from employees
order by id;