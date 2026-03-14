/*
In this example, the new Company table will define the companies in a hypothetical giant mega conglomerate.
Each company has a CompanyID and an optional ParentCompanyID. The example will
demonstrate how to display the company hierarchy in the results using a recursive CTE. 
First, the table is created:
*/

CREATE TABLE dbo.Company(
	CompanyID int NOT NULL PRIMARY KEY,
	ParentCompanyID int NULL,
	CompanyName varchar(25) NOT NULL
	)

-- Next, rows are inserted into the new table (using new SQL Server 2008 syntax that I’ll be demonstrating in Chapter 2):

INSERT dbo.Company (CompanyID, ParentCompanyID, CompanyName)
VALUES (1, NULL, 'Mega-Corp'),
		(2, 1, 'Mediamus-Corp'),
		(3, 1, 'KindaBigus-Corp'),
		(4, 3, 'GettinSmaller-Corp'),
		(5, 4, 'Smallest-Corp'),
		(6, 5, 'Puny-Corp'),
		(7, 5, 'Small2-Corp')

-- Now the actual example:

WITH CompanyTree(ParentCompanyID, CompanyID, CompanyName, CompanyLevel)
AS ( SELECT ParentCompanyID,
			CompanyID,
			CompanyName,
			0 AS CompanyLevel
	 FROM dbo.Company
	 WHERE ParentCompanyID IS NULL
	 UNION ALL
	 SELECT c.ParentCompanyID,
			c.CompanyID,
			c.CompanyName,
			p.CompanyLevel + 1
	 FROM dbo.Company c 
		INNER JOIN CompanyTree p ON c.ParentCompanyID = p.CompanyID
	)
SELECT ParentCompanyID, CompanyID, CompanyName, CompanyLevel
FROM CompanyTree




/* IMPORTANT NOTE BELOW: how to limit recursion

In the results, for each level in the company hierarchy, the CTE increased the CompanyLevel
column. With this useful new feature come some cautions, however. If you create your recursive CTE
incorrectly, you could cause an infinite loop. While testing, to avoid infinite loops, use the
MAXRECURSION hint mentioned earlier in the chapter.

For example, you can stop the previous example from going further than two levels by adding
the OPTION clause with MAXRECURSION at the end of the query:
*/

WITH CompanyTree(ParentCompanyID, CompanyID, CompanyName, CompanyLevel) AS
(
	SELECT ParentCompanyID, CompanyID, CompanyName, 0 AS CompanyLevel
	FROM dbo.Company
	WHERE ParentCompanyID IS NULL
	UNION ALL
	SELECT c.ParentCompanyID, c.CompanyID, c.CompanyName, p.CompanyLevel + 1
	FROM dbo.Company c INNER JOIN CompanyTree p ON c.ParentCompanyID = p.CompanyID
)
SELECT ParentCompanyID, CompanyID, CompanyName, CompanyLevel
FROM CompanyTree
OPTION (MAXRECURSION 2)

