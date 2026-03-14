Identifying which rows belong to which type of aggregate becomes progressively more difficult for
each new column you add to GROUP BY and each unique data value that can be grouped and aggregated.
For example, assume that I have a non-aggregated report showing the quantity of products
that exist in location 3 within bins 1 and 2:
SELECT
i.Shelf,
i.LocationID,
i.Bin,
i.Quantity
FROM Production.ProductInventory i
WHERE i.LocationID IN (3) AND
i.Bin IN (1,2)
This query returns only two rows:
Shelf LocationID Bin Quantity
A 3 2 41
A 3 1 49
Now what if I wanted to report aggregations based on the various combinations of shelf, location,
and bin? I could use CUBE to give summaries of all these potential combinations:
SELECT
i.Shelf,
i.LocationID,
i.Bin,
SUM(i.Quantity) Total
FROM Production.ProductInventory i
WHERE i.LocationID IN (3) AND
i.Bin IN (1,2)
GROUP BY CUBE (i.Shelf,i.LocationID, i.Bin)
ORDER BY i.Shelf, i.LocationID, i.Bin
Although the query returns the various aggregations expected from CUBE, the results are difficult
to decipher:

Shelf LocationID Bin Total
NULL NULL NULL 90
NULL NULL 1 49
NULL NULL 2 41

NULL 3 NULL 90
NULL 3 1 49
NULL 3 2 41
A NULL NULL 90
A NULL 1 49
A NULL 2 41
A 3 NULL 90
A 3 1 49
A 3 2 41
(12 row(s) affected)
This is where GROUPING_ID comes in handy. Using this function, I can determine the level of
grouping for the row. This function is more complicated than GROUPING, however, because
GROUPING_ID takes one or more columns as its input and then returns the integer equivalent of the
base-2 (binary) number calculation on the columns.
This is best described by example, so I’ll demonstrate taking the previous query and adding
CASE logic to return proper row descriptors:
SELECT
i.Shelf,
i.LocationID,
i.Bin,
CASE GROUPING_ID(i.Shelf,i.LocationID, i.Bin)
WHEN 1 THEN 'Shelf/Location Total'
WHEN 2 THEN 'Shelf/Bin Total'
WHEN 3 THEN 'Shelf Total'
WHEN 4 THEN 'Location/Bin Total'
WHEN 5 THEN 'Location Total'
WHEN 6 THEN 'Bin Total'
WHEN 7 THEN 'Grand Total'
ELSE 'Regular Row'
END,
SUM(i.Quantity) Total
FROM Production.ProductInventory i
WHERE i.LocationID IN (3) AND
i.Bin IN (1,2)
GROUP BY CUBE (i.Shelf,i.LocationID, i.Bin)
ORDER BY i.Shelf, i.LocationID, i.Bin
I’ll explain what each of the integer values mean in the “How It Works” section. The results
returned from this query give descriptions of the various aggregations CUBE resulted in:

Shelf LocationID Bin Total
NULL NULL NULL Grand Total 90
NULL NULL 1 Bin Total 49
NULL NULL 2 Bin Total 41
NULL 3 NULL Location Total 90
NULL 3 1 Location/Bin Total 49
NULL 3 2 Location/Bin Total 41
A NULL NULL Shelf Total 90
A NULL 1 Shelf/Bin Total 49
A NULL 2 Shelf/Bin Total 41
A 3 NULL Shelf/Location Total 90
A 3 1 Regular Row 49

A 3 2 Regular Row 41
(12 row(s) affected)
How It Works
GROUPING_ID takes a column list and returns the integer value of the base-2 binary column list calculation
(I’ll step through this).
The query started off with the list of the three non-aggregated columns to be returned in the
result set:
SELECT
i.Shelf,
i.LocationID,
i.Bin,
Next, I defined a CASE statement that evaluated the return value of GROUPING_ID for the list of
the three columns:
CASE GROUPING_ID(i.Shelf,i.LocationID, i.Bin)
In order to illustrate the base-2 conversion to integer concept, I’ll focus on a single row, the row
that shows the grand total for shelf A generated automatically by CUBE:
Shelf LocationID Bin Total
A NULL NULL 90
Now envision another row beneath it that shows the bit values being enabled or disabled based
on whether the column is not a grouping column. Both Location and Bin from GROUPING_ID’s perspective
have a bit value of 1 because neither of them are a grouping column for this specific row.
For this row, Shelf is the grouping column:
Shelf LocationID Bin
A NULL NULL
0 1 1
Converting the binary 011 to integer, I’ll add another row that shows the integer value beneath
the flipped bits:
Shelf LocationID Bin
A NULL NULL
0 1 1
4 2 1
Because only location and bin have enabled bits, I add 1 and 2 to get a summarized value of 3,
which is the value returned for this row by GROUPING_ID. So the various combinations of grouping
are calculated from binary to integer. In the CASE statement that follows, 3 translates to a shelf total.
Since I have three columns, the various potential aggregations are represented in the following
WHEN/THENs:
CASE GROUPING_ID(i.Shelf,i.LocationID, i.Bin)
WHEN 1 THEN 'Shelf/Location Total'
WHEN 2 THEN 'Shelf/Bin Total'
WHEN 3 THEN 'Shelf Total'
WHEN 4 THEN 'Location/Bin Total'
WHEN 5 THEN 'Location Total'
WHEN 6 THEN 'Bin Total'
WHEN 7 THEN 'Grand Total'
ELSE 'Regular Row'
END,
Each potential combination of aggregations is handled in the CASE statement. The rest of the
query involves using an aggregate function on quantity, and then using CUBE to find the various
aggregation combinations for shelf, location, and bin:
SUM(i.Quantity) Total
FROM Production.ProductInventory i
WHERE i.LocationID IN (3) AND
i.Bin IN (1,2)
GROUP BY CUBE (i.Shelf,i.LocationID, i.Bin)
ORDER BYi.Shelf, i.LocationID, i.Bin