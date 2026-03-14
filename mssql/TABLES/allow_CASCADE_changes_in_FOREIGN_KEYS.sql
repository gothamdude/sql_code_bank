/*
Foreign keys restrict the values that can be placed within the foreign key column or columns. If the
associated primary key or unique value does not exist in the reference table, the INSERT or UPDATE to
the table row fails. This restriction is bidirectional in that if an attempt ismade to delete a primary
key, but a row referencing that specific key exists in the foreign key table, an error will be returned.
All referencing foreign key rowsmust be deleted prior to deleting the targeted primary key or
unique value; otherwise, an error will be raised.

SQL Server provides an automaticmechanismfor handling changes in the primary key/unique
key column, called cascading changes. In previous recipes, cascading options weren’t used. You can
allow cascading changes for deletions or updates using ON DELETE and ON UPDATE. The basic syntax
for cascading options is as follows:

[ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
[ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ]
[ NOT FOR REPLICATION ]


Table 4-9. Cascading Change Arguments
--------------------------------------------------------------------------------------------------------------
Argument			Description
--------------------------------------------------------------------------------------------------------------
NO ACTION			The default setting for a new foreign key is NO ACTION,meaning if an
					attempt to delete a row on the primary key/unique column occurs when
					there is a referencing value in a foreign key table, the attempt will raise an
					error and prevent the statement fromexecuting.
CASCADE				For ON DELETE, if CASCADE is chosen, foreign key rows referencing the
					deleted primary key are also deleted. For ON UPDATE, foreign key rows
					referencing the updated primary key are also updated.
SET NULL			If the primary key row is deleted, the foreign key referencing row(s) can
					also be set to NULL (assuming NULL values are allowed for that foreign key
					column).
SET DEFAULT			If the primary key row is deleted, the foreign key referencing row(s) can
					also be set to a DEFAULT value. The new cascade SET DEFAULT option
					assumes the column has a default value set for a column. If not, and the
					column is nullable, a NULL value is set.
NOT FOR REPLICATION	The NOT FOR REPLICATION option is used to prevent foreign key constraints
					frombeing enforced by SQL Server Replication Agent processes (allowing
					data to arrive via replication potentially out-of-order fromthe primary
					key data).
--------------------------------------------------------------------------------------------------------------

*/

DROP TABLE Person.EmployeeEducationType

CREATE TABLE Person.EmployeeEducationType(
	EmployeeEducationTypeID int NOT NULL PRIMARY KEY,
	BusinessEntityID int NOT NULL,
	EducationTypeID int NULL,
	CONSTRAINT FK_EmployeeEducationType_Employee FOREIGN KEY(BusinessEntityID) REFERENCES HumanResources.Employee(BusinessEntityID)
	ON DELETE CASCADE,
	CONSTRAINT FK_EmployeeEducationType_EducationType FOREIGN KEY(EducationTypeID) REFERENCES Person.EducationType(EducationTypeID)
	ON UPDATE SET NULL
)

/*
Using this cascade option, if a row is deleted on the HumanResources.Employee table, any referencing
BusinessEntityID in the Person.EmployeeEducationType table will also be deleted.

If an update is made to the primary key of the Person.EducationType table, the EducationTypeID 
column in the referencing Person.EmployeeEducationType table will be set to NULL.
*/
