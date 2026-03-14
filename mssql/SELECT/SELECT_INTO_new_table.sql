USE AdventureWorks2008
GO 


SELECT BusinessEntityID,
Name,
SalesPersonID,
Demographics
INTO Store_Archive
FROM Sales.Store