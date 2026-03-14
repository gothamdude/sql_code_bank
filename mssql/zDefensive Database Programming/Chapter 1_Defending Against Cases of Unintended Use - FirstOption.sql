/* 1st OPTION 

Enforcing or eliminating the special characters assumption

Our first option is to fix our data by enforcing the assumption that messages will not contain special characters in their subject line. 
We can delete all the rows with special characters in their subject line, and then add a CHECK constraint that forbids their future use, 
as shown in Listing 1-6. 

The patterns used in the DELETE command and in the CHECK constraint are advanced, and need some explanation. 
The first pattern, %[[]%, means the following:
*/

BEGIN TRAN ;

DELETE FROM dbo.Messages 
WHERE Subject LIKE '%[[]%' OR Subject LIKE '%[%]%' ;

ALTER TABLE dbo.Messages
ADD CONSTRAINT Messages_NoSpecialsInSubject CHECK (Subject NOT LIKE '%[[]%' AND Subject NOT LIKE '%[%]%') ;

SELECT * FROM dbo.Messages 

ROLLBACK TRAN;


