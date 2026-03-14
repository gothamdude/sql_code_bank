USE AdventureWorks2008
GO

-- viewing all index on employee table 
EXEC sp_helpindex 'HumanResources.Employee'


-- for more in-depth analysis, you can use sys.indexes system catalog view 
SELECT SUBSTRING(name, 1, 30) index_name,
	allow_row_locks,
	allow_page_locks,
	is_disabled,
	fill_factor,
	has_filter 
FROM sys.indexes 
WHERE object_id = object_id('HumanResources.Employee') 


-- see all metadata
SELECT *
FROM sys.indexes 
WHERE object_id = object_id('HumanResources.Employee') 
