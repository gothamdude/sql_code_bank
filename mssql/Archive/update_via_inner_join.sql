-- Update values from columns from FR_SignatureFile 		
UPDATE FR_AccountGraphic 
SET	 FR_AccountGraphic.GraphicFilename = FR_SignatureFile.Filename, 
	 FR_AccountGraphic.GroupID  = FR_SignatureFile.GroupID, 
	 FR_AccountGraphic.ActiveInd = FR_SignatureFile.ActiveInd,
	 FR_AccountGraphic.CreatedBy  = FR_SignatureFile.CreatedBy,  
	 FR_AccountGraphic.CreatedDate = FR_SignatureFile.CreatedDate, 
	 FR_AccountGraphic.ModifiedBy = FR_SignatureFile.ModifiedBy, 
	 FR_AccountGraphic.ModifiedDate = FR_SignatureFile.ModifiedDate 
FROM FR_AccountGraphic 
	INNER JOIN FR_SignatureFile ON FR_AccountGraphic.SignatureFileNameID = FR_SignatureFile.SignatureFileNameID
	
	
		UPDATE Rule_RuleDays  
	SET [Days] =  T.DaysNotice,
		[MaxDays] = T.MaxDaysNotice,
		ModifiedDate = GETDATE(),
		ModifiedBy = 'Data Refresh Delta 5.1'
	FROM Rule_RuleDays Rd
		INNER JOIN @temp T ON Rd.LOBID =  T.LOBID 
								AND Rd.ActionID = T.ActionID 
								AND Rd.StateID = T.StateID
								AND Rd.CircumstanceID = T.CircumstanceID
								AND Rd.BusinessID = T.BusinessID  
								AND Rd.GroupID = T.GroupID 
	WHERE [Days] <> T.DaysNotice  OR [MaxDays] <> T.MaxDaysNotice

