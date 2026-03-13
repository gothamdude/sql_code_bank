-- parent table 
CREATE TABLE products_base ( 
	product_id SERIAL PRIMARY KEY, 
	name VARCHAR(255), 
	description TEXT, 
	price NUMERIC(10, 2) 
);


-- create inherited tables 
create table electronics_products() inherits(products_base);
create table clothing_products() inherits(products_base);
create table books_products() inherits(products_base);


-- to detach inheritance 
alter table electronics_products NO INHERIT products_base;


-- validate 
select table_name,column_name,data_type
from information_schema.columns 
where table_name='clothing_products';

/** 
---you will see the same structure 
 
table_name	column_name	data_type
clothing_products	product_id	integer
clothing_products	price	numeric
clothing_products	name	character varying
clothing_products	description	text

but you can do some alterations on child tables  
**/

alter table electronics_products add column brand varchar(50);
alter table clothing_products add column available_size varchar(10);
alter table books_products add column author_name varchar(100);

-- validate 
select table_name,column_name,data_type
from information_schema.columns 
where table_name='clothing_products';
 

/**
	table_name	column_name	data_type
	clothing_products	product_id	integer
	clothing_products	price	numeric
	clothing_products	name	character varying
	clothing_products	description	text
	clothing_products	available_size	character varying   --> added
**/ 




