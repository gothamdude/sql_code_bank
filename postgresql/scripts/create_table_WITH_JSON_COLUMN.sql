/** 
 
JSON datatype 
JavaScript Object Notation (JSON) is an open standard format that consists of key-value pairs. 
The main usage of JSON is to transport data between a server and a web application. 
Unlike other formats, JSON is human-readable text. 
We use JSON datatype in REST API to display information as well. 

 * 
 */

create table person_json (
	id serial not null primary key,
	info json not null   -- note json field, i wonder how jdbc will treat this 
); 


insert into person_json (info)
values 	('{"name":"Tony","details":{"age":12,"country":"CHN"}}'),
		('{"name":"Jerry","details":{"age":13,"country":"NZ"}}'),
		('{"name":"JOhn","details":{"age":15,"country":"UK"}}');


select * from person_json pj ;