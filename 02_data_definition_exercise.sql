-- 01 Create tables
CREATE TABLE minions (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
age INT
);
CREATE TABLE towns  (
town_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
age INT
);

-- 02 Alter minions table
ALTER TABLE minions
ADD town_id INT,
ADD FOREIGN KEY minions(town_id) REFERENCES towns(id);

-- 03 Insert records in both tables
INSERT INTO towns(id, name)
VALUES (1, 'Sofia');
INSERT INTO towns(id, name)
VALUES (2, 'Plovdiv');
INSERT INTO towns(id, name)
VALUES (3, 'Varna');

INSERT INTO minions (id, name, age, town_id)
VALUES (1,	'Kevin', 22, 1);
INSERT INTO minions (id, name, age, town_id)
VALUES (2, 'Bob', 15, 3);
INSERT INTO minions (id, name, age, town_id)
VALUES (3,	'Steward', NULL, 2);

-- 04 Truncate table minions
TRUNCATE minions;

-- 05 Drop All tables
drop table minions;
drop table towns;

-- 06 Create table people
create table people (
id int primary key auto_increment,
name nvarchar(200) not null,
picture blob,
height float(10, 2),
weight float(6, 2),
gender enum('m', 'f') not null,
birthdate date not null,
biography nvarchar(4000)
);

insert into people
values 
(1, 'Test1', 'pic1.jpg', 1.71, 70.23, 'm', '1994.05.05', 'biography1'),
(2, 'Test2', 'pic2.jpg', 1.81, 80.23, 'm', '1994.06.05', 'biography2'),
(3, 'Test3', 'pic3.jpg', 1.541, 100.23, 'f', '1994.07.05', 'biography3'),
(4, 'Test4', 'pic4.jpg', 1.451, 75.23, 'f', '1994.08.05', 'biography4'),
(5, 'Test5', 'pic5.jpg', 1.76, 89.23, 'm', '1994.09.05', 'biography5');

-- 07 Create table users
create table users(
id bigint primary key auto_increment,
username varchar(30),
password varchar(26),
profile_picture MEDIUMBLOB,
last_login_time DATETIME,
is_deleted bool
);

insert into users
values
(1, 'username1', 'password1', 'pic1.jpg', '1970-01-01 00:00:00', false),
(2, 'username2', 'password2', 'pic2.jpg', '1970-01-01 00:00:01', true),
(3, 'username3', 'password3', 'pic3.jpg', '1970-01-01 00:00:02', false),
(4, 'username4', 'password4', 'pic4.jpg', '1970-01-01 00:00:03', true),
(5, 'username5', 'password5', 'pic5.jpg', '1970-01-01 00:00:04', false);

-- 08 Change primary key
alter table users
drop primary key,
ADD CONSTRAINT pk_users PRIMARY KEY (id, username);

-- 09 Set default value of a field
ALTER TABLE users
MODIFY COLUMN last_login_time datetime DEFAULT CURRENT_TIMESTAMP;

--10 Set unique field
ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY (id),
ADD CONSTRAINT UC_username UNIQUE (username);

-- 11 Create table movies
create table directors (
id int primary key auto_increment,
director_name varchar(255) not null,
notes varchar(255)
);

create table genres (
id int primary key auto_increment,
genre_name varchar(255) not null,
notes varchar(255)
);

create table categories (
id int primary key auto_increment,
category_name varchar(255) not null,
notes varchar(255)
);

create table movies (
id int primary key auto_increment,
title varchar(255) not null,
director_id int,
copyright_year date,
length int,
genre_id int,
category_id int,
rating int,
notes varchar(255),
foreign key (director_id) references directors(id),
foreign key (genre_id) references genres(id),
foreign key (category_id) references categories(id)
);

insert into directors
values 
(1, 'Director1', "Note1"),
(2, 'Director2', "Note2"),
(3, 'Director3', "Note3"),
(4, 'Director4', "Note4"),
(5, 'Director5', "Note5");

insert into genres
values 
(1, 'Genre1', "Note1"),
(2, 'Genre2', "Note2"),
(3, 'Genre3', "Note3"),
(4, 'Genre4', "Note4"),
(5, 'Genre5', "Note5");

