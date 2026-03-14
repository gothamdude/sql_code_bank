USE SwapMap 
GO

--RTRIM, LTRIM
SELECT TOP 1000 [ItemID]
      ,RTRIM(LTRIM([Name]))
      ,RTRIM(LTRIM([Description]))
      ,[ImageFile]
      ,[Value]
FROM [SwapMap].[dbo].[Item]

-- LEFT, RIGHT   -- not sure there is any good use for RIGHT ; no sample here 
SELECT [ItemID]
      ,[Name]
      ,LEFT([Description], 20) + ' ... ' AS DESCRIPTION
      ,[Value]
FROM [SwapMap].[dbo].[Item]


-- LEN -- # of characters in a string
SELECT [ItemID]
      ,[Name]
      ,LEFT([Description], 20) + ' ... ' AS DESCRIPTION
      ,LEN(Description) AS HowManyCharsDescription
      ,[Value]
FROM [SwapMap].[dbo].[Item]


-- DATALENGTH -- # of number bytes  in a string 
-- Take note that DataLength on NVARCHAR, NCHAR will equal half of that 
-- CHAR, VARCHAR since the first two take up two bytes per character 
USE AdventureWorks2008
GO 

-- when used for string columns
SELECT DocumentNode, DocumentSummary, DATALENGTH(DocumentSummary) AS LengthOfDocumentSummary
FROM Production.Document
  
-- when used for varbinary columns 
SELECT DocumentNode, Document, DATALENGTH(Document) AS LengthOfDocument
FROM Production.Document


-- CHARINDEX() -- to find the numeric starting position of a search string insid another string 
-- by just checking whether CHARINDEX returns greater than 0, you can determine whether the 
-- search string exists in the second value
-- returns 12
SELECT CHARINDEX('Kerwin', 'Is it true Kerwin is typing up all the SQL rules') 
-- returns 0
SELECT CHARINDEX('Kerwin', 'Is it true Kerwin is typing up all the SQL rules',13) -- change START base 


--SUBSTRING (string, start, length) -- return string from another string with paramter for start base, length as option 
-- ; returns 'brown fox'
SELECT SUBSTRING('The cute brown fox jumped over the fence', 10, 10)

-- REVERSE 
SELECT REVERSE('REED')

-- UPPER, LOWER  -- uppercase and lowercase; use in conjunction with RTRIM,LTRIM comparison
SELECT UPPER('statue of liberty')
SELECT LOWER('WHITE HOUSE')

--- REPLACE (<string value>, <string to replace>, <replacement>)
SELECT REPLACE ('Kerwin is now living in Banawe.','Kerwin','Jelene') 








  
  
  