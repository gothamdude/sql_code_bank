/* 
Inserting Multiple Rows with VALUES

SQL Server 2008 introduces the ability to insert multiple rows using a single INSERT command without
having to issue a subquery or stored procedure call. This allows the application to reduce the
code required to add multiple rows and also reduce the number of individual commands executed.
Essentially, you use the VALUES to group and specify one or more rows and their associated column
values, as the following recipe demonstrates:
*/


-- Create a lookup table
CREATE TABLE HumanResources.Degree (
	DegreeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	DegreeNM varchar(30) NOT NULL,
	DegreeCD varchar(5) NOT NULL,
	ModifiedDate datetime NOT NULL)
GO

INSERT HumanResources.Degree (DegreeNM, DegreeCD, ModifiedDate)
VALUES	('Bachelor of Arts', 'B.A.', GETDATE()),
		('Bachelor of Science', 'B.S.', GETDATE()),
		('Master of Arts', 'M.A.', GETDATE()),
		('Master of Science', 'M.S.', GETDATE()),
		('Associate''s Degree', 'A.A.', GETDATE())
GO

-- This returns the following query output:
-- (5 row(s) affected)