USE AdventureWorksLT2008
GO 

-- simple Update Query 
UPDATE dbo.demoCustomer 
SET NameStyle = 0 
WHERE Title = 'Ms.'


-- UPDATE via JOIN 
UPDATE a
SET AddressLine1 = FirstName + ' ' + LastName, 
	Addressine2 = AddressLine1 + ISNULL(' ' + AddressLine2,' ') 
FROM dbo.demoAddress AS a 
	INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID 
	INNER JOIN dbo.demoCustomer AS c ON ca.CustomerID = c.CustomerID 


