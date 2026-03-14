/* 

Maintaining Reusable Code

Scalar UDFs allow you to reduce code bloat by encapsulating logic within a single function, rather
than repeating the logicmultiple times wherever it happens to be needed.

For example, the following scalar, user-defined function is used to determine the kind of personal
computer that an employee will receive. There are several lines of code that evaluate different
input parameters, including the title of the employee, the employee’s hire date, and salaried status.
Rather than include this logic inmultiple areas across your database application, you can encapsulate
the logic in a single function:
*/

CREATE FUNCTION dbo.udf_GET_AssignedEquipment(@Title nvarchar(50), @HireDate datetime, @SalariedFlag bit)
RETURNS nvarchar(50)
AS
BEGIN
DECLARE @EquipmentType nvarchar(50)
	IF @Title LIKE 'Chief%' OR
	@Title LIKE 'Vice%' OR
	@Title = 'Database Administrator'
	BEGIN
	SET @EquipmentType = 'PC Build A'
	END
	IF @EquipmentType IS NULL AND @SalariedFlag = 1
	BEGIN
	SET @EquipmentType = 'PC Build B'
	END
	IF @EquipmentType IS NULL AND @HireDate < '1/1/2002'
	BEGIN
	SET @EquipmentType = 'PC Build C'
	END
	IF @EquipmentType IS NULL
	BEGIN
	SET @EquipmentType = 'PC Build D'
	END
	RETURN @EquipmentType
END
GO

/*
Once you’ve created it, you can use this scalar function inmany areas of your Transact-SQL
code without having to recode the logic within. For example, the new scalar function is used in the
SELECT, GROUP BY, and ORDER BY clauses of a query:*/
SELECT dbo.udf_GET_AssignedEquipment (JobTitle, HireDate, SalariedFlag) PC_Build, COUNT(*) Employee_Count
FROM HumanResources.Employee
GROUP BY dbo.udf_GET_AssignedEquipment (JobTitle, HireDate, SalariedFlag)
ORDER BY dbo.udf_GET_AssignedEquipment (JobTitle, HireDate, SalariedFlag)

/*This returns

PC_Build Employee_Count
PC Build A 7
PC Build B 45
PC Build C 238

This second query uses the scalar function in both the SELECT and WHERE clauses, too:*/

SELECT	JobTitle,
		BusinessEntityID,
		dbo.udf_GET_AssignedEquipment(JobTitle, HireDate, SalariedFlag) PC_Build
FROM HumanResources.Employee
WHERE dbo.udf_GET_AssignedEquipment (JobTitle, HireDate, SalariedFlag) IN ('PC Build A', 'PC Build B')

/*
This returns the following (abridged) results:

JobTitle BusinessEntityID PC_Build
Chief Executive Officer 1 PC Build A
Vice President of Engineering 2 PC Build A
Engineering Manager 3 PC Build B
Design Engineer 5 PC Build B
Design Engineer 6 PC Build B
*/
...