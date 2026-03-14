/*
Multi-statement UDFs allow you to return data in the same way you would froma view, only with
the ability tomanipulate data like a stored procedure.
In this example, amulti-statement UDF is created to apply row-based security based on the
caller of the function. Only rows for the specified salesperson will be returned. In addition to this,
the second parameter is a bit flag that controls whether rows fromthe SalesPersonQuotaHistory
table will be returned in the results:
*/
CREATE FUNCTION dbo.udf_SEL_SalesQuota
( @BusinessEntityID int,
@ShowHistory bit )
RETURNS @SalesQuota TABLE
(BusinessEntityID int,
QuotaDate datetime,
SalesQuota money)
AS
BEGIN
INSERT @SalesQuota
(BusinessEntityID, QuotaDate, SalesQuota)
SELECT BusinessEntityID, ModifiedDate, SalesQuota
FROM Sales.SalesPerson
WHERE BusinessEntityID = @BusinessEntityID
IF @ShowHistory = 1
BEGIN
INSERT @SalesQuota
(BusinessEntityID, QuotaDate, SalesQuota)
SELECT BusinessEntityID, QuotaDate, SalesQuota
FROM Sales.SalesPersonQuotaHistory
WHERE BusinessEntityID = @BusinessEntityID
END
RETURN
END
GO
After the UDF is created, the following query is executed to show sales quota data for a specific
salesperson fromthe SalesPerson table:
SELECT BusinessEntityID, QuotaDate, SalesQuota
FROM dbo.udf_SEL_SalesQuota (275,0)

AS
BEGIN
INSERT @SalesQuota
(BusinessEntityID, QuotaDate, SalesQuota)
SELECT BusinessEntityID, ModifiedDate, SalesQuota
FROM Sales.SalesPerson
WHERE BusinessEntityID = @BusinessEntityID
IF @ShowHistory = 1
BEGIN
INSERT @SalesQuota
(BusinessEntityID, QuotaDate, SalesQuota)
SELECT BusinessEntityID, QuotaDate, SalesQuota
FROM Sales.SalesPersonQuotaHistory
WHERE BusinessEntityID = @BusinessEntityID
END
RETURN
END
GO
After the UDF is created, the following query is executed to show sales quota data for a specific
salesperson fromthe SalesPerson table:
SELECT BusinessEntityID, QuotaDate, SalesQuota
FROM dbo.udf_SEL_SalesQuota (275,0)