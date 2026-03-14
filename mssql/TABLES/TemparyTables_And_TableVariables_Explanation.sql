/* 
Temporary tables are defined just like regular tables, only they are automatically stored in the
tempdb database (nomatter which database context you create themin). Temporary tables are often
used in the following scenarios:

	• As an alternative to cursors: For example, instead of using a Transact-SQL cursor to loop
	through a result set, performing tasks based on each row, you can populate a temporary
	table instead. Using a WHILE loop, you can loop through each row in the table, performthe
	action for the specified row, and then delete the row fromthe temp table.

	• As an incremental storage of result sets: For example, let’s say you have a single SELECT query
	that performs a join against ten tables. Sometimes queries with several joins can perform
	badly. One technique to try is to break down the large query into smaller, incremental
	queries. Using temporary tables, you can create intermediate result sets based on smaller
	queries, instead of trying to execute a single, very large,multi-joined query.

	• As a temporary, low-overhead lookup table: For example, imagine that you are using a query
	that takes several seconds to execute but only returns a small result set. You wish to use the
	small result set in several areas of your stored procedure, but each time you reference it, you
	incur the query execution time overhead. To resolve this, you can execute the query just
	once within the procedure, populating the temporary table. Then you can reference the temporary
	table inmultiple places in your code, without incurring the extra overhead.

There are two different temporary table types: global and local. Local temporary tables are prefixed
with a single # sign, and global temporary tables with a double ## sign.

Local temporary tables are available for use by the current user connection that created them.
Multiple connections can create the same-named temporary table for local temporary tables without
encountering conflicts. The internal representation of the local table is given a unique name, so
as not to conflict with other temporary tables with the same name created by other connections in
the tempdb database. Local temporary tables are dropped by using the DROP statement or are automatically
removed frommemory when the user connection is closed.

Global temporary tables have a different scope fromlocal temporary tables. Once a connection
creates a global temporary table, any user with proper permissions to the current database he is in
can access the table. Unlike local temporary tables, you can’t create simultaneous versions of a
global temporary table, as this will generate a naming conflict. Global temporary tables are removed
fromSQL Server if explicitly dropped by DROP TABLE. They are also automatically removed after the
connection that created it disconnects and the global temporary table is no longer referenced by
other connections. As an aside, I rarely see global temporary tables used in the field.When a table
must be shared across connections, a real table is created, instead of a global temporary table.
Nonetheless, SQL Server offers this as a choice.

Temporary tables are much maligned by the DBA community due to performance issues—
some of these complaints are valid, and some aren’t. It is true that temporary tablesmay cause
unwanted disk overhead in tempdb, locking of tempdb during their creation, as well as stored procedure
recompilations, when included within a stored procedure’s definition (a recompilation is when
an execution plan of the stored procedure is re-created instead of reused).
 
A table variable is a data type that can be used within a Transact-SQL batch, stored procedure,
or function—and is created and defined similarly to a table, only with a strictly defined lifetime
scope. Table variables are often good replacements of temporary tables when the data set is small.
Statistics are notmaintained for table variables like they are for regular or temporary tables, so
using too large a table variablemay cause query optimization issues. Unlike regular tables or temporary
tables, table variables can’t have indexes or FOREIGN KEY constraints added to them. Table
variables do allow some constraints to be used in the table definition (PRIMARY KEY, UNIQUE, CHECK).
Reasons to use table variables include the following:

	• Well scoped. The lifetime of the table variable only lasts for the duration of the batch, function,
	or stored procedure.
	• Shorter locking periods (because of the tighter scope).
	• Less recompilation when used in stored procedures.

As stated earlier, there are drawbacks to using table variables. Table variable performance suffers
when the result set becomes too large or when column data cardinality is critical to the query
optimization process.When encountering performance issues, be sure to test all alternative solutions,
and don’t necessarily assume that one option (temporary tables) is less desirable than others
(table variables).

*/
