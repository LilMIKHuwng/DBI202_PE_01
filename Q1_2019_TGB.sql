-- Create the Q1_PE_2019 database
CREATE DATABASE Q1_PE_2019;

-- Use the newly created database
USE Q1_PE_2019;

-- Create the Student table
CREATE TABLE Student (
StudentID INT PRIMARY KEY,
Name VARCHAR(50),
Address VARCHAR(200),
Gender char(1)
);

-- Create the Teachers table
CREATE TABLE Teachers (
TeacherID INT PRIMARY KEY,
Name VARCHAR(50),
Address VARCHAR(200),
Gender CHAR(1)
);

-- Create the Classes table
CREATE TABLE Classes (
ClassID INT PRIMARY KEY,
Semester CHAR(10),
Year INT,
NoCredits INT,
CourseID char(6),
GroupID char(6),
TeacherID INT,
FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);

-- Create the Attend table
CREATE TABLE Attend (
Date DATE,
Slot INT,
StudentID INT,
ClassID INT,
Attend BIT,
PRIMARY KEY (Date, Slot, StudentID, ClassID),
FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);