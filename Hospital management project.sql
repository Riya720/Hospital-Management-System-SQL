CREATE DATABASE  hospital_db;
USE  hospital_db;

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    contact VARCHAR(15),
    city VARCHAR(50)
);
DESC Patients;


CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(50),
    consultation_fee INT
);
DESC Doctors;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);
DESC Departments;

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
DESC Appointments;

CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    diagnosis VARCHAR(100),
    treatment_cost INT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
DESC Treatments;

CREATE TABLE Bills (
    bill_id INT PRIMARY KEY,
    patient_id INT,
    total_amount INT,
    payment_mode VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);
DESC Bills;

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    bill_id INT,
    payment_date DATE,
    amount INT,
    payment_status VARCHAR(20),
    FOREIGN KEY (bill_id) REFERENCES Bills(bill_id)
);
DESC Payments;

INSERT INTO Patients VALUES
(1,'Amit Sharma','Male',35,'9876543210','Delhi'),
(2,'Riya Verma','Female',28,'9123456780','Mumbai'),
(3,'Neha Singh','Female',42,'9988776655','Patna'),
(4,'Rohit Kumar','Male',55,'9876501234','Kolkata'),
(5,'Pooja Mishra','Female',31,'9001122334','Lucknow'),
(6,'Ankit Gupta','Male',23,'9112233445','Delhi'),
(7,'Suman Devi','Female',63,'9898989898','Varanasi'),
(8,'Ajit Kumar','Male',25,'8969845612','Kolkata'),
(9,'Piya Kumari','Female',30,'9638521475','Ranchi'),
(10,'Rahul Mishra','Male',28,'7412589632','Siliguri'),
(11,'Sunil Dutta','Male',35,'8632591472','Noida'),
(12,'Pargati Kumari','Female',26,'9631478552','Banaras'),
(13,'Krishna Nag','Female',27,'8974365215','Durgapur');
SELECT * FROM Patients;


INSERT INTO Doctors VALUES
(101,'Dr Mehta','Cardiology',800),
(102,'Dr Khan','Orthopedic',600),
(103,'Dr Rao','Neurology',1000),
(104,'Dr Singh','General Physician',400),
(105,'Dr Verma','Dermatology',500);
SELECT * FROM Doctors;

INSERT INTO Departments VALUES
(1,'Cardiology'),
(2,'Orthopedic'),
(3,'Neurology'),
(4,'General Medicine'),
(5,'Dermatology');
SELECT * FROM Departments;


INSERT INTO Appointments VALUES
(201,1,101,'2025-01-10','Completed'),
(202,2,102,'2025-01-11','Completed'),
(203,3,101,'2025-01-12','Pending'),
(204,4,103,'2025-01-13','Completed'),
(205,5,104,'2025-01-14','Completed'),
(206,6,105,'2025-01-15','Pending'),
(207,7,101,'2025-01-16','Completed'),
(208,8,104,'2025-01-17','Completed'),
(209,9,103,'2025-01-18','Completed'),
(210,10,102,'2025-01-19','Pending'),
(211,11,104,'2025-01-20','Completed'),
(212,12,105,'2025-01-21','Pending'),
(213,13,102,'2025-01-22','Completed');
SELECT * FROM Appointments;


INSERT INTO Treatments VALUES
(301,201,'Heart Checkup',5000),
(302,202,'Knee Pain Treatment',3000),
(303,204,'Migraine Treatment',4500),
(304,205,'Viral Fever',1500),
(305,207,'Blood Pressure Monitoring',2500),
(306,208,'General Health Checkup',2000),
(307,209,'Neuro Consultation',4800),
(308,211,'Seasonal Infection',1800),
(309,213,'Joint Pain Treatment',3200);
SELECT * FROM Treatments;

INSERT INTO Bills VALUES
(401,1,5800,'Card'),
(402,2,3600,'Cash'),
(403,4,5200,'UPI'),
(404,5,1900,'Card'),
(405,7,2800,'Cash'),
(406,8,2200,'UPI'),
(407,9,5000,'Card'),
(408,11,2000,'Cash'),
(409,13,3500,'UPI');
SELECT * FROM Bills;

INSERT INTO Payments VALUES
(501,401,'2025-01-10',5800,'Paid'),
(502,402,'2025-01-11',3600,'Paid'),
(503,403,'2025-01-13',5200,'Paid'),
(504,404,'2025-01-14',1900,'Paid'),
(505,405,'2025-01-16',2800,'Paid'),
(506,406,'2025-01-17',2200,'Paid'),
(507,407,'2025-01-18',5000,'Paid'),
(508,408,'2025-01-20',2000,'Paid'),
(509,409,'2025-01-22',3500,'Paid');
SELECT * FROM Payments;

-- Total Number of patients
SELECT COUNT(*) AS total_patients
FROM Patients;

-- Patients distribution by city
SELECT city, COUNT(*) AS patient_count
FROM Patients
GROUP BY city
ORDER BY patient_count DESC;

-- Gender-Wise patient analysis
SELECT gender, COUNT(*) AS total_patients
FROM Patients
GROUP BY gender;

-- Doctor-Wise appointment count
SELECT d.doctor_name,
       COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name
ORDER BY total_appointments DESC;

-- Specialization-Wise demand
SELECT d.specialization,
       COUNT(a.appointment_id) AS visit_count
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.specialization
ORDER BY visit_count DESC;

-- Completed vs pending appointments
SELECT status, COUNT(*) AS total_appointments
FROM Appointments
GROUP BY status;

-- Patients with pending appointments
SELECT p.patient_name, a.appointment_date
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.status = 'Pending';

-- Average treatment cost
SELECT ROUND(AVG(treatment_cost),2) AS avg_treatment_cost
FROM Treatments;

-- Total revenug generated
SELECT SUM(amount) AS total_revenue
FROM Payments;

-- Payment mode analysis 
SELECT payment_mode, COUNT(*) AS total_payments
FROM Bills
GROUP BY payment_mode;

-- High-value patients (bill > 4000)
SELECT p.patient_name, b.total_amount
FROM Patients p
JOIN Bills b ON p.patient_id = b.patient_id
WHERE b.total_amount > 4000;

-- Doctor-wise consultation revenue 
SELECT d.doctor_name,
       COUNT(a.appointment_id) * d.consultation_fee AS consultation_revenue
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name, d.consultation_fee
ORDER BY consultation_revenue DESC;

-- Patient age group analysis 
SELECT 
CASE
    WHEN age < 18 THEN 'Child'
    WHEN age BETWEEN 18 AND 40 THEN 'Adult'
    WHEN age BETWEEN 41 AND 60 THEN 'Middle Age'
    ELSE 'Senior'
END AS age_group,
COUNT(*) AS total_patients
FROM Patients
GROUP BY age_group;


-- Patients without treatments
SELECT p.patient_name, a.status
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
LEFT JOIN Treatments t ON a.appointment_id = t.appointment_id
WHERE t.treatment_id IS NULL;

-- Monthly revenue trend 
SELECT MONTH(payment_date) AS month,
       SUM(amount) AS monthly_revenue
FROM Payments
GROUP BY MONTH(payment_date)
ORDER BY month;





