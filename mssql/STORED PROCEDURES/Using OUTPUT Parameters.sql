

-- Using OUTPUT Parameters

CREATE PROCEDURE dbo.usp_SEL_Department
@GroupName nvarchar(50),
@DeptCount int OUTPUT
AS
SELECT Name
FROM HumanResources.Department
WHERE GroupName = @GroupName
ORDER BY Name
SELECT @DeptCount = @@ROWCOUNT
GO
