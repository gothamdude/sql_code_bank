
-- First populating the example
SELECT *
INTO Sales.Example_Store
FROM Sales.Store

-- Next, truncating ALL rows from the example table
TRUNCATE TABLE Sales.Example_Store

-- Next, the table’s row count is queried:

SELECT COUNT(*)
FROM Sales.Example_Store

/*
This returns
0
*/


/*
How It Works

The TRUNCATE TABLE statement, like the DELETE statement, can delete rows from a table. TRUNCATE
TABLE deletes rows faster than DELETE, because it is minimally logged. Unlike DELETE however, the
TRUNCATE TABLE removes ALL rows in the table (no WHERE clause).

Although TRUNCATE TABLE is a faster way to delete rows, you can’t use it if the table columns are
referenced by a foreign key constraint (see Chapter 4 for more information on foreign keys), if the
table is published using transactional or merge replication, or if the table participates in an indexed
view (see Chapter 7 for more information). Also, if the table has an IDENTITY column, keep in mind
that the column will be reset to the seed value defined for the column (if no seed was explicitly set,
it is set to 1).
*/