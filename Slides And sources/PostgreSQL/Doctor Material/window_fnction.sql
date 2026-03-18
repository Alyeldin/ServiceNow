select name,salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
from employees;

select name,salary,
RANK() OVER (ORDER BY salary DESC) as row_num
from employees;

select name,salary,
DENSE_RANK() OVER (ORDER BY salary DESC) as row_num
from employees;

select name,salary,
NTILE(2) OVER (ORDER BY salary DESC) as group_number
from employees;

select name,salary,
LAG(salary) OVER (ORDER BY salary DESC) as prev_salary
from employees;

select name,salary,
LEAD(salary) OVER (ORDER BY salary DESC) as next_salary
from employees;

select name,salary,
SUM(salary) OVER (ORDER BY salary DESC) as running_total
from employees;

select name,salary,
AVG(salary) OVER () as avg_salary
from employees;

select array_agg(name) from employees;

select dep_id,array_agg(name) from employees group by dep_id;

select array_agg(name order by salary desc) from employees;

select array_agg(distinct dep_id) from employees;

select dep_id, BOOL_AND(salary > 4000) as all_above_4000
from employees
GROUP by dep_id;

select dep_id, BOOL_OR(salary > 7500) as all_above_5000
from employees
GROUP by dep_id;

ALTER TABLE enrollments ADD score float DEFAULT 0;
select * from enrollments;
update enrollments set score=60 where enrollment_id=1;
update enrollments set score=80 where enrollment_id=2;
update enrollments set score=40 where enrollment_id=3;
update enrollments set score=75 where enrollment_id=4;
select * from enrollments;

SELECT 
    s.student_id,
    s.student_name,
    c.course_name,
    e.score,
    RANK() OVER (
        PARTITION BY c.course_id
        ORDER BY e.score DESC
    ) AS rank_in_course
FROM students s
JOIN  enrollments e
    ON e.student_id = s.student_id
JOIN courses c 
    ON e.course_id = c.course_id

SELECT *
FROM (
    SELECT
        s.student_id,
        s.student_name,
        c.course_name,
        e.score,
        ROW_NUMBER() OVER (
            PARTITION BY c.course_id
            ORDER BY e.score DESC
        ) AS rn
    FROM enrollments e
    JOIN students s 
        ON e.student_id = s.student_id
    JOIN courses c 
        ON e.course_id = c.course_id
) t
WHERE rn = 1;


SELECT distinct
    s.student_name,
    COUNT(parent_id) OVER (
        PARTITION BY s.student_id
    ) AS total_parents
FROM students s
JOIN student_parents sp
    ON s.student_id = sp.student_id;

SELECT * FROM public.employees
ORDER BY salary desc
	SELECT
    s.student_id,
    s.student_name,
    c.course_name,
    e.score,
    DENSE_RANK() OVER (
        ORDER BY e.score DESC
    ) AS global_rank
FROM enrollments e
JOIN students s
    ON s.student_id = e.student_id
JOIN courses c
    ON c.course_id = e.course_id;