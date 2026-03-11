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

	