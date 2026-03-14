SELECT CustomerID, 
		FirstName + ' ' + LastName As Name, 
		c.TerritoryID, 
		Row_NUMBER() OVER ( Partition BY c.TerritoryID ORDER BY LastName, FirstName) AS Row 
FROM Sales.Customer AS c 
	INNER JOIN Person.Person AS p 
ON c.PersonID = p.BusinessEntityID

 -- parition by res-starts the seed number for each 