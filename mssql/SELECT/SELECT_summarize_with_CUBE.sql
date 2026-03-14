
-- Use CUBE to add summarizing total values to a result set based on columns in the GROUP BY clause.
-- This example demonstrates a query that returns the total quantity of a product, 
-- grouped by the  shelf the product is kept on:

SELECT	i.Shelf,
		SUM(i.Quantity) Total
FROM Production.ProductInventory i
GROUP BY i.Shelf

SELECT	i.Shelf,
		SUM(i.Quantity) Total
FROM Production.ProductInventory i
GROUP BY CUBE (i.Shelf)					-- see last row, there is a null row that sums up the valurs for Total 

/*
This returns the following results:
--------------------------------------------------------------
Shelf Total
A		26833
B		12672
C		19868
D		17353
E		31979
F		21249
G		40195
H		20055
J		12154
K		16311
L		13553
M		3567
N		5254
N/A		30582
R		23123
S		5912
T		10634
U		18700
V		2635
W		2908
Y		437
NULL	335974
(22 row(s) affected)
--------------------------------------------------------------
*/

-- In this next query, I’ll modify the SELECT and GROUP BY clauses by adding LocationID:

SELECT	i.Shelf,
		i.LocationID,
		SUM(i.Quantity) Total
FROM Production.ProductInventory i
GROUP BY CUBE (i.Shelf, i.LocationID)

/*
This returns a few levels of totals, the first being by location (abridged):
-----------------------------------------------------------------------------
Shelf	LocationID Total
A		1		2727
C		1		13777
D		1		6551
...
K		1		6751
L		1		7537
NULL	1		72899
-----------------------------------------------------------------------------

In the same result set, later on you also see totals by shelf, and then across all shelves and locations:

-----------------------------------------------------------------------------
Shelf LocationID Total
...
T NULL 10634
U NULL 18700
V NULL 2635
W NULL 2908
Y NULL 437
NULL NULL 335974
-----------------------------------------------------------------------------

*/