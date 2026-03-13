--QUIZ 2

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    dept_id INT REFERENCES departments(dept_id) ON DELETE CASCADE ON UPDATE CASCADE,
    hire_date DATE
	
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    dept_id INT REFERENCES departments(dept_id) ON DELETE SET NULL ON UPDATE CASCADE
);


SELECT * FROM departments
ORDER BY dept_id ASC 