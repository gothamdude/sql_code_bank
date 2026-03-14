USE [AdventureWorks2008]
Go 


-- query all views in current database 
SELECT s.name SchemaName, v.Name ViewName 
FROM sys.views v
INNER JOIN sys.schemas s ON v.schema_id = s.schema_id
ORDER BY s.Name, v.Name