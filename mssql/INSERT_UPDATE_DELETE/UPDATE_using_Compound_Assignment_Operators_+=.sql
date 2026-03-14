/*

Assigning and Modifying Database Values “in Place”

SQL Server 2008 introduces new compound assignment operators beyond the standard equality (=)
operator that allow you to both assign and modify the outgoing data value. These operators are similar
to what you would see in the C and Java languages. New assignment operators include the
following:

• += (add, assign)
• -= (subtract, assign)
• *= (multiply, assign)
• /= (divide, assign)
• |= (bitwise |, assign)
• ^= (bitwise exclusive OR, assign)
• &= (bitwise &, assign)
• %= (modulo, assign)

This recipe will demonstrate modifying base pay amounts using assignment operators. I’ll start
by creating a new table and populating it with a few values:
*/


USE AdventureWorks2008
GO

CREATE TABLE HumanResources.EmployeePayScale (
		EmployeePayScaleID int NOT NULL PRIMARY KEY IDENTITY(1,1),
		BasePayAMT numeric(9,2) NOT NULL,
		ModifiedDate datetime NOT NULL DEFAULT GETDATE()
		)
GO

-- Using new multiple-row insert functionality
INSERT HumanResources.EmployeePayScale (BasePayAMT)
VALUES (30000.00), (40000.00), (50000.00), (60000.00)

-- check 
SELECT BasePayAMT
FROM HumanResources.EmployeePayScale
WHERE EmployeePayScaleID = 4


-- UPDATE statements below using the compound assignment operators 

UPDATE HumanResources.EmployeePayScale
SET BasePayAMT += 10000
WHERE EmployeePayScaleID = 4

UPDATE HumanResources.EmployeePayScale
SET BasePayAMT *= 2
WHERE EmployeePayScaleID = 4

