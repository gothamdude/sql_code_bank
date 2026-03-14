USE AdventureWorks2008
GO 

-- Joining to a DERIVED tables 

SELECT c.CustomerID, s.SalesOrderID  
FROM Sales.Customer C
	INNER JOIN ( SELECT SalesOrderID, CustomerID	
				 FROM Sales.SalesOrderHeader ) S ON c.CustomerID = s.CustomerID 
				