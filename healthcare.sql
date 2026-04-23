create database healthcare_db;
use healthcare_db;
CREATE TABLE patients (
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Blood_Type VARCHAR(5),
    Medical_Condition VARCHAR(50),
    Date_of_Admission DATE,
    Doctor VARCHAR(100),
    Hospital VARCHAR(100),
    Insurance_Provider VARCHAR(50),
    Billing_Amount DECIMAL(15,2),
    Room_Number INT,
    Admission_Type VARCHAR(20),
    Discharge_Date DATE,
    Medication VARCHAR(50),
    Test_Results VARCHAR(20),
    Length_of_Stay INT,
    Age_Group VARCHAR(20)
);
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/Users/vanit/OneDrive/Desktop/healthcare_cleaned.csv'
INTO TABLE patients
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Name, Age, Gender, Blood_Type, Medical_Condition,
 Date_of_Admission, Doctor, Hospital, Insurance_Provider,
 Billing_Amount, Room_Number, Admission_Type,
 Discharge_Date, Medication, Test_Results,
 Length_of_Stay, Age_Group)
SET
  Date_of_Admission = STR_TO_DATE(Date_of_Admission, '%Y-%m-%d'),
  Discharge_Date = STR_TO_DATE(Discharge_Date, '%Y-%m-%d');

SELECT * FROM patients LIMIT 3;

#Total Patients
SELECT COUNT(*) AS Total_Patients FROM patients;

#Gender Distribution
SELECT Gender,
       COUNT(*) AS Patient_Count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS Percentage
FROM patients
GROUP BY Gender;

#Top Medical Conditions by Patient Count

SELECT Medical_Condition,
       COUNT(*) AS Patient_Count
FROM patients
GROUP BY Medical_Condition
ORDER BY Patient_Count DESC;

# Avg Billing Amount by Medical Condition
SELECT Medical_Condition,
       ROUND(AVG(Billing_Amount), 2) AS Avg_Billing
FROM patients
GROUP BY Medical_Condition
ORDER BY Avg_Billing DESC;

# Avg Length of Stay by Admission Type
SELECT Admission_Type,
       ROUND(AVG(Length_of_Stay), 1) AS Avg_Stay_Days,
       COUNT(*) AS Patient_Count
FROM patients
GROUP BY Admission_Type
ORDER BY Avg_Stay_Days DESC;

#Test Results Distribution
SELECT Test_Results,
       COUNT(*) AS Count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS Percentage
FROM patients
GROUP BY Test_Results
ORDER BY Count DESC;

#Abnormal Test Results by Medical Condition
SELECT Medical_Condition,
       COUNT(*) AS Total_Patients,
       SUM(CASE WHEN Test_Results = 'Abnormal' THEN 1 ELSE 0 END) AS Abnormal_Count,
       ROUND(SUM(CASE WHEN Test_Results = 'Abnormal' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Abnormal_Pct
FROM patients
GROUP BY Medical_Condition
ORDER BY Abnormal_Pct DESC;

#Top 10 Hospitals by Revenue
SELECT Hospital,
       COUNT(*) AS Total_Patients,
       ROUND(SUM(Billing_Amount), 2) AS Total_Revenue,
       ROUND(AVG(Billing_Amount), 2) AS Avg_Billing
FROM patients
GROUP BY Hospital
ORDER BY Total_Revenue DESC
LIMIT 10;

# Insurance Provider Analysis
SELECT Insurance_Provider,
       COUNT(*) AS Patient_Count,
       ROUND(AVG(Billing_Amount), 2) AS Avg_Billing,
       ROUND(SUM(Billing_Amount), 2) AS Total_Billed
FROM patients
GROUP BY Insurance_Provider
ORDER BY Total_Billed DESC;

#High Risk Patients (Urgent/Emergency + Abnormal Results)
SELECT Medical_Condition,
       COUNT(*) AS High_Risk_Count,
       ROUND(AVG(Billing_Amount), 2) AS Avg_Billing,
       ROUND(AVG(Length_of_Stay), 1) AS Avg_Stay
FROM patients
WHERE Admission_Type IN ('Urgent', 'Emergency')
  AND Test_Results = 'Abnormal'
GROUP BY Medical_Condition
ORDER BY High_Risk_Count DESC;




