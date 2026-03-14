
/*
GROUP BY ROLLUP is used to add hierarchical data summaries based on the ordering of columns in the GROUP BY clause.

This example retrieves the shelf, product name, and total quantity of the product:
*/

SELECT	i.Shelf,
		p.Name,
		SUM(i.Quantity) Total
FROM Production.ProductInventory i
	INNER JOIN Production.Product p ON i.ProductID = p.ProductID
GROUP BY ROLLUP (i.Shelf, p.Name)


/* NOTE: this is the same as CUBE except second column is Merged for total ; Cube is first column merged for total 

This returns the following (abridged) results:
--------------------------------------------------------------
Shelf	Name Total
A		Adjustable Race 761
A		BB Ball Bearing 909
...
A		NULL			26833
B		Adjustable Race 324
B		BB Ball Bearing 443
B		Bearing Ball	318
...
B		Touring Front Wheel 304
B		NULL			12672
C		Chain			236
C		Chain Stays		585
Y		LL Spindle/Axle 209
Y		NULL 437
NULL NULL 335974
--------------------------------------------------------------


FROM STACKOVERFLOW :  Difference between CUBE and ROLLUP - if summarizing on one column ; there is none 

http://stackoverflow.com/questions/7053471/understanding-the-differences-between-cube-and-rollup

*/
