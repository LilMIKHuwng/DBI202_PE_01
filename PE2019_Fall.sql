-- Không được nộp các câu lệnh Create Database, Use, Go 
Create Database Q1_Temp;

Create Table Departments(
	DepID varchar(15) Primary Key,
	Name nvarchar(60)
);

Create Table Offices(
	OfficeNumber int Primary Key,
	Address nvarchar(30),
	Phone Varchar(15),
	
);

ALTER TABLE Offices
ADD DepID varchar(15) REFERENCES Departments(DepID);

Select * from Offices;

Create Table Employees (
	EmployeeID int Primary Key,
	FullName nvarchar(50),
	OfficeNumber int Foreign Key References Offices(OfficeNumber)
);

Create Table WorkFor(
	EmployeeID int Foreign Key References Employees(EmployeeID),
	DepID varchar(15) Foreign Key References Departments(DepID),
	[From] Date,
	Salary Float,
	[To] Date,
	Primary Key (EmployeeID, DepID, [From]),
);

-- Q2
Select *
From Locations
Where CountryID = 'US' or CountryID = 'CA';

-- Q3 Co chu e or E xuat hien
Select EmployeeID, FirstName, LastName, Salary, Commission_pct, HireDate
From Employees
Where Salary Between 4000 and 10000 and Commission_pct > 0 and (FirstName like '%[Ee]%')
Order By HireDate Desc;

-- Q4
Select 
From Employees e
Join Departments d on d.DepartmentID = e.DepartmentID




