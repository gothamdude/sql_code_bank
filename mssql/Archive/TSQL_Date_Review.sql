-- GETDATE ; SYSDATETIME
SELECT GETDATE()
SELECT SYSDATETIME()

-- DATEADD
SELECT DATEADD(wk, 1, getdate())

DECLARE @vCurrentDate DateTime = GETDATE()
SELECT @vCurrentDate AS CurrentDate, 
	  DATEADD(year, 1, @vCurrentDate) AS OneMoreYear,
	  DATEADD(month, 1, @vCurrentDate) AS OneMoreMonth,
	  DATEADD(day, -1, @vCurrentDate) as OneLessDay 
	   
-- DATEDIFF difference between 2 dates 
SELECT  OrderDate, 
		@vCurrentDate AS CurrentDate,
		DATEDIFF (year, OrderDate, @vCurrentDate) as YearDiff, 
		DATEDIFF (month, OrderDate, @vCurrentDate) as MonthDiff, 
		DATEDIFF (day, OrderDate, @vCurrentDate) as DayDiff
FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN (43659,43714,60621) 

--DATENAME AND DATEPART
-- DATEPART always returns numeric number 
--DATENAME returns actual name when the date part is the month or the day of the week 

SELECT  OrderDate, 
		DATEPART(YEAR, OrderDate) AS OrderYear, 
		DATEPART(MONTH, OrderDate) AS OrderMonth, 
		DATEPART(DAY, OrderDate) AS OrderDay, 
		DATEPART(Weekday, OrderDate) AS OrderWeekDay 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN (43659,43714,60621) 

SELECT DATEPART(Weekday, '2/22/2015') AS Feb22ndWeekDay
SELECT DATEPART(Weekday, '2/23/2015') AS Feb23ndWeekDay
SELECT DATEPART(Weekday, '2/24/2015') AS Feb24ndWeekDay
SELECT DATEPART(Weekday, '2/25/2015') AS Feb25ndWeekDay
SELECT DATEPART(Weekday, '2/26/2015') AS Feb26ndWeekDay
SELECT DATEPART(Weekday, '2/27/2015') AS Feb27ndWeekDay

/*
OrderDate				OrderYear	OrderMonth	OrderDay	OrderWeekDay
2005-07-01 00:00:00.000		2005	7			1			6
2005-07-05 00:00:00.000		2005	7			5			3
2007-12-23 00:00:00.000		2007	12			23			1
*/


SELECT  OrderDate, 
		DATENAME(YEAR, OrderDate) AS OrderYear, 
		DATENAME(MONTH, OrderDate) AS OrderMonth, 
		DATENAME(DAY, OrderDate) AS OrderDay, 
		DATENAME(Weekday,OrderDate) AS OrderWeekDay 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN (43659,43714,60621) 


/*
OrderDate					OrderYear	OrderMonth	OrderDay OrderWeekDay
2005-07-01 00:00:00.000		2005		July		1		 Friday
2005-07-05 00:00:00.000		2005		July		5		 Tuesday
2007-12-23 00:00:00.000		2007		December	23		 Sunday
*/


-- DAY, MONTH, YEAR 


SELECT  OrderDate, 
		YEAR(OrderDate) AS OrderYear, 
		MONTH(OrderDate) AS OrderMonth, 
		DAY(OrderDate) AS OrderDay
FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN (43659,43714,60621) 

OrderDate				OrderYear	OrderMonth	OrderDay
2005-07-01 00:00:00.000	2005		7			1
2005-07-05 00:00:00.000	2005		7			5
2007-12-23 00:00:00.000	2007		12			23


declare @d datetime
select @d = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)		-- get first day of the month 
select  DATEADD(dd, number,@d),
		ROW_NUMBER() OVER(ORDER BY DATEADD(dd,number,@d) DESC) AS WeekNum
from master..spt_values
where type = 'p'
	and MONTH(DATEADD(dd,number,@d))=YEAR(@d)
	and MONTH(DATEADD(dd,number,@d))=MONTH(@d)
	and DATEPART(dw,dateadd(dd,number,@d)) = 7


declare @d datetime
select @d = '20150201'  
select dateadd(dd,number,@d) AS SatDates,
	   row_number() OVER(ORDER BY dateadd(dd,number,@d) ASC) AS WeekNum	
from master..spt_values
where type = 'p'
and year(dateadd(dd,number,@d))=year(@d)
and month(dateadd(dd,number,@d))=month(@d)
and DATEPART(dw,dateadd(dd,number,@d)) = 7

