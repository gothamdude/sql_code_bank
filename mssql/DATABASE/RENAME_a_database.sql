USE master
GO 

-- creat demo database 
CREATE DATABASE BookWarehouse 
GO 

-- make single user so as not to fail -- STANDARD RULE 
ALTER DATABASE BookWarehouse 
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE 
GO 

ALTER DATABASE BookWarehouse 
MODIFY NAME = BookMart
GO 

ALTER DATABASE BookMart
SET MULTI_USER
GO 

--NOTE: this does not change name for underlying data and log files ; just name change 
-- if there happen to be transactions running, you will most probably see this message 

/*  
Nonqualified transactions are being rolled back.
Estimated rollback completion: 100% 
The database name 'BookMart' has been set.' 


