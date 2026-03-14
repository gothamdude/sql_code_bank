/*
The ENCRYPTION OPTION in the CREATE VIEW and ALTER VIEW commands allows you to encrypt the
Transact-SQL of a view. Once encrypted, you can no longer view the definition in the sys.
sql_modules systemcatalog view. Software vendors who use SQL Server in the back end often
encrypt their views or stored procedures in order to prevent tampering or reverse-engineering from
clients or competitors. If you use encryption, be sure to save the original, unencrypted definition.

This example demonstrates encrypting the Transact-SQL definition of a new view:
*/

CREATE VIEW dbo.v_Product_TopTenListPrice
WITH ENCRYPTION 
AS
SELECT TOP 10
		p.Name,
		p.ProductNumber,
		p.ListPrice
FROM Production.Product p
ORDER BY p.ListPrice DESC
GO

-- Next, the sys.sql_modules systemcatalog view is queried for the new view’s Transact-SQL definition:

SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('v_Product_TopTenListPrice')

-- This returns NULL 
