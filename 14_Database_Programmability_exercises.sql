-- 01 Employees with Salary Above 35000
DELIMITER $$

CREATE PROCEDURE `usp_get_employees_salary_above_35000`()
BEGIN
	SELECT 
    first_name, last_name
	FROM
		employees
	WHERE
		salary > 35000
	ORDER BY first_name , last_name;
END$$

DELIMITER ;

-- 02 Employees with Salary Above Number
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above`(target_salary DECIMAL(12, 4))
BEGIN
	SELECT 
		first_name, last_name
	FROM
		employees
	WHERE
		salary >= target_salary
	ORDER BY first_name , last_name , employee_id;
END$$
DELIMITER ;

-- 03 Town Names Starting With
DELIMITER $$
CREATE PROCEDURE `usp_get_towns_starting_with`(chars VARCHAR(20))
BEGIN
	SELECT 
		name AS town_name
	FROM
		towns
	WHERE
		name LIKE CONCAT(chars, '%')
	ORDER BY name;
END$$
DELIMITER ;

-- 04 Employees from Town
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_from_town`(town_name VARCHAR(20))
begin
	SELECT 
    first_name, last_name
	FROM
		employees e
			JOIN
		addresses a ON e.address_id = a.address_id
			JOIN
		towns t ON a.town_id = t.town_id
	WHERE
		name = town_name
	ORDER BY first_name , last_name , employee_id;
end$$
DELIMITER ;

-- 05 Salary Level Function
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level`(salary DECIMAL(12, 2)) 
RETURNS varchar(7) 
DETERMINISTIC
NO SQL
BEGIN
	DECLARE salary_level VARCHAR(7);
    if (salary < 30000) then
		set salary_level = 'Low';
	elseif (salary between 30000 and 50000) then
		set salary_level = 'Average';
	else
		set salary_level = 'High';
	END IF;
    RETURN salary_level;
END$$
DELIMITER ;

-- 06 Employees by Salary Level
-- Copy the 5th exercise along with 6th and delete DELIMITER statements when posting in Judge
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_by_salary_level`(salary_level VARCHAR(7))
BEGIN  
	SELECT 
    first_name, last_name
	FROM
		employees
	WHERE
		salary_level = (SELECT ufn_get_salary_level(salary))
	ORDER BY first_name DESC , last_name DESC;
END$$
DELIMITER ;

-- 07 Define Function
DELIMITER $$
CREATE FUNCTION `ufn_is_word_comprised`(set_of_letters varchar(50), word varchar(50)) 
RETURNS tinyint
NO SQL
BEGIN
	DECLARE output TINYINT;
    SET output = (SELECT word REGEXP CONCAT('^[', set_of_letters, ']+$'));
    RETURN output;
END$$
DELIMITER ;

-- 08 Find Full Name
CREATE PROCEDURE usp_get_holders_full_name()
	SELECT concat(first_name, ' ', last_name) AS full_name
    FROM account_holders
    ORDER BY full_name, id;

-- 09 People With Balance Higher That
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(amount DECIMAL(19,4))
SELECT 
    ah.first_name,
    ah.last_name
FROM accounts a
    JOIN account_holders ah ON a.account_holder_id = ah.id
GROUP BY account_holder_id
HAVING SUM(a.balance) > amount
ORDER BY ah.id;

-- 10 Future Value Function
CREATE FUNCTION ufn_calculate_future_value(
	inital_amount DECIMAL(19,4), 
    interest_rate DOUBLE(19,4), 
    years INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
RETURN inital_amount * (pow((1 + interest_rate), years));

-- 11 Calculating Interest
CREATE PROCEDURE usp_calculate_future_value_for_account(in account_id INT, in interest_rate DOUBLE(19,4))
	SELECT 
		a.id account_id,
		ah.first_name,
		ah.last_name,
		a.balance current_balance,
		ufn_calculate_future_value(a.balance, interest_rate, 5) balance_in_5_years
	FROM
		account_holders ah
			JOIN
		accounts a ON a.account_holder_id = ah.id
	WHERE
		a.id = account_id;
        
-- 12 Deposit Money
DELIMITER $$

CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4)) 
BEGIN
	START TRANSACTION;
    IF (select count(*) from accounts where id = account_id) != 1
    OR money_amount <= 0
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts
        SET balance = balance + money_amount
        WHERE id = account_id;
        
        COMMIT;
	END IF;
END$$
	
DELIMITER ;

-- 13 Withdraw money
DELIMITER $$

CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4)) 
BEGIN
	START TRANSACTION;
    IF (select count(*) from accounts where id = account_id) != 1
    OR (SELECT balance FROM accounts WHERE id = account_id) - money_amount < 0
    OR money_amount <= 0
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = account_id;
        
        COMMIT;
	END IF;
END$$
	
DELIMITER ;

-- 14 Money Transfer
DELIMITER $$

CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19, 4)) 
BEGIN
	START TRANSACTION;
    IF (select count(*) from accounts where id = from_account_id) != 1
    OR (select count(*) from accounts where id = to_account_id) != 1
    OR (SELECT balance FROM accounts WHERE id = from_account_id) - amount < 0
    OR from_account_id = to_account_id
    OR amount <= 0
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
        
		UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        
        COMMIT;
	END IF;
END$$

DELIMITER ;

-- 15 Log Accounts Trigger
CREATE TABLE logs(log_id INT primary key auto_increment, account_id INT, old_sum DECIMAL(12, 4), new_sum DECIMAL(12, 4)); 

DELIMITER $$
CREATE TRIGGER trg_account_changes
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
	IF OLD.balance != NEW.balance THEN
		INSERT INTO logs (account_id, old_sum, new_sum)
		VALUES(NEW.id, OLD.balance, NEW.balance);
    END IF;
END$$
DELIMITER ;

-- 16 Emails Trigger
-- When you paste into judge, copy the whole data from 15th exercise, 
-- remove the delimiters and add ; to the end after the first trigger
CREATE TABLE notification_emails(
	id INT PRIMARY KEY auto_increment, 
    recipient INT, 
    subject VARCHAR(100), 
	body VARCHAR(255));
    
DELIMITER $$
CREATE TRIGGER trg_insert_logs
AFTER INSERT ON logs
FOR EACH ROW
BEGIN
	INSERT INTO notification_emails (recipient, subject, body)
	VALUES(
		NEW.account_id, 
		CONCAT('Balance change for account: ', NEW.account_id), 
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ', ROUND(NEW.old_sum, 2), ' to ', ROUND(NEW.new_sum, 2), '.'));
END$$
DELIMITER ;

	
