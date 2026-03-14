Use SwapMap 
GO 

-- Check Login PROC 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CheckLogin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CheckLogin]
GO

CREATE PROCEDURE usp_CheckLogin
(
	@pEmail VARCHAR(200),
	@pPassword VARCHAR(100)
) 
AS
BEGIN

	DECLARE @vUserID INT 
	SET @vUserID  = 0  -- NOT FOUND 
	
	IF EXISTS(SELECT UserID 
			  FROM [User] 
			  WHERE UPPER(RTRIM(LTRIM(Email)))= UPPER(RTRIM(LTRIM(@pEmail )))
					AND UPPER(RTRIM(LTRIM([Password])))= UPPER(RTRIM(LTRIM(@pPassword))))
	BEGIN 				
		SET @vUserID = (SELECT UserID 
							FROM [User] 
							WHERE UPPER(RTRIM(LTRIM(Email)))= UPPER(RTRIM(LTRIM(@pEmail)))
									AND UPPER(RTRIM(LTRIM([Password])))= UPPER(RTRIM(LTRIM(@pPassword)))) 
	END 
	ELSE 
	BEGIN 
	
		SET @vUserID = 0 
	
	END 
	
	RETURN @vUserID 
	
END
GO