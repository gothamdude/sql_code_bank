-- Listing 9-1: Ensuring that READ COMMITTED SNAPSHOT is off for our database
-- replace OurDatabaseName
-- with the name of the database
-- where you are running the examples
ALTER DATABASE OurDatabaseName 
SET READ_COMMITTED_SNAPSHOT OFF ;

-- Listing 9-2: Creating the AccountBalances table
CREATE TABLE dbo.AccountBalances
    (
      AccountNumber INT NOT NULL
                CONSTRAINT PK_AccountBalances PRIMARY KEY ,
      Amount DECIMAL(10, 2) NOT NULL ,
      CustomerID INT NOT NULL ,
-- I want the table to be quite wide,
-- so that scanning it takes considerable time,
-- this is why I have added a filler column
      SpaceFiller CHAR(100) NOT NULL
    ) ;	

-- Listing 9.3: Adding test data
INSERT INTO dbo.AccountBalances
        ( AccountNumber ,
          Amount ,
          CustomerID ,
          SpaceFiller
        )
VALUES  ( 101 ,
          20 , 
          1 , 
          'some information'  
        ) ;
        
INSERT INTO dbo.AccountBalances
        ( AccountNumber ,
          Amount ,
          CustomerID ,
          SpaceFiller
        )
VALUES  ( 105 , 
          20 , 
          2 , 
          'some information'
        ) ;        

-- Listing 9.4: Tab #1, start a transaction and select some data
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
BEGIN TRANSACTION ;
SELECT  AccountNumber ,
        Amount
FROM    dbo.AccountBalances 
WHERE AccountNumber BETWEEN 101 AND 105 ;
-- COMMIT ;

-- Listing 9-5: Tab #2, begin a transaction and modify the same data as queried in tab #1
BEGIN TRANSACTION ;

-- Update account 101
UPDATE  dbo.AccountBalances
SET     Amount = Amount + 10
WHERE   AccountNumber = 101 ;

-- Delete account 105 (belonging to Customer with ID=2)
DELETE  dbo.AccountBalances
WHERE   AccountNumber = 105 ;

-- Create a new account for Customer with ID=2
INSERT  INTO dbo.AccountBalances
        ( AccountNumber ,
          Amount ,
          CustomerID ,
          SpaceFiller
        )
VALUES  ( 103 ,
          25 ,
          2 ,
          'some information'
        ) ;        

-- COMMIT ;      
-- ROLLBACK ;  

-- Listing 9-7: Deleting the modified test data
DELETE FROM dbo.AccountBalances ;

-- Listing 9-8: Start a query under REPEATABLE READ isolation level
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
BEGIN TRANSACTION ;
SELECT  AccountNumber ,
        Amount
FROM    dbo.AccountBalances 
WHERE AccountNumber BETWEEN 101 AND 105 ;

-- COMMIT ;      

-- Listing 9-9: Adding a new account
INSERT INTO dbo.AccountBalances
        ( AccountNumber ,
          Amount ,
          CustomerID ,
          SpaceFiller
        )
VALUES  ( 103 , -- AccountNumber - int
          25 , -- Amount - decimal
          2 , -- CustomerID - int
          'some information'  -- SpaceFiller - char(100)
        ) ;        

-- Listing 9-11: A query with SERIALIZABLE isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ;
BEGIN TRANSACTION ;
SELECT  AccountNumber ,
        Amount
FROM    dbo.AccountBalances 
WHERE AccountNumber BETWEEN 101 AND 105 ;

-- COMMIT ;      

-- Listing 9-12: Populating the AccountBalances table with test data; depending on the server, this script may run for several minutes
-- the TRUNCATE statement is there because 
-- we will rerun the script multiple times
TRUNCATE TABLE dbo.AccountBalances ;
GO
DECLARE @i INT ;
-- make sure to turn NOCOUNT on 
-- otherwise you will get a huge output
SET NOCOUNT ON ;
SET @i = 100000 ;
WHILE @i < 300000 
    BEGIN ;
        INSERT  dbo.AccountBalances
                ( AccountNumber ,
                  Amount ,
                  CustomerID ,
                  SpaceFiller
                )
        VALUES  ( @i * 10 ,
                  1000 ,
                  @i ,
                  'qwerty'
                ) ;
        SET @i = @i + 1 ;
    END ;
GO

-- Listing 9-13: A simple query to calculate the total amount in all accounts
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
SELECT  SUM(Amount) AS TotalAmount
FROM    dbo.AccountBalances ;

-- Listing 9-14: A transaction that transfers $10 from one account to another 
DECLARE @rc INT ,
    @succeeded INT ;
BEGIN TRAN ;
SET @succeeded = 0 ;
UPDATE  dbo.AccountBalances
SET     Amount = Amount - 10
WHERE   AccountNumber = 1234560
        AND Amount > 10 ;
