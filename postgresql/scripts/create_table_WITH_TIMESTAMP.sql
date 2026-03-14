/**
Timestamp datatype 
PostgreSQL provides you with two temporal data types for handling timestamp: 

	timestamp: A timestamp without timezone one. 
	timestamptz: A timestamp with a timezone.

The timestamp datatype allows you to store both date and time. However, it does not have any time zone data. 
This means that when you change the time zone of your database server, the timestamp value stored in the database will not change automatically. 

The timestamptz datatype is the timestamp with the time zone. 
The timestamptz datatype is a time zone-aware date and time data type. 
When you insert a value into a timestamptz column, PostgreSQL converts the timestamptz value into a UTC value and stores the UTC value in the table.

**/	

create table timestamp_demo(
	ts timestamp,
	tstz timestamptz 
);

insert into timestamp_demo (ts, tstz) 
values ('2016-06-22 19:10:25-7','2016-06-22 19:10:25-07');


select ts,tstz from timestamp_demo ;

/**
ts							tstz
2016-06-22 19:10:25.000		2016-06-22 22:10:25.000 -0400   -- timezone is store since i am in NORHTEAST
**/ 



