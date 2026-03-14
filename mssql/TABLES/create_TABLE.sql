/*
CREATE TABLE
[ database_name . [ schema_name ] . | schema_name . ] table_name
( column_name <data_type> [ NULL | NOT NULL ] [ ,...n ] )


Table 4-1. CREATE TABLE Arguments
-----------------------------------------------------------------------------------------------------
Argument								Description
-----------------------------------------------------------------------------------------------------
[ database_name . [ schema_name ] .		This argument indicates that you can qualify the
| schema_name . ] table_name			new table name using the database, schema, and table
										name, or just the schema and table name.
column_name								This argument defines the name of the column.
data_type								This argument specifies the column’s data type (data
										types are described next).
NULL | NOT NULL							The NULL | NOT NULL option refers to the column
										nullability. Nullability defines whether a column can
										contain a NULL value. A NULL valuemeans that the
										value is unknown. It does notmean that the column
										is zero, blank, or empty.
-----------------------------------------------------------------------------------------------------
*/
USE AdventureWorks2008 
GO 

CREATE TABLE Person.EducationType (
				EducationTypeID int NOT NULL,
				EducationTypeNM varchar(40) NOT NULL
	)
GO 