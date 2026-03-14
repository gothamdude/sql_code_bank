
-- update simple query 
UPDATE Sales.SpecialOffer
SET DiscountPct = 0.15
WHERE SpecialOfferID = 10


-- Updating Rows Based on a FROM and WHERE Clause
UPDATE Sales.ShoppingCartItem
SET Quantity =2,
	ModifiedDate = GETDATE()
FROM Sales.ShoppingCartItem c
	INNER JOIN Production.Product p ON c.ProductID = p.ProductID
WHERE p.Name = 'Full-Finger Gloves, M ' AND c.Quantity > 2

/* 
Stepping through the code, the first line showed the table to be updated:

	UPDATE Sales.ShoppingCartItem

Next, the columns to be updated were designated in the SET clause:

	SET Quantity =2,
	ModifiedDate = GETDATE()

Next came the optional FROM clause where the Sales.ShoppingCartItem and Production.
Product tables were joined by ProductID. As you can see, the object being updated can also be referenced
in the FROM clause. The reference in the UPDATE and in the FROM were treated as the same table:
	
	FROM Sales.ShoppingCartItem c
	INNER JOIN Production.Product p ON
	c.ProductID = p.P roductID

Using the updated table in the FROM clause allows you to join to other tables. Presumably, those
other joined tables will be used to filter the updated rows or to provide values for the updated rows

If you are self-joining to more than one reference of the updated table in the FROM clause, at least
one reference to the object cannot specify a table alias. All the other object references, however,
would have to use an alias.

The WHERE clause specified that only the “Full-Finger Gloves, M” product in the Sales.
ShoppingCartItem should be modified, and only if the Quantity is greater than 2 units:

*/

WHERE p.Name = 'Full-Finger Gloves, M ' AND
c.Quantity > 2