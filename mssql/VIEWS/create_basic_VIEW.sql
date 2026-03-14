USE [AdventureWorks2008]
Go 

/*
A view is created using the CREATE VIEW command. The syntax is as follows:

CREATE VIEW [ schema_name . ] view_name [ (column [ ,...n ] ) ]
[ WITH [ ENCRYPTION ] [ SCHEMABINDING ] [ VIEW_METADATA ] [ ,...n ] ]
AS select_statement
[ WITH CHECK OPTION ]

The SELECT statement allows a view to have up to 1,024 defined columns. You cannot use certain
SELECT elements in a view definition, including INTO, OPTION, COMPUTE, COMPUTE BY, or references
to table variables or temporary tables. You also cannot use ORDER BY, unless used in conjunction
with the TOP keyword.

This example demonstrates how to create a view that accesses data fromboth the
Production.TransactionHistory and the Production.Product tables:

*/

CREATE VIEW dbo.v_Product_TransactionHistory
AS
SELECT p.Name ProductName,
	p.ProductNumber,
	c.Name ProductCategory,
	s.Name ProductSubCategory,
	m.Name ProductModel,
	t.TransactionID,
	t.ReferenceOrderID,
	t.ReferenceOrderLineID,
	t.TransactionDate,
	t.TransactionType,
	t.Quantity,
	t.ActualCost
FROM Production.TransactionHistory t
	INNER JOIN Production.Product p ON t.ProductID = p.ProductID
	INNER JOIN Production.ProductModel m ON m.ProductModelID = p.ProductModelID
	INNER JOIN Production.ProductSubcategory s ON s.ProductSubcategoryID = p.ProductSubcategoryID
	INNER JOIN Production.ProductCategory c ON c.ProductCategoryID = s.ProductCategoryID
WHERE c.Name = 'Bikes'
GO

-- Next, I will query the new view to show transaction history for products by product name and model:

SELECT ProductName, ProductModel, ReferenceOrderID, ActualCost
FROM dbo.v_Product_TransactionHistory
ORDER BY ProductName