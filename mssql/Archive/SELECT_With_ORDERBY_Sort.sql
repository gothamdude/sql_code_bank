USE AdventureWorks2008
GO

SELECT ProductID, Name, ProductNumber, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice <> 0.00
ORDER BY ListPrice  ASC -- DEFAULT ; lowest to highest


SELECT ProductID, Name, ProductNumber, Color, ListPrice 
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice <> 0.00
ORDER BY ListPrice  DESC -- Other way around ; highest to lowest 


SELECT SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, LineTotal 
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderID, SalesOrderDetailID  -- MULTIPLE SORT 