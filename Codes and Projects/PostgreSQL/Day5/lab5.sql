-- Create Departments Table
CREATE TABLE Department (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(50)
);

INSERT INTO Department (dept_id, dept_name, location) VALUES
(1, 'IT', 'New York'),
(2, 'HR', 'London'),
(3, 'Finance', 'Tokyo'),
(4, 'Marketing', 'Paris'),
(5, 'Operations', 'Dubai');

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

Select * From Department;
Select * From Employee;
Select * From Project;
Select * From Works_On;

--Lab 5--
--Q1
SELECT distinct on (d.dept_id) e.hire_date, d.dept_name, e.emp_name
FROM department d
JOIN employee e ON d.dept_id = e.dept_id
order by d.dept_id, e.hire_date Desc ;

--Q2
select emp_name, dept_name from employee natural join department

--Q3
SELECT p.project_name, p.budget, COUNT(w.emp_id) AS employee_count FROM Project p
LEFT JOIN Works_On w ON p.project_id = w.project_id
GROUP BY p.project_id, p.project_name, p.budget
ORDER BY employee_count DESC;

--Q4
SELECT e1.emp_name AS employee_1, e2.emp_name AS employee_2, e1.salary
FROM Employee e1
JOIN Employee e2 ON e1.salary = e2.salary
WHERE e1.emp_id < e2.emp_id;

--Q5
SELECT p.project_name, e.emp_name FROM Project p
JOIN Works_On w ON p.project_id = w.project_id
JOIN Employee e ON w.emp_id = e.emp_id
ORDER BY p.project_name;

--Q6
SELECT e.emp_name, d.dept_name
FROM Employee e
FULL JOIN Department d 
ON e.dept_id = d.dept_id;


--Homework
--Q1
SELECT DISTINCT ON (d.dept_id) d.dept_name,e.emp_name
FROM Department d
JOIN Employee e ON d.dept_id = e.dept_id
ORDER BY d.dept_id;

--Q2
SELECT d.dept_name, sub.avg_salary
FROM Department d
JOIN ( SELECT dept_id, AVG(salary) AS avg_salary 
FROM Employee 
GROUP BY dept_id
) sub 
ON d.dept_id = sub.dept_id;

--Q3
SELECT e1.emp_name AS employee_1, e2.emp_name AS employee_2, e1.hire_date
FROM Employee e1
JOIN Employee e2 ON e1.hire_date = e2.hire_date
WHERE e1.emp_id < e2.emp_id;

--Q4
SELECT emp_name, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee)
ORDER BY salary DESC;
