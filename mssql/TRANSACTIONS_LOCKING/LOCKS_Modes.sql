/*
Table 3-2. SQL Server LockModes
-------------------------------------------------------------------------------------------
Name					Description
------------------------------------------------------------------------------------------
Shared lock				Shared locks are issued during read-only, non-modifying queries. They
						allow data to be read, but not updated by other processes while being
						held.
Intent lock				Intent locks effectively create a lock queue, designating the order of
						connections and their associated right to update or read resources. SQL
						Server uses intent locks to show future intention of acquiring locks on a
						specific resource.
Update lock				Update locks are acquired prior tomodifying the data.When the row is
						modified, this lock is escalated to an exclusive lock. If notmodified, it is
						downgraded to a shared lock. This lock type prevents deadlocks if two
						connections hold a shared lock on a resource and attempt to convert to
						an exclusive lock, but cannot because they are each waiting for the other
						transaction to release the shared lock.
Exclusive lock			This type of lock issues a lock on the resource that bars any kind of
						access (reads or writes). It is issued during INSERT, UPDATE, or DELETE
						statements.
Schemamodification		This type of lock is issued when a DDL statement is executed.
Schema stability		This type of lock is issued when a query is being compiled. It keeps DDL
						operations frombeing performed on the table.
Bulk update				This type of lock is issued during a bulk-copy operation. Performance is
						increased for the bulk copy operation, but table concurrency is reduced.
Key-range				Key-range locks protect a range of rows (based on the index key)—for
						example, protecting rows in an UPDATE statement with a range of dates
						from1/1/2005 to 12/31/2005. Protecting the range of data prevents row
						inserts into the date range that would bemissed by the current data
						modification.
-------------------------------------------------------------------------------------------
*/


