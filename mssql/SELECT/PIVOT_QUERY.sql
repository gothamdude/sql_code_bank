USE AdventureWorks2008
GO 

--SELECT c.CustomerID, s.SalesOrderID
--FROM Sales.Customer AS c 
--	INNER JOIN (SELECT SalesOrderID, CustomerID
--				FROM Sales.SalesOrderHeader) AS s 
--			ON c.CustomerID = s.CustomerID


With orders AS (
	SELECT SalesOrderID, CustomerID 
	FROM Sales.SalesOrderHeader
	) 

SELECT c.CustomerID, o.SalesOrderID 
FROM Sales.Customer AS c 
	INNER JOIN orders  as o ON c.CustomerID = o.CustomerID

-- product a list of all customers along with orders if any places on a certain date 


select c.customerid, s.SalesOrderID, s.OrderDate 
from sales.Customer as c 
	left outer join  sales.SalesOrderHeader as s on c.CustomerID = s.customerID  
where s.orderdate = '2005/07/01'



-- use cte to solve problem 
with orders as (
select salesorderid, customerid, orderdate 
from sales.SalesOrderHeader 
where orderdate = '2005/07/01')

select c.customerid, o.salesorderid, o.orderdate
from sales.customer as c 
	left outer join orders o on c.customerid = o.customerid 
order by o.OrderDate desc


--SELECT COUNT(*) 
--FROM Sales.SalesOrderHeader

SELECT TOP 100* 
FROM Sales.SalesOrderHeader


SELECT YEAR(OrderDate) As OrderYear, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 1 THEN TotalDue ELSE 0 END),0) AS Jan, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 2 THEN TotalDue ELSE 0 END),0) AS Feb, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 3 THEN TotalDue ELSE 0 END),0) AS Mar, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 4 THEN TotalDue ELSE 0 END),0) AS April, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 5 THEN TotalDue ELSE 0 END),0) AS May, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 6 THEN TotalDue ELSE 0 END),0) AS June, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 7 THEN TotalDue ELSE 0 END),0) AS July, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 8 THEN TotalDue ELSE 0 END),0) AS August, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 9THEN TotalDue ELSE 0 END),0) AS September, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 10 THEN TotalDue ELSE 0 END),0) AS October, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 11 THEN TotalDue ELSE 0 END),0) AS November, 
	ROUND(SUM(CASE MONTH(OrderDate) WHEN 12 THEN TotalDue ELSE 0 END),0) AS December 
FROM Sales.SalesOrderHeader
Group BY YEAR(OrderDate) 
ORDER By OrderYear 




