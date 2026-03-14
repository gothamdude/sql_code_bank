/*
Constraints are used by SQL Server to enforce column data integrity. Both primary and foreign keys
are forms of constraints. Other forms of constraints used for a column include the following:

	■ UNIQUE constraints, which enforce uniqueness within a table on non-primary key columns
	■ DEFAULT constraints, which can be used when you don’t know the value of a column in a row 
	  when it is first inserted into a table, but still wish to populate that column with an anticipated
	  value
	■ CHECK constraints, which are used to define the data format and values allowed for a column
*/

-- Creating a Unique Constraint
CREATE TABLE HumanResources.EmployeeAnnualReview(
	EmployeeAnnualReviewID int NOT NULL PRIMARY KEY,
	EmployeeID int NOT NULL,
	AnnualReviewSummaryDESC varchar(900) NOT NULL UNIQUE
)

-- In this example, a new table is created with a UNIQUE constraint based on three table columns:
CREATE TABLE Person.EmergencyContact (
	EmergencyContactID int NOT NULL PRIMARY KEY,
	EmployeeID int NOT NULL,
	ContactFirstNM varchar(50) NOT NULL,
	ContactLastNM varchar(50) NOT NULL,
	ContactPhoneNBR varchar(25) NOT NULL, 
	CONSTRAINT UNQ_EmergencyContact_FirstNM_LastNM_PhoneNBR UNIQUE (ContactFirstNM, ContactLastNM, ContactPhoneNBR)
)

-- Adding a UNIQUE Constraint to an Existing Table

ALTER TABLE Production.Culture
ADD CONSTRAINT UNQ_Culture_Name 
UNIQUE (Name)

