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



-----------------------------------------
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