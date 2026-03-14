/*
Date Functions
As I reviewed earlier in the book, SQL Server has several data types used to store date and time data:
datetime, datetime2, date, time, datetimeoffset, and smalldatetime. SQL Server offers several functions
used tomanipulate and work with these data types, described in Table 8-5.

Table 8-5. Date Functions
-----------------------------------------------------------------------------------------------------------
Function(s) Description
-----------------------------------------------------------------------------------------------------------
DATEADD		DATEADD returns a new date that is incremented or decremented
			based on the interval and number specified.
DATEDIFF	DATEDIFF subtracts the first date fromthe second date to produce
			a value in the format of the datepart code specified.
DATENAME	DATENAME returns a string value for the part of a date specified in
			the datepart code.
DATEPART	DATEPART returns an integer value for the part of a date specified
			in the datepart code.
DAY, MONTH, and YEAR	DAY returns an integer value for the day, MONTH returns the integer
						representing themonth, and YEAR returns the integer
						representing the year of the evaluated date.
GETDATE, GETUTCDATE, and	GETDATE and CURRENT_TIMESTAMP both return the current date
CURRENT_TIMESTAMP			and time. GETUTCDATE returns the Coordinated Universal Time
							(UTC).
ISDATE		ISDATE returns a 1 (true) when an expression is a valid date or
			time and 0 (false) if not.
SYSDATETIME, SYSUTCDATETIME,	SYSDATETIME returns the current date and time in datetime2
and SYSDATETIMEOFFSET			format, and SYSUTCDATETIME returns the UTC in datetime2
								format. SYSDATETIMEOFFSET returns the current date and time
								along with the hour andminute offset between the current time
								zone and UTC in datetimeoffset format. These functions return
								timing accurate to 10milliseconds.
SWITCHOFFSET		SWITCHOFFSET allows you tomodify the existing time zone offset
					to a new offset in datetimeoffset data type format.
					TODATETIMEOFFSET TODATETIMEOFFSET allows you tomodify a date and time value to a
					specific time zone offset, returning a value in datetimeoffset
					data type format.
-----------------------------------------------------------------------------------------------------------
*/

-- This example demonstrates how to return the current date and time, as well as the Coordinated
-- Universal Time and associated offsets:
SET NOCOUNT ON
SELECT 'CurrDateAndTime_HighPrecision', SYSDATETIME()
SELECT 'UniversalTimeCoordinate_HighPrecision', SYSUTCDATETIME()
SELECT 'CurrDateAndTime_HighPrecision _UTC_Adjust', SYSDATETIMEOFFSET()

/*
Converting Between Time Zones
The following recipe demonstrates using functions to adjust and convert datetimeoffset and
datetime data type values to datetimeoffset data type values. In the first query, the SWITCHOFFSET
function converts an existing datetimeoffset value from-05:00 to +03:00.
Values in the datetimeoffset data type represent date and time values in specific time zones
that are referenced to UTC time. For example, the U.S. Eastern Standard time zone is defined as
UTC –5:00 (UTCminus five hours). You can convert datetimeoffset values between time zones by
invoking the SWITCHOFFSET function. In the following example, an input value is converted from
UTC –5:00 to UTC +3:00:
*/

SELECT SWITCHOFFSET ( '2007-08-12 09:43:25.9783262 -05:00', '+03:00')

/*The effect of the conversion is to change the datetime portion of the value such that the
new, combined datetime and offset represent the exact same UTC time as before. In this case,
the result is
-----------------------------------------------------------------------------------------------------------
2007-08-12 17:43:25.9783262 +03:00
-----------------------------------------------------------------------------------------------------------
*/

/*Both 2007-08-12 09:43:25.9783262 -05:00 (the input) and 2007-08-12 17:43:25.9783262
+03:00 (the output) represent the samemoment in time. Both work out to 2007-08-12
14:43:25.9783262 in UTC time (offset 0:00).

In this second query, TODATETIMEOFFSET takes a regular datatime data type value (no time zone
associated with it) and converts it to a datetimeoffset data type value:*/

SELECT TODATETIMEOFFSET ( '2007-08-12 09:43:25' , '-05:00' )

-- This returns
-- 2007-08-12 09:43:25.0000000 -05:00

-- This first example decreases the date by a year:
SELECT DATEADD(yy, -1, '4/2/2009')

-- This next example increases the date by a quarter:
SELECT DATEADD(q, 1, '4/2/2009')

-- This example decreases a date by sixmonths:
SELECT DATEADD(mm, -6, '4/2/2009')

-- This example increases a date by 50 days:
SELECT DATEADD(d, 50, '4/2/2009')

-- This example decreases the date and time by 30minutes:
SELECT DATEADD(mi, -30, '2009-09-01 23:30:00.000')

-- Find difference in months between now and EndDate
SELECT ProductID, GETDATE() Today, EndDate, DATEDIFF(m, EndDate, GETDATE()) MonthsFromNow
FROM Production.ProductCostHistory
WHERE EndDate IS NOT NULL

-- Show the EndDate's day of the week
SELECT ProductID, EndDate, DATENAME(dw, EndDate) WeekDay
FROM Production.ProductCostHistory
WHERE EndDate IS NOT NULL

-- This example returns the current year:
SELECT YEAR(GETDATE())

-- This example returns the currentmonth:
SELECT MONTH(GETDATE())

-- This example returns the current day:
SELECT DAY(GETDATE())

























