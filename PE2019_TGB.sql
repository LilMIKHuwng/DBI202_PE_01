-- Q2
Select * From Customer where city = 'Arlington' and Segment = 'Consumer';

-- Q3
Select c.ID, c.CustomerName, c.Segment, c.Country, c.City, c.State, c.PostalCode, c.Region 
From Customer c 
inner join Orders o on c.ID = o.CustomerID
where c.CustomerName like 'B%' and MONTH(o.OrderDate) = 12 and YEAR(o.OrderDate) = 2017
order by c.Segment desc, c.CustomerName asc;

-- Q4
SELECT 
    sc.ID, 
    sc.SubCategoryName, 
    COUNT(od.Quantity) AS NumberOfProducts
FROM SubCategory sc
inner join Product p on sc.ID = p.SubCategoryID
inner join OrderDetails od on p.ID = od.ProductID
GROUP BY sc.ID, sc.SubCategoryName
HAVING COUNT(od.Quantity) > 100
ORDER BY NumberOfProducts DESC;

-- Q5
WITH MaxQuantityProducts AS (
  SELECT
    ProductID,
    ProductName,
    Quantity,
    OrderID
  FROM Product p
  inner join OrderDetails od on p.ID = od.ProductID
  WHERE Quantity = (SELECT MAX(Quantity) FROM OrderDetails)
)
SELECT
  ProductID,
  ProductName,
  Quantity
FROM MaxQuantityProducts;

-- Q6
WITH CustomerOrderCounts AS (
  SELECT
    c.ID,
    c.CustomerName,
    COUNT(o.ID) AS NumberOfOrders
  FROM Customer c
  LEFT JOIN Orders o ON c.ID = o.CustomerID
  GROUP BY c.ID, c.CustomerName
)
SELECT
  ID,
  CustomerName,
  NumberOfOrders
FROM CustomerOrderCounts
WHERE NumberOfOrders = (SELECT MAX(NumberOfOrders) FROM CustomerOrderCounts);

-- Q7
-- 5 products with the highest unit prices
SELECT TOP 5
    ID,
    ProductName,
    UnitPrice
FROM Product
ORDER BY UnitPrice DESC;

-- 5 products with the smallest unit prices
SELECT TOP 5
    ID,
    ProductName,
    UnitPrice
FROM Product
ORDER BY UnitPrice ASC;

-- Create a temporary table for the lowest priced products
SELECT TOP 5
    p.ID,
    ProductName,
    UnitPrice,
	p.SubCategoryID
INTO #LowestPriceds
FROM Product p 
ORDER BY UnitPrice ASC;

-- Create a temporary table for the highest priced products
SELECT TOP 5
    p.ID,
    ProductName,
    UnitPrice,
	p.SubCategoryID
INTO #HighestPriceds
FROM Product p
ORDER BY UnitPrice DESC 

-- Combine the results from both temporary tables

SELECT * FROM #HighestPriceds
UNION ALL
SELECT * FROM #LowestPriceds
ORDER BY UnitPrice DESC;

-- Q8
CREATE FUNCTION CountOrderID(@orderID nvarchar(255))
RETURNS int
AS
BEGIN
    DECLARE @total int
    SELECT @total = Count(od.ProductID)
    FROM OrderDetails od
	inner join Orders o on o.ID = od.OrderID 
    WHERE o.ID = @orderID
	Group by o.ID;
    RETURN @total;
END;

DROP FUNCTION CountOrderID;

Select dbo.CountOrderID('CA-2014-100391') as CountOrderID;

-- Q9
CREATE TABLE TempProductInfo (
    ProductName NVARCHAR(MAX),
    SubCategoryName NVARCHAR(MAX)
);

CREATE TRIGGER InsertProduct
ON Product
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductName NVARCHAR(MAX);
    DECLARE @SubCategoryName NVARCHAR(MAX);

    -- Fetch the recently inserted product data
    SELECT @ProductName = i.ProductName, @SubCategoryName = s.SubCategoryName
    FROM inserted i
    INNER JOIN SubCategory s ON i.SubCategoryID = s.ID;

    -- Insert the data into the TempProductInfo table
    INSERT INTO TempProductInfo (ProductName, SubCategoryName)
    VALUES (@ProductName, @SubCategoryName);

    -- You can also display the data here if needed
    PRINT 'New Product Inserted: ProductName = ' + @ProductName + ', SubCategoryName = ' + @SubCategoryName;
END;

DROP TRIGGER InsertProduct;

insert into Product(ProductName, UnitPrice, SubCategoryID)
values ('Craft paper', 0.5, 3);

Select * from TempProductInfo;

-- Q10
INSERT INTO Category(CategoryName) VALUES 
('Sports');

INSERT INTO dbo.SubCategory(SubCategoryName) VALUES 
('Tennis'),
('Football');


DELETE FROM SubCategory
WHERE SubCategoryName IN ('Tennis', 'Football');
DBCC CHECKIDENT ('SubCategory', RESEED, 0);

Select * from Category;
Select * from Orders;
Select * from SubCategory;
