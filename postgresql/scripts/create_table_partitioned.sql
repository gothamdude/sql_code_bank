/**
Large tables can be made more manageable by dividing them into smaller, more manageable parts known as partitions. 
This database design method termed partitioned tables in PostgreSQL. 
For the purpose of organizing and accessing data, each partition works as a separate table, but when combined, they form a logical entity. PostgreSQL supports list, range, hash and combinations of these partition methods.
**/


-- list partition 
-- A list partition is created with predefined values to hold in a partitioned table. For example, list of district based on states will be created using the following code:
CREATE TABLE customers (id INTEGER, location TEXT, phone NUMERIC) PARTITION BY LIST(location);
CREATE TABLE cust_US PARTITION OF customers FOR VALUES IN ('US'); 
CREATE TABLE cust_IND PARTITION OF customers FOR VALUES IN ('INDIA'); 
CREATE TABLE cust_others PARTITION OF customers DEFAULT;

-- range partition 
-- To hold values inside the range given on the partition key, a range partition is made. It is necessary to provide the range's minimum and maximum values, with the minimum being inclusive and the maximum being exclusive. For example, from January to June, the range partition will be created using:
CREATE TABLE test (id INTEGER, name TEXT) PARTITION BY RANGE(id); 
CREATE TABLE test1 PARTITION OF test FOR VALUES FROM(0) TO (10); 
CREATE TABLE test2 PARTITION OF test FOR VALUES FROM(11) TO (20);

-- hash partition 
-- A hash partition is created using modulus and remainder for each partition, where rows are inserted by generating a hash value using this mo-- dulus and remainders. Refer to the following code:
CREATE TABLE customers (id INTEGER, location TEXT) PARTITION BY HASH(id); 
CREATE TABLE customer_part1 PARTITION OF customers FOR VALUES WITH (modulus 3, remainder 0); 
CREATE TABLE customer_part2 PARTITION OF customers FOR VALUES WITH (modulus 3, remainder 1);


/*** NOTE 
 * Range partition does not allow null values 
 * Unique constraints on partitioned tables must include all partition key columns
 */



