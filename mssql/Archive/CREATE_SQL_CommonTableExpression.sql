USE AdventureWorks2008 
GO 


-- NOTE: You cannot use ORDER BY in Common Table Expression 
-- WHEN creating more than one CTE, you will need to separate using comma
-- succeeding CTEs do not need 'WITH' phrase  

With CTE AS (
SELECT ProductID, Name, ProductNumber, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice <> 0.00 ) 

SELECT * 
FROM CTE 