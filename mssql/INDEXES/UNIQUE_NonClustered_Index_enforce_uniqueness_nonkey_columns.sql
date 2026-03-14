USE AdventureWorks2008
GO

--enforce uniqueness in a non-key column by creating a unique index 
CREATE UNIQUE NONCLUSTERED INDEX UNI_TerminationReason 
ON HumanResources.TerminationReason(TerminationReason)


-- now the third of these inserts will fail since it is not unique 
INSERT HumanResources.TerminationReason (DepartmentID, TerminationReason)
VALUES(1, 'Bad Engineering Skills')

INSERT HumanResources.TerminationReason (DepartmentID, TerminationReason)
VALUES(2, 'Breaks Expensive Tools')

-- if i attempt this 
INSERT HumanResources.TerminationReason (DepartmentID, TerminationReason)
VALUES(2, 'Breaks Expensive Tools')

/* 
I GET THIS ERROR:

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Msg 2601, Level 14, State 1, Line 1
Cannot insert duplicate key row in object 'HumanResources.TerminationReason' with unique index 'UNI_TerminationReason'. The duplicate key value is (Breaks Expensive Tools).
The statement has been terminated.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------