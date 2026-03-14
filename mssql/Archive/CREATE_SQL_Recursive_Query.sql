--Listing 10-5. A Recursive CTE


/*

To write the recursive CTE, you must have an anchor member, which is a statement that
returns the top of your intended results. This is like the root of the directory. Following the anchor
member, you will write the recursive member. The recursive member actually joins the CTE that
contains it to the same table used in the anchor member. The results of the anchor member and the
recursive member join in a UNION ALL query. Type in and execute the code in Listing 10-5 to see how
this works.

*/


USE AdventureWorks;
GO
WITH OrgChart (EmployeeID, ManagerID, Title, Level,Node)
AS (SELECT EmployeeID, ManagerID, Title, 0,
CONVERT(VARCHAR(30),'/') AS Node
FROM HumanResources.Employee
WHERE ManagerID IS NULL
UNION ALL
SELECT a.EmployeeID, a.ManagerID,a.Title, b.Level + 1,
CONVERT(VARCHAR(30),b.Node +
CONVERT(VARCHAR,a.ManagerID) + '/')
FROM HumanResources.Employee AS a
INNER JOIN OrgChart AS b ON a.ManagerID = b.EmployeeID
)
SELECT EmployeeID, ManagerID, SPACE(Level * 3) + Title AS Title, Level, Node
FROM OrgChart
ORDER BY Node;

/*
Figure 10-5 shows the results. The anchor member selects the EmployeeID, ManagerID, and Title
from the HumanResources.Employee table for the CEO. The CEO is the only employee with a NULL
ManagerID. The level is zero. The node column, added to help sorting, is just a slash. To get this to work,
the query uses the CONVERT function to change the data type of the slash to a VARCHAR(30) because the
data types in the columns of the anchor member and recursive member must match exactly. The
recursive member joins HumanResources.Employee to the CTE, OrgChart. The query is recursive because
the CTE is used inside its own definition. The regular columns in the recursive member come from the
table, and the level is one plus the value of the level returned from the CTE. To sort in a meaningful way,
the node shows the ManagerID values used to get to the current employee surrounded with slashes. This
looks very similar to the node used in the HierarchyID example in Chapter 9. 

The query runs the recursive member repeatedly until all possible paths are selected, that is,
until the recursive member no longer returns results. In case of an incorrectly written recursive query
that will run forever, the recursive member will run only 100 times by default unless you specify the
MAXRECURSION option to limit how many times the query will run. To alter the query in Listing 10-5 to a
potential unending loop, change a.ManagerID = b.EmployeeID to a.EmployeeID = b.EmployeeID.
Just because the default MAXRECURSION value is 100 doesn’t mean that a recursive query will
return only 100 rows. In this example, the anchor returns the CEO, EmployeeID 109. The first time the
recursive member runs, the results include all employees who report to 109. The next call returns the
employees reporting to the employees returned in the last call, and so on. The values from one call feed
the next call.
Instead of filtering the anchor to find the CEO, you can supply any ManagerID value. If you
specify a particular manager, instead of starting at the CEO, the results will start at the subordinates of
the ManagerID supplied. On your own, change the criteria in the anchor member, and rerun the query to
see what happens.
Writing recursive queries is an advanced skill you may or may not need right away. Luckily, if
you do need to write a recursive query, you will know where to find a simple example.

*/