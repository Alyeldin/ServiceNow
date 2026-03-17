-----------------employee & department tables-------------------
CREATE TABLE departments (id SERIAL PRIMARY KEY,department_name VARCHAR(50));

INSERT INTO departments (department_name) VALUES('IT'),('HR'),('Finance'),
('Marketing'),
('Administration'),
('Technical Support');

CREATE TABLE employees (id SERIAL PRIMARY KEY,name VARCHAR(50),
age INT,salary NUMERIC,dep_id INT,FOREIGN KEY (dep_id) REFERENCES departments(id));


INSERT INTO employees (name, age, salary, dep_id) VALUES
('Ahmed', 30, 8000, 1),
('Sara', 28, 6000, 1),
('Mohamed', 35, 7000, 2),
('Mona', 32, 9000, 3),
('Ali', 26, 5000, 2),
('Nour', 29, 7500, 4),
('Hassan', 40, 10000, 3),
('Mai', 34, 7500, 3),
('Mostafa', 38, 12000, 2),
('Amr', 23, 4000, 1);
INSERT INTO employees (name, age, salary, dep_id) VALUES ('mohAMed', 32, 7100, 2);
INSERT INTO employees (name, age, salary, dep_id) VALUES ('sAlma', 24, 5600, 3);

ALTER TABLE employees  ADD manager_id INT;
---------------------using state---------------------
SELECT *
FROM students
JOIN enrollments USING (student_id);
------------------operators--------------------
SELECT student_id FROM enrollments
UNION
SELECT student_id FROM students;

SELECT student_id FROM enrollments
UNION ALL
SELECT student_id FROM students;

SELECT student_id FROM students
INTERSECT
SELECT student_id FROM enrollments;

SELECT student_id FROM students
EXCEPT
SELECT student_id FROM enrollments;
---------------------CTE (with)------------------------------
WITH high_earners AS (SELECT * FROM employees WHERE salary > 8000) 
SELECT dep_id, COUNT(*) 
FROM high_earners GROUP BY dep_id; -- Use the CTE like a table.

WITH dept_avg AS (
    SELECT dep_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY dep_id
),
top_depts AS (
    SELECT *
    FROM dept_avg
    WHERE avg_sal > 7000
)
SELECT *
FROM top_depts
JOIN departments
ON top_depts.dep_id = departments.id;


WITH student_courses AS (
    SELECT student_id, COUNT(*) AS total_courses
    FROM enrollments
    GROUP BY student_id
)
SELECT s.student_name, sc.total_courses
FROM students s
JOIN student_courses sc
ON s.student_id = sc.student_id;

-----------------transactions------------------
START TRANSACTION;

INSERT INTO employees(name,salary,dep_id)
VALUES ('Try Transaction', 1000,3);
commit;


select * from enrollments;
START TRANSACTION;

DELETE FROM enrollments
WHERE student_id = 1;

ROLLBACK;

-------------json & jsonb-------------------
CREATE TABLE test_json (
    data json
);

INSERT INTO test_json VALUES ('{"name": "Alice", "age": 30}');

SELECT data->>'age' FROM test_json;  

CREATE TABLE test_jsonb (
    data jsonb
);

INSERT INTO test_jsonb VALUES ('{"name": "Alice", "age": 30}');

SELECT * FROM test_jsonb WHERE data ? 'age';

SELECT * FROM test_jsonb WHERE data @> '{"name": "Alice"}';

