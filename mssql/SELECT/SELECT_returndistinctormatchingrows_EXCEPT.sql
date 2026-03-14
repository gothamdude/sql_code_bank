-- First two new tables based on ProductionProduct will be
-- created, in order to demonstrate EXCEPT and INTERSECT.
-- See Chapter 8 for more on ROW_NUMBER
-- Create TableA

SELECT	prod.ProductID,
		prod.Name
INTO dbo.TableA
FROM (	SELECT ProductID,
			Name,
			ROW_NUMBER() OVER (ORDER BY ProductID) RowNum
		FROM Production.Product
		) prod
WHERE RowNum BETWEEN 1 and 20

-- Create TableB
SELECT	prod.ProductID,
		prod.Name
INTO dbo.TableB
FROM (	SELECT ProductID, 
				Name,
				ROW_NUMBER() OVER (ORDER BY ProductID) RowNum
		FROM Production.Product
		) prod
WHERE RowNum BETWEEN 10 and 29

-- Now the EXCEPT operator will be used to determine which rows exist only in the 
-- left table of the query, TableA, and not in TableB:

	SELECT ProductID,
			Name
	FROM dbo.TableA
	EXCEPT
	SELECT ProductID,
			Name
	FROM dbo.TableB


-- To show distinct values from both result sets that match, use the INTERSECT operator:

SELECT	ProductID,
		Name
FROM dbo.TableA
INTERSECT
SELECT ProductID,
		Name
FROM dbo.TableB