-- get information about a table 
select * 
from information_schema.columns 
where table_name='supplier';



-- get information about a field 
select pg_column_size(postalcode) from supplier;

 
-- get data type of a table's fields  
select column_name, data_type 
from information_schema.columns
where table_name='supplier';


