USE AdventureWorks2008
GO 


-- BREAKING a LOOP - cause loop to stop processing
DECLARE @Count INT = 1

WHILE @Count<50 
BEGIN 
	PRINT @Count;
	
	IF @Count = 10 
	BEGIN 
		PRINT 'EXITING WHILE LOOP'
		BREAK; 
	END 
	SET @Count += 1

END 


-- CONTINUING a LOOP  -- cause loop to continue to the top ; skipping lower statements 
DECLARE @Count INT = 1

WHILE @Count<10 
BEGIN 
	
	PRINT @Count;
	SET @Count += 1
	
	IF @Count = 3 
	BEGIN 
		PRINT 'CONTINUE'
		CONTINUE 
	END 
	
	PRINT 'Bottom of LOOP'

END 


