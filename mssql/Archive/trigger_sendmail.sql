use ZKerwin 
Go 

DROP TRIGGER V4_Alert_Corrupt
GO 

CREATE TRIGGER V4_Alert_Corrupt 
ON dbo.items 
AFTER UPDATE 
AS
BEGIN 

	DECLARE @vDomainLogin varchar(100)
	DECLARE @vServer varchar(100) 
	DECLARE @vRemoteServer varchar(100) 
	DECLARE @vUpdateDescString nvarchar(500) 
	DECLARE @SPId varchar(100) 
	DECLARE @ProcId varchar(100) 
	
	SET @vLogin = (select SUSer_Name())
	SET @vServer = (select ISNULL(@@SERVERNAME,''))
	SET @vRemoteServer = (select ISNULL(@@REMSERVER,''))
	SET @vSPId =  (select ISNULL(@@spid,''))
	SET @vProcId =  (select ISNULL(@@procid,''))
	
	SET @vUpdateDescString = (select top 1 rtrim(ltrim([description])) from inserted)

	IF @vUpdateDescString = '1' 
	BEGIN
	
		DECLARE @msg varchar(max)
		SET @msg = 'V4 Corrupttion was done by ' + @vLogin + ' at '+ convert(varchar,getdate())  + '
		' + ' from Local Server Name ' + @vServer  + '
		' + ' from Remote Server Name ' + @vRemoteServer 
		EXEC msdb.dbo.sp_send_dbmail @recipients=N'kerwin.lim@wolterskluwer.com', @body= @msg,  @subject = 'V4 Corruption', @profile_name = 'Mail'

	END
	
END 
GO
