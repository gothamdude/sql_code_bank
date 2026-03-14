/* 
The systemstored procedure sp_help returns information about the specified table, including the
column definitions, IDENTITY column, ROWGUIDCOL, filegroup location, indexes (and keys), CHECK,
DEFAULT, and FOREIGN KEY constraints, and referencing views.

The syntax for this systemstored procedure is as follows:

sp_help [ [ @objname = ] ' name ' ]

This example demonstrates how to report detailed information about the object or table (the
results aren’t shown here as they include several columns andmultiple result sets):
*/


EXEC sp_help 'HumanResources.Employee'