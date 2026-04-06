
--QUIZ 1
CREATE TABLE Doctor (
    doctor_id SERIAL PRIMARY KEY,
    specialization VARCHAR(100),
    qualification VARCHAR(100),
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE Patient (
    patient_id SERIAL PRIMARY KEY,
	 first_name VARCHAR(50),
    middle_name VARCHAR(50),
    dob DATE,
    locality VARCHAR(100),
    city VARCHAR(100),
    doctor_id INT REFERENCES Doctor(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE medicines (
    code SERIAL PRIMARY KEY,
    medicine_name VARCHAR(100),
    price NUMERIC(10,2),
    quantity INTEGER  
);

	
CREATE TABLE patient_medcines (
    bill_id SERIAL PRIMARY KEY,
    patient_id INTEGER,
    medicine_code INTEGER,
    quantity INTEGER,
    bill_date DATE,
	FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
	FOREIGN KEY (medicine_code) REFERENCES medicines(code)
);




INSERT INTO Doctor (specialization, qualification, first_name, middle_name, last_name) VALUES
('Cardiology', 'MD', 'Gregory', 'House', 'MD'),
('Neurology', 'PhD', 'Leonard', 'Hofstadter', 'PhD'),
('Pediatrics', 'MD', 'Doogie', 'Howser', 'MD');


INSERT INTO Patient (first_name, middle_name, dob, locality, city, doctor_id) VALUES
('Alice', 'Jane', '1990-05-15', 'Main St', 'New York', 1),
('Bob', 'Lee', '1985-08-20', 'Oak Ave', 'Chicago', 2),
('Charlie', 'Ray', '2000-01-10', 'Pine Rd', 'Boston', 3),
('Diana', 'Rose', '1995-12-05', 'Elm St', 'Seattle', 1),
('Evan', 'Paul', '1988-03-22', 'Maple Dr', 'Austin', 2);


INSERT INTO medicines (medicine_name, price, quantity) VALUES
('Aspirin', 10.50, 100),
('Ibuprofen', 15.00, 50),
('Amoxicillin', 25.75, 30),
('Lisinopril', 12.00, 40),
('Metformin', 20.00, 60);


INSERT INTO patient_medcines (patient_id, medicine_code, quantity, bill_date) VALUES
(1, 1, 2, '2026-03-01'),
(2, 2, 1, '2026-03-02'),
(3, 3, 3, '2026-03-03'),
(4, 4, 1, '2026-03-04'),
(5, 5, 2, '2026-03-05');


UPDATE medicines 
SET price = price + 2.00 
WHERE code = 1;

UPDATE Patient 
SET doctor_id = 3 
WHERE patient_id = 1;


ALTER TABLE Doctor 
ADD COLUMN phone_number VARCHAR(15);


ALTER TABLE Patient 
ADD COLUMN email VARCHAR(100) UNIQUE;


ALTER TABLE medicines 
ADD CONSTRAINT price CHECK (price >= 0);


SELECT patient_id, first_name, doctor_id 
FROM Patient 
WHERE doctor_id = 1;

UPDATE Doctor 
SET doctor_id = 100 
WHERE doctor_id = 1;

SELECT patient_id, first_name, doctor_id 
FROM Patient 
WHERE doctor_id = 100;

-- QUIZ 1 done 

