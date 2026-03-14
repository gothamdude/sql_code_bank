/* 
Using the PIVOT Function

Microsoft introduced the PIVOT function with SQL Server 2005. In my opinion, the PIVOT function is more
difficult to understand than using CASE to produce the same results. Just like CASE, you have to hard-code
the column names. This works fine when the pivoted column names will never change, such as the
months of the year. When the query bases the pivoted column on data that changes over time, such as
employee or department names, the query must be modified each time that data changes. Here is
the syntax for PIVOT:

SELECT <groupingCol>, <pivotedValue1> [AS <alias1>], <pivotedValue2> [AS <alias2>]
FROM (SELECT <groupingCol>, <value column>, <pivoted column>) AS <queryAlias>
PIVOT
( <aggregate function>(<value column>)
FOR <pivoted column> IN (<pivotedValue1>,<pivotedValue2>)
) AS <pivotAlias>
[ORDER BY <groupingCol>]


The SELECT part of the query lists any nonpivoted columns along with the values from the
pivoted column. These values from the pivoted column will become the column names in your query.
You can use aliases if you want to use a different column name than the actual value. For example, if the
column names will be the month numbers, you can alias with the month names.
This syntax uses a derived table, listed after the word FROM, as the basis of the query. See the
“Derived Tables” section in Chapter 4 to review derived tables. Make sure that you only list columns that
you want as grouping levels, the pivoted column, and the column that will be summarized in this
derived table. Adding other columns to this query will cause extra grouping levels and unexpected
results. The derived table must be aliased, so don’t forget that small detail.

Follow the derived table with the PIVOT function. The argument to the PIVOT function includes
the aggregate expression followed by the word FOR and the pivoted column name. Right after the pivoted
column name, include an IN expression. Inside the IN expression, list the pivoted column values. These
will match up with the pivoted column values in the SELECT list. The PIVOT function must also have an
alias. Finally, you can order the results if you want. Usually, this will be by the grouping level column,
but you can also sort by any of the pivoted column names. Type in and execute Listing 10-11 to learn
how to use PIVOT. */

USE AdventureWorks2008;
GO

--1
SELECT OrderYear, [1] AS Jan, [2] AS Feb, [3] AS Mar,
[4] AS Apr, [5] AS May, [6] AS Jun
FROM (SELECT YEAR(OrderDate) AS OrderYear, TotalDue,
MONTH(OrderDate) AS OrderMonth
FROM Sales.SalesOrderHeader) AS MonthData
PIVOT (
SUM(TotalDue)
FOR OrderMonth IN ([1],[2],[3],[4],[5],[6])
) AS PivotData
ORDER BY OrderYear;
--2
SELECT OrderYear, ROUND(ISNULL([1],0),0) AS Jan,
ROUND(ISNULL([2],0),0) AS Feb, ROUND(ISNULL([3],0),0) AS Mar,
ROUND(ISNULL([4],0),0) AS Apr, ROUND(ISNULL([5],0),0) AS May,
ROUND(ISNULL([6],0),0) AS Jun
FROM (SELECT YEAR(OrderDate) AS OrderYear, TotalDue,
MONTH(OrderDate) AS OrderMonth
FROM Sales.SalesOrderHeader) AS MonthData
PIVOT (
SUM(TotalDue)
FOR OrderMonth IN ([1],[2],[3],[4],[5],[6])
) AS PivotData
ORDER BY OrderYear;


/*
Figure 10-11 shows the results. First take a look at the derived table aliased as MonthData in
query 1. The SELECT statement in the derived table contains an expression that returns the year of the
OrderDate, the OrderYear, and an expression that returns the month of the OrderDate, OrderMonth. It also
contains the TotalDue column. The query will group the results by OrderYear. The OrderMonth column is
the pivoted column. The query will sum up the TotalDue values. The derived table contains only the
columns and expressions needed by the pivoted query.

The PIVOT function specifies the aggregate expression SUM(TotalDue). The pivoted column is
OrderMonth. The IN expression contains the numbers 1–6, each surrounded by brackets. The IN
expression lists the values for OrderMonth that you want to show up in the final results. These values are
also the column names. Since columns starting with numbers are not valid column names, the brackets
surround the numbers. You could also quote these numbers. The IN expression has two purposes: to
provide the column names and to filter the results.
The outer SELECT list contains OrderYear and the numbers 1–6 surrounded with brackets. These
must be the same values found in the IN expression. Because you want the month abbreviations instead
of numbers as the column names, the query uses aliases. Notice that the SELECT list does not contain the
TotalDue column. Finally, the ORDER BY clause specifies that the results will sort by OrderYear.
The results of query 2 are identical to the results from the pivoted results using the CASE
technique in the previous section. This query uses the ROUND and ISNULL functions to replace NULL with

*/
