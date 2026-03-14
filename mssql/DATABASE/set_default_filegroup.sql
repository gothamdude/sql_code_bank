/*

This recipe demonstrates how to change a filegroup into the default filegroup,meaning that the
filegroup will contain all newly created database objects by default (unless database objects are
explicitly put in a different filegroup during their creation).

This recipe sets the FG2 filegroup in the BookWarehouse database to the default filegroup:
*/

ALTER DATABASE BookTransferHouse
MODIFY FILEGROUP FG2 DEFAULT