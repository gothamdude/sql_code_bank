USE AdventureWorks2008
GO 


-- 1. EXPLICIT TRANSACTION
BEGIN TRAN 
 
	-- DO ALL THINGS HERE 
	INSERT INTO dbo.demoTransaction (col1) VALUES (3)
	INSERT INTO dbo.demoTransaction (col1) VALUES (4)
	INSERT INTO dbo.demoTransaction (col1) VALUES (5)
	
COMMIT TRAN 




-- 2. EXPLICIT TRANSACTION WITH ROLLBACK 
BEGIN TRAN 

	-- DO ALL THINGS HERE 
	INSERT INTO dbo.demoTransaction (col1) VALUES (3)
	INSERT INTO dbo.demoTransaction (col1) VALUES (4)
	INSERT INTO dbo.demoTransaction (col1) VALUES (5)

ROLLBACK TRAN 
