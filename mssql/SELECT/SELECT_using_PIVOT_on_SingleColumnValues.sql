USE AdventureWorks2008
GO 
/*
Using PIVOT to Convert Single Column Values into Multiple Columns and Aggregate Data

The PIVOT operator allows you to create cross-tab queries that convert values into columns, using
an aggregation to group the data by the new columns. PIVOT uses the following syntax:

	FROM table_source
	PIVOT ( aggregate_function ( value_column )
	FOR pivot_column
	IN ( <column_list>)
	) table_alias

------------------------------------------------------------------------------------------------
Argument Description
------------------------------------------------------------------------------------------------
table_source							The table where the data will be pivoted
aggregate_function ( value_column )		The aggregate function that will be used against the specified column
pivot_column							The column that will be used to create the column headers
column_list								The values to pivot from the pivot column
table_alias								The table alias of the pivoted result set
------------------------------------------------------------------------------------------------

This next example shows you how to PIVOT and aggregate data similar to the pivot features in
Microsoft Excel—shifting values in a single column into multiple columns, with aggregated data
shown in the results. The first part of the example displays the data prepivoted. The query results show employee
shifts, as well as the departments that they are in:
*/

SELECT s.Name ShiftName,
		h.BusinessEntityID,
		d.Name DepartmentName
FROM HumanResources.EmployeeDepartmentHistory h
	INNER JOIN HumanResources.Department d ON h.DepartmentID = d.DepartmentID
	INNER JOIN HumanResources.Shift s ON h.ShiftID = s.ShiftID
WHERE EndDate IS NULL AND d.Name IN ('Production', 'Engineering', 'Marketing')
ORDER BY ShiftName

/*
Notice that the varying departments are all listed in a single column:
------------------------------------------------------------------------------------
ShiftName	BusinessEntityID DepartmentName
Day			3				Engineering
Day			9				Engineering
...
Day			2				Marketing
Day			6				Marketing
...
Evening		25				Production
Evening		18				Production
Night		14				Production
Night		27				Production
...
Night 252 Production
(194 row(s) affected)
------------------------------------------------------------------------------------
*/

-- The next query pivots the department values into columns, along with a count of employees by shift:

SELECT	ShiftName,
		Production,
		Engineering,
		Marketing
FROM  (
	SELECT	s.Name ShiftName,
			h.BusinessEntityID,
			d.Name DepartmentName
	FROM HumanResources.EmployeeDepartmentHistory h 
		INNER JOIN HumanResources.Department d ON h.DepartmentID = d.DepartmentID
		INNER JOIN HumanResources.Shift s ON h.ShiftID = s.ShiftID
	WHERE EndDate IS NULL AND d.Name IN ('Production', 'Engineering', 'Marketing') 	
	) AS a 
		PIVOT (COUNT(BusinessEntityID) FOR DepartmentName IN ([Production], [Engineering], [Marketing])
		) AS b
ORDER BY ShiftName

/*
How It Works

The result of the PIVOT query returned employee counts by shift and department. The query began
by naming the fields to return:

	SELECT ShiftName,
	Production,
	Engineering,
	Marketing

Notice that these fields were actually the converted rows, but turned into column names.
The FROM clause referenced the subquery (the query used at the beginning of this example). The
subquery was aliased with an arbitrary name of a:

	FROM
	(SELECT s.Name ShiftName,
	h. BusinessEntityID,
	d.Name DepartmentName
	FROM HumanResources.EmployeeDepartmentHistory h
	INNER JOIN HumanResources.Department d ON
	h.DepartmentID = d.DepartmentID
	INNER JOIN HumanResources.Shift s ON
	h.ShiftID = s.ShiftID
	WHERE EndDate IS NULL AND
	d.Name IN ('Production', 'Engineering', 'Marketing')) AS a

Inside the parentheses, the query designated which columns would be aggregated (and how).
In this case, the number of employees would be counted:

	PIVOT
	(COUNT(BusinessEntityID)

After the aggregation section, the FOR statement determined which row values would be converted
into columns. Unlike regular IN clauses, single quotes aren’t used around each string
character, instead using square brackets. DepartmentName was the data column where values are
converted into pivoted columns:
FOR DepartmentName IN ([Production], [Engineering], [Marketing]))

------------------------------------------------------------------------------------
Note The list of pivoted column names cannot already exist in the base table or view query columns being
pivoted.
------------------------------------------------------------------------------------
Lastly, a closed parenthesis closed off the PIVOT operation. The PIVOT operation was then
aliased like a table with an arbitrary name (in this case b):

AS b

The results were then ordered by ShiftName:

ORDER BY ShiftName

The results took the three columns fixed in the FOR part of the PIVOT operation and aggregated
counts of employees by ShiftName.

*/