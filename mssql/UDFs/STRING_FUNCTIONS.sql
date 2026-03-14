/* 
String Functions

This next set of recipes demonstrates SQL Server’s string functions. String functions provide amultitude
of uses for your Transact-SQL programming, allowing for string cleanup, conversion between
ASCII and regular characters, pattern searches, removal of trailing blanks, andmuchmore.
Table 8-3 lists the different string functions available in SQL Server.

Table 8-3. String Functions
-----------------------------------------------------------------------------------------------------------
Function Name(s)	Description
-----------------------------------------------------------------------------------------------------------
ASCII and CHAR		The ASCII function takes the leftmost character of a character
					expression and returns the ASCII code. The CHAR function converts an
					integer value for an ASCII code to a character value instead.
CHARINDEX and PATINDEX	The CHARINDEX function is used to return the starting position of a string
						within another string. The PATINDEX function is similar to CHARINDEX,
						except that PATINDEX allows the use of wildcards when specifying the
						string for which to search.
DIFFERENCE and SOUNDEX	The two functions DIFFERENCE and SOUNDEX both work with character
						strings to evaluate those that sound similar. SOUNDEX assigns a string a
						four-digit code, and DIFFERENCE evaluates the level of similarity
						between the SOUNDEX outputs for two separate strings.
LEFT and RIGHT		The LEFT function returns a part of a character string, beginning at the
					specified number of characters fromthe left. The RIGHT function is like
					the LEFT function, only it returns a part of a character string beginning
					at the specified number of characters fromthe right.
LEN and DATALENGTH		The LEN function returns the number of characters in a string
						expression, excluding any blanks after the last character (trailing
						blanks). DATALENGTH, on the other hand, returns the number of bytes
						used for an expression.
LOWER and UPPER		The LOWER function returns a character expression in lowercase, and the
					UPPER function returns a character expression in uppercase.
LTRIM and RTRIM		The LTRIM function removes leading blanks, and the RTRIM function
					removes trailing blanks.
NCHAR and UNICODE	The UNICODE function returns the Unicode integer value for the first
					character of the character or input expression. The NCHAR function takes
					an integer value designating a Unicode character and converts it to its
					character equivalent.
QUOTENAME			The QUOTENAME function adds delimiters to a Unicode input string in
					order tomake it a valid delimited identifier.
REPLACE				The REPLACE function replaces all instances of a provided string within a
					specified string with a new string.
REPLICATE			The REPLICATE function repeats a given character expression a
					designated number of times.
REVERSE				The REVERSE function takes a character expression and outputs the
					expression with each character position displayed in reverse order.
SPACE				The SPACE function returns a string of repeated blank spaces, based on
					the integer you designate for the input parameter.
STR					The STR function converts numeric data into character data.
STUFF				The STUFF function deletes a specified length of characters and inserts a
					designated string at the specified starting point.
SUBSTRING			The SUBSTRING function returns a defined chunk of a specified expression.
-----------------------------------------------------------------------------------------------------------
*/

-- This first example demonstrates how to convert characters into the integer ASCII value:
SELECT ASCII('H'), ASCII('e'), ASCII('l'), ASCII('l'), ASCII('o')

-- Next, the CHAR function is used to convert the integer values back into characters again:
SELECT CHAR(72), CHAR(101), CHAR(108), CHAR(108), CHAR(111) 

-- This first example converts single characters into an integer value representing the Unicode standard character code:
SELECT UNICODE('G'), UNICODE('o'), UNICODE('o'), UNICODE('d'), UNICODE('!')

-- Next, the Unicode integer values are converted back into characters:
SELECT NCHAR(71), NCHAR(111), NCHAR(111), NCHAR(100), NCHAR(33)

-- The CHARINDEX function is used to return the starting position of a string within another string. 
-- The syntax is as follows:
SELECT CHARINDEX('String to Find','This is the bigger string to find something in.')


-- The PATINDEX function is similar to CHARINDEX, except that PATINDEX allows the use of wildcards in
-- the string you are searching for. The syntax for PATINDEX is as follows:
SELECT AddressID, AddressLine1
FROM Person.Address
WHERE PATINDEX('[3][5]%olive%', AddressLine1) > 0

/* 
The two functions, DIFFERENCE and SOUNDEX, both work with character strings in order to evaluate
those that sound similar, based on English phonetic rules. SOUNDEX assigns a string a four-digit code,
and then DIFFERENCE evaluates the level of similarity between the SOUNDEX outputs for two separate
strings. DIFFERENCE returns a value of 0 to 4, with 4 indicating the closestmatch in similarity.
This example demonstrates how to identify strings that sound similar—first by evaluating
strings individually, and then comparing themin pairs :*/
SELECT SOUNDEX('Fleas'),
SOUNDEX('Fleece'),
SOUNDEX('Peace'),
SOUNDEX('Peas')

-- Next, string pairs are compared using DIFFERENCE:
SELECT DIFFERENCE ( 'Fleas', 'Fleece')  -- =4 
SELECT DIFFERENCE ( 'Fleece', 'Peace')  -- =2

-- This next example demonstrates zero-padding the ListPrice column’s value:
-- Padding a number for business purposes
SELECT TOP 3 ProductID, RIGHT('0000000000' + CONVERT(varchar(10), ListPrice),10)
FROM Production.Product
WHERE ListPrice > 0

-- This first example returns the number of characters in the Unicode string (Unicode data takes
-- two bytes for each character, whereas non-Unicode takes only one):
SELECT LEN(N'She sells sea shells by the sea shore.')

-- This next example returns the number of bytes in the Unicode string:
SELECT DATALENGTH(N'She sells sea shells by the sea shore.')

-- This example demonstrates how to replace all instances of a provided string with a new string:
SELECT REPLACE('Zenon is our major profit center. Zenon leads the way.', 'Zenon', 'Xerxes')

/*The first argument of this function is the character expression to bemodified. The second
argument is the starting position of the inserted string. The third argument is the number of
characters to delete within the character expression. The fourth argument is the actual character
expression that you want to insert. This example replaces a part of a string and inserts a new
expression into the string body:*/ 
SELECT STUFF ( 'My cat''s name is X. Have you met him?', 18, 1, 'Edgar' )


SELECT LEFT('I only want the leftmost 10 characters.', 10)
SELECT RIGHT('I only want the rightmost 10 characters.', 10) 
SELECT LOWER(DocumentSummary) FROM Production.Document WHERE FileName = 'Installing Replacement Pedals.doc'
SELECT UPPER(DocumentSummary) FROM Production.Document WHERE FileName = 'Installing Replacement Pedals.doc'
SELECT LTRIM(' String with leading blanks.')
SELECT RTRIM('"' + 'String with trailing blanks ') + '"'
SELECT REPLICATE ('Z', 30)
SELECT 'Give me some' + SPACE(6) + 'space.'
SELECT TOP 1 GroupName, REVERSE(GroupName) GroupNameReversed
FROM HumanResources.Department
ORDER BY GroupName

DECLARE @BankAccountNumber char(14)
SET @BankAccountNumber = '1424-2342-3536'
SELECT 'XXXX-' + SUBSTRING(@BankAccountNumber, 6,4) + '-XXXX'
Masked_BankAccountNumber









