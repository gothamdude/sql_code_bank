	WITH CTE_FormField (FormID, FieldID) AS (
		SELECT DISTINCT FormID, FieldID 
		FROM FR_FormField
		WHERE [Active] = 1
	)
	
		--SELECT * FROM CTE_FormField

	SELECT CTE.* 
	FROM [FRGDB].[dbo].[RTFActionField] RTFA		
		 INNER JOIN	[FRGDB].[dbo].Form f ON RTFA.FormId = F.FormId AND F.formid IN (SELECT DISTINCT FormId FROM [FRGDB].dbo.[AccountFormState] WHERE AcctNum =1948)
		 INNER JOIN FR_Field FF ON RTFA.FieldName = FF.FieldName
 		 INNER JOIN [FRGDB].[dbo].FieldMaster FM ON FM.fieldname = FF.FieldName 
         INNER JOIN FR_Form F1 ON F1.UniformNo = F.UniformNo
         LEFT OUTER JOIN CTE_FormField AS CTE ON F1.FormID = CTE.FormID AND FF.FieldID = CTE.FieldID 					
	WHERE RTFA.RecordActive = 1 AND CTE.FormID IS NULL AND CTE.FieldID IS NULL 
 	--ORDER BY FormId, FieldName ASC