-- Q2
select * from ProductSubcategory 
where Category = 'Accessories';

-- Q3
select  p.ProductID, p.Name, p.Color, p.Cost, p.Price, p.SellEndDate
from Product p
where p.Cost < 100 and p.SellEndDate is not null
order by p.Cost;

-- Q4
select p.ProductID, p.Name ProductName, p.Price, pm.Name ModelName, ps.Name SubCategoryName, ps.Category
from Product p 
left join ProductSubcategory PS on p.SubcategoryID = ps.SubcategoryID
left join ProductModel PM on p.ModelID = pm.ModelID
where p.Price < 100 and p.Color = 'Black';

-- Q5
SELECT
    ps.SubcategoryID,
    ps.Name AS SubCategoryName,
    ps.Category,
    COUNT(DISTINCT p.ProductID) AS NumberOfProducts
FROM
    ProductSubcategory ps
INNER JOIN
    Product p ON ps.SubcategoryID = p.SubcategoryID
GROUP BY
    ps.SubcategoryID, ps.Name, ps.Category
ORDER BY
    ps.Category ASC, NumberOfProducts DESC, ps.Name ASC;

-- Q6
SELECT
    l.LocationID,
    l.Name LocationName,
    COUNT(DISTINCT p.ProductID) AS NumberOfProducts
FROM
    Location l
inner join ProductInventory pi on pi.LocationID = l.LocationID
INNER JOIN
    Product p ON pi.ProductID = p.ProductID
GROUP BY
    l.LocationID, l.Name
HAVING
    COUNT(DISTINCT p.ProductID) = (
        SELECT MIN(NumberOfProducts)
        FROM (
            SELECT LocationID, COUNT(DISTINCT ProductID) AS NumberOfProducts
            FROM ProductInventory
            GROUP BY LocationID
        ) AS MinProducts
    );

-- Q7
WITH SubcategoryCounts AS (
  SELECT
    ps.Category,
    ps.Name AS Subcategory,
    COUNT(DISTINCT p.ProductID) AS NumberOfProducts
  FROM
    ProductSubcategory ps
  INNER JOIN
    Product p ON ps.SubcategoryID = p.SubcategoryID
  GROUP BY
    ps.Category, ps.Name
),
RankedSubcategories AS (
  SELECT
    Category,
    Subcategory,
    NumberOfProducts,
    ROW_NUMBER() OVER(PARTITION BY Category ORDER BY NumberOfProducts DESC) AS RowNum
  FROM
    SubcategoryCounts
)
SELECT
  Category,
  Subcategory,
  NumberOfProducts
FROM
  RankedSubcategories
WHERE
  RowNum = 1
ORDER BY
  NumberOfProducts desc;

-- C2
WITH SubcategoryCounts AS (
  SELECT 
    ps.Category,
    ps.Name AS Subcategory,
    COUNT(DISTINCT p.ProductID) AS NumberOfProducts
  FROM
    ProductSubcategory ps
  INNER JOIN
    Product p ON ps.SubcategoryID = p.SubcategoryID
  GROUP BY
    ps.Category, ps.Name
)

SELECT
  s.Category,
  s.Subcategory,
  s.NumberOfProducts
FROM
  SubcategoryCounts s
WHERE
  s.NumberOfProducts = (
    SELECT Max(NumberOfProducts)
    FROM SubcategoryCounts
    WHERE Category = s.Category
  )
ORDER BY
  s.NumberOfProducts desc;

-- Q8
CREATE FUNCTION proc_product_model(@modelID int)
RETURNS int
AS
BEGIN
    DECLARE @numberOfProducts int
    SELECT @numberOfProducts = Count( Distinct p.ProductID )
    FROM Product p
	inner join ProductModel pm on pm.ModelID = p.ModelID 
    WHERE pm.ModelID = @modelID
	Group by p.ModelID;
    RETURN @numberOfProducts;
END;

DROP FUNCTION proc_product_model;

Select dbo.proc_product_model(9) as NumberOfProducts;

-- Q9
CREATE TABLE TempProductInfo (
    ProductID int,
    ProductName nvarchar(max),
	ModelID int,
	ModelName nvarchar(max),
);

Delete from TempProductInfo;
Drop Table TempProductInfo;

CREATE TRIGGER tr_insert_Product
ON Product
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ProductID int;
    DECLARE @ProductName NVARCHAR(max);
	DECLARE @ModelID int;
    DECLARE @ModelName NVARCHAR(max);

    -- Fetch the recently inserted product data
    SELECT @ProductID = i.ProductID, @ProductName = i.Name, @ModelID = i.ModelID, @ModelName = pm.Name
    FROM inserted i
    INNER JOIN ProductModel pm ON i.ModelID = pm.ModelID

    -- Insert the data into the TempProductInfo table
    INSERT INTO TempProductInfo (ProductID, ProductName, ModelID, ModelName)
    VALUES ( @ProductID, @ProductName, @ModelID, @ModelName);

    -- You can also display the data here if needed
    Select * from TempProductInfo;
	Delete from TempProductInfo;
END;

DROP TRIGGER tr_insert_Product;

insert into Product(ProductID, Name, Cost, Price, ModelID, SellStartDate)
values (1001, 'Product Test', 12, 15.5, 1,'2021-10-25');

DELETE FROM Product
WHERE ProductID >= 1000;

-- Q10
DELETE pi
FROM ProductInventory pi
JOIN Product p ON pi.ProductID = p.ProductID
WHERE p.ModelID = 33;

Select * from ProductInventory pi
inner join Product p on pi.ProductID = p.ProductID
where p.ModelID = 33;
