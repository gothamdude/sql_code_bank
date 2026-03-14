/* 2nd OPTION 

Listing 1-7 shows how to alter the stored procedure so that it can handle special
characters. To better demonstrate how the procedure escapes special characters, I included some debugging output. 
Always remember to remove such debugging code before handing over the code for QA and deployment!

*/

USE [DefensiveDatabase]
GO 

ALTER PROCEDURE [dbo].[SelectMessagesBySubjectBeginning]
	@SubjectBeginning VARCHAR(50)
AS 

	SET NOCOUNT ON;
	
	DECLARE @ModifiedSubjectBeginning VARCHAR(150);

	SET @ModifiedSubjectBeginning = REPLACE(REPLACE(@SubjectBeginning, '[','[[]'),'%','[%]');

	SELECT  @SubjectBeginning AS [@SubjectBeginning], 
			@ModifiedSubjectBeginning AS [@ModifiedSubjectBeginning];

	SELECT Subject, Body 
	FROM dbo.Messages
	WHERE Subject LIKE @ModifiedSubjectBeginning + '%';
GO 


-- now both of these works 
EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning = '[OT]' ;

EXEC dbo.SelectMessagesBySubjectBeginning @SubjectBeginning = '50%' ;