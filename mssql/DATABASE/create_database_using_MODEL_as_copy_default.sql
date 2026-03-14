USE master 
GO 

IF NOT EXISTS(	SELECT NAME 
				FROM sys.databases 
				WHERE NAME='BookStoreInternational')
CREATE DATABASE BookStoreInternational 
GO 