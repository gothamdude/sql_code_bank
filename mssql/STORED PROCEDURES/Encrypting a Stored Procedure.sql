-- Encrypting a Stored Procedure

/*In order to encrypt the stored procedure, WITH ENCRYPTION is designated after the name of the
new stored procedure, as this next example demonstrates:*/
CREATE PROCEDURE dbo.usp_SEL_EmployeePayHistory
WITH ENCRYPTION
AS
SELECT EmployeeID, RateChangeDate, Rate, PayFrequency, ModifiedDate
FROM HumanResources.EmployeePayHistory
GO
-- Once you’ve created WITH ENCRYPTION, you’ll be unable to view the procedure’s text definition:
-- View the procedure's text
EXEC sp_helptext usp_SEL_EmployeePayHistory

/*
This returns
The text for object 'usp_SEL_EmployeePayHistory' is encrypted.
*/