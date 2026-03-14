USE master 
GO

-- SQL Server provides three database user access modes that affect which and how many users can access a db
-- SINGLE_USER, RESTRICTED_USER, MULTI_USER 
-- the SINGLE_USER and RESTRICTED_USER are both methods for SHUTTING THE DOOR on other users performing activites in the database 
-- useful when performing database configuration changes 
-- these options are also used when you need to undo a data change or force users out prior to a cutover to a new system 

-- SINGLE USER - only one user allowed at a time 
-- RESTRICTED_USER - allow sysadmin, dbcreator, and db_owner access
-- MULTI-USER - all users with permissions allowed 


-- this recipe demonstrates taking a database into a SINGLE_User mode, rolling back any open transactions, 
-- and putting database back to MULTI_USER mode 

-- TURN OFF row count messages 
SET NOCOUNT OFF

SELECT user_access_desc 
FROM sys.databases 
WHERE name='BookStoreInternational'

ALTER DATABASE BookStoreInternational
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE 

SELECT user_access_desc 
FROM sys.databases 
WHERE name='BookStoreInternational'

ALTER DATABASE BookStoreInternational
SET MULTI_USER 

SELECT user_access_desc 
FROM sys.databases 
WHERE name='BookStoreInternational'







