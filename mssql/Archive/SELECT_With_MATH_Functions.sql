USE AdventureWorks2008
GO

-- ADDITION
SELECT 1 + 1;


-- DIVISION, MODULO -- the remainder only
SELECT 10/3 AS DIVISION, 10% 3 AS MODULO;

-- MULTIPLICATION 
SELECT OrderQty, OrderQty * 10 AS Times10
FROM Sales.SalesOrderDetail
	
-- More complicated; LineTotal is a computed column
-- COMPUTED COLUMNS have a property PERSISTED which allows value to be stored in the table ; 
-- if false, it is computed everyt time the select is run -- not performant
SELECT OrderQty * UnitPrice * (1.0-UnitPriceDiscount) AS Calculated, LineTotal
FROM Sales.SalesOrderDetail
	

-- More complicated
SELECT SpecialOfferID, MaxQty, DiscountPct, DiscountPct*ISNULL(MaxQty,1000) AS MaxDiscount
FROM Sales.SpecialOffer ;


-- ABS(X) - absolute value
SELECT ABS(-14)

-- POWER(X, WhatPower) 
SELECT POWER(9,2) -- equals 81


-- SQRT(X) 
SELECT SQRT(144) -- equals 12


-- ROUND(X)  -- round a number to given precision 
SELECT ROUND(3144.12033,1) -- equals 144.10000
SELECT ROUND(3144.12033,2) -- equals 144.12000
SELECT ROUND(3144.12033,-2) -- equals 3100.00000
SELECT ROUND(1234.1294,-1,1) -- 1200.0000  -- 1 causes to just truncate instead of rounding ; no rounding happening


-- RAND()  -- random less than 1.0 decimal number  so would you usually * 1000
SELECT RAND() * 1000

-- supply @seed to make random values with pattern 
SELECT RAND(3) 
SELECT RAND() 
SELECT RAND() 
SELECT RAND(3) 
SELECT RAND() 
SELECT RAND() 



