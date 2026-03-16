
------Doctor material 

CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    task_name VARCHAR(100),
    status VARCHAR(20),
    priority VARCHAR(20),
    due_date DATE,
    emp_id INT
);

INSERT INTO tasks (task_name, status, priority, due_date, emp_id)
VALUES  ('Lab 6', 'solving', 'High', '2026-03-16', 110),
('Lab 6', 'Pending', 'High', '2026-03-16', 108),
('Prepare report', 'Completed', 'High', '2026-03-20', 101),
('Fix system bug', 'In Progress', 'High', '2026-03-18', 102),
('Update database', 'Pending', 'Medium', '2026-03-25', 103),
('Design new feature', 'In Progress', 'High', '2026-03-22', 101),
('Test application', 'Completed', 'Low', '2026-03-19', 104),
('Write documentation', 'Pending', 'Medium', '2026-03-28', 102),
('Client meeting preparation', 'In Progress', 'High', '2026-03-17', 105),
('Code review', 'Completed', 'Medium', '2026-03-21', 103),
('Deploy update', 'Pending', 'High', '2026-03-26', 101),
('Security audit', 'Pending', 'High', '2026-03-30', 104);



