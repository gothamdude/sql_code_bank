-- Using the ROWGUIDCOL Property

/* 
First, a table is created using ROWGUIDCOL, identified after the column data type definition but before
the default definition (populated via the NEWID systemfunction):
*/ 

CREATE TABLE HumanResources.BuildingAccess( 
	BuildingEntryExitID uniqueidentifier ROWGUIDCOL DEFAULT NEWID(),
	EmployeeID int NOT NULL,
	AccessTime datetime NOT NULL,
	DoorID int NOT NULL
)

-- Next, a row is inserted into the table:

INSERT HumanResources.BuildingAccess (EmployeeID, AccessTime, DoorID)
VALUES (32, GETDATE(), 2) 

/*
The table is then queried, using the ROWGUIDCOL designator instead of the original 
BuildingEntryExitID column name (although the original name can be used too — ROWGUIDCOL
just offers amore genericmeans of pulling out the identifier in a query):
*/

SELECT ROWGUIDCOL, 
		EmployeeID,
		AccessTime,
		DoorID
FROM HumanResources.BuildingAccess