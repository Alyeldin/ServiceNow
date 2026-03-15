-- Example 1

CREATE TABLE Department (
dept_id SERIAL PRIMARY KEY,
name VARCHAR(50)

);

CREATE TABLE Employee (
emp_id SERIAL PRIMARY KEY,
name VARCHAR(50),
dept_id INT REFERENCES Department(dept_id) ON DELETE CASCADE

);


INSERT INTO Department (dept_id, name) VALUES
    (1, 'Engineering'),
    (2, 'Marketing'),
    (3, 'Human Resources');

INSERT INTO Employee (name, dept_id)
VALUES
    ('Alice Vance', 1),
    ('Bob Ross', 2),
    ('Charlie Day', 1),
    ('Diana Prince', 3),
    ('Evan Wright', 2);

SELECT * FROM Department, Employee;

DELETE FROM Department 
WHERE dept_id = 2;


-- Example 2

-- Insert Departments
INSERT INTO Department (name) VALUES
('IT'),
('HR'),
('Finance');

-- Insert Employees
INSERT INTO Employee (name, dept_id) VALUES
('Ali', 1),
('Sara', 1),
('Omar', 2);


SELECT * FROM Department;


SELECT * FROM Employee;

DELETE FROM Department
WHERE dept_id = 1;

SELECT * FROM Department;
SELECT * FROM Employee;



-- Doctor code
INSERT INTO Department (name) VALUES
('IT'),
('HR'),
('Finance');

-- Insert Employees
INSERT INTO Employee (name, dept_id) VALUES
('Ali', 3),
('Sara', 3),
('Omar', 4);


SELECT * FROM Department;


SELECT * FROM Employee;

DELETE FROM Department
WHERE dept_id = 1;

SELECT * FROM Department;



-- ERROR:  update or delete on table "departments" violates foreign key constraint "employees_dept_id_fkey" on table "employees"
-- Key (dept_id)=(1) is still referenced from table "employees".
	