USE AdventureWorks2008
GO 

-- LOCAL TEMP TABLE 
CREATE TABLE #myCustomers (CustomerID INT, FirstName VARCHAR(25),LastName VARCHAR(25))
GO 

INSERT INTO #myCustomers(CustomerID, FirstName, LastName)
SELECT C.CustomerID, FirstName, LastName 
FROM Person.Person AS P 
	INNER JOIN Sales.Customer AS C ON P.BusinessEntityID = C.PersonID 
Go 

SELECT CustomerID, FirstName, LastName
FROM #myCustomers
 
DROP TABLE #myCustomers


-- GLOBAL TEMP  TABLE 
USE AdventureWorks2008
GO 

CREATE TABLE ##myCustomers (CustomerID INT, FirstName VARCHAR(25),LastName VARCHAR(25))
GO 

INSERT INTO ##myCustomers(CustomerID, FirstName, LastName)
SELECT C.CustomerID, FirstName, LastName 
FROM Person.Person AS P 
	INNER JOIN Sales.Customer AS C ON P.BusinessEntityID = C.PersonID 
Go 

USE AdventureWorksLT2008  -- SEE, THIS PROVES ACCESSIBLE FROM OTHER DBs
GO 

SELECT CustomerID, FirstName, LastName
FROM ##myCustomers
 
DROP TABLE ##myCustomers

