select c.id as customer_id, 
		c.first_name || ' ' || c.last_name as full_name,
		c.age as age,
		a.street || ', ' || a.city || ', ' || a.state as full_address
from public.customers c, public.address a
where c.id = a.customer_id; 