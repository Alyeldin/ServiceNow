
-- Create Departments Table
CREATE TABLE Department (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(50)
);

INSERT INTO Department (dept_id, dept_name, location) VALUES
(7, 'Sales', 'Cairo'),
(1, 'IT', 'New York'),
(2, 'HR', 'London'),
(3, 'Finance', 'Tokyo'),
(4, 'Marketing', 'Paris'),
(5, 'Operations', 'Dubai'),
(6, 'Administration', 'Dubai');

-- Create Employees Table
CREATE TABLE Employee (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    hire_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

INSERT INTO Employee (emp_id, emp_name, salary, hire_date, dept_id) VALUES
(110, 'Hady Hany', 9500, '2022-01-15', 7),
(101, 'Alice Johnson', 7500, '2022-01-15', 1),
(102, 'Bob Smith', 5000, '2021-03-20', 2),
(103, 'Charlie Brown', 9000, '2020-07-10', 1),
(104, 'David Lee', 3500, '2023-05-01', 3),
(105, 'Eva Green', 12000, '2019-11-25', 4),
(106, 'Frank White', 4000, '2022-08-12', NULL),
(107, 'Grace Kim', 6000, '2021-12-30', 5);

INSERT INTO Employee (emp_id, emp_name, salary, hire_date, dept_id) VALUES
(108, 'Ahmed Maged', 7500, '2022-01-15', NULL);

-- Create Projects Table
CREATE TABLE Project (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(12, 2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

INSERT INTO Project (project_id, project_name, budget, dept_id) VALUES
(201, 'Project Alpha', 50000, 1),
(202, 'Project Beta', 75000, 2),
(203, 'Project Gamma', 100000, 1),
(204, 'Project Delta', 25000, 3),
(205, 'Project Epsilon', 80000, 4);




-- Create Works_on Table
CREATE TABLE Works_On (
    emp_id INT,
    project_id INT,
    hours NUMERIC(6, 2) CHECK (hours >= 0),
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE
);

INSERT INTO Works_On (emp_id, project_id, hours) VALUES
(101, 201, 120),
(101, 202, 80),
(102, 203, 150),
(103, 201, 100),
(104, 204, 90),
(105, 205, 200),
(107, 202, 50);



------Doctor material 

CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    task_name VARCHAR(100),
    status VARCHAR(20),
    priority VARCHAR(20),
    due_date DATE,
    emp_id INT
);

INSERT INTO tasks (task_name, status, priority, due_date, emp_id)
VALUES  ('Lab 6', 'solving', 'High', '2026-03-16', 110),
('Lab 6', 'Pending', 'High', '2026-03-16', 108),
('Prepare report', 'Completed', 'High', '2026-03-20', 101),
('Fix system bug', 'In Progress', 'High', '2026-03-18', 102),
('Update database', 'Pending', 'Medium', '2026-03-25', 103),
('Design new feature', 'In Progress', 'High', '2026-03-22', 101),
('Test application', 'Completed', 'Low', '2026-03-19', 104),
('Write documentation', 'Pending', 'Medium', '2026-03-28', 102),
('Client meeting preparation', 'In Progress', 'High', '2026-03-17', 105),
('Code review', 'Completed', 'Medium', '2026-03-21', 103),
('Deploy update', 'Pending', 'High', '2026-03-26', 101),
('Security audit', 'Pending', 'High', '2026-03-30', 104);

Select * From Department;
Select * From tasks;
Select * From Employee;
Select * From Project;
Select * From Works_On;



---Lab 7 ---

--Q1
SELECT distinct on(t.task_name) t.task_name, t.due_date,e.emp_name,
ROW_NUMBER() OVER (ORDER BY due_date ) AS due
FROM tasks t
join employee e ON t.emp_id= e.emp_id ;

--Q2
SELECT emp_name, salary,
RANK( ) OVER (ORDER BY salary DESC) AS rank
FROM employee;

--Q3
SELECT task_name, emp_name , status
FROM (SELECT t.task_name, e.emp_name, t.status,
RANK() OVER (PARTITION BY t.task_name ORDER BY t.due_date ) as due_date 
FROM employee e
JOIN tasks t ON e.emp_id = t.emp_id) AS ranked_table
WHERE due_date = 1;

--Q4
SELECT e.emp_name, d.dept_name, e.salary,
AVG(e.salary) OVER (PARTITION BY d.dept_name  ORDER BY e.salary) AS Average_total
FROM employee e
JOIN department d ON e.dept_id= d.dept_id

--Q5
SELECT t.task_name, e.emp_name,t.due_date, COUNT(t.task_id) OVER (PARTITION by t.emp_id ORDER BY t.due_date) AS running_count
FROM tasks t
JOIN employee e ON e.emp_id = t.emp_id


--Q6
SELECT emp_name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employee;

--Q7 
SELECT emp_name, task_count FROM (SELECT e.emp_name, COUNT(t.task_id) AS task_count,
AVG(COUNT(t.task_id)) OVER () AS avg_tasks
FROM employee e
LEFT JOIN tasks t ON e.emp_id = t.emp_id GROUP BY e.emp_name)sub
WHERE task_count > avg_tasks;


--Assignment Questions

--Q1
SELECT task_name,priority, DENSE_RANK()
OVER (ORDER BY CASE priority WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END ) AS high_rank
FROM tasks;

--Q2
SELECT emp_name, total_tasks
FROM (SELECT e.emp_name, COUNT(t.task_id) AS total_tasks, RANK() OVER  (ORDER BY COUNT(t.task_id) DESC) as task_rank
FROM Employee e
JOIN tasks t ON e.emp_id = t.emp_id
GROUP BY e.emp_id, e.emp_name) ranked_counts
WHERE task_rank = 1;

--Q3
--Alter part

ALTER TABLE employee ADD COLUMN manager_id INT;

ALTER TABLE employee ADD CONSTRAINT fk_manager FOREIGN KEY (manager_id)REFERENCES employee(emp_id);

UPDATE employee SET manager_id = 103 WHERE emp_id IN (101, 102);
UPDATE employee SET manager_id = 104 WHERE emp_id = 105;

select * from employee

WITH TaskCounts AS (SELECT  e.emp_name, COUNT(t.task_id) AS total_tasks
FROM Employee e
LEFT JOIN tasks t ON e.emp_id = t.emp_id
GROUP BY e.emp_id, e.emp_name)
SELECT emp_name, total_tasks
FROM (SELECT emp_name, total_tasks, RANK() OVER (ORDER BY total_tasks DESC) as task_rank
FROM TaskCounts) ranked_table
WHERE task_rank = 1;

