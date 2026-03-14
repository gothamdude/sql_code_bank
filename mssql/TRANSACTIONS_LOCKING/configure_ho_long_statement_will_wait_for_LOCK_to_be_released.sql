/* 
Configuring How Long a StatementWillWait for a Lock to Be Released

When a transaction or statement is being blocked, thismeans it is waiting for a lock on a resource to
be released. This recipe demonstrates the SET LOCK_TIMEOUT option, which specifies how long the
blocked statement should wait for a lock to be released before returning an error.

*/

--SET LOCK_TIMEOUT timeout_period 

-- The timeout period is the number ofmilliseconds before a locking error will be returned. In
-- order to set up this recipe’s demonstration, I will execute the following batch:

BEGIN TRAN
UPDATE Production.ProductInventory
SET Quantity = 400
WHERE ProductID = 1 AND
LocationID = 1

-- In a second query window, this example demonstrates setting up a lock timeout period of one
-- second (1000milliseconds):

SET LOCK_TIMEOUT 1000

UPDATE Production.ProductInventory
SET Quantity = 406
WHERE ProductID = 1 AND
LocationID = 1

-- After one second (1000milliseconds), I receive the following errormessage:
---------------------------------------------------------------------------------
Msg 1222, Level 16, State 51, Line 3
Lock request time out period exceeded.
The statement has been terminated.

---------------------------------------------------------------------------------