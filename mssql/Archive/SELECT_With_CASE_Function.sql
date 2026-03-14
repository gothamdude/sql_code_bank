USE AdventureWorks2008
GO 

-- simple CASE expression 
-- CASE <test expression>
--		WHEN  <comparison expression> THEN <return value>
--		WHEN  <comparison expression> THEN <return value>
--		[ELSE <value3>] END 
SELECT  BusinessEntityID, 
		LoginID,
		CASE MaritalStatus 
			WHEN 'S' THEN 'Single'
			WHEN 'M' THEN 'Married'
		END AS [Status], 
		CASE 
			WHEN CHARINDEX('Manager',JobTitle)  > 0 THEN 'IsManager'
			WHEN CHARINDEX('Engineer',JobTitle) > 0  THEN 'IsEngineer'
			ELSE 'IsNeither' 
		END 
FROM HumanResources.Employee
WHERE HireDate BETWEEN '01/01/1999' AND GETDATE()
	
	
-- complicated CASE expression ; SEARCHED CASE syntax 
-- CASE WHEN<test expression1> THEN <value1>
--	    WHEN<test expression2> THEN <value2>
--	    [ELSE <value3>] END
SELECT  Title, 
		FirstName + ' ' + LastName AS FullName,
		CASE WHEN Title IN ('Ms',' Mrs.','Miss') THEN 'Female'
			 WHEN Title ='Mr.' THEN 'Male' 
			 ELSE 'Unknown' END  AS GENDER 
FROM Person.Person
WHERE BusinessEntityID <100


