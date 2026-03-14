Use AdventureWorks2008
Go 

-- INNER JOIN 
SELECT E.BusinessEntityID, E.LoginID, D.Name
FROM HumanResources.Employee AS E
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH ON E.BusinessEntityID = EDH.BusinessEntityID
	INNER JOIN HumanResources.Department AS D ON EDH.DepartmentID = D.DepartmentID
WHERE EDH.StartDate > '01/01/2005' AND EndDate IS NULL 

	
-- LEFT OUTER JOIN JOIN   -- get only those with values on LEFT TABLE including NULL on RIGHT TABLE 
SELECT P.ProductID, P.Name, PCH.StartDate, PCH.EndDate
FROM Production.Product AS P 
	LEFT OUTER JOIN Production.ProductCostHistory AS PCH ON P.ProductID = PCH.ProductID
ORDER BY ProductID 

-- RIGHT OUTER JOIN  -- used only if your MAIN table is the one on the righ 
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate
FROM Sales.SalesOrderHeader As S
RiGHT OUTER JOIN Sales.Customer As C ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IN (11208,11029,1,2,34)

-- OUTER JOIN TO Find Rows With No match 
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate
FROM Sales.Customer As C 
	LEFT OUTER JOIN Sales.SalesOrderHeader AS S ON c.CustomerID=s.CustomerID  
WHERE s.SalesOrderID IS NULL 

-- for multiple tables use left outer join for all so as to maintain that one MAIN table as your reference 
SELECT c.CustomerID, soh.SalesOrderID, sod.SalesOrderDetailID, SOD.ProductID
FROM Sales.Customer As C 
	LEFT OUTER JOIN Sales.SalesOrderHeader AS SOH ON c.CustomerID=soh.CustomerID  
	LEFT OUTER JOIN Sales.SalesOrderDetail AS SOD ON c.CustomerID=sod.SalesOrderID
WHERE c.CustomerID IN (11208,11029,1,2,34)


-- FULL OUTER JOIN  ; similar to LEFT OUTER JOIN and RIGHT OUTER JOIN 
-- but in case all rows from each side of the join are returned (i.e. the ones without match included)
-- NO SAMPLE 


-- CROSS JOIN ; rarely used ; also called Cartesian Product 
-- you might write a CROSS JOIN query to populate a table for a special purpose such as inventory
-- you may need a list of every product in very possible location 
-- below example justvaries on how to sort 
SELECT p.ProductID, L.LocationID 
FROM Production.Product AS p
	CROSS JOIN Production.Location AS L 
ORDER BY ProductID 

SELECT p.ProductID, L.LocationID 
FROM Production.Product AS p
	CROSS JOIN Production.Location AS L 
ORDER BY LocationID 

--SELF JOIN  -- joins a table back to itself. 
-- e.g. correlation between two entities  (like a chain) but all in one table 
-- e.g. person reporting to one person reporting to another person and so on ....
SELECT E1.EmployeeID, E1.Title As EmployeeTitle, E2.EmployeeID AS ManagerID, E2.Title as ManagerTitle 
FROM HumanResources.Employee AS E1
	LEFT OUTER JOIN HumanResources.Employee AS E2 ON E1.ManagerID = E2.EmployeeID 


