USE AdventureWorks2008
GO 

-- determine conference room based on department 
SELECT DepartmenID, 
		Name,
		CASE GroupName 
			WHEN 'Reasearch and Development' THEN 'Room A'
			WHEN 'Sales and Marketing' THEN 'Room B'
			WHEN 'Manufacturing' THEN 'Room C'
			ELSE 'Room D'
		END ConferenceRoom
FROM HumanResource.Department 
