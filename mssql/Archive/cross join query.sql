

declare @numbers table (Numbers int) 
insert into @numbers values (1) 
insert into @numbers values (2) 
insert into @numbers values (3) 

declare @letters table (Letters char(1)) 
insert into @letters values ('A') 
insert into @letters values ('B') 
insert into @letters values ('C')  

declare @symbols table (Symbols char(1)) 
insert into @symbols  values ('@') 
insert into @symbols  values ('#') 
insert into @symbols  values ('*') 

select * 
from @numbers 
	cross join @letters
	cross join @symbols  