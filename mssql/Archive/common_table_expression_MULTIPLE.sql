/********************************************************************
-- Wolters Kluwer Financial Services 2013 © All rights reserved
-- @Create By : Kerwin Lim  
-- @Date (MM/DD/YY): 01/18/2013
-- @Description:	This is DELTA run of IMPORT_CNR4_5_AccountsFormState for Data Refresh 5.1 
--					
--
********************************************************************/
USE [CNRV5_1_Live]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.[IMPORT_CNR4_5_DELTA_AccountsFormState]') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.[IMPORT_CNR4_5_DELTA_AccountsFormState]
GO


CREATE PROCEDURE IMPORT_CNR4_5_DELTA_AccountsFormState
AS
BEGIN 

	-- Comment: Get all the possible combinations of AccountFormState from AWEB account (i.e. AcctNum = 1269); Store in temp table
	CREATE TABLE #temp (  AcctNum Nvarchar(255)
						, StateCode Nvarchar(255)
						, Uniformno Nvarchar(255)
						, ActionCode Nvarchar(255)
						, LOBAbbr Nvarchar(255)
						, ProductWhereCondition Nvarchar(255)
						, RTFName Nvarchar(255)
						, FormID int 
						, DefinedFieldCount int
						, LOBID int )  --added newly on 2010-12-17

	INSERT INTO #temp (   AcctNum 
						, StateCode
						, Uniformno		
						, ActionCode
						, LOBAbbr
						, ProductWhereCondition 
						, RTFName 
						, FormID  
						, DefinedFieldCount 
						, LOBID ) --added
	SELECT  afs.AcctNum, 
		    afs.StateCode, 
			fr.Uniformno,
		    pa.ActionCode,
			l.LOBAbbr, 
			pc.WhereConditionDesc,
			afs.RTFName,
			afs.FormID,
			Count(*) as DefinedFieldCount
			,ASTW.LOBID --added
	FROM FRGDB.dbo.AccountFormState AS afs
		 INNER JOIN FRGDB.dbo.RTFActionField AS rtfa ON afs.StateCode = rtfa.StateCode
												AND afs.FormID = rtfa.FormID
												AND rtfa.RecordActive = 1 
												AND rtfa.FieldName = 'PolicyNumber'
												AND rtfa.FieldDefined = 1
		INNER JOIN FRGDB.dbo.FormState AS ffs ON afs.StateCode = ffs.StateCode
												AND afs.formid = ffs.formid
												AND afs.AcctNum = 1269
		INNER JOIN FRGDB.dbo.Form AS fr ON afs.FormID = fr.FormID AND  fr.CurrentEdition = 1
		INNER JOIN FRGDB.dbo.ProductAction AS pa ON pa.ActionID = rtfa.ActionID
		INNER JOIN FRGDB.dbo.LOB AS l ON l.lobid= rtfa.lobid
		INNER JOIN FRGDB.dbo.ProductWhereCondition AS pc ON pc.WhereConditionID = rtfa.WhereConditionID
		LEFT JOIN FRGDB.dbo.AccountStateLOBActionWhere AS ASTW ON ASTW.statecode =  rtfa.statecode
																AND ASTW.lobid = rtfa.lobid
																AND ASTW.actionid = rtfa.ActionID
																AND ASTW.whereconditionid = rtfa.WhereConditionID
																AND ASTW.AcctNum = 1269
	GROUP BY  afs.AcctNum
			, afs.StateCode
			, fr.Uniformno
			, pa.ActionCode
			, l.LOBAbbr
			, pc.WhereConditionDesc
			, afs.RTFName
			, afs.FormID
			, ASTW.LOBID --added
	ORDER BY  afs.AcctNum
			, afs.StateCode
			, fr.Uniformno
			, pa.ActionCode
			, l.LOBAbbr
			, pc.WhereConditionDesc
			, afs.RTFName
			, afs.FormID
	
	-- Comment: Get whole list of OrganizationID and GroupID combinations then place in cursor
	DECLARE @vOrganizationID INT 
	DECLARE @vGroupID INT 
	DECLARE @vCNRStandardID INT 
	
	SET @vCNRStandardID = 11296   -- CNR Standard Prod ID
	
	DECLARE curOrgGrpIDs CURSOR FOR
	SELECT DISTINCT OrganizationID, RecordID
	FROM ENT_TOrganizationGroup
	WHERE Active = 1
	ORDER BY OrganizationID, RecordID
	
	OPEN curOrgGrpIDs
	
	FETCH NEXT FROM curOrgGrpIDs INTO  @vOrganizationID, @vGroupID

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		WITH CTE_State_Attribs     -- JURISDICTION AttributeIDs
		AS (	SELECT DISTINCT AttributeID
				FROM ENT_GroupSubscribtions
				WHERE GroupID =  @vGroupID
					AND ProdID = @vCNRStandardID 
					AND AttributeID  IN (SELECT DISTINCT AttributeID FROM dbo.ENTAttr_TAttribute WHERE AttributeTypeID = 1000 )), 

		CTE_LOB_Attribs    -- LOB AttributeIDs
		AS (	SELECT DISTINCT AttributeID
				FROM ENT_GroupSubscribtions
				WHERE GroupID = @vGroupID
					AND ProdID = @vCNRStandardID 
					AND AttributeID  IN (SELECT DISTINCT AttributeID FROM dbo.ENTAttr_TAttribute WHERE AttributeTypeID = 1002) ),  
		
		CTE_AccountFormState      -- Get subset of FR_AccountFormState for each Account
		AS(		SELECT DISTINCT StateID, 
								ActionID,
								LOBId,  
								CircumstanceID,
								FormID
				FROM FR_AccountFormState
				WHERE BusinessID = @vOrganizationID 
							AND GroupID =  @vGroupID 
							AND ActiveInd = 1) 
		
		INSERT INTO FR_AccountFormState(
				[StateID]
			   ,[ActionID]
			   ,[LobID]
			   ,[CircumstanceID]
			   ,[FormID]
			   ,[DefinedFieldCount]
			   ,RTFName
			   ,BusinessId
			   ,GroupId
			   ,ActiveInd
			   ,UseThisEditionInd --adding field
			   ,ModifiedDate
			   ,ModifiedBy)
		SELECT rs.stateId
			   ,ra.actionid
			   ,rl.Lobid
			   ,rc.[CircumstanceID]
			   ,ff.formid
			   ,fac.[DefinedFieldCount]
			   ,fac.RTFName
			   ,@vOrganizationID
			   ,@vGroupID
			   ,CASE WHEN fac.LOBID IS NOT NULL THEN 1 ELSE 0 END --0
			   ,1
			   ,GETDATE()
			   ,'Data Refresh 5.1'
		FROM #temp as fac 
			INNER JOIN Rule_State rs ON rs.statecode = fac.statecode
			INNER JOIN Rule_Action ra ON ra.Code = fac.actioncode
			INNER JOIN Rule_LOB rl ON rl.LOBAbbr = fac.LOBAbbr
			INNER JOIN Rule_Circumstance rc ON fac.ProductWhereCondition = rc.CriteriaDesc
			INNER JOIN FR_Form ff ON  fac.Uniformno = ff.Uniformno
		WHERE rs.StateID IN (SELECT DISTINCT AttributeID FROM CTE_State_Attribs)
			AND rl.LOBID IN (SELECT DISTINCT AttributeID FROM CTE_LOB_Attribs)
			AND ([dbo].[udf_Check_AccountFormStateRow](rs.StateID,rs.ActionID,rs.LobID, rc.CircumstanceID, ff.FormID, @vOrganizationID, @vGroupID) <> 1) 
	
		
	 FETCH NEXT FROM curOrgGrpIDs INTO  @vOrganizationID, @vGroupID
	 
 	END 
	
	CLOSE curOrgGrpIDs
	
	DEALLOCATE curOrgGrpIDs
	
 
	DROP TABLE  #temp

	
END
GO 

  