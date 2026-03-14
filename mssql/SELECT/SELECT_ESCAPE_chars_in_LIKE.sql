USE AdventureWorks2008
GO 

-- ESCAPE a character 
UPDATE Production.ProductDescription
SET [Description] = 'Chromoly steel. High % of defects'
WHERE ProductDescriptionID = 3


SELECT  ProductDescriptionID, 
		[Description]
FROM Production.ProductDescription
WHERE Description LIKE '%/%%' ESCAPE '/'