SELECT  @rc = @@ROWCOUNT ;
IF @rc = 1 
    BEGIN;
        UPDATE  dbo.AccountBalances
        SET     Amount = Amount + 10
        WHERE   AccountNumber = 2345670 ; 
        SELECT  @rc = @@ROWCOUNT ;
        SET @succeeded = CASE WHEN @rc = 1 THEN 1
                              ELSE 0
                         END ;
    END ;
IF @succeeded = 1 
    BEGIN ;
        COMMIT ;
    END ;
ELSE 
    BEGIN ;
        ROLLBACK ;
    END ;

-- Listing 9-15: The script to transfer money between randomly chosen accounts in a loop
DECLARE @i INT ,
  @rc INT ,
  @AccountNumber INT ,
  @AnotherAccountNumber INT ,
  @succeeded INT ;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
SET NOCOUNT ON ;
SET @i = 0 ;
WHILE  @i < 100000  
  BEGIN ;
  -- currently all account numbers end with zeros
    SET @AccountNumber = 100000 + RAND() * 200000 ;
    SET @AnotherAccountNumber = 100000 + RAND()*200000 ;
   -- so I calculate account numbers in two simple steps
    SET @AccountNumber = @AccountNumber * 10 ;
    SET @AnotherAccountNumber=@AnotherAccountNumber*10 ;
    IF @AccountNumber <> @AnotherAccountNumber 
      BEGIN ;
        SET @succeeded = 0 ;
        BEGIN TRAN ;
        UPDATE  dbo.AccountBalances
        SET   Amount = Amount - 10
        WHERE   AccountNumber = @AccountNumber
                                   AND Amount > 10 ;
        SET @rc = @@ROWCOUNT ;
        IF @rc = 1 
          BEGIN ;
            UPDATE  dbo.AccountBalances
            SET   Amount = Amount + 10
            WHERE AccountNumber =@AnotherAccountNumber ;
            SET @rc = @@ROWCOUNT ;
            SET @succeeded = CASE WHEN @rc = 1
                          THEN 1
                        ELSE 0
                     END ;
          END ;
        IF @succeeded = 1 
          BEGIN ; 
            COMMIT ;
          END ;
        ELSE 
          BEGIN ;
            ROLLBACK ;
          END ;
      END ;
    SET @i = @i + 1 ;
  END ;

-- Listing 9-16: Selecting the total amount in a loop, under READ COMMITTED isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
-- SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ;

SET NOCOUNT ON ;
DECLARE @i INT ;
SET @i = 0 ;
DECLARE @totals TABLE ( total DECIMAL(17, 2) ) ;
WHILE  @i < 50
    BEGIN ;
        INSERT  INTO @totals
                ( total
                )
                SELECT  SUM(Amount)
                FROM    dbo.AccountBalances ;
        SET @i = @i + 1 ;
    END ;
SELECT  COUNT(*) AS [Count] ,
        total
FROM    @totals
GROUP BY total ; 

-- Listing 9-18: A script to transfer money in $10 increments from randomly chosen accounts into new accounts, in a loop
DECLARE @i INT ,
  @rc INT ,
  @AccountNumber INT ,
  @AnotherAccountNumber INT ,
  @succeeded INT ;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
SET NOCOUNT ON ;
SET @i = 0 ;
WHILE ( @i < 10000 ) 
  BEGIN ;
  -- currently all account numbers end with zeros
    SET @AccountNumber = 100000 + RAND() * 200000 ;
    SET @AnotherAccountNumber = 100000 + RAND()*200000 ;
  -- so I calculate account numbers in two simple steps
    SET @AccountNumber = @AccountNumber * 10 ;
    SET @AnotherAccountNumber =@AnotherAccountNumber*10;
    IF @AccountNumber <> @AnotherAccountNumber 
      BEGIN ;
        SET @succeeded = 0 ;
        BEGIN TRAN ;
        UPDATE  dbo.AccountBalances
        SET   Amount = Amount - 10
        WHERE   AccountNumber = @AccountNumber
            AND Amount > 10 ;
        SELECT  @rc = @@ROWCOUNT ;
        IF @rc = 1 
          BEGIN ;
            INSERT  dbo.AccountBalances
                ( AccountNumber ,
                  Amount ,
                  CustomerID ,
                  SpaceFiller
                )
                SELECT  @AnotherAccountNumber - 5 ,
                    10 ,
                    @i ,
                    'qwerty'
                WHERE   NOT EXISTS ( SELECT 1
                           FROM   dbo.AccountBalances
                           WHERE  AccountNumber = 
                                   @AnotherAccountNumber
                              - 5 ) ;
            SET @rc = @@ROWCOUNT ;
            SET @succeeded = CASE WHEN @rc = 1 THEN 1
                        ELSE 0
                     END ;
          END ;
        IF @succeeded = 1 
          BEGIN ; 
            COMMIT ;
          END ;
        ELSE 
          BEGIN ;
            ROLLBACK ;
          END ;
      END ;
    SET @i = @i + 1 ;
  END ;

