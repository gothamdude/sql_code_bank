/*
ALTER DATABASE database_name
MODIFY FILE
(
NAME = logical_file_name
[ , SIZE = size [ KB | MB | GB | TB ] ]
[ , MAXSIZE = { max_size [ KB | MB | GB | TB ] |
UNLIMITED } ]
[ , FILEGROWTH = growth_increment [ KB | MB | % ] ]
)
*/

-- In this recipe, a file is increased to 6MB in size and given amaximumallowable size of 10MB:

ALTER DATABASE BookTransferHouse
MODIFY FILE (	NAME='BookTransferHouse_DataFile1', 
				SIZE=6MB, 
				MAXSIZE=10MB
				)
GO 