/*

You learned all about aggregate queries in Chapter 5. Another option, GROUPING SETS, when added to an
aggregate query, allows you to combine different grouping levels within one statement. This is
equivalent to combining multiple aggregate queries with UNION. For example, suppose you want the data
summarized by one column combined with the data summarized by a different column. Just like MERGE,
this feature is very valuable for loading data warehouses and data marts. When using GROUPING SETS
instead of UNION, you can see increased performance, especially when the query includes a WHERE clause
and the number of columns specified in the GROUPING SETS clause increases. Here is the syntax:

Listing 10-9 compares the equivalent UNION query to a query using GROUPING SETS. Type in and
execute the code to learn more. */

--Listing 10-9. Using GROUPING SETS

USE AdventureWorks2008;
GO
--1
SELECT NULL AS SalesOrderID,SUM(UnitPrice)AS SumOfPrice,ProductID
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 44175 AND 44180
GROUP BY ProductID
UNION
SELECT SalesOrderID,SUM(UnitPrice), NULL
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 44175 AND 44180
GROUP BY SalesOrderID;

--2
SELECT SalesOrderID,SUM(UnitPrice) AS SumOfPrice,ProductID
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 44175 AND 44180
GROUP BY GROUPING SETS(SalesOrderID,ProductID);


/*
Figure 10-9 shows the partial results. Query 1 is a UNION query that calculates the sum of the
UnitPrice. The first part of the query supplies a NULL value for SalesOrderID. That is because
SalesOrderID is just a placeholder. The query groups by ProductID, and SalesOrderID is not needed. The
second part of the query supplies a NULL value for ProductID. In this case, the query groups by
SalesOrderID, and ProductID is not needed. The UNION query combines the results. Query 2 demonstrates
how to write the equivalent query using GROUPING SETS. */