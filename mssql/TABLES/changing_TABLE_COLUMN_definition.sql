/*
ALTER TABLE table_name
ALTER COLUMN column_name
[type_name] [NULL | NOT NULL] [COLLATE collation_name]
*/



-- Make it Nullable
ALTER TABLE HumanResources.Employee
ALTER COLUMN Gender nchar(1) NULL


-- Expanded nvarchar(256) to nvarchar(300)
ALTER TABLE HumanResources.Employee
ALTER COLUMN LoginID nvarchar(300) NOT NULL