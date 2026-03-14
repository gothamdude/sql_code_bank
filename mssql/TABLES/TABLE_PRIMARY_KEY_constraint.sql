/*
A primary key is a special type of constraint that identifies a single column or set of columns, which
in turn uniquely identifies all rows in the table
	Constraints place limitations on the data that can be entered into a column or columns. A primary
key enforces entity integrity,meaning that rows are guaranteed to be unambiguous and
unique. Best practices for database normalization dictate that every table should have a primary
key. A primary key provides a way to access the record and ensures that the key is unique. A primary
key column can’t contain NULL values.
	Only one primary key is allowed for a table, and when a primary key is designated, an underlying
table index is automatically created, defaulting to a clustered index (index types are reviewed in
Chapter 5). You can also explicitly designate a nonclustered index be created when the primary key
is created instead, if you have a better use for the single clustered index allowed for a table. An index
created on primary key counts against the total indexes allowed for a table.
	To designate a primary key on a single column, use the following syntax in the column
definition:
*/

  ( column_name <data_type> [ NULL | NOT NULL ] PRIMARY KEY )

/*
	The key words PRIMARY KEY are included at the end of the column definition.
	A composite primary key is the unique combination ofmore than one column in the table. In
order to define a composite primary key, youmust use a table constraint instead of a column constraint.
Setting a single column as the primary key within the column definition is called a column
constraint. Defining the primary key (single or composite) outside of the column definition is
referred to as a table constraint.
	The syntax for a table constraint for a primary key is as follows:
*/

CONSTRAINT constraint_name PRIMARY KEY
(column [ ASC | DESC ] [ ,...n ] )

/*
	Foreign key constraints establish and enforce relationships between tables and helpmaintain
referential integrity, whichmeans that every value in the foreign key columnmust exist in the
corresponding column for the referenced table. Foreign key constraints also help define domain
integrity, in that they define the range of potential and allowed values for a specific column or
columns. Domain integrity defines the validity of values in a column.
	The basic syntax for a foreign key constraint is as follows:
*/

CONSTRAINT constraint_name
FOREIGN KEY (column_name)
REFERENCES [ schema_name.] referenced_table_name [ ( ref_column ) ]

-- Creating a Table with a Primary Key

CREATE TABLE Person.CreditRating(
	CreditRatingID int NOT NULL PRIMARY KEY,
	CreditRatingNM varchar(40) NOT NULL
	)
GO

-- Creating a Table with Composite Primary Key 
CREATE TABLE Person.EmployeeEducationType (
EmployeeID int NOT NULL,
EducationTypeID int NOT NULL,
CONSTRAINT PK_EmployeeEducationType
PRIMARY KEY (EmployeeID, EducationTypeID))


-- Adding a Primary Key Constraint to an Existing Table
-- In this recipe, I’ll demonstrate how to add a primary key to an existing table using ALTER TABLE and ADD CONSTRAINT:

CREATE TABLE Person.EducationType (
		EducationTypeID int NOT NULL,
		EducationTypeNM varchar(40) NOT NULL
)

ALTER TABLE Person.EducationType
ADD CONSTRAINT PK_EducationType PRIMARY KEY (EducationTypeID)










