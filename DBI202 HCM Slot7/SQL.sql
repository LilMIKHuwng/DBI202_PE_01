-- Q2
select *
from tblInvoices i
where i.employeeid = 'S002';
-- Q3
select p.proid, p.proname, s.supname
from tblProducts p
join tblSuppliers s on s.supcode = p.supcode
where s.supname = 'Hoan Vu';

-- Q5
select * from tblInv_Detail
select  i.employeeid, Count(i.invid) as [Total Number]
from tblInvoices i
group by i.employeeid

-- Q6
select  d.invid, sum (d.quantity * d.price) as [Total amount]
from tblInv_Detail d
group by d.invid

SELECT top 1 invid, MAX([Total price]) as [Total amount]
FROM (
    SELECT invid, SUM(quantity * price) AS [Total price]
    FROM tblInv_Detail
    GROUP BY invid
) AS s
GROUP BY invid
order by MAX([Total price]) desc;

-- Q7
select i.invid, i.invdate, p.proid, d.quantity, d.price
from tblInv_Detail d
join tblInvoices i on i.invid = d.invid
join tblProducts p on p.proid = d.proid
where i.employeeid = 'S003'


-- Q8
create procedure proProductNumber @supcode nvarchar(2),@total int
output
as 
	select @total = count(p.proid) from tblSuppliers s
	inner join tblProducts p 
	on s.supcode = p.supcode
	where s.supcode = @supcode
	group by s.supcode
go
declare @Productnumber int
exec proProductNumber'MT',@Productnumber output
select @Productnumber

-- Q9
-- Create a trigger to print total amount on insert
CREATE TRIGGER trg_PrintTotalAmount
ON tblinv_Detail
AFTER INSERT
AS
BEGIN

    -- Get the newly inserted invoice details
    SELECT i.invid, SUM(d.quantity * d.price) as [Total_Amount]
    FROM tblinv_Detail d
    INNER JOIN inserted i ON d.invid = i.invid
    GROUP BY i.invid;
  
END;

drop trigger trg_PrintTotalAmount

insert into dbo.tblInv_Detail
values('000003', 'RTPL02', 1, 10000000);
select * from dbo.tblInv_Detail

delete from dbo.tblInv_Detail where invid = '000003' and proid = 'RTPL02'

-- Q10
select * from tblInvoices

Delete from dbo.tblInvoices where customer = 'Lê Minh phương';