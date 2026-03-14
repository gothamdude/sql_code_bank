USE AdventureWorks2008
GO 

-- GROUPING AND SUMMARIZING 

-- COUNT   -  count number of non-null values  
-- SUM  - adds up the values 
-- AVG   - calculates average in numeric or money data 
-- MIN  - lowest value ; can be used string data as well as numeric, money, or date data 
-- MAX  - highest value ; can be used string data as well as numeric, money, or date data 

--1 
SELECT COUNT(*) AS CountOfRows, 
	MAX(TotalDue) As MaxTotal, 
	MIN(TotalDue) As MinTotla, 
	SUM(TotalDue) AS SumOfTotal, 
	AVG(TotalDue) As AvgTotal
FROM Sales.SalesOrderHeader  


--2 
SElECT  MIN(Name) As MinName, 
		MAX(Name) As MaxName, 
		MIN(SellStartDate) As MinSellStartDate
FROM Production.Product 
		



