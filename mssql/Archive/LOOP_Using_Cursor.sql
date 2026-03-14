USE SwapMap 
GO 

-- LOOPING Using Curosr 
BEGIN 


	DECLARE @vItemName VARCHAR(100), @vItemDescription VARCHAR(500), @vItemActive BIT
	
	DECLARE itemCursor CURSOR FAST_FORWARD FOR 
		SELECT ItemName, ItemDescription, ItemActive
		FROM SomeTable 
		WHERE Filter = 'WHAT EVER VALUE'

	OPEN itemCursor 
	
	FETCH NEXT FROM itemCursor INTO @vItemName, @vItemDescription, @vItemActive
	
	WHILE @@FETCH_STATUS = 0
	BEGIN 
			
			-- do whatever needs to be done here 
	
		FETCH NEXT FROM itemCursor INTO @vItemName, @vItemDescription, @vItemActive
	END 
	
	CLOSE itemCursor 
	DEALLOCATE itemCursor 

END 
GO 

