/**
CREATE TABLE [IF NOT EXISTS] table_name ( 
	column1 datatype(length) column_contraint, 
	column2 datatype(length) column_contraint, 
	column3 datatype(length) column_contraint, 
	table_constraints 
);


CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE [ IF NOT EXISTS ] table_name 
OF type_name [ (
 { column_name [ WITH OPTIONS ] [ column_constraint [ ... ] ] 
 	| table_constraint } 
 	[, ... ] 
 )]
 [ PARTITION BY { RANGE | LIST | HASH } ( { column_name | ( expression ) } [ COLLATE collation ] [ opclass ] [, ... ] ) ] 
 [ USING method ] 
 [ WITH ( storage_parameter [= value] [, ... ] ) | WITHOUT OIDS ] 
 [ ON COMMIT { PRESERVE ROWS | DELETE ROWS | DROP } ] 
 [ TABLESPACE tablespace_name ]
 

**/
 

create table if not exists items (
item_id serial primary key,
item_name varchar(20) not null,
country text[]
);


 drop table if exists items; 
 

 -- validation 
select * from information_schema.columns where table_name='items';
select * from information_schema.tables where table_schema='public';


 