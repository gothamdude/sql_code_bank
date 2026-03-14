USE AdventureWorks2008
GO 

/*
SQL Server 2005 join types fall into three categories: inner, outer, and cross. Inner joins use the
INNER JOIN keywords. INNER JOIN operates by matching common values between two tables. Only
table rows satisfying the join conditions are used to construct the result set. INNER JOINs are the
default JOIN type, so if you wish, you can use just the JOIN keyword in your INNER JOIN operations.

Outer joins have three different join types: LEFT OUTER, RIGHT OUTER, and FULL OUTER joins. LEFT
OUTER and RIGHT OUTER JOINs, like INNER JOINs, return rows that match the conditions of the join
condition. Unlike INNER JOINs, LEFT OUTER JOINs return unmatched rows from the first table of the
join pair, and RIGHT OUTER JOINs return unmatched rows from the second table of the join pair. The
FULL OUTER JOIN clause returns unmatched rows on both the left and right tables.

An infrequently used join type is CROSS JOIN. A CROSS JOIN returns a Cartesian product when a
WHERE clause isn’t used. A Cartesian product produces a result set based on every possible combination
of rows from the left table, multiplied against the rows in the right table. For example, if the
Stores table has 7 rows, and the Sales table has 22 rows, you would receive 154 rows (or 7 times 22)
in the query results (each possible combination of row displayed).
*/

-- INNER JOIN 
SELECT	p.Name,
		s.DiscountPct
FROM Sales.SpecialOffer s
	INNER JOIN Sales.SpecialOfferProduct o ON s.SpecialOfferID = o.SpecialOfferID
	INNER JOIN Production.Product p ON o.ProductID = p.ProductID
WHERE p.Name = 'All-Purpose Bike Stand'


-- OUTER JOIN 
SELECT	s.CountryRegionCode,
		s.StateProvinceCode,
		t.TaxType,
		t.TaxRate
FROM Person.StateProvince s 
	LEFT OUTER JOIN Sales.SalesTaxRate t ON s.StateProvinceID = t.StateProvinceID


-- CROSS JOIN 
SELECT	s.CountryRegionCode,
		s.StateProvinceCode,
		t.TaxType,
		t.TaxRate
FROM Person.StateProvince s CROSS JOIN Sales.SalesTaxRate t


