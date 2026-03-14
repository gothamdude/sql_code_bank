Use AW_Extract
GO 

CREATE TABLE #tblSampleItems (RowID INT, FirstName VARCHAR(20), LastName VARCHAR(20), Age INT)

Bulk Insert #tblSampleItems 
FROM 'C:\SampleItems.txt'
WITH (
	FieldTerminator ='	', ROWTERMINATOR = '\n'
	)

SELECT * FROM #tblSampleItems 

DROP TABLE #tblSampleItems 

