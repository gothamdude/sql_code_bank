
/*   Large-Value String Data Types (MAX)

Table 9-1. The String Data Types
---------------------------------------------------------------------
Name			Type			Maximum Characters	Character Set
CHAR			Fixed width		8,000				ASCII
NCHAR			Fixed width		4,000				Unicode
VARCHAR			Variable width	8,000				ASCII
NVARCHAR		Variable width	4,000				Unicode
TEXT			Variable width	2^31 – 1			ASCII
NTEXT			Variable width	2^30 – 1			Unicode
VARCHAR(MAX)	Variable width	2^31 – 1			ASCII
NVARCHAR(MAX)	Variable width	2^30 – 1			Unicode
---------------------------------------------------------------------

You work with the MAX string data types just like you do with the traditional types for the most part 

*/
--1
CREATE TABLE #maxExample (maxCol VARCHAR(MAX),
line INT NOT NULL IDENTITY PRIMARY KEY);
GO
--2
INSERT INTO #maxExample(maxCol)
VALUES ('This is a varchar(max)');
--3
INSERT INTO #maxExample(maxCol)
VALUES (REPLICATE('aaaaaaaaaa',9000));
--4
INSERT INTO #maxExample(maxCol)
VALUES (REPLICATE(CONVERT(VARCHAR(MAX),'bbbbbbbbbb'),9000));

--5
SELECT LEFT(MaxCol,10) AS Left10,LEN(MaxCol) AS varLen
FROM #maxExample;
GO
DROP TABLE #maxExample;


/*  Large-Value Binary Data Types

You probably have less experience with the data types that store binary data. You can use BINARY,
VARBINARY, and IMAGE to store binary data including files such as images, movies, and Word documents.
The BINARY and VARBINARY data types can hold up to 8,000 bytes. The IMAGE data type, also deprecated,
holds data that exceeds 8,000 bytes, up to 2GB. Beginning with SQL Server 2005, use the VARBINARY(MAX)
data type, which can store up to 2GB of binary data, instead of IMAGE.*/

USE AdventureWorks2008;
GO
--1
IF OBJECT_ID('dbo.BinaryTest') IS NOT NULL BEGIN
DROP TABLE dbo.BinaryTest;
END;
--2
CREATE TABLE dbo.BinaryTest (DataDescription VARCHAR(50),
BinaryData VARBINARY(MAX));
GO
--3
INSERT INTO dbo.BinaryTest (DataDescription,BinaryData)
VALUES ('Test 1', CONVERT(VARBINARY(MAX),'this is the test 1 row')),
('Test 2', CONVERT(VARBINARY(MAX),'this is the test 2 row'));
--4
SELECT DataDescription, BinaryData, CONVERT(VARCHAR(MAX), BinaryData)
FROM dbo.BinaryTest;


-- Using FileStream  -- SKIPPING THIS; WILL BE VERY SLOW 