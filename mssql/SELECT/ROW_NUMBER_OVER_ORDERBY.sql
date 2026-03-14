SELECT  Row_NUMBER() OVER (ORDER BY LastName, FirstName) AS Row, 
		CustomerID, 
		FirstName + ' ' + LastName As Name
FROM Sales.Customer AS c 
	INNER JOIN Person.Person AS p
	ON c.PersonID = p.BusinessEntityID