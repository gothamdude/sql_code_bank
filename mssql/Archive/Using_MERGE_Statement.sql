/*The MERGE Statement

The MERGE statement, also known as upsert, allows you to synchronize two tables with one statement. For
example, you would normally need to perform at least one UPDATE, one INSERT, and one DELETE statement
to keep the data in one table up-to-date with the data from another table. By using MERGE, you can
perform the same work more efficiently, assuming that the tables have the proper indexes in place, and
with just one statement. The drawback is that MERGE is more difficult to understand and write than the
three individual statements. One potential use for MERGE, where taking the time to write the MERGE
statements really pays off, is loading data warehouses and data marts. Here is the syntax for a simple
MERGE statement: 


MERGE <target table>
USING <source table name>|(or query>) AS alias [(column names)]
ON (<join criteria>)
WHEN MATCHED [AND <other critera>]
THEN UPDATE SET <col> = alias.<value>
WHEN NOT MATCHED BY TARGET [AND <other criteria>]
THEN INSERT (<column list>) VALUES (<values>) –- row is inserted into target
WHEN NOT MATCHED BY SOURCE [AND <other criteria>]
THEN DELETE –- row is deleted from target
[OUTPUT $action, DELETED.*, INSERTED.*];


At first glance, the syntax may seem overwhelming. Basically, it defines an action to perform if a
row from the source table matches the target table (WHEN MATCHED), an action to perform if a row is
missing in the target table (WHEN NOT MATCHED BY TARGET), and an action to perform if an extra row is in
the target table (WHEN NOT MATCHED BY SOURCE). The actions to perform on the target table can be
anything you need to do. For example, if the source table is missing a row that appears in the target table
(WHEN NOT MATCHED BY SOURCE), you don’t have to delete the target row. You could, in fact, leave out that
part of the statement or perform another action. In addition to the join criteria, you can also specify any
other criteria in each match specification. You can include an optional OUTPUT clause along with the
$action option. The $action option shows you which action is performed on each row. Include the
DELETED and INSERTED tables in the OUTPUT clause to see the before and after values. The MERGE statement
must end with a semicolon. Type in and execute the code in Listing 10-8 to learn how to use MERGE.

Listing 10-8. Using the MERGE Statement 
*/ 

USE AdventureWorks2008;
GO
--1
IF OBJECT_ID('dbo.CustomerSource') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerSource;
END;
IF OBJECT_ID('dbo.CustomerTarget') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerTarget;
END;
--2
CREATE TABLE dbo.CustomerSource (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150), PersonID INT NOT NULL);
CREATE TABLE dbo.CustomerTarget (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150), PersonID INT NOT NULL);
GO
--3
INSERT INTO dbo.CustomerSource(CustomerID,Name,PersonID)
SELECT CustomerID,
p.FirstName + ISNULL(' ' + p.MiddleName,'') + ' ' + p.LastName,
PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
WHERE c.CustomerID IN (29485,29486,29487,10299);
--4
INSERT INTO dbo.CustomerTarget(CustomerID,Name,PersonID)
SELECT CustomerID, p.FirstName + ' ' + p.LastName, PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
WHERE c.CustomerID IN (29485,29486,21139);
--5
SELECT CustomerID, Name, PersonID
FROM dbo.CustomerSource
ORDER BY CustomerID;

--6
SELECT CustomerID, Name, PersonID
FROM dbo.CustomerTarget
ORDER BY CustomerID;
--7
MERGE dbo.CustomerTarget AS t
USING dbo.CustomerSource AS s
ON (s.CustomerID = t.CustomerID)
WHEN MATCHED AND s.Name <> t.Name
THEN UPDATE SET Name = s.Name
WHEN NOT MATCHED BY TARGET
THEN INSERT (CustomerID, Name, PersonID) VALUES (CustomerID, Name, PersonID)
WHEN NOT MATCHED BY SOURCE
THEN DELETE
OUTPUT $action, DELETED.*, INSERTED.*;--semi-colon is required
--8
SELECT CustomerID, Name, PersonID
FROM dbo.CustomerTarget
ORDER BY CustomerID;

/*
Figure 10-8 shows the results. Code section 1 drops the tables dbo.CustomerSource and
dbo.CustomerTarget. Code section 2 creates the two tables. They have the same column names, but this
is not a requirement. Statement 3 populates the dbo.CustomerSource with four rows. It creates the Name
column using the FirstName, MiddleName, and LastName columns. Statement 4 populates the
dbo.CustomerTarget table with three rows. Two of the rows contain the same customers as the
dbo.CustomerSource table. Query 5 displays the data from dbo.CustomerSource, and query 6 displays
the data from dbo.CustomerTarget. Statement 7 synchronizes dbo.CustomerTarget with dbo.
CustomerSource, correcting the Name, inserting missing rows, and deleting extra rows by using the
MERGE command. Because the query includes the OUTPUT clause, you can see the action performed on
each row. Query 8 displays the dbo.CustomerTarget with the changes. The target table now matches the
source table.*/



