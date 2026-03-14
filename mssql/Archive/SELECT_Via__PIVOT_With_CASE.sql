/* 

Pivoted Queries

Normally, a query displays the data in a way that is similar to how it looks in a table, often with the
column headers being the actual names of the columns within the table. 
A pivoted query displays the values of one column as column headers instead. For example, you could
display the sum of the sales by month so that the month names are column headers. Each row would
then contain the data by year with the sum for each month displayed from left to right. This section
shows how to write pivoted queries with two techniques: CASE and PIVOT.

Pivoting Data with CASE

Before SQL Server 2005, many developers used the CASE function to create pivoted results. (See “The
Case Function” section in Chapter 3 to learn more about CASE.) In fact, many still use this technique.
Essentially, you use several CASE expressions in the query, one for each pivoted column header. For
example, the query will have a CASE expression checking to see whether the month of the order date is
January. If the order does occur in January, supply the total sales value. If not, supply a zero. For each
row, the data ends up in the correct column where it can be aggregated. Here is the syntax for using CASE
to pivot data:

Listing 10-10. Using CASE to Pivot Data */

USE AdventureWorks2008;
GO
SELECT YEAR(OrderDate) AS OrderYear,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 1 THEN TotalDue ELSE 0 END),0)
AS Jan,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 2 THEN TotalDue ELSE 0 END),0)
AS Feb,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 3 THEN TotalDue ELSE 0 END),0)
AS Mar,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 4 THEN TotalDue ELSE 0 END),0)
AS Apr,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 5 THEN TotalDue ELSE 0 END),0)
AS May,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 6 THEN TotalDue ELSE 0 END),0)
AS Jun
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

/* 
Figure 10-10 shows the results. To save space in the results, the statement calculates the totals
only for the months January through June and uses the ROUND function. The GROUP BY clause contains just
the YEAR(OrderDate) expression. You might think that you need to group by month as well, but this
query doesn’t group by month. It just includes each TotalDue value in a different column depending on
the month. */