SELECT first_name,last_name, age
FROM public.customers
where age>35
ORDER BY id ASC ;

-- like with wildcard
select * 
from public.customers 
where first_name like '%m';

--and
select * 
from public.customers 
where last_name like 'G%' and age>20;

-- or
select * 
from public.customers 
where last_name like 'G%' or age<40;

-- not
select * 
from public.customers 
where not last_name like 'G%';

-- order by 
select * 
from public.customers 
where not last_name like 'G%'
order by age;








