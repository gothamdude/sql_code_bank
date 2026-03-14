/*
SQL Server 2008 introduces the ability to create filtered, nonclustered indexes in support of queries
that require only a small percentage of table rows. The CREATE INDEX command now includes a filter
predicate that can be used to reduce index size by indexing only rows thatmeet certain conditions.
That reduced index size saves on disk space and potentially improves the performance of queries
that now need only read a fraction of the index entries that they would otherwise have to process.
The filter predicate allows for several comparison operators to be used, including IS, IS NOT, =,
<>, >, <, andmore. In this recipe, I will demonstrate how to add filtered indexes to one of the larger
tables in the AdventureWorks database, Sales.SalesOrderDetail. To set upmy example, let’s assume
that I have the following common query against the UnitPrice column:
*/
SELECT SalesOrderID
FROM Sales.SalesOrderDetail
WHERE UnitPrice BETWEEN 150.00 AND 175.00

/*
Let’s also assume that the person executing this query is the only one who typically uses the
UnitPrice column in the search predicate, and when she does query it, she is only concerned with
values between $150 and $175. Creating a full index on this columnmay be considered to be wasteful.

If this query is executed often, and a full clustered index scan is performed against the base
table each time, thismay cause performance issues.

I have just described an ideal scenario for a filtered index on the UnitPrice column. You can
create that filtered index as follows:
*/

CREATE NONCLUSTERED INDEX NCI_UnitPrice_SalesOrderDetail
ON Sales.SalesOrderDetail(UnitPrice)
WHERE UnitPrice>=150.00 AND UnitPrice <= 175.00

/*
Queries that search against UnitPrice that also search in the defined filter predicate range will
likely use the filtered index instead of performing a full index scan or using full-table index alternatives.
In this second example, let’s assume that it is common to query products with two distinct IDs.
In this case, I amalso querying anything with an order quantity greater than ten; however, this is
notmy desired filtering scenario—just the product ID filtering:
*/

SELECT SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE ProductID IN (776, 777) AND
OrderQty > 10

/*
This query performs a clustered index scan. I can improve performance of the query by adding
a filtered index, which will result in an index seek against that nonclustered index instead of the
clustered index scan. Here’s how to create that filtered index:
*/

CREATE NONCLUSTERED INDEX NCI_ProductID_SalesOrderDetail
ON Sales.SalesOrderDetail(ProductID,OrderQty)
WHERE ProductID IN (776, 777)