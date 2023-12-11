-- Q2
select * from dbo.Courses where credits > 3;

-- Q3
select a.id AssessmentId, a.type, a.name, a.[percent], c.title CourseTitle 
from dbo.Assessments a
join Courses c on c.id = a.courseId
where c.title = 'Introduction to Databases';

-- Q4
Select e.studentId, st.name, st.department, se.code, se.year, c.title
from Students st
join enroll e on e.studentId = st.id
join Courses c on c.id = e.courseId
join semesters se on se.id = e.semesterId
where c.title = 'Operating Systems'
order by se.year asc, se.code asc, st.id asc

-- Q5
select e.courseId, c.code, c.title, Count(e.enrollId) NumberOfEnrolledStudents
from Courses c
join enroll e on e.courseId = c.id
join semesters s on s.id = e.semesterId
where s.year = 2019
group by e.courseId, c.code, c.title

-- Q6
select top 1 c.id, c.code, c.title, count(distinct a.type) NumberOfAssessmentTypes, count(a.id) NumberOfAssessments
from Courses c
join Assessments a on a.courseId = c.id
group by c.id, c.code, c.title
order by count(a.id) desc

-- Q7 
Select e.enrollId, e.courseId,
c.title, e.studentId, st.name, e.semesterId, se.code, SUM(m.mark * a.[percent]) AS average_mark
from enroll e 
join Courses c on c.id = e.courseId
join Students st on st.id = e.studentId
join semesters se on se.id = e.semesterId
join marks m on m.enrollId = e.enrollId
join Assessments a  on a.courseId = c.id
where c.title = 'Introduction to Databases'
group by e.enrollId, e.courseId,
c.title, e.studentId, st.name, e.semesterId, se.code
order by e.studentId asc, e.semesterId desc

SELECT m.enrollId, c.title, c.id, s.id, s.name, se.id, se.code , SUM(m.mark * a.[percent]) as 'AverageMark' 
FROM 
Students s JOIN enroll e ON s.id = e.studentId
JOIN Courses c ON c.id = e.courseId
JOIN marks m ON m.enrollId = e.enrollId
JOIN Assessments a ON a.id = m.assessmentId
JOIN semesters se ON se.id = e.semesterId
WHERE c.title = 'Introduction to Databases'
GROUP BY m.enrollId, c.id, s.id, s.name, se.code, se.id, c.title
ORDER BY s.id, se.id desc

-- Q8
CREATE PROCEDURE P2 @stID INT, @seCode varchar(20), @num int OUTPUT
AS
  Select @num = count(c.id) 
  from Students st 
  join enroll e on e.studentId = st.id
  join semesters se on se.id = e.semesterId
  join Courses c on c.id = e.courseId
  where st.id = @stID and se.code = @seCode
  --group by st.id, se.code
GO

drop PROCEDURE P2

DECLARE @x INT

EXEC P2 9,'Sp2019', @x OUTPUT
SELECT
  @x AS NumberOfCourses;

-- Q9
DROP TRIGGER Tr1
CREATE TRIGGER Tr1
ON enroll
AFTER INSERT
AS
BEGIN
    INSERT INTO marks (enrollId, assessmentId, mark)
    SELECT i.enrollId, a.id, 0 
    FROM inserted i
    JOIN Courses c ON c.id = i.courseId
    JOIN Assessments a ON a.courseId = c.id;

	select i.enrollId, m.assessmentId, m.mark
	FROM inserted i
    join marks m on m.enrollId = i.enrollId;
    
END;

insert into enroll(enrollId, studentId, courseId, semesterId)
values (600,9,11,4)

delete from enroll where 
enrollId = 600 and studentId = 9
and courseId = 11 and semesterId = 4

select * from enroll 
select * from marks ;


-- Q10
select * from Students s where s.id=110
select *
from Departments

INSERT INTO Students (id, name, birthdate, gender, department)
VALUES (110, 'Mary Jane', '2001-05-12', 'Female',
    (SELECT code FROM Departments WHERE name = 'Business Administration'));
