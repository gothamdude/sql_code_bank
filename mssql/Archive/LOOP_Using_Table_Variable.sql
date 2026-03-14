USE SwapMap 
GO 

-- THIS IS SCRIPT FOR LOOPING TRHOUGH RECORDSET 
-- THIS REPLACES A CURSOR USING A TABLE VARIABLE 
-- TAKE NOTE THAT IF RECORDSET IS BIG ; BETTER USE CURSOR INSTEAD

BEGIN 


	DECLARE @tblItems TABLE (RowID INT IDENTITY(1,1), Col1 VARCHAR(100), Col2 VARCHAR(500), Col3 BIT)
	
	INSERT INTO @tblItems (Col1, Col2, Col3)
	SELECT ItemName, ItemDescription, ItemActive
	FROM SomeTable 
	WHERE Filter = 'WHAT EVER VALUE'


	DECLARE @vLoopCount INT 
	DECLARE @vTotalRows INT 
	DECLARE @vItemName VARCHAR(100), @vItemDescription VARCHAR(500), @vItemActive BIT
	
	SET @vLoopCount = 1
	SET @vTotalRows = (SELECT COUNT(*) FROM @tblItems)

	WHILE (@vLoopCount<=@vTotalRows)
	BEGIN 
	
		SELECT @vItemName = Col1, 
			   @vItemDescription = Col2,
			   @vItemActive = Col3
		FROM  @tblItems	
		WHERE RowID = @vLoopCount
		
		
		/***********************
		
		-- DO WHATEVERE INSERT OR UPDATE PROCESSING NEEDED HERE USING THE VARIABLE 
	
		************************/
	
	
		SET @vLoopCount += 1
	
	END 
	
	
	-- NO NEED TO DROP SINCE TABLE VARIABLE 


END 
GO 

