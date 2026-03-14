
-- In the next example, CONVERT is used to change the integer value into the char data type:
SELECT CONVERT(char(4), 2008) + ' Can now be concatenated!'

-- This example demonstrates performing the same type of conversion, this time using CAST:
SELECT BusinessEntityID, CAST(SickLeaveHours AS char(4)) + ' Sick Leave Hours Left' SickTime
FROM HumanResources.Employee

/*
Converting Dates to Their Textual Representation
As Imentioned earlier, CONVERT has an optional style parameter that allows you to convert datetime
or smalldatetime to specialized character formats.Many people confuse how the date and time is
stored with the actual presentation of the date in the query results.When using the style parameter,
keep inmind that you are only affecting how the date is presented in its character-based form, and
not how it is stored (unless, of course, you choose to store the presented data in a non-datetime
data type column).

Some examples of available style formats using the CONVERT function are shown in Table 8-7.

Table 8-7. CONVERT Style Formats
-----------------------------------------------------
Style Code Format
-----------------------------------------------------
101			mm/dd/yyyy
102			yy.mm.dd
103			dd/mm/yy
108			hh:mm:ss
110			mm-dd-yy
112			yymmdd
-----------------------------------------------------
*/

SELECT CONVERT(varchar(20), GETDATE(), 101)
SELECT CONVERT(datetime, CONVERT( varchar(11), '2008-08-13 20:37:22.570', 101))
SELECT CONVERT(date,'2008-08-13 20:37:22.570')




