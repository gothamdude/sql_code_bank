USE AdventureWorks2008
GO 
/*
As a DBA or developer, you sometimes need a Transact-SQL script to run against several objects
within a database or against several databases across a SQL Server instance. For example, you may
want to show how many rows exist in every user table in the database. Or perhaps you have a very
large table with several columns, which you need to validate in search conditions, but you don’t
want to have to manually type each column.

This next recipe offers a time-saving technique, using SELECT to write out Transact-SQL for you.
You can adapt this recipe to all sorts of purposes.

In this example, assume that you wish to check for rows in a table where all values are NULL.
There are many columns in the table, and you want to avoid hand-coding them. Instead, you can
create a script to do the work for you:
*/

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employee'


SELECT column_name + ' IS NULL AND '
FROM INFORMATION_SCHEMA.columns
WHERE table_name = 'Employee'
ORDER BY ORDINAL_POSITION


/*
This returns code that you can integrate into a WHERE clause (after you remove the trailing AND at the last WHERE condition):
---------------------------------------------------------
EmployeeID IS NULL AND
NationalIDNumber IS NULL AND
ContactID IS NULL AND
LoginID IS NULL AND
ManagerID IS NULL AND
Title IS NULL AND
BirthDate IS NULL AND
MaritalStatus IS NULL AND
Gender IS NULL AND
HireDate IS NULL AND
SalariedFlag IS NULL AND
VacationHours IS NULL AND
SickLeaveHours IS NULL AND
CurrentFlag IS NULL AND
rowguid IS NULL AND
ModifiedDate IS NULL AND
(16 row(s) affected)
---------------------------------------------------------

How It Works

The example used string concatenation and the INFORMATION_SCHEMA.columns system view to generate
a list of columns from the Employee table. For each column, IS NULL AND was concatenated to its
name. The results can then be copied to the WHERE clause of a query, allowing you to query for rows
where each column has a NULL value.

This general technique of concatenating SQL commands to various system data columns can
be used in numerous ways, including for creating scripts against tables or other database objects.

*/