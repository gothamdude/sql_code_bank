

create table orders_with_check_constraint(
	order_id serial,  
	quantity numeric check(quantity>0)
);

-- this is ok 
insert into orders_with_check_constraint(quantity) 
values (2);


-- this will fail 
insert into orders_with_check_constraint(quantity) 
values (-5);
 
/**
  SQL Error [23514]: ERROR: new row for relation "orders_with_check_constraint" violates check constraint "orders_with_check_constraint_quantity_check"
  Detail: Failing row contains (2, -5).
  Error position:
 */


create table orders_with_check_constraint_with_name(
	order_id serial,  
	quantity numeric constraint no_zero_quantity check(quantity>0)
);


-- this will fail 
insert into orders_with_check_constraint_with_name(quantity) 
values (-5);
 
/**
SQL Error [23514]: ERROR: new row for relation "orders_with_check_constraint_with_name" violates check constraint "no_zero_quantity"
  Detail: Failing row contains (1, -5).

Error position:
**/



