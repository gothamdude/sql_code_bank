IF object_id('tempdb..#MyTempTable') IS NOT NULL
BEGIN
   DROP TABLE #MyTempTable
END

CREATE TABLE #MyTempTable
(
   ID int IDENTITY(1,1),
   SomeValue varchar(100)
)
GO

