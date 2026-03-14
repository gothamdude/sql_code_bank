/** 

INSERT INTO TABLE_NAME    (column1,    column2,    column3, ……columnN)     
VALUES (value1, value2, value3, ….. valueN);

***/ 

insert into electronics_products(name,description,price,brand) 
values('Speaker','Bluetooth speaker',454545.34,'Samsung');

-- validate
select * from electronics_products;

/**
product_id	name	description	price	brand
1	Speaker	Bluetooth speaker	454,545.34	Samsung
**/

insert into books_products(name,description,price,author_name) values('Java-A complete practical solution','Complete hands on book',657.3,'Swati saxena'); 
insert into clothing_products(name,description,price,available_size) values('T-Shirt','Full sleeves',1657.3,'L');

select * from clothing_products;
select * from books_products;





 