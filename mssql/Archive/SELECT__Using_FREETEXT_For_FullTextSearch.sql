USE AdventureWorks2008
GO 

-- FREETEXT is similar to contains except that it returns rows that do not exactly.
-- It will return rows that have terms with similar meanings to your search terms by using a thesaurus
-- FREETEXT is less precise that CONTAINS and it is flexible 

SELECT 'FileName', DocumentSummary
FROM Production.Document
WHERE FREETEXT ((DocumentSummary), 'provides')  -- finds same meaning as provides 

-- You cannot use AND, OR , NEAR with FREETEXT function 






