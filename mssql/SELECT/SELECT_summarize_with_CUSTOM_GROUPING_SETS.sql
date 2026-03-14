/*
SQL Server 2008 introduces the ability to define your own grouping sets within a single query result
set without having to resort to multiple UNION ALLs. Grouping sets also provides you with more control
over what is aggregated, compared to the previously demonstrated CUBE and ROLLUP operations.
This is performed by using the GROUPING SETS operator.

First, I’ll demonstrate by defining an example business requirement for a query. Let’s assume I
want a single result set to contain three different aggregate quantity summaries. Specifically, I
would like to see quantity totals by shelf, quantity totals by shelf and product name, and then also
quantity totals by location and name.

To achieve this in previous versions of SQL Server, you would need to have used UNION ALL:
*/
	SELECT NULL, i.LocationID, p.Name, SUM(i.Quantity) Total
	FROM Production.ProductInventory i
		INNER JOIN Production.Product p ON i.ProductID = p.ProductID
	WHERE Shelf IN ('A','C') AND Name IN ('Chain', 'Decal', 'Head Tube')
	GROUP BY i.LocationID, p.Name

	UNION ALL

	SELECT i.Shelf, NULL, NULL, SUM(i.Quantity) Total
	FROM Production.ProductInventory i
	INNER JOIN Production.Product p ON i.ProductID = p.ProductID
	WHERE Shelf IN ('A','C') AND Name IN ('Chain', 'Decal', 'Head Tube')
	GROUP BY i.Shelf

	UNION ALL
	
	SELECT i.Shelf, NULL, p.Name, SUM(i.Quantity) Total 
	FROM Production.ProductInventory i 
		INNER JOIN Production.Product p ON i.ProductID = p.ProductID
	WHERE Shelf IN ('A','C') AND Name IN ('Chain', 'Decal', 'Head Tube')
	GROUP BY i.Shelf, p.Name

/*
In SQL Server 2008, you can save yourself all that extra code by using the GROUPING SETS operator
instead to define the various aggregations you would like to have returned in a single result set:
*/

SELECT	i.Shelf, 
		i.LocationID,
		p.Name,
		SUM(i.Quantity) Total
FROM Production.ProductInventory i 
	INNER JOIN Production.Product p ON i.ProductID = p.ProductID
WHERE Shelf IN ('A','C') 
	AND  Name IN ('Chain', 'Decal', 'Head Tube')
GROUP BY 
	GROUPING SETS ((i.Shelf), (i.Shelf, p.Name), (i.LocationID, p.Name))

-- NOTE: instead of using multiple unions 