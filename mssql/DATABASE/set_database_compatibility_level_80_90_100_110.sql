USE master 
GO

ALTER DATABASE BookStoreInternational 
SET COMPATIBILITY_LEVEL = 100 
GO 

-- SQL Server 2000 Compatibility Level = 80 
-- SQL Server 2005 Compatibility Level = 90 
-- SQL Server 2008 Compatibility Level = 100 
-- SQL Server 2012 Compatibility Level = 110

-- In previous versions this is set using sp_dbcmptlevel system stored proc 
-- Compatibility level allows you to keep databases in SQL Server 2008 that remain compatible with prior versions of SQL Server.
-- This also means that you cannot use T-SQL extensions introduced in SQL Server with 2008 with a SQL Server 2005 compatible database 
 
