USE AdventureWorks2008
GO 

-- by turning on ROWCOUNT  setting, you can specify the number of rows addected by each execution of the statement 
-- the setting stays in effect for the currenct connection until it is turned off 

SET ROWCOUNT 0; 

INSERT INTO dbo.demoSalesOrderDetail(SalesOrderID, SaledOrderDetailID, Processed) 
SELECT SalesOrderID, SalesOrderDetailID, 0 
FROM Sales.SalesOrderDetailID 
PRINT 'Populted Work Table!'


SET ROWCOUNT 5000;     -- this tells while to execute in intervale of 50000
WHILE EXISTS(SELECT * FROM dbo.demoSalesOrderDetail WHERE Process = 0 ) 
BEGIN 

	UPDATE dbo.demoSalesOrderDetail      
	SET Processed = 1 
	PRINT 'Updated 50000 rows'
	
END 
PRINT 'DONE!'

