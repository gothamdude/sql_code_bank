USE master 
GO 

CREATE DATABASE BookStoreInternational 
ON PRIMARY 
( NAME = 'BookStoreInternational',
  FILENAME ='C:\SQLData\BookStoreInternational.mdf', 
  SIZE = 3MB, 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 10MB),
( NAME = 'BookStoreInternational2',
  FILENAME = 'C:\SQLData\BookStoreInternational2.ndf',
  SiZE = 1MB, 
  MAXSIZE = 30, 
  FILEGROWTH = 5% )
LOG ON 
( NAME='BookStoreInternational_Log',
  FILENAME = 'C:\SQLData\BookStoreInternational_log.ldf',
  SIZE=504KB,
  MAXSIZE = 100MB, 
  FILEGROWTH = 10%)
GO 


-- PRIMARY keyword is used to designate first file as primary data file 
-- in production scenarios, you will likely place data files in separate drive letters to support RAID 
-- .ndf extension is not necessary, though naming it .mdf too will make it harder to identify which one is primary 
-- adding multiple files that are spread out over different drive letter , assuming each drive letter is RAID enabled 
-- can allow you to spread out I/O and potentially improve performance for large, high traffic databases 


