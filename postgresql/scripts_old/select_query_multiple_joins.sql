SELECT c.id as customer_id, 
		c.first_name || ' ' || c.last_name as customer_name,
		-- c.age as age,
		o.id as item_name,
		o.order_details order_details,
		a.street || ', ' || a.city || ', ' || a.state as delivery_address
FROM public.customers c, 
     public.address a, 
	 public.orders o
where c.id = a.customer_id and c.id = o.customer_id
order by c.id, o.id