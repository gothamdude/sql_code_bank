USE AdventureWorks2008
GO

-- NOTE: COALESCE meets ANSI standards so it he preferred operator  

-- ISNULL replaces NULL values with what you supply
SELECT BusinessEntityID, FirstName + ISNULL(' '+MiddleName+' ', '') + LastName AS FullName 
FROM Person.Person 



-- COALESCE will take any number of parameters and return the next non null value
-- in this case, the empty string ; this one is not such  good example

SELECT BusinessEntityID, FirstName + COALESCE(' '+MiddleName+' ', '') + LastName AS FullName 
FROM Person.Person 


-- ANOTHER SAMPLE ; if both color or size are null, use 'No Color Or Size'
SELECT ProductID, 
		Size, 
		Color, 
		COALESCE(Size, Color, 'No Color Or Size') AS Description 
FROm Production.Product
Where ProductID <200