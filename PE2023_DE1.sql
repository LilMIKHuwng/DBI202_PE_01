-- Q1
Create table Customers(
	CustormerID int Primary Key,
	CustomerAddress nvarchar(100),
	CustomerPhone varchar(20)
);

Create table Manufacturers(
	ManufacturerID int Primary Key,
	ManufacturerAddress nvarchar(100),
	ManufacturerPhone varchar(20),
	ManufacturerFax varchar(20)
);

Create table Laptops(
	LaptopSKU varchar(10) Primary Key,
	LaptopName nvarchar(150),
	Price decimal(5,2),
	Descriptions nvarchar(100),
	ManufacturerID int foreign key references Manufacturers(ManufacturerID)
);

Create table Purchase(
	CustormerID int foreign key references Customers(CustormerID),
	LaptopSKU varchar(10) foreign key references Laptops(LaptopSKU),
	[Date] DateTime,
	Quantity int
	Primary Key(CustormerID, LaptopSKU)
);

-- Q2
Select e.employee_id, e.first_name, e.last_name
from employees e
where e.employee_id < 105;

-- Q3
Select l.location_id, l.street_address, d.department_name, l.city
from locations l
join departments d on d.location_id = l.location_id
where d.department_name = 'IT' or d.department_name = 'Marketing'
order by l.location_id asc;

-- Q4
select e.first_name +', '+e.last_name as full_name, j.job_title, d.department_name, e.salary
from employees e
join departments d on d.department_id = e.department_id
join locations l on l.location_id = d.location_id
join jobs j on j.job_id = e.job_id
where e.salary > 7000 and e.job_id = 16
order by e.salary asc;

-- Q5
select e.department_id, d.department_name, Max(e.salary) as [MAX(salary)]
from employees e
join departments d on d.department_id = e.department_id
group by e.department_id, d.department_name
order by [MAX(salary)] desc;

-- Q6 
select top 5 e.first_name, e.last_name 
from employees e
inner join jobs j on j.job_id = e.job_id
where j.job_title like '%Manager%'
order by e.first_name asc;

select top 5 e1.first_name, e1.last_name 
from employees e
join employees e1 on e.manager_id = e1.employee_id
group by e1.first_name, e1.last_name
order by e1.first_name asc;

-- Q7
select c.country_id, c.country_name, Count(e.employee_id) as [number of employees]
from countries c
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
join employees e on e.department_id = d.department_id
group by c.country_id, c.country_name
HAVING Count(e.employee_id) > 2
order by Count(e.employee_id) desc;

-- Q8
DROP TRIGGER Salary_Not_Decrease
CREATE TRIGGER Salary_Not_Decrease
ON employees
FOR UPDATE
AS
BEGIN
    DECLARE @OldSalary DECIMAL(10, 2)
    DECLARE @NewSalary DECIMAL(10, 2)

    SELECT @OldSalary = salary
    FROM deleted

    SELECT @NewSalary = salary
    FROM inserted

    IF @NewSalary < @OldSalary
    BEGIN
        ROLLBACK TRANSACTION
    END
END;

UPDATE employees
SET salary = 0
WHERE employee_id = 101;

select e.salary
from employees e
where e.employee_id = 101

-- Q9
CREATE PROCEDURE Get_ManagerID @eID INT, @mID INT OUTPUT
AS
  SELECT
    @mID = e.manager_id
  FROM employees e
  WHERE e.employee_id = @eID
GO

DECLARE @x INT
DECLARE @in INT = 101;
EXEC Get_ManagerID @in, @x OUTPUT
SELECT
  @x AS ManagerID;

-- 10
delete from dependents 
where dependent_id in (
	select d.dependent_id
	from dependents d
	where d.first_name = 'Karen'
)

select d.first_name from dependents d where d.first_name = 'Karen'


