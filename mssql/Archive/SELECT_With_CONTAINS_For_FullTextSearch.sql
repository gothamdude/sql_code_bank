USE AdventureWorks2008
GO

-- CONTAINS is one of the functions used to search full text indexes 
-- CONTAINS  is used for full-text search using fields that have full text catalog built 
-- into them. usually these are varbinary(max) columsn -- blobs

SELECT FileName 
FROM Production.Document
WHERE Contains (Document, 'important')

SELECT FileName 
FROM Production.Document
WHERE Contains (Document, ' "service guidelines" ')
	AND DocumentLevel = 2
	
SELECT FileName 
FROM Production.Document
WHERE Contains (DocumentSummary, 'bicycle and reflectors') -- include 'bicycle' and 'reflectors' found in tex 
	
SELECT FileName 
FROM Production.Document
WHERE Contains (DocumentSummary, 'bicycle AND NOT reflectors')  -- include 'bicycle' exclude  'reflectors' found in tex 

SELECT FileName 
FROM Production.Document
WHERE Contains (DocumentSummary, 'maintain NEAR bicycle AND NOT reflectors')

SELECT FileName, DocumentSummary
FROM Production.Document
WHERE Contains ((DocumentSummary, Document), 'maintain')  --multiple columns not necessarily full text only
	--IS SIMILAR TO --
SELECT FileName, DocumentSummary
FROM Production.Document
WHERE CONTAINS ((DocumentSummary), 'maintain')  --multiple columns not necessarily full text only
	OR CONTAINS ((Document), 'maintain')
	

SELECT FileName, DocumentSummary
FROM Production.Document
WHERE CONTAINS (*, 'maintain')  -- search in all fields 