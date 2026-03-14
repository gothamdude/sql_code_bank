/* 
Executing INSERTs,UPDATEs, and DELETEs in a Single Statement

	SQL Server 2008 introduces the MERGE command to efficiently apply changes to a target table based
on the data in a table source. If you’ve ever had to load and incrementally modify relational data
warehouses or operational data stores based on incoming data from external data sources, you’ll
find this technique to be a big improvement over previous methods.
	
	Rather than create multiple data modification statements, you can instead point MERGE to your
target and source tables, defining what actions to take when search conditions find a match, when
the target table does not have a match, or when the source table does not have a match. Based on
these matching conditions, you can designate whether or not a DELETE, INSERT, or UPDATE operation
takes place (again, within the same statement).
	
	This recipe will demonstrate applying changes to a production table based on data that exists
in a staging table (presumably staged data from an external data source). I’ll start off by creating a
production table that tells me whether or not a corporate housing unit is available for renting. If the
IsRentedIND is 0, the unit is not available. If it is 1, it is available:

*/

CREATE TABLE HumanResources.CorporateHousing(
	CorporateHousingID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	UnitNBR int NOT NULL,
	IsRentedIND bit NOT NULL,
	ModifiedDate datetime NOT NULL DEFAULT GETDATE())
GO

-- Insert existing units

INSERT HumanResources.CorporateHousing (UnitNBR, IsRentedIND)
VALUES (1, 0), (24, 1), (39, 0), (54, 1)

/* 
In this scenario, I receive periodic data feeds that inform me of rental status changes for corporate
units. Units can shift from rented to not rented. New units can be added based on contracts
signed, and existing units can be removed due to contract modifications or renovation requirements.
So for this recipe, I’ll create a staging table that will receive the current snapshot of corporate
housing units from the external data source. I’ll also populate it with the most current information:
*/

CREATE TABLE dbo.StagingCorporateHousing (
	UnitNBR int NOT NULL, 
	IsRentedIND bit NOT NULL)
GO
INSERT dbo.StagingCorporateHousing (UnitNBR, IsRentedIND)
VALUES -- UnitNBR "1" no longer exists
	(24, 0), -- UnitNBR 24 has a changed rental status
	(39, 1), -- UnitNBR 39 is the same
	(54, 0), -- UnitNBR 54 has a change status
	(92, 1) -- UnitNBR 92 is a new unit, and isn't in production yet

/* 
Now my objective is to modify the target production table so that it reflects the most current
data from our data source. If a new unit exists in the staging table, I want to add it. If a unit number
exists in the production table but not the staging table, I want to delete the row. If a unit number
exists in both the staging and production tables, but the rented status is different, I want to update
the production (target) table to reflect the changes.

I’ll start by looking at the values of production before the modification:
*/

-- Before the MERGE
SELECT CorporateHousingID, UnitNBR, IsRentedIND
FROM HumanResources.CorporateHousing

/* This returns
--------------------------------------------------------
CorporateHousingID UnitNBR IsRentedIND
1					1		0
2					24		1
3					39		0
4					54		1
--------------------------------------------------------

--  Next, I’ll modify the production table per my business requirements:

MERGE INTO HumanResources.CorporateHousing p
	USING dbo.StagingCorporateHousing s ON p.UnitNBR = s.UnitNBR

WHEN MATCHED AND s.IsRentedIND <> p.IsRentedIND 
	THEN UPDATE SET IsRentedIND = s.IsRentedIND 
WHEN NOT MATCHED BY TARGET 
	THEN INSERT (UnitNBR, IsRentedIND) VALUES (s.UnitNBR, s.IsRentedIND)
WHEN NOT MATCHED BY SOURCE 
	THEN DELETE;

This returns
(5 row(s) affected)


Next, I’ll check the “after” results of the production table:

-- After the MERGE
*/
SELECT CorporateHousingID, UnitNBR, IsRentedIND
FROM HumanResources.CorporateHousing

/*
This returns
CorporateHousingID UnitNBR IsRentedIND
2					24 0
3					39 1
4					54 0
5					92 1
*/