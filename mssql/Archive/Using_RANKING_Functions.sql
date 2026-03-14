/*
Ranking Functions

The ranking functions introduced with SQL Server 2005 allow you to assign a number to each row
returned from a query. For example, suppose you need to include a row number with each row for
display on a web page. You could come up with a method to do this, such as inserting the query results
into a temporary table that includes an IDENTITY column, but now you can create the numbers by using
the new ROW_NUMBER function. During your T-SQL programming career, you will probably find you can
solve many query problems by including ROW_NUMBER. Recently I needed to insert several thousand rows
into a table that included a unique ID. I was able to add the maximum ID value already in the table to the
result of the ROW_NUMBER function to successfully insert the new rows.

Using ROW_NUMBER

The ROW_NUMBER function returns a sequential numeric value along with the results of a query. The
ROW_NUMBER function contains the OVER clause, which the function uses to determine the numbering
behavior. You must include the ORDER BY option, which determines the order in which the function
applies the numbers. You have the option of starting the numbers over whenever the values of a
specified column change, called partitioning, with the PARTITION BY clause. One limitation with using
ROW_NUMBER is that you cannot include it in the WHERE clause. To filter the rows, include the query
containing ROW_NUMBER in a CTE, and then filter on the ROW_NUMBER alias in the outer query. Here is
the syntax:

*/

-- Listing 10-13. Using ROW_NUMBER

USE AdventureWorks2008;
GO
--1
SELECT CustomerID, FirstName + ' ' + LastName AS Name,
ROW_NUMBER() OVER (ORDER BY LastName, FirstName) AS Row
FROM Sales.Customer AS c INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;

--2
WITH customers AS (
SELECT CustomerID, FirstName + ' ' + LastName AS Name,
ROW_NUMBER() OVER (ORDER BY LastName, FirstName) AS Row
FROM Sales.Customer AS c INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID
)

SELECT CustomerID, Name, Row
FROM customers
WHERE Row > 50
ORDER BY Row;
--3
SELECT CustomerID, FirstName + ' ' + LastName AS Name, c.TerritoryID,
ROW_NUMBER() OVER (PARTITION BY c.TerritoryID
ORDER BY LastName, FirstName) AS Row
FROM Sales.Customer AS c INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;

/*
Using RANK and DENSE_RANK

RANK and DENSE_RANK are very similar to ROW_NUMBER. The difference is how the functions deal with ties in
the ORDER BY values. RANK assigns the same number to the duplicate rows and skips numbers not used.
DENSE_RANK doesn’t skip numbers. For example, if rows 2 and 3 are duplicates, RANK will supply the values
1, 3, 3, and 4, and DENSE_RANK will supply the values 1, 2, 2, and 3. Here is the syntax:

*/
-- Listing 10-14. Using RANK and DENSE_RANK
USE AdventureWorks2008;
GO
SELECT CustomerID,COUNT(*) AS CountOfSales,
		RANK() OVER(ORDER BY COUNT(*) DESC) AS Ranking,
		ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS Row,
		DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS DenseRanking
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY COUNT(*) DESC;


/*
Using NTILE
While the other ranking functions supply a row number or rank to each row, the NTILE function assigns
buckets to groups of rows. For example, suppose the AdventureWorks company wants to divide up
bonus money for the sales staff. You can use the NTILE function to divide up the money based on the
sales by each employee. Here is the syntax:

SELECT <col1>, NTILE(<buckets>) OVER([PARTITION BY <col1>,<col1>]
ORDER BY <col1>,<col2>) AS <alias>
FROM <table1>
Type in and execute Listing 10-15 to learn how to use NTILE.

Listing 10-15. Using NTILE
*/
USE AdventureWorks2008;
GO

SELECT SalesPersonID,SUM(TotalDue) AS TotalSales,
	NTILE(10) OVER(ORDER BY SUM(TotalDue)) * 10000/COUNT(*) OVER() AS Bonus
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
	AND OrderDate BETWEEN '1/1/2008' AND '12/31/2008'
GROUP BY SalesPersonID
ORDER BY TotalSales;

/*
Figure 10-15 shows the results. The AdventureWorks sales department has $10,000 to divide up
in bonuses for the sales staff based on total sales per person. The query returns the sum of the total sales
grouped by the SalesPersonID for 2004. The NTILE function divides the rows into 10 groups, or buckets,
based on the sales for each salesperson. The query multiplies the value returned by the NTILE expression
by 10,000 divided by the number of rows to determine the bonus amount. The query uses the COUNT(*)
OVER() expression to determine the number of rows in the results. See “The OVER Clause” in Chapter 5
to review how this works.
*/