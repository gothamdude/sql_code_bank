/*
This recipe demonstrates how to display database data disk space usage using the sp_spaceused
systemstored procedure. To view transaction log usage, I’ll also demonstrate the DBCC SQLPERF
command.

The syntax for sp_spaceused is as follows:
sp_spaceused [[ @objname = ] 'objname' ]
[,[ @updateusage = ] 'updateusage' ]

The syntax for DBCC SQLPERF is as follows:
DBCC SQLPERF ( LOGSPACE )
[WITH NO_INFOMSGS ]

*/

USE AdventureWorks2008
GO

EXEC sp_spaceused


DBCC SQLPERF ( LOGSPACE )