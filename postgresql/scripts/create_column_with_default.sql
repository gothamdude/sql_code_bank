create table products_with_default(
	product_id integer, 
	category_id varchar(100) default 0, 
	unit_price numeric default 0.00, 
	constraint pk_products_with_default primary key (product_id, category_id) 
);
