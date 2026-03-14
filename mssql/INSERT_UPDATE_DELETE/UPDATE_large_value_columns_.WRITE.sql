/* 

SQL Server introduced new large-value data types in the previous version, which were intended to replace the
deprecated text, ntext, and image data types. These data types include

	• varchar(max), which holds non-Unicode variable-length data
	• nvarchar(max), which holds Unicode variable-length data
	• varbinary(max), which holds variable-length binary data

These data types can store up to 2^31–1 bytes of data (for more information on data types, see Chapter 4).

One of the major drawbacks of the old text and image data types is that they required you to
use separate functions such as WRITETEXT and UPDATETEXT in order to manipulate the image/text
data. Using the new large-value data types, you can now use regular INSERT and UPDATEs instead.

The syntax for inserting a large-value data type is no different from a regular insert. For updating
large-value data types, however, the UPDATE command now includes the .WRITE method:

	UPDATE <table_or_view_name>
	SET column_name = .WRITE ( expression , @Offset , @Length )
	FROM <table_source>
	WHERE <search_condition>


The parameters of the .WRITE method are described in Table 2-5.
--------------------------------------------------------------------------
Table 2-5. UPDATE Command with .WRITE Clause
Argument Description
expression		The expression defines the chunk of text to be placed in the column.
@Offset			@Offset determines the starting position in the existing data the new text should be 
				placed. If @Offset is NULL, it means the new expression will be appended to the end 
				of the column (also ignoring the second @Length parameter).
@Length			@Length determines the length of the section to overlay.
--------------------------------------------------------------------------
*/


CREATE TABLE dbo.RecipeChapter (
		ChapterID int NOT NULL,
		Chapter varchar(max) NOT NULL
	)
GO

INSERT dbo.RecipeChapter (ChapterID, Chapter)
VALUES (1, 'At the beginning of each chapter you will notice that basic concepts are covered first.' )

UPDATE RecipeChapter 
SET Chapter .WRITE (' In addition to the basics, this chapter will also provide recipes that can be used in your day to day development and administration.' ,NULL, NULL)
WHERE ChapterID = 1

SELECT Chapter
FROM RecipeChapter
WHERE ChapterID = 1
