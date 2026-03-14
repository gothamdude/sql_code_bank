-- View database options currently configured for the database
USE master 
GO  

SELECT name, is_read_only, is_auto_close_on, is_auto_shrink_on 
FROM sys.databases 
WHERE name='AdventureWorks2008'
GO 
