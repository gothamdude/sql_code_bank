
/* 
SYNTAX 

DELETE [FROM] table_or_view_name
WHERE search_condition

*/


-- DELETE all rows 
DELETE Production.Example_ProductProductPhoto


-- DELETE with a WHERE clause 
DELETE Production.Example_ProductProductPhoto
WHERE ProductID NOT IN  (SELECT ProductID FROM Production.Product)


-- DELETE using a join 
DELETE Production.ProductProductPhoto
FROM Production.Example_ProductProductPhoto ppp
LEFT OUTER JOIN Production.Product p ON ppp.ProductID = p.ProductID
WHERE p.ProductID IS NULL