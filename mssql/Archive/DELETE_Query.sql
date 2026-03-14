USE AdventureWorksLT2008
GO 

-- simple DELETE statement 
DELETE dbo.demoProduct 
WHERE ProductID > 900


-- DELETE via join 
DELETE d 
FROM dbo.demoSalesOrderDetail AS d 
	INNER JOIN dbo.demoSalesOrderHeader AS h 
		ON d.SalesOrderID = h.SalesOrderID 
WHERE h.SalesOrderNumber = 'SO71797' 


-- DELETE via subquery 
SELECT SalesOrderID , ProductID 
FROM dbo.demoSalesOrderDetail
WHERE ProductID NOT IN 
	(SELECT ProductID FROM dbo.demoProduct WHERE ProductID IS NOT NULL)
