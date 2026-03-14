SELECT TOP (20) 
	[Extent1].[PostId] as [PostId],
	[Extent1].[AnswerCount] as [AnswerCount],
	[Extent1].[ViewCount] as [ViewCount],
	[Extent1].[Title] as [Title],
	[Extent1].[Tags] as [Tags],
	[Extent2].[UserId] as [UserId],
	[Extent2].[DisplayName] as [DisplayName],
	[Extent2].[Reputation] as [Reputation]
FROM [dbo].[Posts] as [Extent1]
	INNER JOIN [dbo].[Users] AS [Extent2] ON [Extent1].[OwnerUserId] = [Extent2].[UserId]
WHERE [Extent1].[PostTypeId] = 1  
ORDER BY [Extent1].[CreationDate] DESC


-- 1. TO GET Row Count - go to table properties, see rowcount property

-- 2. Check how query becomes expensive 
-- see execution plan ; hover over it from right to left  
-- you can't always say index seek and index scan are good; you need to have some context first 
-- indexes are only good if you utilize them 
-- where clause above uses PostTypeId as filter ; but table only has PostId as clustered index ; so index scan is using wrong item


-- thick arrows are fat pipes -- show so much data being shoved over 
-- hove over arrow to see 
	-- Estimated Number of Rows, 
	-- Estimated Row Size, 
	-- Estimated Data Size 

/*
SQL Server Engine has 2 components 
- Relational Engine (cpu, parser, optimizer)
- Storage Engine (disk -> ram )
*/

-- Look for the item that has most cost; start from there 


-- Nested loops are kind of what you want to see because they deal with smaller sets of data 
-- as opposed to heaps joins ; optimizers fastest way to bring data 


-- Also, when reading the Execution Plan ; check what SQL Server Optmizer's suggestion is 
-- this is the text in green 


/*
-- to be able to do parallelism ; break down components into disk
	- one disk for data 
	- one disk for log 
	- one disk for indexes 
	- one disk for tempdb
*/


-- Downgrading SQL Server is a nightmare 
-- SQL Server is limited to 10GB only 


-- how to create covering index for the query  ; PK_ for primary key/clusted index; IX_ for nonclustered index

/*
USE StackOverFaux
GO 

CREATE NONCLUSTERED INDEX [IX_Posts_PostTypeId_WithIncludes]
	ON [dbo].[Posts](PostTypeId)
INCLUDE ([PostId], [CreationDate], [ViewCount], [OwnerUserId], [Title], [Tags]
ON [INDEX]  -- says use 'INDEXES' file group 

GO 
*/

-- index files  end with *.ndf


/*
-- COUPLE OF SERVER Settings to help SQL Server to perform better 
-- 1. go to Computer COnfiguration 
	- Windows Settings 
		- Security Settings 
			- User Rights Assignment 
				- Perform volume maintenance tasks  
-- this is to control how sql server grows a file 

-- Protip 1: add you SQL Service account to "Perform Volume Maintenance Tasks" so it can grow a volume as needed 

-- 1. go to Computer COnfiguration 
	- Windows Settings 
		- Security Settings 
			- User Rights Assignment 
				- Lock pages in memory 

OS can trump SQL with the use of RAM ; if this happens, SQL starts paging data on disk instead of on RAM 

-- Protip 2: set your SQL Service Account to lock pages in memory to give SQL the RAM priority over other services 

*/
 
-- SQL uses two caches
-- PLAN CACHE 
-- DATA CACHE


-- The fastest query is the one that never runs 

/*
-- ACID 
	- ATOMICITY 
	- CONSISTENCY
	- IDIOMATIC 
	- DEPENDABLE 
*/


-- AFTER YOU DO YOUR CHANGE ; YOU REVIEW THE NEW EXECUTION PLAN TO SEE IF THE OVERHEAD IMPROVED 
-- ALSO NOTE THE DIFFERENCE IN LOGICAL READS -- it should have gone down 

-- logical read ; pages i am pulling out of RAM 

-- to clear up SQL cache
DBCC FreeProcCache
DBCC DROPCLEANBUFFERS 

-- READ-AHEAD READS refers to the act of re-caching indexes by sql optimizer


/*
-- you can also optimize SQL by setting Minimum and Maximum server memory  ; SERVER PROPERTIES 
	- miminum - the least amount of RAM 
	- maximum - the most amount of RAM; the rest give to OS 

-- under Database Settings ; make sure Compress backup is checked 

PAGE VERIFY is now checksum which is way better than old mode -- TORN PAGE DETECTION 

*/





