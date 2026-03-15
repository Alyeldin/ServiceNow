CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(50)
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


INSERT INTO students (student_name) VALUES
('Ali'),('Sara'),('Omar'),('Ahmed');

INSERT INTO courses (course_name) VALUES
('Database'),('JS'),('HTML'),('Css');

INSERT INTO enrollments (student_id, course_id) VALUES
(1,1),(1,2),(2,1),(3,3);

CREATE TABLE employees
(
    emp_id serial primary key ,
    emp_name varchar(500),
    manager_id integer
);

INSERT INTO employees (emp_name, manager_id) VALUES
('Alice Johnson', NULL),  
('Bob Smith', 1),      
('Charlie Davis', 1),     
('Diana Evans', 2),      
('Ethan Brown', 2),   
('Fiona Green', 3);  


-- inner join
SELECT s.student_name, c.course_name
FROM enrollments e
INNER JOIN students s
ON e.student_id = s.student_id
INNER JOIN courses c
ON e.course_id = c.course_id;

-- left join
SELECT s.student_name, c.course_name
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
LEFT JOIN courses c
ON e.course_id = c.course_id;

--right join
SELECT s.student_name, c.course_name
FROM students s
RIGHT JOIN enrollments e
ON s.student_id = e.student_id
RIGHT JOIN courses c
ON e.course_id = c.course_id;

--full join
SELECT s.student_name, c.course_name
FROM students s
FULL JOIN enrollments e
ON s.student_id = e.student_id
FULL JOIN courses c
ON e.course_id = c.course_id;

--cross join
SELECT s.student_name, c.course_name
FROM students s
CROSS JOIN courses c;


-- Count courses per student
SELECT s.student_name, COUNT(e.course_id) AS total_courses
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_name;

-- Number of students in each course
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Show students with number of courses sorted by most courses
SELECT s.student_name, COUNT(e.course_id) AS total_courses
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_name
ORDER BY total_courses DESC;

-- Show most popular courses
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY total_students DESC;

-- ===============15-3-2026================

--self join
SELECT e1.emp_name AS manager, e2.emp_name AS emp_name
FROM employees e1
JOIN employees e2
ON e1.emp_id = e2.manager_id;

--lateral join
SELECT s.student_name, c.course_name
FROM students s
JOIN LATERAL (
    SELECT course_id
    FROM enrollments e
    WHERE e.student_id = s.student_id
) e ON TRUE
JOIN courses c ON c.course_id = e.course_id;

-- natural join
SELECT *
FROM students
NATURAL JOIN enrollments;

-- sub query
SELECT s.student_name, sub.total_courses
FROM students s
JOIN (
    SELECT student_id, COUNT(*) AS total_courses
    FROM enrollments
    GROUP BY student_id
) sub
ON s.student_id = sub.student_id
order by sub.total_courses desc

-- task sol
SELECT s.student_name, sub.total_courses
FROM students s
JOIN (
    SELECT student_id, COUNT(*) AS total_courses
    FROM enrollments
    GROUP BY student_id
) sub
ON s.student_id = sub.student_id
WHERE sub.total_courses > 1;

/*

logic cycle
students -> enroll(bridge table) -> courses(m-m)
students ->have(bridge table)student_parents ->partents(m-m)

*/
/*
student name,course name,partent name for only students enrollment in course(inner join)
*/
CREATE TABLE parents (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE student_parents (
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    parent_id INT REFERENCES parents(id) ON DELETE CASCADE,
    PRIMARY KEY (student_id, parent_id)
);

INSERT INTO parents (name) VALUES
('Ahmed Hassan'),
('Fatima Ali'),
('Mohamed Said'),
('Sara Ibrahim'),
('Omar Khaled');
insert into students(student_name) values('Karim');
select * from students;
INSERT INTO student_parents (student_id, parent_id) VALUES
(1,1),
(1,2),
(2,1),
(3,3),
(4,4),
(4,5),
(5,3)

-- get all students names with courses names and partents names
SELECT
    s.student_name AS student,
    p.name AS parent,
    c.course_name AS course
FROM students s
JOIN student_parents sp ON s.student_id = sp.student_id
JOIN parents p ON p.id = sp.parent_id
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c ON c.course_id = e.course_id
ORDER BY student;

-- task sol
SELECT
    p.name AS parent_name,
    s.student_name
FROM parents p
JOIN student_parents sp
ON p.id = sp.parent_id
JOIN students s
ON s.student_id = sp.student_id
ORDER BY parent_name;








