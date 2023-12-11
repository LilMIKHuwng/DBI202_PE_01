-- Q2
select d.location_id, d.department_id, d.department_name from departments d where location_id > 2400;

-- Q3
select l.location_id, c.country_id, l.street_address, l.city
from locations l
join countries c on c.country_id = l.country_id
where c.country_id = 'US' or c.country_id = 'CA'
order by l.location_id desc

-- Q4
select e.employee_id, e.first_name + ', '+e.last_name as full_name, j.job_title, e.phone_number
from employees e
join jobs j on j.job_id = e.job_id
where e.phone_number like '590%'
order by e.phone_number 

-- Q5
select d.department_id, d.department_name , Min(e.salary) as [MIN(salary)]
from departments d
join employees e on e.department_id = d.department_id
group by d.department_id, d.department_name
order by [MIN(salary)]

-- Q6
SELECT TOP 10 e.first_name, e.last_name
FROM employees e
WHERE e.employee_id NOT IN (SELECT manager_id FROM employees WHERE manager_id IS NOT NULL)
ORDER BY e.first_name;

select * from employees

-- Q7
select c.country_id, c.country_name, Count(e.employee_id) as [number of employees]
from countries c
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
join employees e on e.department_id = d.department_id
group by c.country_id, c.country_name
having Count(e.employee_id) >= 2
order by Count(e.employee_id) desc

-- Q8
DROP TRIGGER Salary_Min_Max
CREATE TRIGGER Salary_Min_Max
ON employees
FOR UPDATE
AS
BEGIN
    DECLARE @maximum DECIMAL(10, 2)
	DECLARE @minimum DECIMAL(10, 2)
    DECLARE @NewSalary DECIMAL(10, 2)

    SELECT @maximum = j.max_salary, @minimum = j.min_salary
    FROM deleted d
	join jobs j on j.job_id = d.job_id

    SELECT @NewSalary = salary
    FROM inserted

    IF (@NewSalary < @minimum or @NewSalary > @maximum)
    BEGIN
        ROLLBACK TRANSACTION
    END
END;

update employees
set salary = 37000
where employee_id = 102

select * from employees where employee_id = 102;

select e.employee_id, j.min_salary, j.max_salary
from employees e
join jobs j on j.job_id = e.job_id
where e.employee_id = 102;

-- Q9
CREATE Function Get_ManagerID2( @eID INT )
Returns int
AS
begin
	declare @mID int
   SELECT
    @mID = e.manager_id
  FROM employees e
  WHERE e.employee_id = @eID
  return @mID
end;

DECLARE @id int = 101
select @id as EmployeeID, dbo.Get_ManagerID2(@id) as ManagerID

-- 10

delete from dependents where first_name = 'Alexander';
