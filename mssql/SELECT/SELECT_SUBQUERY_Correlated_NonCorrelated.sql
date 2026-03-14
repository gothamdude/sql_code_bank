USE AdventureWorks2008
GO 

/*
A subquery is a SELECT query that is nested within another SELECT, INSERT, UPDATE, or DELETE statement.
A subquery can also be nested inside another subquery. Subqueries can often be rewritten
into regular JOINs; however, sometimes an existence subquery (demonstrated in this recipe) can
performbetter than equivalent non-subquery methods.

A correlated subquery is a subquery whose results depend on the values of the outer query.
*/

-- This first example demonstrates checking for the existence of matching rows within a correlated subquery:
SELECT DISTINCT s.PurchaseOrderNumber
FROM Sales.SalesOrderHeader s
WHERE EXISTS (	SELECT SalesOrderID
				FROM Sales.SalesOrderDetail
				WHERE UnitPrice BETWEEN 1000 AND 2000 AND SalesOrderID = s.SalesOrderID)


-- This second example demonstrates a regular non-correlated subquery:
SELECT	BusinessEntityID,
		SalesQuota CurrentSalesQuota
FROM Sales.SalesPerson
WHERE SalesQuota = (SELECT MAX(SalesQuota) FROM Sales.SalesPerson)





