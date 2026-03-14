-- Creates a UDF that returns a string array as a table result set
CREATE FUNCTION dbo.udf_ParseArray(
	 @StringArray varchar(max),
	 @Delimiter char(1) 
)
RETURNS @StringArrayTable TABLE (Val varchar(50))
AS
BEGIN
	DECLARE @Delimiter_position int
	IF RIGHT(@StringArray,1) != @Delimiter
	SET @StringArray = @StringArray + @Delimiter
	WHILE CHARINDEX(@Delimiter, @StringArray) <> 0
	BEGIN
	SELECT @Delimiter_position =
	CHARINDEX(@Delimiter, @StringArray)
	INSERT @StringArrayTable
	VALUES (left(@StringArray, @Delimiter_position - 1))
	SELECT @StringArray = STUFF(@StringArray, 1,
	@Delimiter_position, '')
	END
	RETURN
END
GO
/*
Now it will be used to break apart a comma-delimited array of values:

SELECT Val
FROM dbo.udf_ParseArray('A,B,C,D,E,F,G', ',')
This returns the following results:
Val
A
B
C
D
E
F
G

*/