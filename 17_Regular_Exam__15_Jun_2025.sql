CREATE DATABASE car_rental;
USE car_rental ;

-- Section 1 Data Definition Language (DDL)
-- 01 Table Design
CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE lessors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    company_employee_from DATE NOT NULL
);

CREATE TABLE rental_companies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    cross_border_usage BOOLEAN NOT NULL,
    price_per_day DECIMAL(10 , 2 ),
    car_id INT NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (car_id)
        REFERENCES cars (id),
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE renters (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    age INT,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE lessors_rental_companies (
    lessor_id INT,
    rental_company_id INT NOT NULL,
    FOREIGN KEY (lessor_id)
        REFERENCES lessors(id),
    FOREIGN KEY (rental_company_id)
        REFERENCES rental_companies(id)
);

CREATE TABLE lessors_renters (
    lessor_id INT NOT NULL,
    renter_id INT NOT NULL,
    FOREIGN KEY (lessor_id)
        REFERENCES lessors (id),
    FOREIGN KEY (renter_id)
        REFERENCES renters (id)
);

-- Section 2 Data Manipulation Language (DML) 
-- 02 Insert
INSERT INTO renters (first_name, last_name, age, phone_number)
	SELECT 
		REVERSE((LOWER(first_name))),
		REVERSE((LOWER(last_name))),
		age + CAST(SUBSTRING(phone_number, 1, 1) AS SIGNED),
		CONCAT('1+', phone_number)
	FROM
		renters
	WHERE
		age < 20;

-- 03 Update
UPDATE rental_companies rc
        JOIN
    cities c ON rc.city_id = c.id 
SET 
    rc.price_per_day = rc.price_per_day + 30
WHERE
    c.name = 'London'
        && rc.cross_border_usage IS TRUE;

-- 04 Delete
DELETE FROM rental_companies 
WHERE
    cross_border_usage IS FALSE; 

-- Section 3 Querying
-- 05 Youngest renters
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, age
FROM
    renters
WHERE
    first_name LIKE '%a%'
        && age = (SELECT 
            age
        FROM
            renters
        ORDER BY age
        LIMIT 1)
ORDER BY id;


-- 06 Rental companies without lessors
SELECT 
    rc.id, rc.name, c.brand
FROM
    cars c
        JOIN
    rental_companies rc ON c.id = rc.car_id
        LEFT JOIN
    lessors_rental_companies lrc ON rc.id = lrc.rental_company_id
        LEFT JOIN
    lessors l ON lrc.lessor_id = l.id
WHERE
    l.id IS NULL
ORDER BY c.brand , rc.id
LIMIT 5;

-- 07 Lessors with more than one renter
SELECT 
    l.first_name,
    l.last_name,
    COUNT(DISTINCT r.id) AS renters_count,
    MIN(c.name) AS city_name
FROM
    lessors l
        JOIN
    lessors_renters lr ON l.id = lr.lessor_id
        JOIN
    renters r ON lr.renter_id = r.id
        JOIN
    lessors_rental_companies lrc ON l.id = lrc.lessor_id
        JOIN
    rental_companies rc ON lrc.rental_company_id = rc.id
        JOIN
    cities c ON rc.city_id = c.id
GROUP BY l.id, l.first_name, l.last_name
HAVING renters_count > 1
ORDER BY renters_count DESC , l.first_name;

-- 08 Lessor's count by city
SELECT 
    c.name, COUNT(l.id) AS lessors_count
FROM
    cities c
        JOIN
    rental_companies rc ON c.id = rc.city_id
        JOIN
    lessors_rental_companies lrc ON rc.id = lrc.rental_company_id
        JOIN
    lessors l ON lrc.lessor_id = l.id
GROUP BY c.name
ORDER BY lessors_count DESC;

-- 09 Lessor's experience level
SELECT 
    CONCAT(first_name, ' ', last_name),
    CASE
        WHEN
            YEAR(company_employee_from) >= 1980
                && YEAR(company_employee_from) < 1990
        THEN
            'Specialist'
        WHEN
            YEAR(company_employee_from) >= 1990
                && YEAR(company_employee_from) < 2000
        THEN
            'Advanced'
        WHEN
            YEAR(company_employee_from) >= 2000
                && YEAR(company_employee_from) < 2008
        THEN
            'Experienced'
        WHEN
            YEAR(company_employee_from) >= 2008
                && YEAR(company_employee_from) < 2015
        THEN
            'Qualified'
        WHEN
            YEAR(company_employee_from) >= 2015
                && YEAR(company_employee_from) < 2020
        THEN
            'Provisional'
        WHEN YEAR(company_employee_from) >= 2020 THEN 'Trainee'
    END AS level
FROM
    lessors
ORDER BY YEAR(company_employee_from) , first_name;
 
-- Section 4 Programmability 
-- 10 Extract the average price of rent a car by city
CREATE FUNCTION udf_average_price_by_city (city_name VARCHAR(40))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
RETURN
	(SELECT 
		ROUND(AVG(rc.price_per_day), 2) AS average_price_per_day
	FROM
		rental_companies rc
			JOIN
		cities c ON rc.city_id = c.id
	WHERE
		c.name = city_name
	GROUP BY c.name);
    
select * from cities;

SELECT c.name, udf_average_price_by_city ('Liverpool') as average_price_per_day
FROM cities c
WHERE c.name = 'Liverpool';

-- 11 Find a rental company by the desired car brand
CREATE PROCEDURE udp_find_rental_company_by_car(brand VARCHAR(20))
READS SQL DATA
	SELECT 
		rc.name, rc.price_per_day
	FROM
		rental_companies rc
			JOIN
		cars c ON rc.car_id = c.id
	WHERE
		c.brand = brand
	ORDER BY rc.price_per_day DESC;
        
CALL udp_find_rental_company_by_car('Toyota');
