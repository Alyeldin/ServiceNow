---- New Assignment ----
--Q1
select emp_name,dept_name from employee e
left join department d on d.dept_id=e.dept_id

--Q2
select dept_name,count(emp_id)
from department d
left join employee e on d.dept_id=e.dept_id
group by dept_name having count(emp_id) >1


--Q3
select emp_name, salary,dept_name from employee e
inner join department d on d.dept_id=e.dept_id
order by salary desc
limit 3


--Q4
select dept_name, emp_name from department d
Left join employee e on d.dept_id=e.dept_id
-------------------------------------------------------------------



---- Week Assignment ----

--Q1
select emp_name,dept_name from employee e
Left join department d on d.dept_id=e.dept_id

--Q2
select project_name,hours from Project p
Left join Works_On w on p.project_id=w.project_id


--Q3
select dept_name,Round(Avg(e.salary),2) from employee e
join department d on d.dept_id=e.dept_id
group by dept_name having Round(Avg(e.salary),2) >6000