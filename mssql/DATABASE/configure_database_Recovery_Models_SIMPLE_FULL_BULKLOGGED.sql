/* 
SQL Server provides three different recovery models that define whether or not transaction log
backups can be made, and if so, what database activities will write to the transaction log. 
The three recoverymodels are FULL, BULK_LOGGED, and SIMPLE:

• When using SIMPLE recovery, the transaction log is automatically truncated after a database
backup, removing the ability to performtransaction log backups. In this recoverymode, the
risk of data loss is dependent on your full or differential backup schedule—and you will not
be able to performthe point-in-time recovery that a transaction log backup offers.

• The BULK_LOGGED recoverymodel allows you to performfull, differential, and transaction log
backups; however, there isminimal logging to the transaction log for bulk operations. The
benefit of this recoverymode is reduced log space usage during bulk operations, but the
trade-off is that transaction log backups can only be used to recover fromthe end of the
transaction log backup (no point-in-time recovery ormarked transactions allowed).

• The FULL recoverymodel fully logs all transaction activity, bulk operations included. In this
safestmodel, all restore options are available, including point-in-time transaction log
restores, differential backups, and full database backups.

*/

SELECT recovery_model_desc
FROM sys.databases
WHERE name = 'BookMart'
GO

ALTER DATABASE BookMart
SET RECOVERY FULL
GO

SELECT recovery_model_desc
FROM sys.databases
WHERE name = 'BookMart'

/* 
The initial recovery model when a database is created depends on the recovery mode of the model
database. After creating a database, you can alwaysmodify the recovery model using ALTER
DATABASE and SET RECOVERY.
*/