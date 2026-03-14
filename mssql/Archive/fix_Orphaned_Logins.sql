USE FRG_Staging 
go 

sp_change_users_login @Action='Report'
go 

exec sp_change_users_login 'Auto_Fix', 'insuser'
go 
 

