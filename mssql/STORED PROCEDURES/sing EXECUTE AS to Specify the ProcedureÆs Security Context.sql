-- Using EXECUTE AS to Specify the Procedure’s Security Context

USE master
GO
CREATE LOGIN SteveP WITH PASSWORD = '533B295A-D1F0'
USE AdventureWorks
GO
CREATE USER SteveP
GRANT SELECT ON OBJECT::HumanResources.Employee TO SteveP
GO

ALTER PROCEDURE dbo.usp_SEL_CountRowsFromAnyTable
@SchemaAndTable nvarchar(255)
WITH EXECUTE AS 'SteveP'
AS
-- Will work for any tables that SteveP can SELECT from
EXEC ('SELECT COUNT(*) FROM ' + @SchemaAndTable)
GO