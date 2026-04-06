--Import Old databases

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




--Row Number function (used in ranking and pagination and filtering )
SELECT emp_name, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM employee;



--Rank( gives a rank based on the salary as the given example ) 
SELECT emp_name, salary,
RANK( ) OVER (ORDER BY salary DESC) AS rank
FROM employee;
--Dense rank
SELECT emp_name, salary,
DENSE_RANK( ) OVER (ORDER BY salary DESC) AS rank
FROM employee;



--NTile function ( divide employee into two groups based on their salary )
SELECT emp_name, salary,
NTILE(2) OVER (ORDER BY salary DESC) AS group_number
FROM employee;



--Lag (gets the previous row values)
SELECT emp_name, salary,
LAG(salary) OVER (ORDER BY salary) AS previous_salary
FROM employee;
--another example
SELECT emp_name, salary,
LAG(salary,2) OVER (ORDER BY salary) AS previous_salary
FROM employee;



--Lead(same as lag but gets the next not the previous)
SELECT emp_name, salary,
LEAD(salary) OVER (ORDER BY salary) AS next_salary
FROM employee;
--another example
SELECT emp_name, salary,
LEAD(salary,2) OVER (ORDER BY salary) AS next_salary
FROM employee;



--SUM()
SELECT emp_name, salary,
SUM(salary) OVER (ORDER By salary) AS running_total
FROM employee;
--another example
SELECT emp_name, salary,
SUM(salary) OVER () AS running_total
FROM employee;



--AVG()
SELECT emp_name, salary,
AVG(salary) OVER () AS Average_total
FROM employee;
--another example
SELECT emp_name, salary,
AVG(salary) OVER (ORDER By salary) AS Average_total
FROM employee;



--Array_Agregation 
SELECT ARRAY_AGG(emp_name) AS employee_names
FROM employee;
--another example(ORDER BY)
SELECT ARRAY_AGG(emp_name ORDER BY salary DESC) AS employees_by_salary
FROM employee;
--another example (DISTINCT)
SELECT ARRAY_AGG(DISTINCT dept_id) AS departments
FROM employee;
--another example (GROUP BY)
SELECT dept_id, ARRAY_AGG(emp_name) AS employees
FROM employee
GROUP BY dept_id;
--another example (JOIN) 
--Lecture Task 1
select dept_name, array_agg(emp_name)
from employee e
join department d on d.dept_id=e.dept_id
group by dept_name




--BOOL AND 
SELECT dept_id,
BOOL_AND(salary > 4000) AS all_above_4000
FROM employee
GROUP BY dept_id;
--BOOL OR
SELECT dept_id,
BOOL_OR(salary > 7500) AS any_above_7500
FROM employee
GROUP BY dept_id;






--Import student library
CREATE TABLE students (
student_id SERIAL PRIMARY KEY,
student_name VARCHAR(50)
);

CREATE TABLE courses (
course_id SERIAL PRIMARY KEY,
course_name VARCHAR (50)
);

CREATE TABLE enrollments(
enrollment_id SERIAL PRIMARY KEY,
student_id INT,
course_id INT,
score INT,
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (student_name) VALUES
('Ali'), ('Sara'),('Omar'),('Ahmed');

INSERT INTO courses (course_name) VALUES
('Database'), ('JS'), ('HTML'),('Css');

INSERT INTO enrollments (student_id, course_id,score) VALUES
(1,1,60),(1,2,75),(2,1,45),(3,3,88);

CREATE TABLE parents (
id SERIAL PRIMARY KEY,
name TEXT NOT NULL
);

INSERT INTO parents (name) VALUES
('Ahmed Hassan'),
('Fatima Ali'),
('Mohamed Said'),
('Sara Ibrahim'),
('Omar Khaled');

CREATE TABLE student_parents(
student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
parent_id INT REFERENCES parents(id) ON DELETE CASCADE,
PRIMARY KEY (student_id, parent_id)
);

INSERT INTO students (student_id, student_name) 
VALUES (5, 'Kareem');

INSERT INTO student_parents (student_id, parent_id) VALUES
(1,1),
(1,2),
(2,1),
(3,3),
(4,4),
(4,5),
(5,3);



--Partition  (rank students by score within each course)
SELECT s.student_id,s.student_name,c.course_name, e.score,
RANK() OVER( PARTITION BY c.course_id ORDER BY e.score DESC) AS rank_in_course
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;


--another example 
SELECT distinct s.student_id,s.student_name, COUNT(p.id) OVER (PARTITION BY s.student_id) AS total_parents
FROM students s
JOIN student_parents sp ON s.student_id = sp.student_id
JOIN parents p ON p.id = sp.parent_id;



--Lecture task 2

--Q1
WITH ranked AS ( SELECT s.student_id, s.student_name, c.course_name, e.score,
ROW_NUMBER() OVER (PARTITION BY c.course_id  ORDER BY e.score DESC) AS rn
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id)
SELECT *
FROM ranked
WHERE rn = 1;

--Q2
SELECT DISTINCT ON (d.dept_name) d.dept_name, e.emp_name,  e.salary
FROM Employee e JOIN Department d ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.salary DESC;

--another solution
SELECT DISTINCT d.dept_name, MAX(e.salary) OVER (PARTITION BY e.dept_id) AS max_salary
FROM department d
JOIN employee e ON d.dept_id = e.dept_id;

--another solution
SELECT dept_name, emp_name, salary
FROM (SELECT d.dept_name, e.emp_name,e.salary,
RANK() OVER (PARTITION BY d.dept_name ORDER BY e.salary DESC) as salary_rank
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id) AS ranked_table
WHERE salary_rank = 1;
 


--Continue lecture  (Rank all students)
SELECT s.student_id,s.student_name,c.course_name,e. score,
DENSE_RANK( ) OVER (ORDER BY e.score DESC) AS global_rank
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;
