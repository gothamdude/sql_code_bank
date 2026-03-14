/* 
Table partitioning provides you with a built-inmethod of horizontally partitioning data within
a table and/or index while stillmaintaining a single logical object. Horizontal partitioning involves
keeping the same number of columns in each partition, but reducing the number of rows. Partitioning
can easemanagement of very large tables and/or indexes, decrease load time, improve query
time, and allow smallermaintenance windows. These next few recipes in this section will demonstrate
how to use Transact-SQL commands to create,modify, andmanage partitions and partition
database objects.

Before diving into the partitioning-related recipes, I’ll discuss the two new commands CREATE
PARTITION FUNCTION and CREATE PARTITION SCHEME. The CREATE PARTITION FUNCTION maps columns
to partitions based on the value of a specified column. For example, if you are evaluating a column
with a datetime data type, you can partition data to separate filegroups based on the year ormonth.

The basic syntax for CREATE PARTITION FUNCTION is as follows:

CREATE PARTITION FUNCTION partition_function_name(input_parameter_type)
AS RANGE [ LEFT | RIGHT ]
FOR VALUES ( [ boundary_value [ ,...n ] ] )

Table 4-15. CREATE PARTITION FUNCTION Arguments
--------------------------------------------------------------------------------------------------------------
Argument			Description
--------------------------------------------------------------------------------------------------------------
partition_function_name			This specifies the partition function name.
input_parameter_type			This indicates the data type of the partitioning column. You
								cannot use large value data types (text, ntext, image, xml,
								timestamp, varchar(max), varbinary(max), nvarchar(max)), CLR
								user-defined data types, or aliased data types. If you wished to
								partition table data by a datetime column, you would designate
								datetime for the input_parameter_type.
LEFT | RIGHT					You also have a choice of LEFT or RIGHT, which defines which
								boundary the defined values in the boundary_value argument
								belong to (see the upcoming “How ItWorks” section for a review
								of LEFT versus RIGHT).
[ boundary_value [ ,...n ] ]	This argument defines the range of values in each partition.
								You can define up to 999 partitions (however, thatmany isn’t
								recommended due to potential performance concerns). The
								number of values you choose in this argument amounts to a
								total of n + 1 partitions (again, see the upcoming “How ItWorks”
								section for amore in-depth explanation).
--------------------------------------------------------------------------------------------------------------

Once a partition function is created, it can be used with one ormore partition schemes.
A partition scheme maps partitions defined in a partition function to actual filegroups.
The basic syntax for CREATE PARTITION SCHEME is as follows:

	CREATE PARTITION SCHEME partition_scheme_name
	AS PARTITION partition_function_name
	[ ALL ] TO ( { file_group_name | [PRIMARY] } [ ,...n] )

Table 4-16 details the arguments of this command.
Table 4-16. CREATE PARTITION SCHEME Arguments
--------------------------------------------------------------------------------------------------------------
Argument			Description
--------------------------------------------------------------------------------------------------------------
partition_scheme_name			This specifies the name of the partition scheme.
partition_function_name			This indicates the name of the partition function
								that the scheme will bind to.
ALL								If ALL is designated, all partitions willmap to the
								filegroup designated in the file_group_name
								argument.
{ file_group_name | [PRIMARY] } [ ,...n]	This defines the filegroup or filegroups assigned to
											each partition.When PRIMARY is designated, the
											partition will be stored on the primary filegroup.
--------------------------------------------------------------------------------------------------------------

*/