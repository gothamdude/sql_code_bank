use ePilipinas 
go 
sp_addlogin @loginame='User_ePilipinas',@passwd='password',@defdb='ePilipinas',@defLanguage='English'  
go 
sp_grantdbaccess @loginame='User_ePilipinas' 
go 
use eBalita 
go 
sp_addlogin @loginame='User_eBalita',@passwd='password',@defdb='eBalita',@defLanguage='English'    
go 
sp_grantdbaccess @loginame='User_eBalita' 
go 
use eBayad 
go 
sp_addlogin @loginame='User_eBayad',@passwd='password',@defdb='eBayad',@defLanguage='English'
go 
sp_grantdbaccess @loginame='User_eBayad'
go 
use eBenta 
go 
sp_addlogin @loginame='User_eBenta',@passwd='password',@defdb='eBenta',@defLanguage='English'
go 
sp_grantdbaccess @loginame='User_eBenta'
go 
use eHanap 
go 
sp_addlogin  @loginame='User_eHanap',@passwd='password',@defdb='eHanap',@deflanguage='English'
go 
sp_grantdbaccess @loginame='User_eHanap'
go 
use eLakbay 
go 
sp_addlogin  @loginame='User_eLakbay',@passwd='password',@defdb='eLakbay',@deflanguage='English'
go 
sp_grantdbaccess @loginame='User_eLakbay'
go 
use ePadala
go 
sp_addlogin  @loginame='User_ePadala',@passwd='password',@defdb='ePadala',@deflanguage='English'
go 
sp_grantdbaccess @loginame='User_ePadala'
go 
use eReklamo 
go 
sp_addlogin  @loginame='User_eReklamo',@passwd='password',@defdb='eReklamo',@deflanguage='English'
go 
sp_grantdbaccess @loginame='User_eReklamo'
go 
use eTawag
go 
sp_addlogin  @loginame='User_eTawag',@passwd='password',@defdb='eTawag',@deflanguage='English'
go 
sp_grantdbaccess @loginame='User_eTawag'
go 
use eTulong
go 
sp_addlogin  @loginame='User_eTulong',@passwd='password',@defdb='eTulong',@deflanguage='English'
go 
sp_grantdbaccess @loginame='User_eTulong'
go 






