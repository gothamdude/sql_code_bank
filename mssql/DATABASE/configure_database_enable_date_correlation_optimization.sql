/* 
Two tables that are related by a datetime foreign key reference can benefit fromenabling the
DATE_CORRELATION_OPTIMIZATION option.When enabled, SQL Server collects additional statistics,
which in turn help improve the performance of queries that use a join between the two datetime
data type columns (foreign key and primary key pair).

The syntax for enabling this option is as follows:

ALTER DATABASE database_name
SET DATE_CORRELATION_OPTIMIZATION { ON | OFF }

The command takes two arguments: the database name you want tomodify and whether to set
the DATE_CORRELATION_OPTIMIZATION ON or OFF. This option defaults to OFF, as having it ON adds extra
overhead for those tables thatmeet the criteria for date correlation optimization.
This option, when ON, can benefit queries that join two table datetime values, which are related
by a foreign key reference. SQL Server will thenmaintain additional correlation statistics, which
may allow, depending on your query, SQL Server to generatemore efficient, less I/O intensive query
plans.

In order to take advantage of this database setting and for the statistics to be created automatically,
at least one of the datetime columns (primary key or foreign key) has to be the first key
column in a clustered index or the partitioning column in a partitioned table.
Be aware that there is extra overhead in updating the statistics, so you shouldmonitor performance
for databases that have heavy updates to the primary key and foreign key datetimerelated
tables, as the benefits of the query optimizationmay not outweigh the overhead of the
statistics updates.

*/

SET NOCOUNT ON

SELECT is_date_correlation_on
FROM sys.databases
WHERE name = 'AdventureWorks'

ALTER DATABASE AdventureWorks

SET DATE_CORRELATION_OPTIMIZATION ON

SELECT is_date_correlation_on
FROM sys.databases
WHERE name = 'AdventureWorks'


/* returns ... 
-------------------------------------------------------------------------

is_date_correlation_on
0

is_date_correlation_on
1

-------------------------------------------------------------------------