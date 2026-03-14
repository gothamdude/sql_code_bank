/* 
The syntax for setting these options is as follows:

ALTER DATABASE database_name
SET <option> { ON | OFF }

This statement takes two arguments: the database name you want tomodify and the name of
the ANSI SQL setting you wish to enable or disable. 

---------------------------------------------------------------------------------------------------------

ANSI_NULL_DEFAULT	When this option is set to ON, columns not explicitly defined with a
					NULL or NOT NULL in a CREATE or ALTER table statement will default to
					allow NULL values. The default is OFF, whichmeans a column will be
					defined as NOT NULL if not explicitly defined.

ANSI_NULLS			When this option is enabled, a comparison to a null value returns
					UNKNOWN. The default for this setting is OFF,meaning that comparisons
					to a null value will evaluate to TRUE when both values are NULL.

ANSI_PADDING		This option pads strings to the same length prior to inserting into a
					varchar or nvarchar data type column. The default setting is OFF,
					meaning that strings will not be padded.

ANSI_WARNINGS		This setting impacts a few different behaviors.When ON, any null
					values used in an aggregate function will raise a warningmessage.
					Also, divide-by-zero and arithmetic overflow errors will roll back the
					statement and return an errormessage. This setting is OFF by default.

ARITHABORT			When this option is set to ON, a query with an overflow or division by
					zero will terminate the query and return an error. If this occurs within
					a transaction, then that transaction gets rolled back.When this option
					is OFF (the default), a warning is raised, but the statement continues
					to process.

CONCAT_NULL_YIELDS_NULL When this option is set to ON, concatenating a null value with a string
						produces a NULL value.When OFF (the default), a null value is the
						equivalent of an empty character string.

NUMERIC_ROUNDABORT When this option is set to ON, an error is produced when a loss of
					precision occurs in an expression.When OFF (the default), no error
					message is raised, but the result is rounded to the precision of the
					destination column or variable.

QUOTED_IDENTIFIER	When this option is set to ON, identifiers can be delimited by double
					quotationmarks and literals with single quotationmarks.When OFF
					(the default), only literals can be delimited with single or double
					quotationmarks.

RECURSIVE_TRIGGERS	When this option is ON, triggers can fire recursively (trigger 1 fires
					trigger 2, which fires trigger

---------------------------------------------------------------------------------------------------------
*/
USE master 
GO 

SET NOCOUNT ON

SELECT is_ansi_nulls_on
FROM sys.databases
WHERE name = 'TestAttach'

ALTER DATABASE TestAttach
SET ANSI_NULLS ON

SELECT is_ansi_nulls_on
FROM sys.databases
WHERE name = 'TestAttach'