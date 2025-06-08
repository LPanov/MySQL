-- 01 Count Employees by Town
DELIMITER $$

CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
NOT DETERMINISTIC 
READS SQL DATA
BEGIN
  DECLARE result INT;
  SET result :=
  (
         SELECT count(e.employee_id)
         FROM   towns t
         JOIN   addresses a
         ON     a.town_id = t.town_id
         JOIN   employees e
         ON     e.address_id = a.address_id
         WHERE  t.name = town_name );
  RETURN result;
  END$$

DELIMITER ;

-- 02 Employees Promotion
DELIMITER $

CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50)) 
BEGIN
	UPDATE employees
    SET salary = salary * 1.05
    WHERE department_id = (
		SELECT 
			department_id
		FROM
			departments
		WHERE
			name = department_name
    );
END$$

DELIMITER ;

-- 03 Employees Promotion By ID
DELIMITER $$

CREATE PROCEDURE usp_raise_salary_by_id(e_id INT)
BEGIN
    DECLARE e_count INT;
    
    SET e_count := (SELECT COUNT(*) FROM employees WHERE employee_id = e_id);
    
    START TRANSACTION;
	UPDATE employees
    SET salary = salary * 1.05
    WHERE employee_id = e_id;
    
    IF (e_count = 0) THEN
		ROLLBACK;
	ELSE 
		COMMIT;
	END IF;
        
END$$

DELIMITER ;

-- 04 Triggered

CREATE TABLE `deleted_employees` (
    `employee_id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `middle_name` VARCHAR(50) DEFAULT NULL,
    `job_title` VARCHAR(50) NOT NULL,
    `department_id` INT NOT NULL,
    `salary` DECIMAL(19 , 4 ) NOT NULL
);

DELIMITER $$
-- Delete DELIMITER $$ when paste in judge

CREATE TRIGGER trg_copy_deleted_employee
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees (first_name, last_name, middle_name,
		job_title, department_id, salary)
    VALUES (OLD.first_name, OLD.last_name, OLD.middle_name,
			OLD.job_title, OLD.department_id, OLD.salary);
END $$

DELIMITER ;
