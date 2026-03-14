SELECT SERVERPROPERTY('Collation')
/*
In addition to the SQL Server instance’s default collation settings, your database can also have
a default collation defined for it. You can use the DATABASEPROPERTYEX systemfunction to determine
a database’s default collation. For example, this next query determines the default database collation
for the AdventureWorks database (first parameter is database name, second is the Collation
option to be viewed):
*/
SELECT DATABASEPROPERTYEX ( 'AdventureWorks2008' , 'Collation' )

-- SQL_Latin1_General_CP1_CI_AS   -- WHAT DOES THIS MEAN ???

/* But what do the results of these collation functionsmean? To determine the actual settings
that a collation applies to the SQL Server instance or database, you can query the table function
fn_helpcollations for amore user-friendly description. In this example, the collation description
is returned fromthe SQL_Latin1_General_CP1_CI_AS collation: */

SELECT description
FROM sys.fn_helpcollations()
WHERE name = 'SQL_Latin1_General_CP1_CI_AS'

/* result below: 
Latin1-General, case-insensitive, accent-sensitive, kanatype-insensitive, width-insensitive for Unicode Data, 
SQL Server Sort Order 52 on Code Page 1252 for non-Unicode Data
*/


-- In this recipe, I’ll demonstrate how to designate the collation of a table column using the ALTER TABLE command:

ALTER TABLE Production.Product
ADD IcelandicProductName nvarchar(50) COLLATE Icelandic_CI_AI, 
    UkrainianProductName nvarchar(50) COLLATE Ukrainian_CI_AS




