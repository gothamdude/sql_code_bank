/* 
Because partitioning happens in the background, you don’t actually query the individual partitions
directly. In order to determine which partition a row belongs to, you can use the $PARTITION function.
The syntax for $PARTITION is as follows:

$PARTITION.partition_function_name(expression)

Table 4-19 details the arguments of this command.
Table 4-19. $PARTITION Function Arguments
Argument Description
partition_function_name The name of the partition function used to partition the table
expression The column used as the partitioning key

This example demonstrates how to use this function. To begin with, four rows are inserted into
the Sales.WebSiteHits partitioned table:
*/

INSERT Sales.WebSiteHits (WebSitePage, HitDate)
VALUES ('Home Page', '10/22/2007')

INSERT Sales.WebSiteHits(WebSitePage, HitDate)
VALUES ('Home Page', '10/2/2006')

INSERT Sales.WebSiteHits (WebSitePage, HitDate)
VALUES ('Sales Page', '5/9/2008')

INSERT Sales.WebSiteHits (WebSitePage, HitDate)
VALUES ('Sales Page', '3/4/2000')

/* 
The table is then queried using SELECT and the $PARTITION function:
*/

SELECT HitDate, $PARTITION.HitDateRange(HitDate) Partition
FROM Sales.WebSiteHits