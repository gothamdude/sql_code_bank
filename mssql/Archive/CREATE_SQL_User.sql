USE MASTER 
GO 

SP_AddLogin @loginame='user_adventureworks',@passwd='password',@defdb='AdventureWorks2008',@defLanguage='English'  
GO 

SP_GrantDBAccess @loginame='user_adventureworks' 
GO 
