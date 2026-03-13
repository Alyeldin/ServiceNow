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
('Database'),('JS'),('HTML');

INSERT INTO enrollments (student_id, course_id) VALUES
(1,1),(1,2),(2,1),(3,3);

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

