
DECLARE @ProductChanges TABLE
(DeletedName nvarchar(50),
InsertedName nvarchar(50))

UPDATE Production.Product
SET Name = 'HL Spindle/Axle XYZ'
OUTPUT DELETED.Name, INSERTED.Name INTO @ProductChanges
WHERE ProductID = 524

SELECT DeletedName, InsertedName
FROM @ProductChanges

-- This query returns
-- DeletedName			InsertedName
-- HL Spindle/Axle		HL Spindle/Axle XYZ


/*
This next example uses OUTPUT for a DELETE operation. First, I’ll create a demonstration table to
hold the data:
*/

SELECT *
INTO Sales.Example_SalesTaxRate
FROM Sales.SalesTaxRate

/*
Next, I create a table variable to hold the data, delete rows from the table, and then select from the table 
variable to see which rows were deleted:
*/

DECLARE @SalesTaxRate TABLE	(
		[SalesTaxRateID] [int] NOT NULL,
		[StateProvinceID] [int] NOT NULL,
		[TaxType] [tinyint] NOT NULL,
		[TaxRate] [smallmoney] NOT NULL,
		[Name] [dbo]. [Name] NOT NULL,
		[rowguid] [uniqueidentifier] ,
		[ModifiedDate] [datetime] NOT NULL 
)

DELETE Sales.Example_SalesTaxRate
OUTPUT DELETED.* INTO @SalesTaxRate

SELECT SalesTaxRateID, Name
FROM @SalesTaxRate


/*
 This returns the following abridged results:
---------------------------------------
SalesTaxRateID Name
1		Canadian GST + Alberta Provincial Tax
2		Canadian GST + Ontario Provincial Tax
3		Canadian GST + Quebec Provincial Tax
4		Canadian GST
...
27		Washington State Sales Tax
28		Taxable Supply
29		Germany Output Tax
30		France Output Tax
31		United Kingdom Output Tax
---------------------------------------