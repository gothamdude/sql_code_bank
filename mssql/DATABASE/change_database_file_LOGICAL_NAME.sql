/*
You can change a database file’s logical name without having to bring the database offline. The logical
name of a database doesn’t affect the functionality of the database itself, allowing you to change
the name for consistency and naming convention purposes. For example, if you restore a database
frombackup using a new database name, youmay wish for the logical name tomatch the new
database name.

The syntax for changing a logical file name is as follows:

ALTER DATABASE database_name
{NAME = logical_file_name
[ , NEWNAME = new_logical_name ] }

*/

ALTER DATABASE BookTransferHouse
MODIFY FILE (NAME = 'BookTransferHouse', NEWNAME = 'BookTransferHouse_DataFile1')
GO


/*
This returns

-----------------------------------------------------------
The file name 'BookTransferHouse_DataFile1' has been set.
-----------------------------------------------------------

*/