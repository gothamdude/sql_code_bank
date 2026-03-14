-- using DATE and TIME 
USE tempdb;
Go 
--1
IF OBJECT_ID('dbo.DateDemo') IS NOT NULL BEGIN
DROP TABLE dbo.DateDemo;
END
GO
--2
CREATE TABLE dbo.DateDemo(JustTheDate DATE, JustTheTime TIME(1),
NewDateTime2 DATETIME2(3), UTCDate DATETIME2);
GO
--3
INSERT INTO dbo.DateDemo (JustTheDate, JustTheTime, NewDateTime2,
UTCDate)
VALUES (SYSDATETIME(), SYSDATETIME(), SYSDATETIME(), SYSUTCDATETIME());
--4
SELECT JustTheDate, JustTheTime, NewDateTime2, UTCDate
FROM dbo.DateDemo;


-- using DateTimeOffSet 
/*
The new DATETIMEOFFSET data type contains, in addition to the date and time, a time zone offset for
working with dates and times in different time zones. This is the difference between the UTC date and
time and the stored date. Along with the new data type, several new functions for working with
DATETIMEOFFSET are available.*/

USE tempdb;
--1
IF OBJECT_ID('dbo.OffsetDemo') IS NOT NULL BEGIN
DROP TABLE dbo.OffsetDemo;
END;
--2
CREATE TABLE dbo.OffsetDemo(Date1 DATETIMEOFFSET);
GO
--3
INSERT INTO dbo.OffsetDemo(Date1)
VALUES (SYSDATETIMEOFFSET()),
(SWITCHOFFSET(SYSDATETIMEOFFSET(),'+00:00')),
(TODATETIMEOFFSET(SYSDATETIME(),'+05:00'))
--4
SELECT Date1
FROM dbo.OffsetDemo;