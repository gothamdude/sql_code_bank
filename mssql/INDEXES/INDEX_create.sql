USE AdventureWorks2008
GO

CREATE TABLE HumanResources.TerminationReason(
	TerminationReasonID smallint IDENTITY(1,1) NOT NULL,
	TerminationReason varchar(50) NOT NULL,
	DepartmentID smallint NOT NULL,
	CONSTRAINT FK_TerminationReason_DepartmentID FOREIGN KEY (DepartmentID) REFERENCES HumanResources.Department(DepartmentID)
)
GO

-- ADD PRIMARY KEY CONSTRAINT  -- which automatically adds CLUSTERED INDEX 
ALTER TABLE HumanResources.TerminationReason
ADD CONSTRAINT PK_TerminationReason PRIMARY KEY CLUSTERED (TerminationReasonID) 


-- ADD NONCLUSTERED INDEX 
CREATE NONCLUSTERED INDEX NCI_TerminationReason_DepartmentID 
ON HumanResources.TerminationReason(DepartmentID)
