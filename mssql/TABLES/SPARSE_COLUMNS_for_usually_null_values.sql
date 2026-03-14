/* 
To define a sparse column, you need only add the SPARSE storage attribute after the column
definition within a CREATE or ALTER TABLE command, as the following query demonstrates:
*/

CREATE TABLE dbo.WebsiteProduct(
	WebsiteProductID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	ProductNM varchar(255) NOT NULL,
	PublisherNM varchar(255) SPARSE NULL,
	ArtistNM varchar(150) SPARSE NULL,
	ISBNNBR varchar(30) SPARSE NULL,
	DiscsNBR int SPARSE NULL,
	MusicLabelNM varchar(255) SPARSE NULL
)
GO

-- Continuing the demonstration, I’ll insert two new rows into the table (one representing a book and one amusic album):

INSERT dbo.WebsiteProduct (ProductNM, PublisherNM, ISBNNBR)
VALUES ('SQL Server 2008 Transact-SQL Recipes', 'Apress', '1590599802')

INSERT dbo.WebsiteProduct (ProductNM, ArtistNM, DiscsNBR, MusicLabelNM)
VALUES ('Etiquette', 'Casiotone for the Painfully Alone', 1, 'Tomlab')

-- Sparse columns can be queried using a couple ofmethods. The following is an example of using a standardmethod of querying:

SELECT ProductNM, PublisherNM, ISBNNBR
FROM dbo.WebsiteProduct
WHERE ISBNNBR IS NOT NULL

/* This returns
-------------------------------------------------------
ProductNM PublisherNM ISBNNBR
-------------------------------------------------------
SQL Server 2008 Transact-SQL Recipes Apress 1590599802
-------------------------------------------------------
*/
-- SELECT *  will only query for the non-sparse columns ; need to indicate column name 


/*
The secondmethod is to use a column set. A column set allows you to logically group all sparse
columns defined for the table. This xml data type calculated column allows for SELECTs and data
modification and is defined by designating COLUMN_SET FOR ALL_SPARSE_COLUMNS after the column
definition. You can only have one column set for a single table, and you also can’t add one to a table
that already has sparse columns defined in it. In this next example, I’ll re-create the previous table
with a column set included:
*/

DROP TABLE dbo.WebsiteProduct

CREATE TABLE dbo.WebsiteProduct
(WebsiteProductID int NOT NULL PRIMARY KEY IDENTITY(1,1),
ProductNM varchar(255) NOT NULL,
PublisherNM varchar(255) SPARSE NULL,
ArtistNM varchar(150) SPARSE NULL,
ISBNNBR varchar(30) SPARSE NULL,
DiscsNBR int SPARSE NULL,
MusicLabelNM varchar(255) SPARSE NULL,
ProductAttributeCS xml COLUMN_SET FOR ALL_SPARSE_COLUMNS)

-- Re-insert data
INSERT dbo.WebsiteProduct (ProductNM, PublisherNM, ISBNNBR)
VALUES ('SQL Server 2008 Transact-SQL Recipes', 'Apress', '1590599802')

INSERT dbo.WebsiteProduct(ProductNM, ArtistNM, DiscsNBR, MusicLabelNM)
VALUES('Etiquette','Casiotone for the Painfully Alone',1,'Tomlab')

-- Now that the column set is defined, I can reference it instead of the individual sparse columns:

SELECT ProductNM, ProductAttributeCS
FROM dbo.WebsiteProduct
WHERE ProductNM IS NOT NULL

/*
This returns
-------------------------------------------------------
ProductNM								ProductAttributeCS
-------------------------------------------------------
SQL Server 2008 Transact-SQL Recipes	<PublisherNM>Apress</PublisherNM><ISBNNBR>
										1590599802</ISBNNBR>
Etiquette								<ArtistNM>Casiotone for the Painfully Alone
										</ArtistNM><DiscsNBR>1</DiscsNBR>< MusicLabelNM>
										Tomlab</ MusicLabelNM>
-------------------------------------------------------
*/