USE AdventureWorks2008
GO


-- add column first 
ALTER TABLE HumanResources.TerminationReason 
ADD ViolationSeverityLevel smallint 

-- define index column sort direction 
CREATE NONCLUSTERED INDEX NI_TerminationReason_ViolationSeverityLevel
ON	HumanResources.TerminationReason(ViolationSeverityLevel DESC)
