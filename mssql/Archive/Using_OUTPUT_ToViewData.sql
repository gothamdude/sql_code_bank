--Using OUTPUT to View Data

/*When using OUTPUT, you can view the data using the special tables DELETED and INSERTED. You may
wonder why there is not an UPDATED table. Instead of an UPDATED table, you will find the old values in the
DELETED table and the new values in the INSERTED table. Here are the syntax examples for using the OUTPUT
clause for viewing changes when running data manipulation statements: */


USE AdventureWorks2008;
GO
--1
IF OBJECT_ID('dbo.Customers') IS NOT NULL BEGIN
DROP TABLE dbo.Customers;
END;
--2
CREATE TABLE dbo.Customers (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150),PersonID INT NOT NULL)
GO
--3
INSERT INTO dbo.Customers(CustomerID,Name,PersonID)
OUTPUT inserted.CustomerID,inserted.Name
SELECT c.CustomerID, p.FirstName + ' ' + p.LastName,PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;
--4
UPDATE c SET Name = p.FirstName +
ISNULL(' ' + p.MiddleName,'') + ' ' + p.LastName
OUTPUT deleted.CustomerID,deleted.Name AS OldName, inserted.Name AS NewName
FROM dbo.Customers AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID;
--5
DELETE FROM dbo.Customers
OUTPUT deleted.CustomerID, deleted.Name, deleted.PersonID
WHERE CustomerID = 11000;


/*Figure 10-6 shows the partial results. Unfortunately, you cannot add an ORDER BY clause to
OUTPUT, and the INSERT statement returns the rows in a different order than the UPDATE statement. Code
section 1 drops the dbo.Customers table if it already exists. Statement 2 creates the dbo.Customers table.
Statement 3 inserts all the rows when joining the Sales.Customer table to the Person.Person table. The
OUTPUT clause, located right after the INSERT clause, returns the CustomerID and Name. Statement 4
modifies the Name column by including the MiddleName in the expression. The DELETED table displays the
Name column data before the update. The INSERTED table displays the Name column after the update. 
The UPDATE clause includes aliases to differentiate the values. Statement 5 deletes one row from the table. The
OUTPUT clause displays the deleted data.*/


-- Saving OUTPUT Data to a Table
-- Listing 10-7. Saving the Results of OUTPUT

USE AdventureWorks2008;
GO
--1
IF OBJECT_ID('dbo.Customers') IS NOT NULL BEGIN
DROP TABLE dbo.Customers;
END;

IF OBJECT_ID('dbo.CustomerHistory') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerHistory;
END;
--2
CREATE TABLE dbo.Customers (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150),PersonID INT NOT NULL)
CREATE TABLE dbo.CustomerHistory(CustomerID INT NOT NULL PRIMARY KEY,
OldName VARCHAR(150), NewName VARCHAR(150),
ChangeDate DATETIME)
GO
--3
INSERT INTO dbo.Customers(CustomerID, Name, PersonID)
SELECT c.CustomerID, p.FirstName + ' ' + p.LastName,PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;
--4
UPDATE c SET Name = p.FirstName +
ISNULL(' ' + p.MiddleName,'') + ' ' + p.LastName
OUTPUT deleted.CustomerID,deleted.Name, inserted.Name, GETDATE()
INTO dbo.CustomerHistory
FROM dbo.Customers AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID;
--5
SELECT CustomerID, OldName, NewName,ChangeDate
FROM dbo.CustomerHistory;

/*
Figure 10-7 shows the partial results. Code section 1 drops the dbo.Customers and
dbo.CustomerHistory tables if they already exist. Code section 2 creates the two tables. Statement 3
populates the dbo.Customers table. Statement 4 updates the Name column for all of the rows. By including
OUTPUT INTO, the CustomerID along with the previous and current Name values are saved into the table.
The statement also populates the ChangeDate column by using the GETDATE function.*/
