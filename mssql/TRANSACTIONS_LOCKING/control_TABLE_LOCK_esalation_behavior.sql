/* 
SQL Server 2008 introduces the ability to control lock escalation at the table level using the
ALTER TABLE command. You are now able to choose fromthe following three settings:

	• TABLE, which is the default behavior used in SQL Server 2005.When configured, lock escalation
	is enabled at the table level for both partitioned and non-partitioned tables.
	• AUTO enables lock escalation at the partition level (heap or B-tree) if the table is partitioned.
	If it is not partitioned, escalation will occur at the table level.
	• DISABLE removes lock escalation at the table level. Note that you stillmay see table locks due
	to TABLOCK hints or for queries against heaps using a serializable isolation level
	
This recipe demonstratesmodifying a table across the two new SQL Server 2008 settings:
*/	

ALTER TABLE Person.Address 
SET ( LOCK_ESCALATION = AUTO )

SELECT lock_escalation, lock_escalation_desc 
FROM sys.tables 
WHERE name='TRade'
	
