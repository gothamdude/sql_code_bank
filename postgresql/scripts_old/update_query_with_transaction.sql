select * 
from public.customers
order by 1;


begin transaction; 

delete from public.customers
where first_name='Thomas' and last_name='Pott';

commit transaction;