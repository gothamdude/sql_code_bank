/** 

When storing a date value, PostgreSQL uses the yyyy-mm-dd format, for example, 2000-12-31.
You can use the CURRENT_DATE, following the DEFAULT keyword to specify the current date as the column's default value, when creating a table with a DATE column.

 **/

create table product (
	product_id serial primary key, 
	product_name varchar(255),
	manufactur_date date not null default current_date,
	expiry_date date not null
);





