-- 01 Create Table
CREATE TABLE employees (
  id INT PRIMARY KEY  NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL);
  CREATE TABLE categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL);
  CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  category_id INT NOT NULL);

-- 02 Insert Data in tables
INSERT INTO employees (id, first_name, last_name)
VALUES (1, 'Test1', 'Test1');
INSERT INTO employees (id, first_name, last_name)
VALUES (2, 'Test2', 'Test2');
INSERT INTO employees (id, first_name, last_name)
VALUES (3, 'Test3', 'Test3');

-- 03 Alter tables
ALTER TABLE employees
ADD middle_name VARCHAR(50);

-- 04 Adding constraints
ALTER TABLE products
ADD FOREIGN KEY (category_id) REFERENCES categories(id);

-- 05 Modifying columns
ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100);