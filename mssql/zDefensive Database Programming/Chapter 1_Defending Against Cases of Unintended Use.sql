USE DefensiveDatabase
GO 

CREATE TABLE dbo.Messages 
(
	MessageID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
	Subject  VARCHAR(30) NOT NULL,
	Body VARCHAR(100) NOT NULL
);
GO 

INSERT INTO dbo.Messages(Subject, Body) 
SELECT 'Next release delayed', 'Still fixing bugs'
UNION ALL 
SELECT 'New printer arrived', 'By the kitchen area' ;
GO 

DROP PROCEDURE dbo.SelectMessagesBySubjectBeginning; 
GO 

CREATE PROCEDURE dbo.SelectMessagesBySubjectBeginning 
	@SubjectBeginning VARCHAR(30)
AS
	SET NOCOUNT ON;
	
	SELECT Subject, Body
	FROM dbo.Messages
	WHERE Subject LIKE @SubjectBeginning + '%';
GO 


-- TESTING w/ intended use 

-- must return one row too  - good 
EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning='Next';

-- must return one row too - good 
EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning='New';

-- must return two rows  - good 
EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning='Ne';

-- must return nothing - good 
EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning='No Such subject';


-- adding unintended use 

INSERT INTO dbo.Messages(Subject, Body)
SELECT '[OT] Great vacation in Norway ', 'Pictures already uploaded'
UNION ALL 
SELECT '[OT] Great new camera', 'Used it on my vacation'


-- must return nothing - FAILS 
EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning='[OT]';

/* returns: 
Subject							Body
------------------------------ -------------------
*/


INSERT INTO dbo.Messages (Subject , Body) 
SELECT 'Ordered new water cooler' , 'Ordered new water cooler' ;
GO 

EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning = '[OT]' ;

/* returns:
Subject							Body
------------------------------	-------------------
Ordered new water cooler		Ordered new water cooler
*/

-- Our procedure returns the wrong messages when the search pattern contains [OT].
-- When using the LIKE keyword, square brackets ("[" and "]"), are treated as wildcard characters, 
-- denoting a single character within a given range or set. As a result, while the search was 
-- intended to be one for off-topic posts, it in fact searched for "any messages whose subject starts with O or T."


--  In a similar vein, we can also prove that the procedure fails for messages with the % sign in subject lines,
INSERT INTO dbo.Messages ( Subject , Body ) 
SELECT '50% bugs fixed for V2' , 'Congrats to the developers!' 
UNION ALL 
SELECT '500 new customers in Q1' , 'Congrats to all sales!' ;
GO

EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning = '50%' ;

/* returns;
Subject							Body
------------------------------	----------------
50% bugs fixed for V2			Congrats to the developers!
500 new customers in Q1			Congrats to all sales!
*/

-- The problem is basically the same: the % sign is a wildcard character denoting "any string of zero or more characters." 
-- Therefore, the search returns the "500 new customers…" row in addition to the desired "50% bugs fixed…" row.

-- Our testing has revealed an implicit assumption that underpins the implementation of the SelectMessagesBySubjectBeginning stored procedure: 
-- the author of this stored procedure did not anticipate or expect that message subject lines could contain special characters, such as square brackets and percent signs. 
-- As a result, the search only works if the specified SubjectBeginning does not contain special characters. 
-- Having identified this assumption, we have a choice: we can either change our stored procedure so that it does not rely on this assumption, or we can enforce it.





-- 1st option ; 














