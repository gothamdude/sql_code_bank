create table products_with_table_level_constraint(
	product_no integer, 
	name text,
	price numeric check (price>0),
	discounted_price numeric check (discounted_price>0),
	check (price>discounted_price)
);


create table employess_with_table_level_constraint_named(
	eid integer, 
	ename text,
	salary numeric check(salary>0),
	birthdate date, 
	date_of_joining date not null, 
	constraint valid_joining check (birthdate>date_of_joining)
);