-- Listing 9-20: Enabling snapshot isolation in the test database
-- replace OurDatabase
-- with the name of the database
-- in which you are running the examples

ALTER DATABASE OurDatabase
    SET ALLOW_SNAPSHOT_ISOLATION ON ;

-- Listing 9-21: Create the Packages and PackageItems tables
CREATE TABLE dbo.Packages
    (
      PackageLabel VARCHAR(30) NOT NULL ,
      LengthInInches DECIMAL(7, 2) NOT NULL ,
      WidthInInches DECIMAL(7, 2) NOT NULL ,
      HeightInInches DECIMAL(7, 2) NOT NULL ,
      CONSTRAINT PK_Packages PRIMARY KEY (PackageLabel )
    ) ;
GO

CREATE TABLE dbo.PackageItems
    (
      ItemLabel VARCHAR(30) NOT NULL ,
      PackageLabel VARCHAR(30) NOT NULL ,
      MaxSizeInInches DECIMAL(7, 2) NOT NULL ,
      CONSTRAINT PK_PackageItems PRIMARY KEY (ItemLabel ) ,
      CONSTRAINT FK_PackageItems_Packages 
          FOREIGN KEY ( PackageLabel ) 
          REFERENCES dbo.Packages (PackageLabel )
    ) ;  

-- Listing 9-22: Populate Packages and PackageItems tables with test data

INSERT  INTO dbo.Packages
        ( PackageLabel ,
          LengthInInches ,
          WidthInInches ,
          HeightInInches   
        )
VALUES  ( 'Gifts for in-laws' ,
          5 ,
          5 ,
          2
        ) ;
GO

INSERT  INTO dbo.PackageItems
        ( PackageLabel ,
          ItemLabel ,
          MaxSizeInInches
        )
VALUES  ( 'Gifts for in-laws' ,
          'Box of chocolates' ,
          5
        ) ;

-- Listing 9-23: A query that selects data from the Packages table
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;

BEGIN TRANSACTION ;

SELECT  PackageLabel ,
        LengthInInches ,
        WidthInInches ,
        HeightInInches
FROM    dbo.Packages
WHERE   PackageLabel = 'Gifts for in-laws' ;  

-- Listing 9-24: While one connection queries the Packages table, another connection modifies that same data
BEGIN TRY ;
    BEGIN TRANSACTION ;

    INSERT  INTO dbo.PackageItems
            ( PackageLabel ,
              ItemLabel ,
              MaxSizeInInches
            )
    VALUES  ( 'Gifts for in-laws' ,
              'Golf Club' ,
              45
            ) ;
            
    UPDATE  dbo.Packages
    SET     LengthInInches = 48
    WHERE   PackageLabel = 'Gifts for in-laws' ;
 
    COMMIT ;

END TRY
BEGIN CATCH ;
    SELECT ERROR_MESSAGE ();
    ROLLBACK ;
END CATCH ;

-- Listing 9-25: A query issued to select information regarding the contents of our package
SELECT  ItemLabel ,
        MaxSizeInInches
FROM    dbo.PackageItems
WHERE   PackageLabel = 'Gifts for in-laws' ;     

COMMIT ;

-- Listing 9-26: Adding fresh test data
SET NOCOUNT ON ;
DELETE FROM dbo.PackageItems ;
DELETE FROM dbo.Packages ;
GO

INSERT  INTO dbo.Packages
        ( PackageLabel ,
          LengthInInches ,
          WidthInInches ,
          HeightInInches   
        )
VALUES  ( 'Gifts for in-laws' ,
          5 ,
          5 ,
          2
        ) ;
GO

DECLARE @i INT ;
SET @i = 1 ;
WHILE @i < 10000
  BEGIN ;
    INSERT  INTO dbo.PackageItems
        ( PackageLabel ,
          ItemLabel ,
          MaxSizeInInches
        )
    SELECT 'Gifts for in-laws' ,
          'item # ' + CAST(@i AS VARCHAR(10)) ,
          2 ;
    SET @i = @i + 1 ;
  END ;

