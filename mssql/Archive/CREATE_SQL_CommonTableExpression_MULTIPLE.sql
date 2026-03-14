
-- Creating CTE Multiple Times
USE AdventureWorks;
GO
WITH
Emp AS(
SELECT e.EmployeeID, e.ManagerID,e.Title AS EmpTitle,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS EmpName
FROM HumanResources.Employee AS e
INNER JOIN Person.Contact AS c
ON e.ContactID = c.ContactID
),
Mgr AS(
SELECT e.EmployeeID AS ManagerID,e.Title AS MgrTitle,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS MgrName
FROM HumanResources.Employee AS e
INNER JOIN Person.Contact AS c
ON e.ContactID = c.ContactID
)
SELECT EmployeeID, Emp.ManagerID, EmpName, EmpTitle, MgrName, MgrTitle
FROM Emp INNER JOIN Mgr ON Emp.ManagerID = Mgr.ManagerID
ORDER BY EmployeeID;



-- Calling a CTE Multiple Times
USE AdventureWorks;
GO
--1
WITH
Employees AS(
SELECT e.EmployeeID, e.ManagerID,e.Title,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS EmpName
FROM HumanResources.Employee AS e
INNER JOIN Person.Contact AS c
ON e.ContactID = c.ContactID
)
SELECT emp.EmployeeID, emp.ManagerID, emp.EmpName, emp.Title AS EmpTitle,
mgr.EmpName as MgrName, mgr.Title as MgrTitle
FROM Employees AS Emp INNER JOIN Employees AS Mgr
ON Emp.ManagerID = Mgr.EmployeeID;
--2
WITH Employees AS (
SELECT e.EmployeeID, e.ManagerID,e.Title,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS EmpName
FROM HumanResources.Employee AS e
INNER JOIN Person.Contact AS c
ON e.ContactID = c.ContactID)
SELECT EmployeeID, ManagerID, EmpName, Title
FROM Employees
WHERE EmployeeID IN (SELECT EmployeeID
FROM Employees AS e
INNER JOIN Sales.SalesOrderHeader AS soh ON e.EmployeeID = soh.SalesPersonID
WHERE soh.TotalDue > 10000);



/*
Joining a CTE to Another CTE
Another very interesting feature of CTEs is the ability to call one CTE from another CTE definition. This
is not recursion, which you will learn about in the “Writing a Recursive Query” section. Calling one CTE
from within another CTE definition allows you to base one query on a previous query. Here is a syntax
example:*/
USE tempdb;
GO
--1
IF OBJECT_ID('dbo.JobHistory') IS NOT NULL BEGIN
DROP TABLE dbo.JobHistory;
END;
--2
CREATE TABLE JobHistory(
EmployeeID INT NOT NULL,
EffDate DATE NOT NULL,
EffSeq INT NOT NULL,
EmploymentStatus CHAR(1) NOT NULL,
JobTitle VARCHAR(50) NOT NULL,
Salary MONEY NOT NULL,
ActionDesc VARCHAR(20)
CONSTRAINT PK_JobHistory PRIMARY KEY CLUSTERED
(
EmployeeID, EffDate, EffSeq
));
GO

348
--3
INSERT INTO JobHistory(EmployeeID, EffDate, EffSeq, EmploymentStatus,
JobTitle, Salary, ActionDesc)
VALUES
(1000,'07-31-2008',1,'A','Intern',2000,'New Hire'),
(1000,'05-31-2009',1,'A','Production Technician',2000,'Title Change'),
(1000,'05-31-2009',2,'A','Production Technician',2500,'Salary Change'),
(1000,'11-01-2009',1,'A','Production Technician',3000,'Salary Change'),
(1200,'01-10-2009',1,'A','Design Engineer',5000,'New Hire'),
(1200,'05-01-2009',1,'T','Design Engineer',5000,'Termination'),
(1100,'08-01-2008',1,'A','Accounts Payable Specialist I',2500,'New Hire'),
(1100,'05-01-2009',1,'A','Accounts Payable Specialist II',2500,'Title Change'),
(1100,'05-01-2009',2,'A','Accounts Payable Specialist II',3000,'Salary Change');
--4
DECLARE @Date DATE = '05-02-2009';
--5
WITH EffectiveDate AS (
SELECT MAX(EffDate) AS MaxDate, EmployeeID
FROM JobHistory
WHERE EffDate <= @Date
GROUP BY EmployeeID
),
EffectiveSeq AS (
SELECT MAX(EffSeq) AS MaxSeq, j.EmployeeID, MaxDate
FROM JobHistory AS j
INNER JOIN EffectiveDate AS d
ON j.EffDate = d.MaxDate AND j.EmployeeID = d.EmployeeID
GROUP BY j.EmployeeID, MaxDate)
SELECT j.EmployeeID, EmploymentStatus, JobTitle, Salary
FROM JobHistory AS j
INNER JOIN EffectiveSeq AS e ON j.EmployeeID = e.EmployeeID
AND j.EffDate = e.MaxDate AND j.EffSeq = e.MaxSeq;




--  Using the Alternate CTE Syntax
-- I prefer naming all the columns within the CTE definition, but you can also specify the column names
-- outside the definition. There is no advantage to either syntax, but you should be familiar with both. Here
-- is the syntax:
USE AdventureWorks;
GO
WITH Emp (EmployeeID, ManagerID, JobTitle,EmpName) AS
(SELECT e.EmployeeID, e.ManagerID,e.Title,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName
FROM HumanResources.Employee AS e
INNER JOIN Person.Contact AS c
ON e.ContactID = c.ContactID)
SELECT Emp.EmployeeID, ManagerID, JobTitle, EmpName
FROM Emp;
