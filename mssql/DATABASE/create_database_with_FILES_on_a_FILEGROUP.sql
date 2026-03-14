USE master 
GO 

-- a filegroup is a named grouping of files for administrative and placement reasons 
-- the primary file group contains primary data file as well as other data files that have not been explicityly assigned to different filegroup
-- data files belong to file groups 
-- in addition to primary file group which all SQL Server databases have, you can create secondary user-defined file groups for placing your files 
-- back-ups can be managed at the file group level instead of the entire database 

-- you can place tables and indexes on specific file groups 


CREATE DATABASE BookStoreInternational 
ON PRIMARY 
( NAME = 'BookStoreInternal',
  FILENAME ='C:\SQLData\BookStoreInternational.mdf', 
  SIZE = 3MB, 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 5MB),
FILEGROUP FG2 DEFAULT
( NAME = 'BookStoreInternal2',
  FILENAME ='C:\SQLData\BookStoreInternational2.ndf', 
  SIZE = 1MB, 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 1MB)
LOG ON 
( NAME='BookStoreInternal_Log',
  FILENAME = 'C:\SQLData\BookStoreInternal_log.ldf',
  SIZE=504KB,
  MAXSIZE = 100MB, 
  FILEGROWTH = 10%)
GO 

-- with multiple files in a filegroup SQL Server will fill each in a proportional manner, instead of filling up a single file before moving on to the next 