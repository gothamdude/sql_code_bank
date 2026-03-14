/*
Creating Recursive Foreign Key References

A foreign key column in a table can be defined to reference its own primary/unique key. This technique
is often used to represent recursive relationships, as I’ll demonstrate. In this example, a table
is created with a foreign key reference to its own primary key:

*/

CREATE TABLE HumanResources.Company (
	CompanyID int NOT NULL PRIMARY KEY,
	ParentCompanyID int NULL,
	CompanyName varchar(25) NOT NULL,
	CONSTRAINT FK_Company_Company FOREIGN KEY (ParentCompanyID) REFERENCES HumanResources.Company(CompanyID)
)

-- A row specifying CompanyID and CompanyName is added to the table: 

INSERT HumanResources.Company (CompanyID, CompanyName)
VALUES(1, 'MegaCorp')

-- A second row is added, this time referencing the ParentCompanyID, which is equal to the previously inserted row:
INSERT HumanResources.Company (CompanyID, ParentCompanyID, CompanyName)
VALUES(2, 1, 'Medi-Corp')

-- A third row insert is attempted, this time specifying a ParentCompanyID for a CompanyID that does not exist in the table:
INSERT HumanResources.Company (CompanyID, ParentCompanyID, CompanyName)
VALUES(3, 8, 'Tiny-Corp')

/*
Msg 547, Level 16, State 0, Line 1
The INSERT statement conflicted with the FOREIGN KEY SAME TABLE constraint "FK_Company_Company". The conflict occurred in database "AdventureWorks2008", table "HumanResources.Company", column 'CompanyID'.
The statement has been terminated.
*/