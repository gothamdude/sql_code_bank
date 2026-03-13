/**

Array datatype 
To store more than one value of the same type in one column, Postgres allows array datatype. 
For example, if you need to store multiple email addresses or phone numbers of one person, you can use the array data type. 
Every data type has its own companion array type; for example, an integer has an integer[] array type, the character has a character[] array type, and so on. 
In case you define your own data type, PostgreSQL generates the corresponding array type in the background for you.

 * 
 */

drop table items_special; 

create table items_special (
	item_id serial primary key, 
	item_name varchar(50) not null,
	country text[]           ---> array of varchars 
); 


-- sample insert 

insert into items_special 
values (10, 'apple', '{"India","USA"}' ),
		(20, 'orange', '{"Russia","India"}'),
		(30, 'banana', '{"India","Mexico"}'
);


select * from items_special;

