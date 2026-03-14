USE AdventureWorks2008
GO


-- COMPOSITE INDEX (i.e. multi-column) 

CREATE NONCLUSTERED INDEX NI_TerminationReason_TerminationReason_DepartmentID
ON HumanResources.TerminationReason(TerminationReason,DepartmentID)


