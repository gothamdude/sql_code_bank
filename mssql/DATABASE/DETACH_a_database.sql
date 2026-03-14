USE master 
GO

-- use system stored proc sp_detach_db 
-- sp_detach_db [ @dbname=] 'dbname' [, @skipchecks= ] 'skipchecks' ]

-- skipchecks - this option allows true or false value ; when the option is tru, statistics are not updated prior to detaching the database 
--				by default, statistics are updated 


CREATE DATABASE TestDetach 
GO

ALTER DATABASE TestDetach 
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE 
GO 

-- DETACH DB 
EXEC sp_detach_db TestDetach, 'false' -- don't skip checks 


/*  -- SAMPLE SUCCESS MESSAGE BELOW --

Updating [sys].[queue_messages_1977058079]
    [queue_clustered_index], update is not necessary...
    [queue_secondary_index], update is not necessary...
    0 index(es)/statistic(s) have been updated, 2 did not require update.
 
Updating [sys].[queue_messages_2009058193]
    [queue_clustered_index], update is not necessary...
    [queue_secondary_index], update is not necessary...
    0 index(es)/statistic(s) have been updated, 2 did not require update.
 
Updating [sys].[queue_messages_2041058307]
    [queue_clustered_index], update is not necessary...
    [queue_secondary_index], update is not necessary...
    0 index(es)/statistic(s) have been updated, 2 did not require update.
 
Updating [sys].[filestream_tombstone_2073058421]
    [FSTSClusIdx], update is not necessary...
    [FSTSNCIdx], update is not necessary...
    0 index(es)/statistic(s) have been updated, 2 did not require update.
 
Updating [sys].[syscommittab]
    [ci_commit_ts], update is not necessary...
    [si_xdes_id], update is not necessary...
    0 index(es)/statistic(s) have been updated, 2 did not require update.
 
Updating [sys].[filetable_updates_2105058535]
    [FFtUpdateIdx], update is not necessary...
    0 index(es)/statistic(s) have been updated, 1 did not require update.
 */




