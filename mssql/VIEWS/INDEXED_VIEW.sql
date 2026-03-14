/*

A view is nomore efficient than the underlying SELECT query that you use to define it. However, one
way you can improve the performance of a frequently accessed view is to add an index to it. To do
so, youmust first create a unique, clustered index on the view. Once this index has been built, the
data used tomaterialize the view is stored inmuch the same way as a table’s clustered index. After
creating the unique clustered index on the view, you can also create additional nonclustered
indexes. The underlying (base) tables are not impacted physically by the creation of these view
indexes, as they are separate underlying objects.

Indexed views can be created across all editions of SQL Server, although they require SQL
Server Enterprise Edition in order for the Query Optimizer to automatically consider using an
indexed view in a query execution plan. In SQL Server Enterprise Edition, an indexed view can
automatically be used by the Query Optimizer when it is deemed useful, even if the SQL statement
explicitly references the view’s underlying base tables and not the view itself. In editions other than
Enterprise Edition, you canmanually force an indexed view to be used by the Query Optimizer by
using the NOEXPAND table hint (reviewed later in the chapter in the “Forcing the Optimizer to Use an
Index for an Indexed View” recipe).

Indexed views are particularly ideal for view definitions that aggregate data acrossmany rows,
as the aggregated values remain updated andmaterialized, and can be queried without continuous
recalculation. Indexed views are ideal for queries referencing infrequently updated base tables, but
creating themon highly volatile tablesmay result in degraded performance due to constant updating
of the indexes. Base tables with frequent updates will trigger frequent index updates against the
view,meaning that update speed will suffer at the expense of query performance.

Creating an IndexedView

In this recipe, I’ll demonstrate how to create an indexed view. First, I will create a new view, and
then create indexes (clustered and nonclustered) on it. In order to create an indexed view, you are
required to use the WITH SCHEMABINDING option, which binds the view to the schema of the underlying
tables. This prevents any changes in the base table that would impact the view definition. The
WITH SCHEMABINDING option also adds additional requirements to the view’s SELECT definition.
Object references in a schema-bound viewmust include the two-part schema.object naming convention,
and all referenced objects have to be located in the same database.

*/

CREATE VIEW dbo.v_Product_Sales_By_LineTotal
WITH SCHEMABINDING 
AS 
SELECT p.ProductID, p.Name ProductName,
SUM(LineTotal) LineTotalByProduct,
COUNT_BIG(*) LineItems
FROM Sales.SalesOrderDetail s
INNER JOIN Production.Product p ON
s.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
GO

/*Before creating an index, we’ll demonstrate querying the regular view, returning the query
I/O cost statistics using the SET STATISTICS IO command (see Chapter 28 formore info on this
command): */

SET STATISTICS IO ON
GO

SELECT TOP 5 ProductName, LineTotalByProduct
FROM v_Product_Sales_By_LineTotal
ORDER BY LineTotalByProduct DESC

/*
This returns the following results:

ProductName LineTotalByProduct
Mountain-200 Black, 38 4400592.800400
Mountain-200 Black, 42 4009494.761841
Mountain-200 Silver, 38 3693678.025272
Mountain-200 Silver, 42 3438478.860423
Mountain-200 Silver, 46 3434256.941928

This also returns I/O information reporting the various scanning activities against the underlying
base tables used in the view (if you are following along with this recipe, keep inmind that your
actual statsmay vary):
*/
Table 'Product'. Scan count 0, logical reads 10, physical reads 0, read-ahead reads
0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads
0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'SalesOrderDetail'. Scan count 1, logical reads 1241, physical reads 7,
read-ahead reads 1251, lob logical reads 0, lob physical reads 0,
lob read-ahead reads 0.
/*
Next, I’ll add a clustered index that will be created on the regular view, based on the unique
value of the ProductID view column:
*/

CREATE UNIQUE CLUSTERED INDEX UCI_v_Product_Sales_By_LineTotal
ON dbo.v_Product_Sales_By_LineTotal (ProductID)
GO

-- Once the clustered index is created, I can then start creating nonclustered indexes as needed:
CREATE NONCLUSTERED INDEX NI_v_Product_Sales_By_LineTotal
ON dbo.v_Product_Sales_By_LineTotal (ProductName)
GO
-- Next, I’ll execute the query I executed earlier against the regular view:
SELECT TOP 5 ProductName, LineTotalByProduct
FROM v_Product_Sales_By_LineTotal
ORDER BY LineTotalByProduct DESC

/*
This returns the same results as before, but this time the I/O activity is different. Instead of two
base tables being accessed, along with a worktable (tempdb used temporarily to process results),
only a single object is accessed to retrieve results:
*/
Table 'v_Product_Sales_By_LineTotal'. Scan count 1, logical reads 5, physical
reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob
read-ahead reads 0


-- YOU CAN SEE IT WENT AFTER THE VIEW ONLY 