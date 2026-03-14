USE AdventureWorks2008
GO 


SELECT s.Name, 
	COUNT(w.WorkOrderID) Cnt
FROM Production.ScrapReason s 
	INNER JOIN Production.WorkOrder w ON s.ScrapReasonID = w.ScrapReasonID
GROUP BY  s.Name 
HAVING COUNT(*) > 50 