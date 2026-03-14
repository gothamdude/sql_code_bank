USE master 
GO

-- when dropping db, it also removes underlying data and log files 
DROP DATABASE BookStoreInternational
GO 


-- a better way below 

USE master 
GO 

CREATE DATABASE BookStore_Archive 
GO

ALTER DATABASE BookStore_Archive 
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE 
GO 

DROP DATABASE BookStore_Archive 
GO 


