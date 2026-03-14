
-- This example demonstrates creating an inline table UDF that accepts an integer parameter and
-- returns the associated addresses of a business entity:
CREATE FUNCTION dbo.udf_ReturnAddress(@BusinessEntityID int)
RETURNS TABLE
AS
RETURN (
	SELECT t.Name AddressTypeNM,
	a.AddressLine1,
	a.City,
	a.StateProvinceID,
	a.PostalCode
	FROM Person.Address a
	INNER JOIN Person.BusinessEntityAddress e ON
	a.AddressID = e.AddressID
	INNER JOIN Person.AddressType t ON
	e.AddressTypeID = t.AddressTypeID
	WHERE e.BusinessEntityID = @BusinessEntityID )
GO
/*
Next, the new function is tested in a query, referenced in the FROM clause for business entity 332:
*/
SELECT AddressTypeNM, AddressLine1, City, PostalCode
FROM dbo.udf_ReturnAddress(332)
--This returns
--------------------------------------------------------------------------------------
AddressTypeNM	AddressLine1			City		PostalCode
Shipping		26910 Indela Road		Montreal	H1Y 2H5
Main Office		25981 College Street	Montreal	H1Y 2H5
--------------------------------------------------------------------------------------