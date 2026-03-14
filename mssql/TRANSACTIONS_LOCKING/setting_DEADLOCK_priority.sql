/*
Table 3-9. SET DEADLOCK_PRIORITY Command Arguments

Argument Description
---------------------------------------------------------------------------------
LOW				LOWmakes the current connection the likely deadlock victim.
NORMAL			NORMAL lets SQL Server decide based on which connection seems least
				expensive to roll back.
HIGH			HIGH lessens the chances of the connection being chosen as the victim,
				unless the other connection is also HIGH or has a numeric priority greater
				than 5.
<numeric-priority> The numeric priority allows you to use a range of values from-10 to 10,
					where -10 is themost likely deadlock victim, up to 10 being the least likely
					to be chosen as a victim. The higher number between two participants in a
					deadlock wins.
---------------------------------------------------------------------------------


For example, had the first query fromthe previous recipe used the following deadlock priority
command, it would almost certainly have been chosen as the victim(normally, the default deadlock
victimis the connection SQL Server deems least expensive to cancel and roll back):
*/


SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET DEADLOCK_PRIORITY LOW

BEGIN TRAN 

	UPDATE Purchasing.Vendor
	SET CreditRating = 1
	WHERE BusinessEntityID = 2
	UPDATE Purchasing.Vendor
	SET CreditRating = 2
	WHERE BusinessEntityID = 1
COMMIT TRAN

/* 
How It Works
You can also set the deadlock priority to HIGH and NORMAL. HIGHmeans that unless the other session
is of the same priority, it will not be chosen as the victim. NORMAL is the default behavior and will be
chosen if the other session is HIGH, but not chosen if the other session is LOW. If both sessions have
the same priority, the least expensive transaction to roll back will be chosen.

*/a