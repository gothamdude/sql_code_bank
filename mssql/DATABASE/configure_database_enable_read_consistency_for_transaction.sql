/*

SQL Server provides two database options that allow for statement-level and transaction-level read
consistency: ALLOW_SNAPSHOT_ISOLATION and READ_COMMITTED_SNAPSHOT (which will be demonstrated
after this recipe).

The ALLOW_SNAPSHOT_ISOLATION database option enables a snapshot of data at the transaction
level.When ALLOW_SNAPSHOT_ISOLATION is enabled, you can use the snapshot transaction isolation
level to read a transactional consistent version of the data as it existed at the beginning of a transaction.
Using this option, data reads don’t block datamodifications. If data was changed while reading
the snapshot data and an attempt wasmade within the snapshot transaction to change the data,
the change attempt will not be allowed, and you will see a warning fromSQL Server’s update conflict
detection support. Once this database setting is enabled, snapshot isolation is initiated when
SET TRANSACTION ISOLATION LEVEL with SNAPSHOT isolation is specified before the start of the
transaction.

The READ_COMMITTED_SNAPSHOT setting enables row versioning at the individual statement level.
Row versioning retains the original copy of a row in tempdb whenever the row ismodified, storing
the latest version of the row in the current database. For databases with a large amount of transactional
activity, you’ll want tomake sure tempdb has enough space in order to hold row versions. The
READ_COMMITTED_SNAPSHOT setting enables row versioning at the individual statement level for the
query session.When enabling READ_COMMITTED_SNAPSHOT, locks are not held on the data. Row versioning
is used to return the statement’s data as it existed at the beginning of the statement
execution. Data being read during the statement execution still allows updates by others, and unlike
snapshot isolation, there is nomandatory update conflict detection to warn you that the data has
beenmodified during the read. Once this database option is enabled, row versioning is then initiated
when executing a query in the default read-committed isolation level or when SET TRANSACTION
ISOLATION LEVEL with READ COMMITTED is used before the statement executes.

The main benefit of using these options is the reduction in locks for read operations. If your
application requires real-time data values, these two options are not the best choice. However, if
snapshots of data are acceptable to your application, setting these optionsmay be appropriate.

The syntax for enabling these options is as follows:

ALTER DATABASE database_name
SET ALLOW_SNAPSHOT_ISOLATION {ON | OFF }
| READ_COMMITTED_SNAPSHOT {ON | OFF }

*/

SELECT snapshot_isolation_state_desc, is_read_committed_snapshot_on
FROM sys.databases
WHERE name = 'AdventureWorks2008'

ALTER DATABASE AdventureWorks
SET ALLOW_SNAPSHOT_ISOLATION ON

ALTER DATABASE AdventureWorks
SET READ_COMMITTED_SNAPSHOT ON

-- Next, the database settings are validated again, post-change: 

SELECT snapshot_isolation_state_desc,
is_read_committed_snapshot_on
FROM sys.databases
WHERE name = 'AdventureWorks2008'

