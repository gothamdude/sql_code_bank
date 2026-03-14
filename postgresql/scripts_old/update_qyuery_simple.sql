select * 
from public.customers
order by 1;

update public.customers
set age = age+1 
where id=3;

update public.customers
set first_name = 'Thomas' 
where id=4;

update public.customers
set first_name = 'Jimmy' 
where first_name='Jim' and last_name='Beam';