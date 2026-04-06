


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


--Assignment Q1
SELECT emp_name 
FROM Employee 
WHERE dept_id = (SELECT dept_id FROM Department WHERE dept_name = 'IT');

--Assignment Q2
SELECT emp_name, salary
FROM Employee
WHERE salary BETWEEN 4000 AND 9000;

--Assignment Q3
SELECT emp_name 
FROM Employee
WHERE emp_name SIMILAR TO 'A%';

--Assignment Q4
SELECT emp_id, emp_name, salary
FROM Employee
WHERE dept_id IS NULL;

--Assignment Q5
SELECT emp_id, emp_name, dept_id
FROM Employee
WHERE dept_id IN (1, 2, 3);


--Assignment Q6
SELECT 
    emp_name, 
    salary,
    CASE 
        WHEN salary > 8000 THEN 'High'
        WHEN salary BETWEEN 4000 AND 8000 THEN 'Medium'
        WHEN salary < 4000 THEN 'Low'
        ELSE 'Uncategorized'
    END AS salary_level
FROM Employee;


--Assignment Q7
SELECT emp_id, emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1 
    FROM Works_On w 
    WHERE w.emp_id = e.emp_id
);

--Assignment Q8
SELECT emp_name, salary
FROM Employee
WHERE salary > ANY (
    SELECT salary 
    FROM Employee 
    WHERE dept_id = 2
);

--Assignment Q9
SELECT emp_name, salary
FROM Employee
WHERE salary = (SELECT MAX(salary) FROM Employee);


--Assignment Q10
CREATE TABLE High_Salary_Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    salary NUMERIC(10, 2),
    dept_id INT
);
INSERT INTO High_Salary_Employees (emp_id, emp_name, salary, dept_id)
SELECT emp_id, emp_name, salary, dept_id
FROM Employee
WHERE salary > 8000;
Select * from High_Salary_Employees;



--Assignment Q11
DELETE FROM Employee
WHERE NOT EXISTS (
    SELECT 1 
    FROM Works_On 
    WHERE Works_On.emp_id = Employee.emp_id
);
Select * from Works_On;
Select * From Employee;


--Assignment Q12
INSERT INTO Department (dept_id, dept_name, location) 
VALUES (6, 'Sales', 'Berlin');
SELECT d.dept_id, d.dept_name
FROM Department d
WHERE NOT EXISTS (
    SELECT 1 
    FROM Employee e 
    WHERE e.dept_id = d.dept_id
);

--Assignment Q13
SELECT DISTINCT location
FROM Department;


--Assignment Q14
SELECT 
    emp_name, 
    salary AS current_salary,
    salary * 1.10 AS salary_with_bonus
FROM Employee;


--Assignment Q15
SELECT 
    emp_name,
    UPPER(emp_name) AS all_caps,
    LOWER(emp_name) AS all_lowercase,
    INITCAP(emp_name) AS capitalized_properly
FROM Employee;


--Assignment Q16
SELECT 
    emp_name,
    LTRIM(emp_name) AS left_trimmed,
    RTRIM(emp_name) AS right_trimmed,
    TRIM(emp_name) AS fully_trimmed
FROM Employee;

--Assignment Q17
SELECT 
    emp_name, 
    salary,
    CONCAT(emp_name, ' ', salary) AS full_name
FROM Employee;


--Assignment Q18
SELECT 
    emp_name,
    SUBSTRING(emp_name FROM 1 FOR 5) AS first_five_chars,
    SUBSTRING(emp_name FROM 1 FOR 1) AS first_initial
FROM Employee;


--Assignment Q19
SELECT 
    emp_name,
    POSITION(' ' IN emp_name) AS space_index,
    POSITION('e' IN emp_name) AS first_e_index
FROM Employee;


--Assignment Q20
SELECT 
    emp_name,
    REPLACE(emp_name, 'Johnson', 'Smith') AS name_change,
    REPLACE(emp_name, ' ', '_') AS underscored_name
FROM Employee;


--Assignment Q21
SELECT 
    emp_name, 
    salary AS original_salary,
    CAST(salary AS INTEGER) AS integer_salary
FROM Employee;


--Assignment Q22
SELECT 
    emp_name, 
    salary::INTEGER AS integer_salary
FROM Employee;


