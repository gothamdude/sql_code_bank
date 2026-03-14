USE AdventureWorks2008
GO 

SELECT FirstName, LastName
FROM Person.Person TableSample System (2 percent) 

/*
How It Works

TABLESAMPLE works by extracting a sample of rows from the query result set. In this example, 2 percent
of rows were sampled from the Person.Person table. However, don’t let the “percent” fool you.
That percentage is the percentage of the table’s data pages. Once the sample pages are selected, all
rows for the selected pages are returned. Since the fill state of pages can vary, the number of rows
returned will also vary—you’ll notice that the first time the query is executed in this example there
were 232 rows, and the second time there were 198 rows. If you designate the number of rows, this is
actually converted by SQL Server into a percentage, and then the same method used by SQL Server
to identify the percentage of data pages is used.
*/