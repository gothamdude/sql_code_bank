
-- Creating a Table with a Foreign Key Reference
-- In this recipe, I’ll demonstrate how to create a table with a foreign key. In this example, I define two
-- foreign key references within the definition of a CREATE TABLE statement:

CREATE TABLE Person.EmployeeCreditRating(
	EmployeeCreditRating int NOT NULL PRIMARY KEY,
	BusinessEntityID int NOT NULL,
	CreditRatingID int NOT NULL,
	CONSTRAINT FK_EmployeeCreditRating_Employee FOREIGN KEY(BusinessEntityID) REFERENCES HumanResources.Employee(BusinessEntityID),
	CONSTRAINT FK_EmployeeCreditRating_CreditRating FOREIGN KEY(CreditRatingID)	REFERENCES Person.CreditRating(CreditRatingID)
)


-- Adding a Foreign Key to an Existing Table
-- This example adds a foreign key constraint to an existing table:

CREATE TABLE Person.EmergencyContact (
	EmergencyContactID int NOT NULL PRIMARY KEY,
	BusinessEntityID int NOT NULL,
	ContactFirstNM varchar(50) NOT NULL,
	ContactLastNM varchar(50) NOT NULL,
	ContactPhoneNBR varchar(25) NOT NULL
	)

ALTER TABLE Person.EmergencyContact
ADD CONSTRAINT FK_EmergencyContact_Employee FOREIGN KEY (BusinessEntityID) REFERENCES HumanResources.Employee (BusinessEntityID) 



