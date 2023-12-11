WITH MaxLocationQuantity AS (
    SELECT pi.LocationID, MAX(pi.Quantity) AS MaxQuantity
    FROM ProductInventory pi
    GROUP BY pi.LocationID
)

SELECT l.LocationID, l.Name, p.ProductID, p.Name, MAX(pi.Quantity) AS MaxQuantity
FROM Product p 
JOIN ProductInventory pi ON pi.ProductID = p.ProductID
JOIN Location l ON l.LocationID = pi.LocationID
JOIN MaxLocationQuantity mlq ON l.LocationID = mlq.LocationID
WHERE pi.Quantity = mlq.MaxQuantity
GROUP BY l.LocationID, l.Name, p.ProductID, p.Name, mlq.MaxQuantity;

SELECT l.LocationID, l.Name, p.ProductID, p.Name, max(pi.Quantity)
FROM Product p 
JOIN ProductInventory pi ON pi.ProductID = p.ProductID
JOIN Location l ON l.LocationID = pi.LocationID
where l.LocationID in (SELECT pi.LocationID
    FROM ProductInventory pi 
    JOIN Location l ON l.LocationID = pi.LocationID
    GROUP BY pi.LocationID)
GROUP BY l.LocationID, l.Name, p.ProductID, p.Name
HAVING max(pi.Quantity) in (
    SELECT max(pi.Quantity)
    FROM ProductInventory pi 
    JOIN Location l ON l.LocationID = pi.LocationID
    GROUP BY pi.LocationID
);

sELECT max(pi.Quantity)
    FROM ProductInventory pi 
    JOIN Location l ON l.LocationID = pi.LocationID
    GROUP BY pi.LocationID