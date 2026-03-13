/** 

UUID data type 

UUID datatype Universal Unique Identifier (UUID) defined by RFC 4122 and other related standards. 
A UUID is a sequence of 32 digits of hexadecimal digits represented in groups separated by hyphens. 
PostgreSQL allows you store and compare UUID values, but it does not include functions for generating the UUID values in its core. 
Instead, it relies on the third-party modules that provide specific algorithms to generate UUIDs. 
To install the uuid-ossp module, you use the CREATE EXTENSION statement as follows:

**/

create extension if not exists "uuid-ossp";  -- add this to core 

select uuid_generate_v1();  -- call the udf 

-- uuid_generate_v1
-- 89abd204-1ec9-11f1-b4d5-1f2296d271b0


-- so let's use it for a table 

create table customer_special (
	c_id uuid default uuid_generate_v4(),
	first_name varchar not null,
	last_name varchar not null,
	primary key (c_id)
); 


insert into customer_special(first_name, last_name)
values ('dennis','richie'),	('john','doe'),('ryan','gosling');


select * from customer_special;









