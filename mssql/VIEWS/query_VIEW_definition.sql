/* 
Querying theView Definition

You can view the Transact-SQL definition of a view by querying the sys.sql_modules systemcatalog
view.

This example shows you how to query a view’s SQL definition:

*/

SELECT definition 
FROM sys.sql_modules 
WHERE object_id = object_id('v_Product_TransactionHistory')


/*
-------------------------------------------------------------------------------------
definition
-------------------------------------------------------------------------------------
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
*/