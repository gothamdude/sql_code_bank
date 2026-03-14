USE [FRGDB]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_RTFActionField]'))
DROP VIEW [dbo].[vw_RTFActionField]
GO

CREATE view [dbo].[vw_RTFActionField] 
AS 


	SELECT  RTFActionFieldID, 
			StateCode
		   ,LOBID
		   ,ActionID
		   ,WhereConditionID
		   ,FormID 
		   ,FieldName
		   ,Label
		   ,DisplayControl
		   ,DisplayGroup
		   ,DisplayOrder
		   ,DisplaySize
		   ,MaxLength
		   ,FieldDisplayed
		   ,[ReadOnly]
		   ,DefaultValue
		   ,FieldDefined
		   ,InputRequired
		   ,RegulatoryRequirement
		   ,CopyGroupID
		   ,EffectiveDateBegin
	FROM RTFActionField 
	WHERE FormID IN (  SELECT DISTINCT FormId 
							FROM AccountFormState 
							WHERE  AcctNum=1948 )
		AND Label IS NOT NULL 
		AND RecordActive =1  
		
GO

