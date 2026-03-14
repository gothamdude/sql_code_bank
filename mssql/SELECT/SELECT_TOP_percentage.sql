USE AdventureWorks2008
GO 


DECLARE @Percentage float 
SET @Percentage  = 10


SELECT TOP (@Percentage) PERCENT 
		Name 
FROM Production.Product 
ORDER BY Name 


-- also can:
SELECT TOP 25 PERCENT 
		Name 
FROM Production.Product 
ORDER BY Name 


/* 
In previous versions of SQL Server, developers used SET ROWCOUNT to limit how many rows the query
would return or impact. In SQL Server 2005 and 2008, you should use the TOP keyword instead of SET
ROWCOUNT, as the TOP will usually perform faster. Also, not having the ability to use local variables in
the TOP clause was a major reason why people still used SET ROWCOUNT over TOP in previous versions
of SQL Server.
*/