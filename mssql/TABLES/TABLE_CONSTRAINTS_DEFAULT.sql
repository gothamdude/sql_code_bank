/*

If you don’t know the value of a column in a row when it is first inserted into a table, you can use a
DEFAULT constraint to populate that column with an anticipated or non-NULL value. The syntax for
designating the default value in the column definition of a CREATE TABLE is as follows:

*/

CREATE TABLE Person.EmployeeEducationType(
	EmployeeEducationTypeID int NOT NULL PRIMARY KEY,
	EmployeeID int NOT NULL,
	EducationTypeID int NOT NULL DEFAULT 1,
	GPA numeric(4,3) NOT NULL 
)



-- Adding a DEFAULT Constraint to an Existing Table
ALTER TABLE HumanResources.Company
ADD CONSTRAINT DF_Company_ParentCompanyID
DEFAULT 1 FOR ParentCompanyID

-- Dropping a Constraint froma Table
ALTER TABLE HumanResources.Company
DROP CONSTRAINT DF_Company_ParentCompanyID