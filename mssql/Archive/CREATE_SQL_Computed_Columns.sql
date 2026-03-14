/*
Several rules apply to using these column types:
• A table may contain only one IDENTITY column
• By default, IDENTITY columns begin with the value 1 and increment by 1.
You can specify different values by specifying seed and increment values.
• You may not insert values into IDENTITY columns unless the IDENTITY_INSERT setting is turned
on for the table and session.
• A table may contain only one ROWVERSION column.
• The ROWVERSION value will be unique within the database.
• You may not insert values into ROWVERSION columns.
• Each time you update the row, the ROWVERSION value changes.
• A table may contain multiple COMPUTED columns.
• Do not specify a data type for COMPUTED columns.
• You may not insert values into COMPUTED columns.
• By specifying the option PERSISTED, the database engine stores the value in
the table.
• You can define indexes on PERSISTED COMPUTED columns.
• You can specify other non-COMPUTED columns, literal values, and scalar functions in the COMPUTED
column definition.
• You do not need to specify a value for a column with a DEFAULT value defined.
• You can use expressions with literal values and scalar functions, but not other column names
with DEFAULT value columns.
• If a value is specified for a column with a DEFAULT, the specified value applies.
• If a column with a DEFAULT value specified allows NULL values, you can still specify NULL for the
column.
*/

USE tempdb;
GO
--1
IF OBJECT_ID('table3') IS NOT NULL BEGIN
DROP TABLE table3;
END;
--2
CREATE TABLE table3 (col1 VARCHAR(10),
idCol INT NOT NULL IDENTITY,
rvCol ROWVERSION,
defCol DATETIME2 DEFAULT GETDATE(),
calcCol1 AS DATEADD(m,1,defCol),
calcCol2 AS col1 + ':' + col1 PERSISTED);
GO
--3
INSERT INTO table3 (col1)
VALUES ('a'), ('b'), ('c'), ('d'), ('e'), ('g');
--4
INSERT INTO table3 (col1, defCol)
VALUES ('h', NULL),('i','1/1/2009');
--5
SELECT col1, idCol, rvCol, defCol, calcCol1, calcCol2
FROM table3;