CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization TEXT,
    qualification TEXT
);

CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    locality TEXT,
    city VARCHAR(50)
    -- Age is [derived], so we calculate it in queries rather than storing it.
);

CREATE TABLE Doctor_Patient (
    doctor_id INTEGER REFERENCES Doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE,
    patient_id INTEGER REFERENCES Patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (doctor_id, patient_id)
);

CREATE TABLE Medicines (
    code VARCHAR(10) PRIMARY KEY,
    medicine_name VARCHAR(50),
    price NUMERIC(10,2) CHECK (price >= 0),
    quantity INTEGER
);

CREATE TABLE Patient_Medicine (
    bill_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES Patients(patient_id) ON DELETE CASCADE,
    medicine_code VARCHAR(10) REFERENCES Medicines(code) ON DELETE CASCADE,
    quantity INTEGER,
    bill_date DATE DEFAULT CURRENT_DATE
);



INSERT INTO Doctors (doctor_id, specialization, qualification, first_name , middle_name, last_name)
VALUES
(1, 'Cardiology', 'MD', 'Ahmed', 'Ali', 'Hassan'),
(2, 'Neurology', 'PhD', 'Mona', 'Mohamed', 'Fahmy'),
(3, 'Orthopedics', 'MBBS', 'Khaled', NULL, 'Saeed'),
(4, 'Pediatrics', 'MD', 'Sara', 'Ahmed', 'Nabil'),
(5, 'Dermatology', 'MD', 'Omar', 'Hassan', 'Farouk');


INSERT INTO Patients (patient_id, first_name,last_name, dob, locality, city)
VALUES
(101,'Ahmed' , 'Ali' ,'1990-05-12', 'Heliopolis', 'Cairo'),
(102, 'Mohamed','Kareem', '1985-11-23', 'Zamalek', 'Cairo'),
(103, 'Nada', 'Ahmed','2000-01-30', 'Nasr City', 'Cairo'),
(104, 'Hazem','Ibrahim','2010-07-15', 'Maadi', 'Cairo'),
(105, 'Aser','Aly','1975-09-10', 'Dokki', 'Giza');

INSERT INTO Medicines (code, medicine_name,price, quantity)
VALUES
('M001', 'Panadol',150.50, 20),
('M002', 'Tramadol',75.00, 50),
('M003', 'Gaviscon',300.25, 10),
('M004','Catafast', 120.00, 30),
('M005', 'Vitamin C',50.75, 100);


-- Doctor 1 treats Patients 101, 102
INSERT INTO Doctor_Patient (Doctor_id, Patient_id)
VALUES
(1, 101),
(1, 102),
(2, 103),
(3, 104),
(4, 105),
(2, 101);


INSERT INTO Patient_Medicine (patient_id, medicine_code, quantity)
VALUES
(101, 'M001', 2),
(101, 'M002', 1),
(102, 'M003', 1),
(103, 'M002', 3),
(104, 'M004', 2),
(105, 'M005', 5);

-- QUIZ 1
-- QUESTION 1
DELETE FROM Patients WHERE patient_id = 105;


-- QUESTION 2
ALTER TABLE Doctors ADD COLUMN salary NUMERIC;

-- Giving them some sample salaries to test the query
UPDATE Doctors SET salary = 15000 WHERE doctor_id = 1; -- Cardiology
UPDATE Doctors SET salary = 11000 WHERE doctor_id = 2; -- Neurology
UPDATE Doctors SET salary = 13000 WHERE specialization = 'Cardiology' AND doctor_id != 1;

SELECT * from Doctors where specialization='Cardiology' AND salary>12000;


-- QUESTION 3
Select * from Patients where first_name ilike 'M%';


-- QUESTION 4
SELECT * from Doctors where  salary BETWEEN 10000 AND 20000;

-- QUESTION 5
SELECT * from Doctors where specialization='Cardiology' OR specialization='Dermatology';
-- another way of the lecture
SELECT * FROM Doctors WHERE specialization IN ('Cardiology','Dermatology');

-- QUESTION 6
SELECT * FROM Doctors WHERE specialization NOT IN ('Neurology');

-- QUESTION 7
ALTER TABLE Patients ADD COLUMN phone VARCHAR(20);
SELECT *FROM Patients WHERE phone is NULL;

-- QUESTION 8
SELECT first_name,salary, CASE WHEN salary > 14000 THEN 'High Salary' ELSE 'Normal Salary' END AS salary_status
FROM Doctors;

-- QUESTION 9 Postponed because it have join

-- QUESTION 10
CREATE TABLE high_salary_doctors AS
SELECT * FROM Doctors
WHERE salary > 14000;

Select * from high_salary_doctors;

-- QUESTION 11
SELECT *
FROM Doctors d WHERE EXISTS ( SELECT 1 FROM Doctor_Patient dp 
    WHERE dp.doctor_id = d.doctor_id
);

-- QUESTION 12
SELECT first_name, last_name, specialization, salary
FROM Doctors
WHERE salary > ANY (
    SELECT salary 
    FROM Doctors 
    WHERE specialization = 'Cardiology'
);

-- QUESTION 13
SELECT * FROM Patients WHERE first_name SIMILAR TO '(A|M)%';

-- QUESTION 14
SELECT DISTINCT specialization FROM Doctors;


-- QUESTION 15
SELECT first_name, last_name, AGE(dob) AS full_age,
    EXTRACT(YEAR FROM AGE(dob)) AS age_years FROM Patients;

-- QUESTION 16
SELECT UPPER(first_name) AS loud_name, LOWER(first_name) AS quiet_name, INITCAP(LOWER(first_name)) AS proper_name
FROM Patients;

-- QUESTION 17
UPDATE Patients SET phone = '01758965823' WHERE patient_id = 101; 
UPDATE Patients SET phone = '01256874968' WHERE patient_id = 102; 
UPDATE Patients SET phone = '01164785269' WHERE patient_id = 103; 
UPDATE Patients SET phone = '01058475964' WHERE patient_id = 104; 

select* from patients;

SELECT phone AS original,'|' || phone || '|' AS visual_check, TRIM(phone) AS both_cleaned,
LTRIM(phone) AS left_cleaned,
RTRIM(phone) AS right_cleaned
FROM Patients;

-- QUESTION 18
SELECT 
    patient_id,
    CONCAT(first_name, ' ', last_name, ' - Phone: ', phone) AS contact_info
FROM Patients;

-- QUestion 19
SELECT 
    first_name,
    SUBSTRING(first_name FROM 1 FOR 3) AS name_short,
    POSITION('a' IN LOWER(first_name)) AS pos_of_a
FROM Patients;

-- QUESTION 20
SELECT 
    first_name AS original,
    REPLACE(first_name, 'Ahmed', 'Ahmad') AS updated_name
FROM Doctors;

-- QUESTION 21
SELECT 
    first_name, 
    salary AS original_numeric,
    CAST(salary AS INTEGER) AS salary_int,
    salary::TEXT AS salary_text
FROM Doctors;


