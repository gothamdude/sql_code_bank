USE AdventureWorks2008
GO 

-- determine conference room based on department 
SELECT DepartmenID, 
		Name,
		CASE 
			WHEN Name = 'Reasearch and Development' THEN 'Room A'
			WHEN (Name = 'Sales and Marketing'  OR DepartmentID = 10) THEN 'Room B'
			WHEN Name LIKE 'T%' THEN 'Room C'
			ELSE 'Room D'
		END ConferenceRoom
FROM HumanResource.Department 
