/* 

Easing VLDB Manageability with Filegroups

Filegroups are often used for very large databases because they can ease backup administration and
potentially improve performance by distributing data over disk LUNs or arrays.When creating a
table, you can specify that it be created on a specific filegroup. For example, if you have a table that
you know will become very large, you can designate that it be created on a specific filegroup.

The basic syntax for designating a table’s filegroup is as follows:

	CREATE TABLE ...
	[ ON {filegroup | "default" }]
	[ { TEXTIMAGE_ON { filegroup | "default" } ]


Table 4-25 details the arguments of this command.
Table 4-25. Arguments for Creating a Table on a Filegroup
--------------------------------------------------------------------------------------------------------------
Argument Description
--------------------------------------------------------------------------------------------------------------
filegroup This specifies the name of the filegroup on which the
table will be created.
"DEFAULT" This sets the table to be created on the default
filegroup defined for the database.
TEXTIMAGE_ON { filegroup | "DEFAULT" } This option stores in a separate filegroup the data
fromtext, ntext, image, xml, varchar(max),
nvarchar(max), and varbinary(max) data types.
--------------------------------------------------------------------------------------------------------------
*/

-- This example demonstrates how to place a table on a non-default, user-created filegroup. The
-- first step involves creating a new filegroup in the AdventureWorks database:

	ALTER DATABASE AdventureWorks
	ADD FILEGROUP AW_FG2
	GO

-- Next, a new file is added to the filegroup:

ALTER DATABASE AdventureWorks
ADD FILE
( NAME = AW_F2,
FILENAME = 'C:\Apress\aw_f2.ndf',
SIZE = 1MB
)
TO FILEGROUP AW_FG2
GO

-- I’ll then create a new table on the new filegroup (causing its data to be stored in the new file, contained within the filegroup):

CREATE TABLE HumanResources.AWCompany(
AWCompanyID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
ParentAWCompanyID int NULL,
AWCompanyNM varchar(25) NOT NULL,
CreateDT datetime NOT NULL DEFAULT (getdate())
) ON AW_FG2

-- In the second example, a table is created by specifying that large object data columns be stored 
-- on a separate filegroup (AW_FG2) fromthe regular data (on the PRIMARY filegroup):

CREATE TABLE HumanResources.EWCompany(
EWCompanyID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
ParentEWCompanyID int NULL,
EWCompanyName varchar(25) NOT NULL,
HeadQuartersImage varbinary(max) NULL,
CreateDT datetime NOT NULL DEFAULT (getdate())
) ON [PRIMARY]
TEXTIMAGE_ON AW_FG2





