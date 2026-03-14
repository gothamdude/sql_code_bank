create table employees_with_primary_key_constraint (
	eid integer primary key, 
	ename text,
	salary numeric check(salary>0),
	birthdate date not null, 
	date_of_joining date not null,
	email varchar(20),
	phone_number bigint,
	constraint valid_joining check (birthdate>date_of_joining),
	constraint employees_with_primary_key_constraint_email_phone unique (email,phone_number)
);


create table employees_with_primary_key_constraint2 (
	eid integer, 
	ename text,
	salary numeric check(salary>0),
	birthdate date not null, 
	date_of_joining date not null,
	email varchar(20),
	phone_number bigint,
	constraint pk_eid primary key(eid),
	constraint employees_with_primary_key_constraint2_email_phone unique (email,phone_number)
);


create table employees_with_primary_key_combined_column (
	eid integer, 
	ename text,
	salary numeric check(salary>0),
	birthdate date not null, 
	date_of_joining date not null,
	email varchar(20),
	phone_number bigint,
	constraint pk_eid primary key(eid),
	constraint employees_with_primary_key_constraint2_email_phone unique (email,phone_number)
);



create table products_with_pk_constrint_combined(
	product_id integer, 
	category_id varchar(100), 
	unit_price numeric, 
	constraint pk_products primary key (product_id, category_id) 
);


