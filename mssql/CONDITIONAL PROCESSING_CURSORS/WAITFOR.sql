

/*In this recipe, I demonstrate the WAITFOR command, which delays the execution of Transact-SQL
code for a specified length of time.


In this first example, a 10-second delay is created by WAITFOR before a SELECT query is executed:
*/

WAITFOR DELAY '00:00:10'
BEGIN
SELECT TransactionID, Quantity
FROM Production.TransactionHistory
END



--In this second example, a query is not executed until a specific time, in this case 7:01 p.m.:

WAITFOR TIME '19:01:00'
BEGIN
SELECT COUNT(*)
FROM Production.TransactionHistory
END