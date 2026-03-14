/*
Partitioned Views

Distributed partitioned views allow you to create a single logical representation (view) of two or
more horizontally partitioned tables that are located across separate SQL Server instances.
In order to set up a distributed partitioned view, a large table is split into smaller tables based
on a range of values defined in a CHECK constraint. This CHECK constraint ensures that each smaller
table holds unique data that cannot be stored in the other tables. The distributed partitioned view is
then created using a UNION ALL to join each smaller table into a single result set.

The performance benefit is realized when a query is executed against the distributed partitioned
view. If the view is partitioned by a date range, for example, and a query is used to return
rows that are only stored in a single table of the partition, SQL Server is smart enough to only search
that one partition instead of all tables in the distributed-partitioned view.

Sincemore than one SQL Server instance will be accessed in a distributed-partitioned view
recipe, linked servers are added to both participating SQL Server instances (see Chapter 27 formore
information on linked servers).
I’ll begin this recipe by creating a linked server on the first SQL Server instance:
*/

USE master
GO
EXEC sp_addlinkedserver
'JOEPROD',
N'SQL Server'
GO
-- skip schema checking of remote tables
EXEC sp_serveroption 'JOEPROD', 'lazy schema validation', 'true'
GO
On the second SQL Server instance, a linked server is created to the first SQL Server instance:
USE master
GO
EXEC sp_addlinkedserver
'JOEPROD\SQL2008',
N'SQL Server'
GO
-- skip schema checking of remote tables
EXEC sp_serveroption 'JOEPROD\SQL2008', 'lazy schema validation', 'true'
GO
Back on the first SQL Server instance, the following table is created to hold rows forMegaCorp
website hits:
IF NOT EXISTS (SELECT name
FROM sys.databases
WHERE name = 'TSQLRecipeTest')
BEGIN
CREATE DATABASE TSQLRecipeTest
END
GO
Use TSQLRecipeTest
GO
CREATE TABLE dbo.WebHits_MegaCorp
(WebHitID uniqueidentifier NOT NULL,
WebSite varchar(20) NOT NULL ,
HitDT datetime NOT NULL,
CHECK (WebSite = 'MegaCorp'),
CONSTRAINT PK_WebHits PRIMARY KEY (WebHitID, WebSite))
On the second SQL Server instance, the following table is created to hold rows forMiniCorp
website hits:
IF NOT EXISTS (SELECT name
FROM sys.databases
WHERE name = 'TSQLRecipeTest')
BEGIN
CREATE DATABASE TSQLRecipeTest
END
GO
USE TSQLRecipeTest
GO
CREATE TABLE dbo.WebHits_MiniCorp
(WebHitID uniqueidentifier NOT NULL ,
WebSite varchar(20) NOT NULL ,
HitDT datetime NOT NULL,
CHECK (WebSite = 'MiniCorp') ,
CONSTRAINT PK_WebHits PRIMARY KEY (WebHitID, WebSite))
Back on the first SQL Server instance, the following distributed partitioned view that references
the local WebHits_MegaCorp table and the remote WebHits.MiniCorp table is created:
CREATE VIEW dbo.v_WebHits AS
SELECT WebHitID,
WebSite,
HitDT
FROM TSQLRecipeTest.dbo.WebHits_MegaCorp
UNION ALL
SELECT WebHitID,
WebSite,
HitDT
FROM JOEPROD.TSQLRecipeTest.dbo.WebHits_MiniCorp
GO
On the second SQL Server instance, the following distributed partitioned view is created—this
time referencing the local WebHits_MiniCorp table and the remote WebHits_MegaCorp table:
CREATE VIEW dbo.v_WebHits AS
SELECT WebHitID,
WebSite,
HitDT
FROM TSQLRecipeTest.dbo.WebHits_MiniCorp
UNION ALL
SELECT WebHitID,
WebSite,
HitDT
FROM [JOEPROD\SQL2008].TSQLRecipeTest.dbo.WebHits_MegaCorp
GO

-- On the second SQL Server instance, the following batch of queries is executed to insert new rows:
-- For these inserts to work the setting XACT_ABORT must be ON and
-- the Distributed Transaction Coordinator service must be running
SET XACT_ABORT ON
INSERT dbo.v_WebHits
(WebHitID, WebSite, HitDT)
VALUES(NEWID(), 'MegaCorp', GETDATE())
INSERT dbo.v_WebHits
(WebHitID, WebSite, HitDT)
VALUES(NEWID(), 'MiniCorp', GETDATE())

--Querying fromthe distributed-partitioned view returns the two newly inserted rows (fromboth underlying tables):

SET XACT_ABORT ON
SELECT WebHitID, WebSite, HitDT
FROM dbo.v_WebHits

-- Querying the MiniCorp table directly returns just the one MiniCorp row, as expected:
SELECT WebHitID, WebSite, HitDT
FROM JOEPROD.AdventureWorks.dbo.WebHits_MiniCorp

-- Querying the MegaCorp table also returns the expected, single row:
SELECT WebHitID, WebSite, HitDT
FROM [JOEPROD\SQL2008].AdventureWorks.dbo.WebHits_MegaCorp



/*
As noted in the script comments, the Distributed Transaction Coordinator also needs to be
running in order to invoke the distributed transaction of inserting a row across SQL Server
instances. Two inserts were performed against the new distributed partitioned view—the first for
a hit to MegaCorp, and the second for MiniCorp:

*/