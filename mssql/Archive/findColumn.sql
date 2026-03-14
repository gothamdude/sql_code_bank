--USE AdventureWorks
--GO

--SELECT t.name AS table_name,
--SCHEMA_NAME(schema_id) AS schema_name,
--c.name AS column_name
--FROM sys.tables AS t
--INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
--WHERE c.name LIKE '%EmployeeID%'
--ORDER BY schema_name, table_name; 



select c.name AS column_name, t.name
FROM sys.tables AS t
INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
WHERE c.name LIKE '%AddressID%'
ORDER BY t.name ; 

delete from COM_Address 
where AddressID not in 
(
	select distinct addressid from BE_EntityAddress
	union 
	select distinct addressid from BE_EntityContactAddress
	union 
	select distinct addressid from DES_Address
)
