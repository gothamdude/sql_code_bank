/*
Table 8-2.Mathematical Functions
-----------------------------------------------------------------------------------------------------------
Function	Description
-----------------------------------------------------------------------------------------------------------
ABS			Calculates the absolute value
ACOS		Calculates the angle, the cosine of which is the specified argument, in radians
ASIN		Calculates the angle, the sine of which is the specified argument, in radians
ATAN		Calculates the angle, the tangent of which is the specified argument, in radians
ATN2		Calculates the angle, the tangent of which is between two float expressions, in radians
CEILING		Calculates the smallest integer greater than or equal to the provided argument
COS			Calculates the cosine
COT			Calculates the cotangent
DEGREES		Converts radians to degrees
EXP			Calculates the exponential value of a provided argument
FLOOR		Calculates the largest integer less than or equal to the provided argument
LOG			Calculates the natural logarithm
LOG10		Calculates the Base-10 logarithm
PI			Returns the PI constant
POWER		Returns the value of the first argument to the power of the second argument
RADIANS		Converts degrees to radians
RAND		Produces a randomfloat-type value ranging from0 to 1
ROUND		Rounds a provided argument’s value to a specified precision
SIGN		Returns -1 for negative values, 0 for zero values, and 1 if the provided argument is
			positive
SIN			Calculates the sine for a given angle in radians
SQUARE		Calculates the square of a provided expression
SQRT		Calculates the square root
TAN			Calculates the tangent
-----------------------------------------------------------------------------------------------------------
*/

-- This first example calculates 10 to the 2nd power:
SELECT POWER(10,2) Result

-- This next example calculates the square root of 100:
SELECT SQRT(100) Result

-- This example rounds a number to the third digit right of the decimal place:
SELECT ROUND(3.22245, 3) RoundNumber

-- This example returns a randomfloat data type value between 0 and 1 (your result will vary from mine):
SELECT RAND()  RandomNumber

-- This last example in the recipe returns a fixed float data type value based on the provided integer value:
SELECT RAND(22) Result
