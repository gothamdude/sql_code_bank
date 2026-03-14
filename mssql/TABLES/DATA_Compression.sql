SQL Server 2008 Enterprise Edition and Developer Edition introduce row- and page-level compression
for tables, indexes, and associated partitions.

Row compression applies variable-length storage to numeric data types (for example, int,
bigint, and decimal) and fixed-length types such as money and datetime. Row compression also
applies variable-length format to fixed-character strings and doesn’t store trailing blank characters,
NULL, and 0 values.

Page compression includes row compression, and also adds prefix and dictionary compression.
Prefix compression involves the storage of column prefix values that are storedmultiple times
in a column across rows and replaces the redundant prefixes with references to the single value.
Dictionary compression occurs after prefix compression and involves finding repeated data values
anywhere on the data page (not just prefixes) and then replacing the redundancies with a pointer to
the single value.

--------------------------------------------------------------------------------------------------------------
■ Caution The trade-off for compression is some increased CPU utilization. You must consider and test your
current application to determine whether the trade-off of disk space to ongoing CPU overhead is beneficial.
--------------------------------------------------------------------------------------------------------------