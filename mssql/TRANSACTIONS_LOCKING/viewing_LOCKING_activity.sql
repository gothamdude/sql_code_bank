/* 
This recipe shows you how tomonitor locking activity in the database using the SQL Server
sys.dm_tran_locks DynamicManagement View. The example query beingmonitored by this DMV
will use a table locking hint.
In the first part of this recipe, a new query editor window is opened, and the following command
is executed
*/

USE AdventureWorks2008 
GO 

BEGIN TRAN 
SELECT ProductID, ModifiedDate
FROM Production.ProductDocument
WITH (TABLOCKX)

-- In a second query editor window, the following query is executed:
SELECT request_session_id [sessionid],
		resource_type [type], 
		resource_database_id [db_id],
		OBJECT_NAME(resource_associated_entity_id, resource_database_id) [objectname],
		request_mode [mode],
		request_status [status]
FROM sys.dm_tran_locks
WHERE resource_type IN ('DATABASE', 'OBJECT')
		

-- The query returned information about the locking session identifier (server process ID, or
-- SPID), the resource being locked, the database, object, resourcemode, and lock status:
------------------------------------------------------------------------------------------
sessionid	type		dbid	objectname			rmode	rstatus
------------------------------------------------------------------------------------------
53			DATABASE	8		NULL				S		GRANT
52			DATABASE	8		NULL				S		GRANT
52			OBJECT		8		ProductDocument		X	GRANT
------------------------------------------------------------------------------------------

/* 
The resource_type column designates what the locked resource represents (for example,
DATABASE, OBJECT, FILE, PAGE, KEY, RID, EXTENT, METADATA, APPLICATION, ALLOCATION_UNIT, or HOBT type).
The resource_associated_entity_id depends on the resource type, determining whether the ID is
an object ID, allocation unit ID, or Hobt ID:

	• If the resource_associated_entity_id column contains an object ID (for a resource type of
	OBJECT), you can translate the name using the sys.objects catalog view.
	• If the resource_associated_entity_id column contains an allocation unit ID (for a resource
	type of ALLOCATION_UNIT), you can reference sys.allocation_units and reference the
	container_id. Container_id can then be joined to sys.partitions where you can then
	determine the object ID.
	• If the resource_associated_entity_id column contains a Hobt ID (for a resource type of KEY,
	PAGE, ROW, or HOBT), you can directly reference sys.partitions and look up the associated
	object ID.
	• For resource types such as DATABASE, EXTENT, APPLICATION, or METADATA, the resource_
	associated_entity_id column will be 0.
	
Use sys.dm_tran_locks to troubleshoot unexpected concurrency issues, such as a query session
thatmay be holding locks longer than desired, or issuing a lock resource granularity or lock
mode that you hadn’t expected (perhaps a table lock instead of a finer-grained row or page lock).
Understanding what is happening at the locking level can help you troubleshoot query concurrency
more effectively.
*/

