USE AdventureWorksLT2008
GO 

-- INSERT one row 
INSERT INTO [ITEM](
	  [UserID]
      ,[Name]
      ,[Description]
      ,[ImageFile]
      ,[Value])
VALUES (1,
		'My Korean Deli',
		'Risking it all for a convenience store .. a novel by Ben Ryder Howe',
		'011.jpg',
		16.75)
GO


-- INSERT multiple rows using UNION 
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MidldleName, LastName) 
SELECT 7 , 'Dominic', 'P.', 'Gash' 
UNION 
SELECT 10 , 'Kathleen', 'M.', 'Garza' 
UNION
SELECT 11 , 'Kathleen', NULL, 'Harding' 



INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MidldleName, LastName) 
VALUES	(7 , 'Dominic', 'P.', 'Gash'), 
		(10 , 'Kathleen', 'M.', 'Garza'),
		(11 , 'Kathleen', NULL, 'Harding') 
		 

-- INSERT from another table 
INSERT INTO dbo.demoCustomer(CustomerID,FirstName, MiddleName, LastName)
SELECT s.CustomerID, c.FirstName, c.MiddleName, c.LastName 
FROM SalesLT.Customer AS C
	INNER JOIN SalesLT.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID 