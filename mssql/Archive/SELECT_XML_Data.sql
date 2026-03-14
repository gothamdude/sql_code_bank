-- Retrieving Data As XML

USE AdventureWorks2008;
GO
--1
SELECT CustomerID, LastName, FirstName, MiddleName
FROM Person.Person AS p
INNER JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID
FOR XML RAW;
--2
SELECT CustomerID, LastName, FirstName, MiddleName
FROM Person.Person AS p
INNER JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID
FOR XML AUTO;
--3
SELECT CustomerID, LastName, FirstName, MiddleName
FROM Person.Person AS p
INNER JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID
FOR XML PATH;

--Using the XML Data Type
-- You can now store XML in an XML column instead of a TEXT column. As mentioned, 
USE AdventureWorks2008;
GO
--1
CREATE TABLE #CustomerList (CustomerInfo XML);
--2
DECLARE @XMLInfo XML;
SET @XMLInfo = (SELECT CustomerID, LastName, FirstName, MiddleName
FROM Person.Person AS p
INNER JOIN Sales.Customer AS c ON p.BusinessEntityID = c.PersonID
FOR XML PATH);
--4
INSERT INTO #CustomerList(CustomerInfo)
VALUES(@XMLInfo);
--5
SELECT CustomerInfo FROM #CustomerList;
DROP TABLE #CustomerList;