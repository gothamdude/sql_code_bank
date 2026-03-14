
/*
The ALTER VIEW command is used tomodify the definition of an existing view. The syntax is as
follows:
*/

ALTER VIEW dbo.v_Product_TransactionHistory
AS
SELECT p.Name,
p.ProductNumber,
t.TransactionID,
t.TransactionDate,
t.TransactionType,
t.Quantity,
t.ActualCost
FROM Production.TransactionHistory t
INNER JOIN Production.Product p ON
t.ProductID = p.ProductID
WHERE Quantity > 10
GO