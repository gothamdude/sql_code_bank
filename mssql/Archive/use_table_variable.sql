
	DECLARE @tblCircumstance TABLE ( RowID INT IDENTITY(1,1)
									,CriteriaDesc VARCHAR(140)
									,[Definition] VARCHAR(1024)
									,DisplayOrder INT
									,ActiveInd INT ) 
	
	INSERT INTO @tblCircumstance ( 	CriteriaDesc 
									,[Definition] 
									,DisplayOrder 
									,ActiveInd )
	SELECT		 RTRIM(LTRIM([WhereConditionDesc]))
				,RTRIM(LTRIM(CONVERT(VARCHAR(1024),[Definition])))
				,ISNULL([DisplayOrder],0)
				,[RecordActive]
	FROM [FRGDB].[dbo].[ProductWhereCondition]  
	WHERE [RecordActive] = 1  
	ORDER BY [WhereConditionID]
	
	SELECT * FROM  @tblCircumstance