USE AdventureWorks2008
GO 

DECLARE @Shifts varchar(20) = ''

SELECT @Shifts = @Shifts + s.Name + ','
FROM HumanResources.Shift s
ORDER BY s.EndTime

SELECT @Shifts 