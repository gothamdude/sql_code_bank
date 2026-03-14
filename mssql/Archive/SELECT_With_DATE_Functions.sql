USE AdventureWorks2008
GO

-- NOTE: The difference is SYSDATETIME returns 7 decimal places after the second, 
--		GETDATE() only returns tree ; for all intents and purposes GETDAT() should suffice
SELECT GETDATE()
SELECT SYSDATETIME()  


-- DATEADD (<datepart>, number, <date>) --- add number of time units to a datte 
SELECT DATEADD(yy, 15, GETDATE()) AS ExpirationDateForMedicine

-- Table of Values for Date Part Parameter
-- Year: yy, yyyy
-- Month: mm, m
-- Day:		dd, d
-- Hour:	hh
-- Minute:	mi, n
-- Seconds: ss, s
-- i.e. also have parts for quarter, dayofyear, week, weekday, millisecond, etc.

-- DATEDIFF(<date part>, <early date><later date>)
SELECT DATEDIFF(yy, '08/24/1976', GETDATE())   -- your age ; not as accurate


-- DATENAME(<date part>, <date>) 
-- DATEPART(<date part>, <date>) 
SELECT DATENAME(MM,GETDATE())  -- returns actual text 
SELECT DATEPART(MM,GETDATE())  -- returns numerical value 


-- DAY, MONTH, YEAR 
SELECT 'Kerwin Lim' AS NAME , MONTH('08/24/1976') AS BirthMonth
							, DAY('08/24/1976') AS BirthDay
							, YEAR('08/24/1976') AS BirthYear

-- CONVERSION for DATEs
SELECT CONVERT(NVARCHAR,GETDATE(), 101)  -- 02/18/2013
SELECT CONVERT(NVARCHAR,GETDATE(), 107)  -- Feb 18, 2013
SELECT CONVERT(NVARCHAR,GETDATE(), 108)  -- 04:01:54  -- just the time element 
SELECT CONVERT(NVARCHAR,GETDATE(), 109)  -- Feb 18 2013  4:02:15:393AM  -- most complete
SELECT CONVERT(NVARCHAR,GETDATE(), 110)  -- 02-18-2013
SELECT CONVERT(NVARCHAR,GETDATE(), 112)  -- 20130218

