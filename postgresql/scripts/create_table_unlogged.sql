/**

UNLOGGED TABLE
An unlogged table is a type of table for which changes are not recorded in the write-ahead log.

Some points to remember when it comes to unlogged tables, are as follows: 
 - Unlogged tables are not crash-safe. If PostgreSQL crashes, the data in an unloggd table may be lost. 
 - Unlogged tables can offer better performance for insert, update, and delete operations due to the absence of logging overhead. 
 - Unlogged tables are often used for temporary storage, such as session-specific data in a web application or intermediate results in data processing.
 - Since unlogged tables are not logged, you cannot use tools like point-in-time recovery to restore the data in case of a failure. 
 - Unlogged tables are useful when the data in them is not critical, but the filling speed is critical.
 
**/


CREATE UNLOGGED TABLE unlogged_table ( 
	id serial PRIMARY KEY, 
	name VARCHAR(255) 
);



