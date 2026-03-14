USE AdventureWorks2008
GO 

SELECT 'The ' +
	p.name +
	' is only ' +
	CONVERT(varchar(25),p.ListPrice) +
	'!'
FROM Production.Product p
WHERE p.ListPrice between 100 AND 120
ORDER BY p.ListPrice