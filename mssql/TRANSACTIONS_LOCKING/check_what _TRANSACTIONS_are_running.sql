/* 
Displaying the Oldest Active Transaction with DBCC OPENTRAN

If a transaction remains open in the database, whether intentionally or not, this transaction can
block other processes fromperforming activity against themodified data. Also, backups of the
transaction log can only truncate the inactive portion of a transaction log, so open transactions can
cause the log to grow (or reach the physical limit) until that transaction is committed or rolled back.
*/

-- TEST BED 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE 

BEGIN TRAN 

SELECT * 
FROM HumanResources.Department 

INSERT HumanResources.Department (Name, GroupName)
VALUES ('Test', 'QA')


/* 
In a separate/new SQL ServerManagement Studio query window, I would like to identify all
open transactions by querying the sys.dm_tran_session_transactions DynamicManagement View
(DMV): */ 

SELECT session_id, transaction_id, is_user_transaction, is_local 
FROM sys.dm_tran_session_transactions 
WHERE is_user_transaction = 1 

/*
This returns the following (your actual session IDs and transaction IDs will vary):
--------------------------------------------------------------------------------------------
session_id transaction_id is_user_transaction is_local
--------------------------------------------------------------------------------------------
54			145866			1					1
--------------------------------------------------------------------------------------------

Now that I have a session ID to work with, I can dig into the details about themost recent query
executed by querying sys.dm_exec_connections and sys.dm_exec_sql_text:
*/

SELECT s.text 
FROM sys.dm_exec_connections c CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) s  
WHERE session_id = 54 


/*
This returns the last statement executed. (I could have also used the sys.dm_exec_requests
DMV for an ongoing and active session; however, nothing was currently executing formy example
transaction, so no data would have been returned.)

--------------------------------------------------------------------------------------------
-- text
--------------------------------------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT *
FROM HumanResources.Department
INSERT HumanResources.Department
(Name, GroupName)
VALUES ('Test', 'QA')
--------------------------------------------------------------------------------------------


Since I also have the transaction ID fromthe first query against sys.dm_tran_session_
transactions, I can use the sys.dm_tran_active_transactions to learnmore about the transaction
itself:

*/

SELECT transaction_begin_time,
CASE transaction_type
WHEN 1 THEN 'Read/write transaction'
WHEN 2 THEN 'Read-only transaction'
WHEN 3 THEN 'System transaction'
WHEN 4 THEN 'Distributed transaction'
END tran_type,
CASE transaction_state
WHEN 0 THEN 'not been completely initialized yet'
WHEN 1 THEN 'initialized but has not started'
WHEN 2 THEN 'active'
WHEN 3 THEN 'ended (read-only transaction)'
WHEN 4 THEN 'commit initiated for distributed transaction'
WHEN 5 THEN 'transaction prepared and waiting resolution'
WHEN 6 THEN 'committed'
WHEN 7 THEN 'being rolled back'
WHEN 8 THEN 'been rolled back'
END tran_state
FROM sys.dm_tran_active_transactions
WHERE transaction_id = 145866

/* 
This returns information about the transaction begin time, the type of transaction, and the
state of the transaction:

--------------------------------------------------------------------------------------------
transaction_begin_time		tran_type	tran_state

2008-08-26 10:03:26.520		Read/write	transaction active
--------------------------------------------------------------------------------------------