-- Listing 9-27: Modifying the data that is being retrieved
SET NOCOUNT ON ;
-- we want to make sure that Listing 3-27 does not
-- become a deadlock victim. It is OK if this one
-- becomes a deadlock victim.
SET DEADLOCK_PRIORITY LOW ;
DECLARE @i INT ;
SET @i = 1 ;
WHILE @i < 10000 
    BEGIN ;
        BEGIN TRAN ;
        UPDATE  dbo.PackageItems
        SET     MaxSizeInInches = MaxSizeInInches + 1
        WHERE   ItemLabel = 'item # 9999'
        UPDATE  dbo.Packages
        SET     HeightInInches = HeightInInches + 1
        WHERE   PackageLabel = 'Gifts for in-laws' ;
        COMMIT ;
        SET @i = @i + 1 ;
    END ;

-- Listing 9-28: Running a query against both test tables, in a loop, and detecting any inconsistent results
-- hit Ctrl+T to run in text mode
 DECLARE @res TABLE
    (
      boxSize DECIMAL(14, 2) NOT NULL ,
      itemSize DECIMAL(14, 2) NOT NULL
    ) ;
 SET NOCOUNT ON ;
-- we want to make sure this script does not
-- become a deadlock victim
 SET DEADLOCK_PRIORITY HIGH ;
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
 DECLARE @i INT ,
    @d INT ;
 SET @i = 1 ;
 WHILE @i < 1000 
    BEGIN ;
        INSERT  INTO @res
                ( boxSize ,
                  itemSize
                )
                SELECT  p.HeightInInches ,
                        i.MaxSizeInInches
                FROM    dbo.Packages AS p
                   INNER JOIN dbo.PackageItems AS i
                   ON p.PackageLabel = i.PackageLabel ;
--  Are the maximum size of all items and the
--  maximum size of all boxes equal to each other?
        SELECT  @d = MAX(boxSize) - MAX(itemSize)
        FROM    @res ;
        IF @d <> 0 
-- If they are not equal, this is a discrepancy
-- Let us display the discrepancy
            SELECT  boxSize ,
                    MAX(itemSize) AS MaxItemSize
            FROM    @res
            GROUP BY boxSize
            HAVING  boxSize <> MAX(itemSize) ;
        DELETE  FROM @res ;
        SET @i = @i + 1 ;
    END ;

-- Listing 9-30: Delete the modified data from Packages and PackageItems
DELETE  FROM dbo.PackageItems ;
DELETE  FROM dbo.Packages ;

-- Listing 9-31: Begin a transaction under SNAPSHOT isolation level, and retrieve the data regarding our package
SET TRANSACTION ISOLATION LEVEL SNAPSHOT ;

BEGIN TRANSACTION ;

SELECT  PackageLabel ,
        LengthInInches ,
        WidthInInches ,
        HeightInInches
FROM    dbo.Packages
WHERE   PackageLabel = 'Gifts for in-laws' ; 

-- Listing 9-32: The same query against PackageItems table, in the context of a transaction under SNAPSHOT isolation level
SELECT  ItemLabel ,
        MaxSizeInInches
FROM    dbo.PackageItems
WHERE   PackageLabel = 'Gifts for in-laws' ;   

COMMIT ;

-- Listing 9-33: Enabling READ_COMMITTED_SNAPSHOT for our database
-- replace OurDatabase
-- with the name of the database
-- in which you are running the scripts

ALTER DATABASE OurDatabase 
SET READ_COMMITTED_SNAPSHOT ON 
WITH ROLLBACK IMMEDIATE ;

-- Listing 9-34: Begin a transaction under READ_COMMITTED_SNAPHOT isolation level and run the first query
-- in this context READ COMMITTED 
-- actually means READ COMMITTED SNAPSHOT
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;

BEGIN TRANSACTION ;

SELECT  PackageLabel ,
        LengthInInches ,
        WidthInInches ,
        HeightInInches
FROM    dbo.Packages
WHERE   PackageLabel = 'Gifts for in-laws' ;     

-- Listing 9-36: Begin a transaction under REPEATABLE READ isolation level and run the first query
-- we want this transaction to be chosen
-- as a deadlock victim
SET DEADLOCK_PRIORITY LOW ; 

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
BEGIN TRANSACTION ;

SELECT  PackageLabel ,
        LengthInInches ,
        WidthInInches ,
        HeightInInches
FROM    dbo.Packages
WHERE   PackageLabel = 'Gifts for in-laws' ;  

-- Listing 9-37: Begin the transaction that modifies our data
BEGIN TRANSACTION ;

INSERT  INTO dbo.PackageItems
        ( PackageLabel ,
          ItemLabel ,
          MaxSizeInInches
        )
VALUES  ( 'Gifts for in-laws' ,
          'Golf Club' ,
          45          
        ) ;

-- Listing 9-38: Complete the modifications in the second tab
UPDATE  dbo.Packages
SET     LengthInInches = 48
WHERE   Label = 'Gifts for in-laws' ;

COMMIT ;
 
