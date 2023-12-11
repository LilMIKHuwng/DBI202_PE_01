-- Q6
select * 
from EMPLOYEE e
join DEPENDENT d on e.Ssn = d.Essn
where e.Ssn not in (select d.Essn from DEPENDENT d)
or (Year(GETDATE()) - YEAR(d.Bdate)) < 18

select * from DEPENDENT
select * from EMPLOYEE

SELECT e.*
FROM EMPLOYEE e
WHERE e.Ssn NOT IN (SELECT d.Essn FROM DEPENDENT d)

UNION

SELECT e.*
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
WHERE (YEAR(GETDATE()) - YEAR(d.Bdate)) < 18;


-- Q8

CREATE PROC updateSalary (
	@location varchar(15)
)
AS	
	BEGIN 
		UPDATE EMPLOYEE 
		SET Salary = Salary + Salary*0.1 
		WHERE Ssn IN(
					SELECT Ssn FROM EMPLOYEE e JOIN DEPT_LOCATIONS d ON e.Dno = d.Dnumber WHERE d.Dlocation = @location AND e.Salary < 30000
					) 
		SELECT e.* FROM EMPLOYEE e JOIN DEPT_LOCATIONS d ON e.Dno = d.Dnumber WHERE  d.Dlocation = @location
	END

-- Q10
UPDATE EMPLOYEE
	SET Salary = Salary + Salary*0.1 WHERE ssn IN (SELECT e.Ssn FROM EMPLOYEE e JOIN DEPENDENT d ON e.Ssn = d.Essn WHERE (year(GETDATE()) - YEAR(d.Bdate)) < 18)

	SELECT * FROM EMPLOYEE left JOIN DEPENDENT ON EMPLOYEE.SSN = DEPENDENT.Essn WHERE (year(GETDATE()) - YEAR(DEPENDENT.Bdate)) < 18