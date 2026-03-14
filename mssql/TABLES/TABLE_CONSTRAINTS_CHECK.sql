
-- Using CHECK Constraints
-- If the logical expression of CHECK evaluates to TRUE, the row will be inserted. If the CHECK constraint
-- expression evaluates to FALSE, the row insert will fail. This example demonstrates adding a
-- CHECK constraint to a CREATE TABLE definition. The GPA column’s values will be restricted to a specific numeric range:

CREATE TABLE Person.EmployeeEducationType(
	EmployeeEducationTypeID int NOT NULL PRIMARY KEY,
	EmployeeID int NOT NULL,
	EducationTypeID int NULL,
	GPA numeric(4,3) NOT NULL CHECK (GPA > 2.5 AND GPA <=4.0)
)

-- In the previous example, the CHECK constraint expression was defined at the column constraint
-- level. A CHECK constraint can also be defined at the table constraint level—where you are allowed to
-- referencemultiple columns in the expression, as this next example demonstrates:
CREATE TABLE Person.EmployeeEducationType(
	EmployeeEducationTypeID int NOT NULL PRIMARY KEY,
	EmployeeID int NOT NULL,
	EducationTypeID int NULL,
	GPA numeric(4,3) NOT NULL,
	CONSTRAINT CK_EmployeeEducationType CHECK (EducationTypeID > 1 AND GPA > 2.5 AND GPA <=4.0)
)


/*
Adding a CHECK Constraint to an Existing Table
Like other constraint types, you can add a CHECK constraint to an existing table using ALTER TABLE
and ADD CONSTRAINT. The syntax is as follows:
*/
ALTER TABLE table_name
WITH CHECK | WITH NOCHECK
ADD CONSTRAINT constraint_name
CHECK ( logical_expression )

-- In this example, a new CHECK request is added to the Person.ContactType table:

ALTER TABLE Person.ContactType WITH NOCHECK 
ADD CONSTRAINT CK_ContactType CHECK (Name NOT LIKE '%assistant%')

/* 
A new constraint was added to the Person.ContactType table to not allow any name like “assistant.”
The first part of the ALTER TABLE statement included WITH NOCHECK:

ALTER TABLE Person.ContactType WITH NOCHECK

Had this statement been executed without WITH NOCHECK, it would have failed because there
are already rows in the table with “assistant” in the name. Adding WITH NOCHECKmeans that existing
values are ignored going forward, and only new values are validated against the CHECK constraint

■ Caution Using WITH NOCHECK may cause problems later on, as you cannot depend on the data in the table
conforming to the constraint.

*/

-- Disabling and Enabling a Constraint
/*
The previous exercise demonstrated using NOCHECK to ignore existing values that disobey the new
constraints rule when adding a new constraint to the table. Constraints are used tomaintain data
integrity, although sometimes youmay need to relax the rules while performing a one-off data
import or non-standard business operation. NOCHECK can also be used to disable a CHECK or FOREIGN
KEY constraint, allowing you to insert rows that disobey the constraints rules
*/

ALTER TABLE Sales.PersonCreditCard
NOCHECK CONSTRAINT FK_PersonCreditCard_CreditCard_CreditCardID

--  To reenable checking of the foreign key constraint, CHECK is used in an ALTER TABLE statement:
ALTER TABLE Sales.PersonCreditCard
CHECK CONSTRAINT FK_PersonCreditCard_CreditCard_CreditCardID













