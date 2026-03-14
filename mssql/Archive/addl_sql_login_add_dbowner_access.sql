CREATE USER insuser FOR LOGIN insuser
GO 
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'insuser'
GO


-- this adds a new schema under insuser instead of dbo ; so it is useless
EXEC sp_adduser 'insuser', 'insuser', 'db_owner'
GO 