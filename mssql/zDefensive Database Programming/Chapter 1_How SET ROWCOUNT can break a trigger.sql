/* 
How SET ROWCOUNT can break a trigger

Traditionally, developers have relied on the SET ROWCOUNT command to limit the number of rows returned 
to a client for a given query, or to limit the number of rows on which a data modification statement 
(UPDATE, DELETE, MERGE or INSERT) acts. In either case, SET ROWCOUNT works by instructing SQL Server to 
stop processing after a specified number of rows.

However, the use of SET ROWCOUNT can have some unexpected consequences for the unwary developer.
*/

CREATE TABLE dbo.Objects ( 
	ObjectID INT NOT NULL PRIMARY KEY , 
	SizeInInches FLOAT NOT NULL , 
	WeightInPounds FLOAT NOT NULL ) ;
GO

INSERT INTO dbo.Objects ( ObjectID , SizeInInches , WeightInPounds) 
SELECT 1 , 10 , 10
UNION ALL 
SELECT 2 ,12 , 12
UNION ALL 
SELECT 3 , 20 , 22 ;
GO




