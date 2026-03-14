/* 
Disk errors can occur when a data page write to the physical disk is interrupted due to a power failure
or other physical issue. SQL Server has threemodes for handling and detecting incomplete I/O
transactions caused by disk errors: CHECKSUM, TORN_PAGE_DETECTION, and NONE.

• The CHECKSUM option (the model database default) writes a checksumvalue to the data page
header based on the contents of the entire data page. If a page is corrupted or partially written,
SQL Server will detect a difference between the header and the actual page contents.
This option offers the most protection.

• The TORN_PAGE_DETECTION option (themain option used in previous versions of SQL Server)
detects data page issues by reversing a bit for each 512-byte sector of the data page.When a
bit is in the incorrect state when read by SQL Server, a “torn” page is identified.

• When NONE is selected, neither CHECKSUM nor TORN_PAGE_DETECTION handling is used in allocating
new data pages or identified by SQL Server during a read.

Unless you have a good reason for doing so (such as a requirement for unfettered query performance
for a benchmark test, for example), keeping the default option of CHECKSUM is a good idea.
Although CHECKSUM hasmore overhead than TORN_PAGE_DETECTION, it is alsomore comprehensive in
its ability to identify data page errors.

ALTER DATABASE database_name
SET PAGE_VERIFY { CHECKSUM | TORN_PAGE_DETECTION | NONE }

*/

SELECT page_verify_option_desc
FROM sys.databases
WHERE name = 'AdventureWorks2008'
GO

ALTER DATABASE AdventureWorks
SET PAGE_VERIFY NONE
GO

SELECT page_verify_option_desc
FROM sys.databases
WHERE name = 'AdventureWorks'
GO