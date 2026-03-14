USE [AdventureWorks2008];
GO
IF EXISTS (
SELECT * FROM sys.types st
JOIN sys.schemas ss ON st.schema_id = ss.schema_id
WHERE st.name = N'CustomerID' AND ss.name = N'dbo') BEGIN
DROP TYPE [dbo].[CustomerID];
END;
GO
CREATE TYPE dbo.CustomerID FROM INT NOT NULL;