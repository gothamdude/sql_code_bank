
/* 
In this recipe, I’ll show you how to control the number of processors used to process a single query.
If using SQL Server Enterprise Edition with amultiprocessor server, you can control/limit the number
of processors potentially used in an index creation operation by using the MAXDOP index option.
Parallelism, which in this context is the use of two ormore processors to fulfill a single query statement,
can potentially improve the performance of the index creation operation.
The syntax for this option, which can be used in both CREATE INDEX and ALTER INDEX, is as
follows:

MAXDOP = max_degree_of_parallelism

The default value for this option is 0, whichmeans that SQL Server can choose any or all of
the available processors for the operation. A MAXDOP value of 1 disables parallelismon the index
creation.

■ Tip Limiting parallelism for index creation may improve concurrency for user activity running during the build,
but may also increase the time it takes for the index to be created.
*/

-- set to use 4 processors at max when doing index build 
CREATE NONCLUSTERED INDEX NI_Address_AddressLine1 ON 
Person.Address(AddressLine1) 
WITH (MAXDOP = 4)
GO 

/*
Just because you set MAXDOP doesn’tmake any guarantee that SQL Server will actually use the
number of processors that you designate. It only ensures that SQL Server will not exceed the MAXDOP
threshold.
*/