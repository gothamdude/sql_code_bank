/*
The UNPIVOT command does almost the opposite of PIVOT by changing columns into rows. It also
uses the same syntax as PIVOT, only UNPIVOT is designated instead.

This example demonstrates how UNPIVOT can be used to remove column-repeating groups
often seen in denormalized tables. For the first part of this recipe, a denormalized table is created
with repeating, incrementing phone number columns:
*/

CREATE TABLE dbo.Contact
(EmployeeID int NOT NULL,
PhoneNumber1 bigint,
PhoneNumber2 bigint,
PhoneNumber3 bigint)
GO

INSERT dbo.Contact (EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3) VALUES( 1, 2718353881, 3385531980, 5324571342)
INSERT dbo.Contact (EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3) VALUES( 2, 6007163571, 6875099415, 7756620787)
INSERT dbo.Contact (EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3) VALUES( 3, 9439250939, NULL, NULL)

SELECT EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3
FROM dbo.Contact

/*
Now using UNPIVOT, the repeating phone numbers are converted into a more normalized form reusing a single 
PhoneValue field instead of repeating the phone column multiple times):
*/

SELECT EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3
FROM dbo.Contact

SELECT	EmployeeID,
		PhoneType,
		PhoneValue
FROM (	SELECT EmployeeID, PhoneNumber1, PhoneNumber2, PhoneNumber3
		FROM dbo.Contact) c
		UNPIVOT (PhoneValue FOR PhoneType IN ([PhoneNumber1], [PhoneNumber2], [PhoneNumber3])
) AS p


This returns
EmployeeID PhoneType PhoneValue
1 PhoneNumber1 2718353881
1 PhoneNumber2 3385531980
1 PhoneNumber3 5324571342
2 PhoneNumber1 6007163571
2 PhoneNumber2 6875099415
2 PhoneNumber3 7756620787
3 PhoneNumber1 9439250939
(7 row(s) affected)