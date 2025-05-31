create database table_relations;
use table_relations;

-- 01 Mountains and Peaks
CREATE TABLE mountains (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255)
);

CREATE TABLE peaks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    mountain_id INT,
    FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
);

-- 02 Trip Organization
SELECT 
    driver_id,
    vehicle_type,
    (SELECT 
            CONCAT(first_name, ' ', last_name)
        FROM
            campers
        WHERE
            campers.id = vehicles.driver_id) AS diver_name
FROM
    vehicles;
    
-- 03 SoftUni Hiking
SELECT 
    starting_point,
    end_point,
    leader_id,
    (SELECT 
            CONCAT(first_name, ' ', last_name)
        FROM
            campers
        WHERE
            campers.id = routes.leader_id) AS leader_name
FROM
    routes;
    
-- 04 Delete Mountains
DROP TABLE peaks, mountains;

CREATE TABLE mountains (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255)
);

CREATE TABLE peaks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    mountain_id INT,
    CONSTRAINT fk_peaks_mountain_id_mountains_id FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
		ON DELETE CASCADE
);

-- 05 Project Management DB
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    project_id INT
);

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    project_lead_id INT,
    FOREIGN KEY (client_id)
        REFERENCES clients (id),
    FOREIGN KEY (project_lead_id)
        REFERENCES employees (id)
);

ALTER TABLE employees
  ADD CONSTRAINT fk_employees_project_id_projects_id FOREIGN KEY (project_id)
  REFERENCES projects(id); 



