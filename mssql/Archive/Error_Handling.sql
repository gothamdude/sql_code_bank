USE AdventureWorks2008
GO 


-- @@Error function returns a number greater then zero if an error exists 

DECLARE @errorNo INT 

SET IDENTITY_INSERT Person.ContactType ON;

INSERT INTO Person.ContactType  (ContactTypeID, Name, ModifiedDate)
VALUES (1, 'Accounting Manager', GETDATE())
SET @errorNo = @@ERROR

IF @errorNo >0 
BEGIN 
	PRINT ' An error has occurred'; 
	PRINT @errorNo;
END 