insert into categories
values 
(1, 'Category1', "Note1"),
(2, 'Category2', "Note2"),
(3, 'Category3', "Note3"),
(4, 'Category4', "Note4"),
(5, 'Category5', "Note5");

insert into movies
values 
(1, 'Title1', 1,'02.02.2000', 100, 1, 1, 5, "Note1"),
(2, 'Title2', 2,'02.02.2000', 100, 2, 2, 5, "Note2"),
(3, 'Title3', 3,'02.02.2000', 100, 3, 3, 5, "Note3"),
(4, 'Title4', 4,'02.02.2000', 100, 4, 4, 5, "Note4"),
(5, 'Title5', 5,'02.02.2000', 100, 5, 5, 5, "Note5");

-- 12 Car rental database
-- Create the categories table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(255) NOT NULL,
    daily_rate DECIMAL(10, 2) NOT NULL,
    weekly_rate DECIMAL(10, 2) NOT NULL,
    monthly_rate DECIMAL(10, 2) NOT NULL,
    weekend_rate DECIMAL(10, 2) NOT NULL
);

-- Insert sample data into categories
INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES
    ('Economy', 30.00, 180.00, 600.00, 50.00),
    ('Compact', 40.00, 220.00, 750.00, 60.00),
    ('SUV', 55.00, 300.00, 1000.00, 80.00);

-- Create the cars table
CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL UNIQUE,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    car_year INT,
    category_id INT,
    doors INT,
    picture VARCHAR(255), 
    car_condition ENUM('Excellent', 'Good', 'Fair', 'Poor'),
    available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Insert sample data into cars
INSERT INTO cars (plate_number, make, model, car_year, category_id, doors, car_condition)
VALUES
    ('AAA123', 'Toyota', 'Corolla', 2020, 1, 4, 'Excellent'),
    ('BBB456', 'Ford', 'Focus', 2018, 2, 4, 'Good'),
    ('CCC789', 'Honda', 'CR-V', 2022, 3, 5, 'Excellent');

-- Create the employees table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(50),
    notes TEXT
);

-- Insert sample data into employees
INSERT INTO employees (first_name, last_name, title)
VALUES
    ('John', 'Doe', 'Manager'),
    ('Jane', 'Smith', 'Agent'),
    ('David', 'Lee', 'Agent');

-- Create the customers table
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    zip_code VARCHAR(10),
    notes TEXT
);

-- Insert sample data into customers
INSERT INTO customers (driver_licence_number, full_name)
VALUES
    ('DL12345', 'John Smith'),
    ('DL67890', 'Jane Doe'),
    ('DL11111', 'David Lee');

-- Create the rental_orders table
CREATE TABLE rental_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition ENUM('Excellent', 'Good', 'Fair', 'Poor'),
    tank_level DECIMAL(3, 1), 
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INT NOT NULL,
    rate_applied DECIMAL(10, 2),
    tax_rate DECIMAL(5, 2),
    order_status ENUM('Pending', 'Confirmed', 'InProgress', 'Completed', 'Cancelled'),
    notes TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (car_id) REFERENCES cars(id)
);

-- Insert sample data into rental_orders (with simplified values for demonstration)
INSERT INTO rental_orders (employee_id, customer_id, car_id, start_date, end_date, total_days, rate_applied, order_status)
VALUES
    (1, 1, 1, '2024-07-01', '2024-07-05', 5, 30.00, 'Completed'),
    (2, 2, 2, '2024-07-10', '2024-07-15', 6, 40.00, 'Completed'),
    (3, 3, 3, '2024-07-15', '2024-07-20', 6, 55.00, 'Completed');

-- 13 Basic insert
insert into towns (name)
values
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

insert into departments (name)
values
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

insert into employees(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
values 
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013.02.01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004.03.02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016.08.28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007.12.09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016.08.28', 599.88);

-- 14 Basic select all fields
select * from towns;
select * from departments;
select * from employees;

-- 15 Basic select all fields and order them
select * from towns
order by name;
select * from departments
order by name;
select * from employees
order by salary DESC;

-- 16 Basic select some fields
select name from towns
order by name;
select name from departments
order by name;
select first_name, last_name, job_title, salary from employees
order by salary DESC;

-- 17 Increase emloyees salary
UPDATE employees
SET salary = salary * 1.1;

SELECT salary
FROM employees;