/***
 
/Time datatype PostgreSQL provides the time data type that allows you to store the time-of-day values. 
A time value may have a precision of up to 6 digits. The precision specifies the number of fractional digits placed in the second field. 
The time data type requires 8 bytes, and it can range from 00:00:00 to 24:00:00.

**/

drop table shift_schedule ;

create table shift_schedule (
	id serial primary key,
	shift_name varchar not null,
	clock_in_time time not null, 
	clock_out_time time not null 
);


insert into shift_schedule(	shift_name,	clock_in_time,clock_out_time ) 
values ('morning','04:00:00','10:00:00'),
	('afternoon','10:00:00','18:00:00'),
	('evening','18:00:00','24:00:00'),
	('night','24:00:00','04:00:00');
 

select * from shift_schedule;


