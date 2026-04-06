
----------DAY 6 LAB----------

--Q1
with high_earning as (select * from employee where salary>4000)
select dept_name from high_earning
join department d on d.dept_id=high_earning.dept_id
group by dept_name


--Q2
select emp_name  from employee 
EXCEPT
select emp_name from employee e join department d on e.dept_id = d.dept_id where d.dept_name='IT' 


--Q3
select emp_name from employee e join works_on w on e.emp_id = w.emp_id
join project p on w.project_id= p.project_id where p.project_name='Project Alpha'
intersect
select emp_name from employee e join works_on w on e.emp_id = w.emp_id
join project p on w.project_id= p.project_id where p.project_name='Project Beta'


--Q4
start transaction;
UPDATE Employee SET salary = 6000 WHERE emp_id = 106;
UPDATE Employee SET dept_id = 3 WHERE emp_id = 106;
COMMIT;


--Q5
select emp_name from employee e 
join department d on d.dept_id=e.dept_id where d.dept_name='Sales';


--Q6
select emp_name from employee e 
join tasks t on t.emp_id=e.emp_id where t.priority='High';


--Q7
select emp_name from employee e 
join tasks t on t.emp_id=e.emp_id where t.due_date= CURRENT_DATE;

--Q8
select emp_name from employee e 
join tasks t on t.emp_id=e.emp_id where t.status !='Completed';

----Homework----
--Q1
select emp_name, count(t.task_id) as task_count from employee e 
join tasks t on t.emp_id=e.emp_id group by e.emp_id, e.emp_name having count(t.task_id)>2;

--Q2
select task_name, due_date, status from tasks 
where due_date > (select max(due_date) from tasks where status='Completed');


--Q3
select emp_name, t.task_name, t.priority from employee e 
join tasks t on t.emp_id=e.emp_id where t.priority='High';

--Q4
select emp_name, t.task_name, t.due_date, t.status from employee e 
join tasks t on t.emp_id=e.emp_id where t.status ='Completed';