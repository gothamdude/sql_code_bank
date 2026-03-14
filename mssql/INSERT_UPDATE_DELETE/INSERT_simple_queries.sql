
-- inserting row into a table 
INSERT Production.Location (Name, CostRate, Availability)
VALUES ('Wheel Storage', 11.25, 80.00)


-- inserting using default values 
INSERT Production.Location
(Name, CostRate, Availability, ModifiedDate)
VALUES ('Wheel Storage 3', 11.25, 80.00, DEFAULT)


-- insert using a SELECT statement 
CREATE TABLE [dbo]. [Shift_Archive](
[ShiftID] [tinyint] NOT NULL,
[Name] [dbo]. [Name] NOT NULL,
[StartTime] [datetime] NOT NULL,
[EndTime] [datetime] NOT NULL,
[ModifiedDate] [datetime] NOT NULL DEFAULT (getdate()),
CONSTRAINT [PK_Shift_ShiftID] PRIMARY KEY CLUSTERED
([ShiftID] ASC)
)
GO

-- Next, an INSERT..SELECT is performed:
INSERT dbo.Shift_Archive (ShiftID, Name, StartTime, EndTime, ModifiedDate)
SELECT ShiftID, Name, StartTime, EndTime, ModifiedDate
FROM HumanResources.Shift
ORDER BY ShiftID

-- for checking 
SELECT ShiftID, Name
FROM Shift_Archive