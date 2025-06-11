CREATE database restaurant_db;
use restaurant_db;

-- Section 1 Data Definition Language (DDL)
-- 01 Table Design
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    type VARCHAR(30) NOT NULL,
    price DECIMAL(10, 2 ) NOT NULL
);

CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    card VARCHAR(50),
    review TEXT
);

CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    floor INT NOT NULL,
    reserved BOOLEAN,
    capacity INT NOT NULL
);

CREATE TABLE waiters (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    salary DECIMAL(10, 2 )
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    waiter_id INT NOT NULL,
    order_time TIME NOT NULL,
    payed_status BOOLEAN,
    FOREIGN KEY (table_id)
        REFERENCES tables (id),
    FOREIGN KEY (waiter_id)
        REFERENCES waiters (id)
);

CREATE TABLE orders_clients (
    order_id INT,
    client_id INT,
    FOREIGN KEY (order_id)
        REFERENCES orders (id),
    FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE orders_products (
    order_id INT,
    product_id INT,
    FOREIGN KEY (order_id)
        REFERENCES orders (id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
);

-- Section 2 Data Manipulation Language (DML) 
-- 02 Insert
INSERT INTO products (name, type, price)
SELECT 
    CONCAT(w.last_name, ' specialty'),
    'Cocktail',
    CEIL(w.salary * 0.01)
FROM
    waiters w
WHERE
    id > 6;
 
-- 03 Update
UPDATE orders 
SET 
    table_id = table_id - 1
WHERE
    id >= 12 && id <= 23;
    
-- 04 Delete
DELETE FROM waiters 
WHERE
    id = 5 OR id = 7;
    
-- Section 3 Querying
-- 05 Clients
SELECT 
    *
FROM
    clients
ORDER BY birthdate DESC , id DESC;

-- 06 Bithdate
SELECT 
    first_name, last_name, birthdate, review
FROM
    clients
WHERE
    card IS NULL
        AND YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC , id
LIMIT 5;

-- 07 Accounts
SELECT 
    CONCAT(last_name,
            first_name,
            CHAR_LENGTH(first_name),
            'Restaurant') AS username,
    REVERSE(SUBSTRING(email, 2, 12)) AS password
FROM
    waiters
WHERE
    salary IS NOT NULL
ORDER BY password DESC;

-- 08 Top from menu
SELECT 
    p.id, p.name, COUNT(p.id) AS count
FROM
    products p
        JOIN
    orders_products op ON p.id = product_id
        JOIN
    orders o ON op.order_id = o.id
GROUP BY p.id
HAVING count >= 5
ORDER BY count DESC , p.name;

-- 09 Availability
SELECT 
    o.table_id,
    t.capacity,
    COUNT(o.table_id) count_clients,
    CASE
        WHEN t.capacity > COUNT(o.table_id) THEN 'Free seats'
        WHEN t.capacity = COUNT(o.table_id) THEN 'Full'
        ELSE 'Extra seats'
    END AS availability
FROM
    orders o
        JOIN
    tables t ON o.table_id = t.id
        JOIN
    orders_clients oc ON o.id = oc.order_id
        JOIN
    clients c ON oc.client_id = c.id
WHERE
    floor = 1
GROUP BY o.table_id
ORDER BY o.table_id DESC;

-- Section 4 Programmability 
-- 10 Extract bill

DELIMITER $$
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50))
RETURNS DECIMAL(10, 2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
	RETURN 
		(SELECT
			SUM(p.price)
		FROM
			products p
				JOIN
			orders_products op ON p.id = op.product_id
				JOIN
			orders o ON op.order_id = o.id
				JOIN
			orders_clients oc ON o.id = oc.order_id
				JOIN
			clients c ON oc.client_id = c.id
		WHERE
			c.first_name = SUBSTRING_INDEX(full_name, ' ', 1)
				AND c.last_name = SUBSTRING_INDEX(full_name, ' ', -1)
                );
END$$

DELIMITER ;

SELECT c.first_name,c.last_name, udf_client_bill('Silvio Blyth') as 'bill' FROM clients c
WHERE c.first_name = 'Silvio' AND c.last_name= 'Blyth';

-- 11 Happy hour
DELIMITER $$

CREATE PROCEDURE udp_happy_hour(procduct_type VARCHAR(50))
MODIFIES SQL DATA
BEGIN
	UPDATE products 
	SET 
		price = price - price * 0.2
	WHERE
		type = procduct_type AND price >= 10;
END$$

DELIMITER ;




  



