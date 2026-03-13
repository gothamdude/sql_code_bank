/**

HSTORE datatype 
The HSTORE data type is used for storing key-value pairs in a single value. 
Keys and values are just text strings. 
The hstore data type is very useful in many cases, such as semi-structured data or rows with many attributes that are rarely queried. 

Before we start working with the hstore data type, you need to enable the hstore extension which loads the contrib module to your PostgreSQL instance. 
To enable the PostgreSQL hstore extension for our PostgreSQL design, we can use the CREATE EXTENSION command. 
**/

CREATE EXTENSION hstore;


create table books_with_hstore (
	id serial primary key, 
	title varchar(255),
	attribute hstore 
);



insert into books_with_hstore (title, attribute) 
values ( 'java complete practical solution', '"paperback"=>"763","publisher"=>"CS publisher","language"=>"English","ISBN-13"=>978-1449370000", "weight" => "11.2 ounces"');


select * from books_with_hstore;