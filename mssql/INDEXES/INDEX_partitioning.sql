/*
In this recipe, I’ll show you how to apply partitioning to a nonclustered index. In Chapter 4, I
demonstrated table partitioning. Partitioning can providemanageability, scalability, and performance
benefits for large tables. This is because partitioning allows you to break down the data set into
smaller subsets of data. Depending on the index key(s), an index on a table can also be quite large.

Applying the partitioning concept to indexes, if large indexes are separated onto separate partitions,
this can positively impact the performance of a query. Queries that target data fromjust one partition
will benefit because SQL Server will target just the selected partition, instead of accessing all
partitions for the index.

This recipe will now demonstrate index partitioning using the HitDateRangeScheme partition
scheme that was created in Chapter 4 on the Sales.WebSiteHits table:

*/

CREATE NONCLUSTERED INDEX NI_WebSiteHits_WebSitePage ON
Sales.WebSiteHits (WebSitePage) 
ON [HitDateRangeScheme] (HitDate)


/*

How It Works
The partition scheme is applied using the ON clause.

ON [HitDateRangeScheme] (HitDate)

Notice that although the HitDate column wasn’t a nonclustered index key, it was included in
the partition scheme,matching that of the table.When the index and table use the same partition
scheme, they are said to be “aligned.”

You can choose to use a different partitioning scheme for the index than the table; however,
that schememust use the same data type argument, number of partitions, and boundary values.
Unaligned indexes can be used to take advantage of collocated joins—meaning if you have two
columns fromtwo tables that are frequently joined that also use the same partition function,
same data type, number of partitions, and boundaries, you can potentially improve query join
performance. However, the common approach willmost probably be to use aligned partition
schemes between the index and table, for administration and performance reasons.

*/

