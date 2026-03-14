USE SwapMap 
GO 

-- SIMPLE TABLE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Location]') AND type in (N'U'))
DROP TABLE [dbo].[Location]
GO
CREATE TABLE [dbo].[Location]
(
	LocationID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserID INT NOT NULL FOREIGN KEY REFERENCES [Item](ItemID),
	StreetAddress1 VARCHAR(500) NOT NULL,
	StreetAddress2 VARCHAR(500) NULL,
	City VARCHAR(200) NOT NULL,
	[State] CHAR(2) NOT NULL,
	ZIPCode VARCHAR(20) NOT NULL,
	Latitude FLOAT NOT NULL,
	Longitude FLOAT NOT NULL,
	Active BIT NOT NULL DEFAULT(1),
	CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreatedBy VARCHAR(200) DEFAULT('SYSTEM'),
	ModifiedDate DATETIME NOT NULL DEFAULT(GETDATE()),
	ModifiedBy VARCHAR(200) DEFAULT('SYSTEM')
);

-- lkup_Status TABLE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_Status]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_Status]
GO
CREATE TABLE [dbo].[lkup_Status]
(
	lkup_StatusID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	[Description] VARCHAR(200) NOT NULL,
	Active BIT NOT NULL DEFAULT(1),
)






