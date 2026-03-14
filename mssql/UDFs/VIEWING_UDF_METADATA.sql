/* 
Viewing UDFMetadata
In this recipe, I demonstrate how to view a list of UDFs in the current database (I don’t show the
results because this query includes the actual UDF T-SQL definition):
*/


SELECT name, type_desc, definition
FROM sys.sql_modules s 
	INNER JOIN sys.objects o ON s.object_id = o.object_id
WHERE TYPE IN ('IF', -- Inline Table UDF
'TF', -- Multistatement Table UDF
'FN') -- Scalar UDF