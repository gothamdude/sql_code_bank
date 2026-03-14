/*
As of SQL Server 2005 and 2008, UPDATE and OPENROWSET can be used together to import an
image into a table. OPENROWSET can be used to import a file into a single-row, single-column value.

The basic syntax for OPENROWSET as it applies to this recipe is as follows:

	OPENROWSET
	( BULK 'data_file' ,
	SINGLE_BLOB | SINGLE_CLOB | SINGLE_NCLOB )

-----------------------------------------------------------------------------------------------------
Table 2-6. The OPENROWSET Command Arguments

Parameter					Description
data_file					This specifies the name and path of the file to read.
SINGLE_BLOB |SINGLE_CLOB |	Designate the SINGLE_BLOB object for importing into a
SINGLE_NCLOB				varbinary(max) data type. Designate SINGLE_CLOB for ASCII data
							into a varchar(max) data type and SINGLE_NCLOB for importing into
							a nvarchar(max) Unicode data type.
-----------------------------------------------------------------------------------------------------
*/


CREATE TABLE dbo.StockBmps(
	StockBmpID int NOT NULL,
	Bmp varbinary(max) NOT NULL)
GO

-- Next, a row containing the image file will be inserted into the table:
INSERT dbo.StockBmps (StockBmpID, bmp)
SELECT 1,  BulkColumn FROM OPENROWSET(BULK'C:\1577947.jpg', SINGLE_BLOB) AS x 

--  This next query selects the row from the table:
SELECT bmp
FROM StockBmps
WHERE StockBmpID = 1

-- to update 
UPDATE dbo.StockBmps
SET bmp = (SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Apress\StockPhotoTwo.bmp', SINGLE_BLOB) AS x)
WHERE StockBmpID =1


