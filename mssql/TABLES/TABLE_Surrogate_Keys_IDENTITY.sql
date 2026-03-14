/*
Surrogate keys, also called artificial keys, can be used as primary keys and have no inherent business/
datameaning. Surrogate keys are independent of the data itself and are used to provide a
single unique record locator in the table. A big advantage to surrogate primary keys is that they
don’t need to change. If you use business data to define your key (natural key), such as first name
and last name, these values can change over time and change arbitrarily. Surrogate keys don’t have
to change, as their onlymeaning is within the context of the table itself.

- IDENTITY property columns seeds 
- UNIQUEIDENTIFIER data type columns 
*/

-- Using the IDENTITY Property During Table Creation 
CREATE TABLE HumanResources.CompanyAuditHistory (
	CompanyAuditHistory int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	CompanyID int NOT NULL ,
	AuditReasonDESC varchar(50) NOT NULL,
	AuditDT datetime NOT NULL DEFAULT GETDATE()
)
INSERT HumanResources.CompanyAuditHistory (CompanyID, AuditReasonDESC, AuditDT)
VALUES (1, 'Bad 1099 numbers.', '6/1/2009')
INSERT HumanResources.CompanyAuditHistory (CompanyID, AuditReasonDESC, AuditDT)
VALUES (1, 'Missing financial statement.', '7/1/2009')

/*
Using DBCC CHECKIDENT toView and Correct IDENTITY SeedValues

In this recipe, I’ll show you how to check the current IDENTITY value of a column for a table by using
the DBCC CHECKIDENT command. DBCC CHECKIDENT checks the currentmaximumvalue for the specified
table. The syntax for this command is as follows:

DBCC CHECKIDENT
( 'table_name' [ , {NORESEED | { RESEED [ , new_reseed_value ] }}])
[ WITH NO_INFOMSGS ]

Table 4-10. CHECKIDENT Arguments
--------------------------------------------------------------------------------------------------------------
Argument				Description
--------------------------------------------------------------------------------------------------------------
table_name					This indicates the name of the table to check IDENTITY values for.
NORESEED | RESEED			NORESEEDmeans that no action is taken other than to report themaximum
							identity value. RESEED specifies what the current IDENTITY value should be.
new_reseed_value			This specifies the new current IDENTITY value.
WITH NO_INFOMSGS			When included in the command, WITH NO_INFOMSGS suppresses
							informationalmessages fromthe DBCC output.
--------------------------------------------------------------------------------------------------------------
*/

-- In this example, the current table IDENTITY value is checked:
DBCC CHECKIDENT('HumanResources.CompanyAuditHistory', NORESEED)

-- This second example resets the seed value to a higher number:
DBCC CHECKIDENT ('HumanResources.CompanyAuditHistory', RESEED, 50)

INSERT HumanResources.CompanyAuditHistory (CompanyID, AuditReasonDESC, AuditDT) 
VALUES (100, 'kerwin sample entry .', '7/1/2009')