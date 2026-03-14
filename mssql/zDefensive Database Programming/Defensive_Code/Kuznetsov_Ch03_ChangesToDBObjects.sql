-- Listing 3-1: Creating the Customers table, with a UNIQUE constraint on the PhoneNumber column
CREATE TABLE dbo.Customers
  (
    CustomerId INT NOT NULL ,
    FirstName VARCHAR(50) NOT NULL ,
    LastName VARCHAR(50) NOT NULL ,
    Status VARCHAR(50) NOT NULL ,
    PhoneNumber VARCHAR(50) NOT NULL ,
    CONSTRAINT PK_Customers PRIMARY KEY ( CustomerId ) ,
    CONSTRAINT UNQ_Customers UNIQUE ( PhoneNumber )
  ) ; 
GO
INSERT  INTO dbo.Customers
        ( CustomerId ,
          FirstName ,
          LastName ,
          Status ,
          PhoneNumber
        )
        SELECT  1 ,
                'Darrel' ,
                'Ling' ,
                'Regular' ,
                '(123)456-7890'
        UNION ALL
        SELECT  2 ,
                'Peter' ,
                'Hansen' ,
                'Regular' ,
                '(234)123-4567' ;

-- Listing 3-2: The SetCustomerStatus stored procedure
CREATE PROCEDURE dbo.SetCustomerStatus
    @PhoneNumber VARCHAR(50) ,
    @Status VARCHAR(50)
AS 
    BEGIN; 
        UPDATE  dbo.Customers
        SET     Status = @Status
        WHERE   PhoneNumber = @PhoneNumber ;
    END ;

-- Listing 3-3: Adding a CountryCode column to the table and to the unique constraint
ALTER TABLE dbo.Customers
   ADD CountryCode CHAR(2)  NOT NULL
     CONSTRAINT DF_Customers_CountryCode
        DEFAULT('US') ;
GO

ALTER TABLE dbo.Customers DROP CONSTRAINT UNQ_Customers;
GO

ALTER TABLE dbo.Customers 
   ADD CONSTRAINT UNQ_Customers 
      UNIQUE(PhoneNumber, CountryCode) ;

-- Listing 3-4: Wayne Miller has the same phone number as Darrell Ling, but with a different county code.
UPDATE  dbo.Customers
SET     Status = 'Regular' ;

INSERT  INTO dbo.Customers
        ( CustomerId ,
          FirstName ,
          LastName ,
          Status ,
          PhoneNumber ,
          CountryCode
        )
        SELECT  3 ,
                'Wayne' ,
                'Miller' ,
                'Regular' ,
                '(123)456-7890' ,
                'UK' ;

-- Listing 3-5: The unchanged stored procedure modifies two rows instead of one
-- at this moment all customers have Regular status
EXEC dbo.SetCustomerStatus 
    @PhoneNumber = '(123)456-7890',
    @Status = 'Preferred' ;

-- the procedure has modified statuses of two customers
SELECT  CustomerId ,
        Status
FROM    dbo.Customers ;

-- Listing 3-6: Step 1, a query to check for constraints on PhoneNumber 
SELECT  COUNT(*)
FROM    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS u
WHERE   u.TABLE_NAME = 'Customers'
        AND u.TABLE_SCHEMA = 'dbo'
        AND u.COLUMN_NAME = 'PhoneNumber' ;

-- Listing 3-7: Step 2 determines if the constraint on column PhoneNumber is a primary key or unique
SELECT  COUNT(*)
FROM    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS u
        JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c
            ON c.TABLE_NAME = u.TABLE_NAME
            AND c.TABLE_SCHEMA = u.TABLE_SCHEMA
            AND c.CONSTRAINT_NAME = u.CONSTRAINT_NAME
WHERE   u.TABLE_NAME = 'Customers'
        AND u.TABLE_SCHEMA = 'dbo'
        AND u.COLUMN_NAME = 'PhoneNumber'
        AND c.CONSTRAINT_TYPE 
            IN ( 'PRIMARY KEY', 'UNIQUE' ) ;

-- Listing 3-8: Step 3, is a unique or PK constraint built on only the PhoneNumber column
SELECT  COUNT(*)
FROM    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS u
        JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c 
            ON c.TABLE_NAME = u.TABLE_NAME
            AND c.TABLE_SCHEMA = u.TABLE_SCHEMA
            AND c.CONSTRAINT_NAME = u.CONSTRAINT_NAME
WHERE   u.TABLE_NAME = 'Customers'
        AND u.TABLE_SCHEMA = 'dbo'
        AND u.COLUMN_NAME = 'PhoneNumber'
        AND c.CONSTRAINT_TYPE
            IN ( 'PRIMARY KEY', 'UNIQUE' ) 
 -- this constraint involves only one column
        AND ( SELECT    COUNT(*)
         FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
                AS u1
              WHERE     u1.TABLE_NAME = u.TABLE_NAME
                    AND u1.TABLE_SCHEMA = u.TABLE_SCHEMA
                    AND u1.CONSTRAINT_NAME = 
                                  u.CONSTRAINT_NAME
            ) = 1 ;

-- Listing 3-9: A stored procedure that will not modify more than one row
ALTER PROCEDURE dbo.SetCustomerStatus
    @PhoneNumber VARCHAR(50) ,
    @Status VARCHAR(50)
AS 
    BEGIN ; 
        BEGIN TRANSACTION ;
    
        UPDATE  dbo.Customers
        SET     Status = @Status
        WHERE   PhoneNumber = @PhoneNumber ;
        
        IF @@ROWCOUNT > 1 
            BEGIN ;
                ROLLBACK ;
                RAISERROR('More than one row updated',
                            16, 1) ;
            END ;
        ELSE 
            BEGIN ;
                COMMIT ;
            END ;  
    END ;

-- Listing 3-10: Testing the altered stored procedure
UPDATE  dbo.Customers
SET     Status = 'Regular' ;

EXEC dbo.SetCustomerStatus 
    @PhoneNumber = '(123)456-7890',
    @Status = 'Preferred' ;

-- verify if the procedure has modified any data
SELECT  CustomerId ,
        Status
FROM    dbo.Customers ;

-- Listing 3-11: Unpredictable variable assignment, using SELECT
DECLARE @CustomerId INT ;

SELECT  @CustomerId = CustomerId
FROM    dbo.Customers
WHERE   PhoneNumber = '(123)456-7890' ;

SELECT  @CustomerId AS CustomerId ;

-- Do something with CustomerId

-- Listing 3-12: Whereas SELECT ignores the ambiguity, SET detects it and raises an error
DECLARE @CustomerId INT ;

-- this assignment will succeed,
-- because in this case there is no ambiguity
SET @CustomerId = ( SELECT CustomerId
                    FROM   dbo.Customers
                    WHERE  PhoneNumber = '(234)123-4567'
                  ) ;

SELECT  @CustomerId AS CustomerId ;

-- this assignment will fail,
-- because there is ambiguity,
-- two customers have the same phone number
SET @CustomerId = ( SELECT CustomerId
                    FROM   dbo.Customers
                    WHERE  PhoneNumber = '(123)456-7890'
                  ) ;

-- the above error must be intercepted and handled
-- See Chapter 8
-- the variable is left unchanged
SELECT  @CustomerId AS CustomerId ;

-- Listing 3-13: The SelectCustomersByName stored procedure
CREATE PROCEDURE dbo.SelectCustomersByName
  @LastName VARCHAR(50) = NULL ,
  @PhoneNumber VARCHAR(50) = NULL
AS 
  BEGIN ;
    SELECT  CustomerId ,
            FirstName ,
            LastName ,
            PhoneNumber ,
            Status
    FROM    dbo.Customers
    WHERE   LastName = COALESCE(@LastName, LastName)
            AND PhoneNumber = COALESCE(@PhoneNumber,
                                         PhoneNumber) ;
  END ;

-- Listing 3-14: Two ways to invoke the SelectCustomersByName stored procedure 
EXEC dbo.SelectCustomersByName
    'Hansen',         -- @LastName
    '(234)123-4567' ; -- @PhoneNumber

EXEC dbo.SelectCustomersByName
    @LastName = 'Hansen',
    @PhoneNumber = '(234)123-4567' ;

-- Listing 3-15: The modified SelectCustomersByName stored procedure
ALTER PROCEDURE dbo.SelectCustomersByName
  @FirstName VARCHAR(50) = NULL ,
  @LastName VARCHAR(50) = NULL ,
  @PhoneNumber VARCHAR(50) = NULL
AS 
  BEGIN ;
    SELECT  CustomerId ,
      FirstName ,
      LastName ,
      PhoneNumber ,
      Status
    FROM    dbo.Customers
    WHERE   FirstName = COALESCE (@FirstName, FirstName)
            AND LastName = COALESCE (@LastName,LastName)
            AND PhoneNumber = COALESCE (@PhoneNumber, 
                                          PhoneNumber) ;
  END ;
GO

-- Listing 3-16: Effect of change in stored procedure signature
-- in the new context this call is interpreted 
-- differently. It will return no rows
EXEC dbo.SelectCustomersByName 
    'Hansen',         -- @FirstName
    '(234)123-4567' ; -- @LastName

-- this stored procedure call is equivalent
-- to the previous one
EXEC dbo.SelectCustomersByName
    @FirstName = 'Hansen',
    @LastName = '(234)123-4567' ;

-- this call returns the required row
EXEC dbo.SelectCustomersByName
    @LastName = 'Hansen',
    @PhoneNumber = '(234)123-4567' ;

-- Listing 3-17: The Shipments and ShipmentItems tables
CREATE TABLE dbo.Shipments
    (
      Barcode VARCHAR(30) NOT NULL PRIMARY KEY,
      SomeOtherData VARCHAR(100) NULL
    ) ;
GO

INSERT  INTO dbo.Shipments
        ( Barcode ,
          SomeOtherData
        )
        SELECT  '123456' ,
                '123456 data'
        UNION ALL
        SELECT  '123654' ,
                '123654 data' ;
GO

CREATE TABLE dbo.ShipmentItems
    (
      ShipmentBarcode VARCHAR(30) NOT NULL,
      Description VARCHAR(100) NULL
    ) ;
GO

INSERT  INTO dbo.ShipmentItems
        ( ShipmentBarcode ,
          Description
        )
        SELECT  '123456' ,
                'Some cool widget'
        UNION ALL
        SELECT  '123456' ,
                'Some cool stuff for some gadget' ;
GO

-- Listing 3-18: A correlated sub-query that works correctly even though column names are not qualified
SELECT  Barcode ,
        ( SELECT    COUNT(*)
          FROM      dbo.ShipmentItems
          WHERE     ShipmentBarcode = Barcode
        ) AS NumItems
FROM    dbo.Shipments ;

-- Listing 3-19: The query works differently when a Barcode column is added to ShipmentItems table
ALTER TABLE dbo.ShipmentItems
ADD Barcode VARCHAR(30) NULL ;
GO
SELECT  Barcode ,
        ( SELECT    COUNT(*)
          FROM      dbo.ShipmentItems
          WHERE     ShipmentBarcode = Barcode
        ) AS NumItems
FROM    dbo.Shipments ;

-- Listing 3-20: Qualified column names lead to more robust code
SELECT  s.Barcode ,
        ( SELECT    COUNT(*)
          FROM      dbo.ShipmentItems AS i
          WHERE     i.ShipmentBarcode = s.Barcode
        ) AS NumItems
FROM    dbo.Shipments AS s ;

-- Listing 3-21: Creating, populating and querying ShipmentItems table
DROP TABLE dbo.ShipmentItems ;
GO

CREATE TABLE dbo.ShipmentItems
    (
      ShipmentBarcode VARCHAR(30) NOT NULL ,
      Description VARCHAR(100) NULL ,
      Barcode VARCHAR(30) NOT NULL
    ) ;
GO


INSERT  INTO dbo.ShipmentItems
        ( ShipmentBarcode ,
          Barcode ,
          Description
        )
        SELECT  '123456' ,
                '1010203' ,
                'Some cool widget'
        UNION ALL
        SELECT  '123654' ,
                '1010203' ,
                'Some cool widget'
        UNION ALL
        SELECT  '123654' ,
                '1010204' ,
                'Some cool stuff for some gadget' ;
GO

-- retrieve all the items from shipment 123654
-- that are not shipped in shipment 123456
SELECT  Barcode
FROM    dbo.ShipmentItems
WHERE   ShipmentBarcode = '123654'
        AND Barcode NOT IN ( SELECT Barcode
                             FROM   dbo.ShipmentItems
                             WHERE  ShipmentBarcode = 
                                            '123456' ) ;

-- Listing 3-22: Now that the Barcode column accepts NULL, our NOT IN query no longer work as expected.
ALTER TABLE dbo.ShipmentItems
ALTER COLUMN Barcode VARCHAR(30) NULL ;
INSERT  INTO dbo.ShipmentItems
        ( ShipmentBarcode ,
          Barcode ,
          Description
        )
        SELECT  '123456' ,
                NULL ,
                'Users manual for some gadget' ;
GO

SELECT  Barcode
FROM    dbo.ShipmentItems
WHERE   ShipmentBarcode = '123654'
        AND Barcode NOT IN ( SELECT Barcode
                             FROM   dbo.ShipmentItems
                             WHERE  ShipmentBarcode =
                                          '123456' ) ;

-- Listing 3-23: NOT IN queries with work differently when there are NULLs in the subquery
SELECT  CASE WHEN 1 NOT IN ( 2, 3 ) THEN 'True'
             ELSE 'Unknown or False'
        END ,
        CASE WHEN 1 NOT IN ( 2, 3, NULL ) THEN 'True'
             ELSE 'Unknown or False'
        END ;

-- Listing 3-24: A query with an IN clause and a logically equivalent query using OR
-- A query using the IN clause:
SELECT  CASE WHEN 1 IN ( 1, 2, NULL ) THEN 'True'
             ELSE 'Unknown or False'
        END ;
-- its logical eqiuvalent using OR
SELECT  CASE WHEN ( 1 = 1 )
                  OR ( 1 = 2 )
                  OR ( 1 = NULL ) THEN 'True'
             ELSE 'Unknown or False'
        END ;

-- Listing 3-25: Three equivalent queries, using NOT IN, two OR predicates and two AND predicates
-- A query using the NOT IN clause:
SELECT  CASE WHEN 1 NOT IN ( 1, 2, NULL ) THEN 'True'
             ELSE 'Unknown or False'
        END ;

-- its logical eqiuvalent using OR
SELECT  CASE WHEN NOT ( ( 1 = 1 )
                        OR ( 1 = 2 )
                        OR ( 1 = NULL )
                      ) THEN 'True'
             ELSE 'Unknown or False'
        END ;
-- applying DeMorgan's law, replacing every OR with AND,
-- and every = with <>
SELECT  CASE WHEN ( ( 1 <> 1 )
                    AND ( 1 <> 2 )
                    AND ( 1 <> NULL )
                  ) THEN 'True'
             ELSE 'Unknown or False'
        END ;

-- Listing 3-26: A query with a subquery that never returns any NULLs
SELECT  Barcode
FROM    dbo.ShipmentItems
WHERE   ShipmentBarcode = '123654'
  AND Barcode NOT IN ( SELECT Barcode
                       FROM   dbo.ShipmentItems
                       WHERE  ShipmentBarcode = '123456'
                         AND Barcode IS NOT NULL ) ;

-- Listing 3-27: An equivalent query with NOT EXISTS 
-- retrieve all the items from shipment 123654
-- that are not shipped in shipment 123456
SELECT  i.Barcode
FROM    dbo.ShipmentItems AS i
WHERE   i.ShipmentBarcode = '123654'
  AND NOT EXISTS ( SELECT *
                   FROM   dbo.ShipmentItems AS i1
                   WHERE  i1.ShipmentBarcode = '123456'
                     AND i1.Barcode = i.Barcode ) ;

-- Listing 3-28: The Codes table and SelectCode stored procedure
DROP TABLE dbo.Codes -- created in previous Chapters
GO

CREATE TABLE dbo.Codes
    (
      Code VARCHAR(5) NOT NULL ,
      Description VARCHAR(40) NOT NULL ,
      CONSTRAINT PK_Codes PRIMARY KEY ( Code )
    ) ;
GO

INSERT  INTO dbo.Codes
        ( Code ,
          Description
        )
VALUES  ( '12345' ,
          'Description for 12345'
        ) ;
INSERT  INTO dbo.Codes
        ( Code ,
          Description
        )
VALUES  ( '34567' ,
          'Description for 34567'
        ) ;
GO

CREATE PROCEDURE dbo.SelectCode
-- clearly the type and length of this parameter
-- must match  the type and length of Code column
-- in dbo.Codes table
    @Code VARCHAR(5)
AS 
    SELECT  Code ,
            Description
    FROM    dbo.Codes
    WHERE   Code = @Code ;
GO

-- Listing 3-29: The SelectCode stored procedure works as expected
EXEC dbo.SelectCode @Code = '12345' ;

-- Listing 3-30: Increasing the length of Code column and adding a row with maximum Code length:
ALTER TABLE dbo.Codes DROP CONSTRAINT PK_Codes ;
GO

ALTER TABLE dbo.Codes
  ALTER COLUMN Code VARCHAR(10) NOT NULL ; 
GO

ALTER TABLE dbo.Codes 
ADD CONSTRAINT PK_Codes 
PRIMARY KEY(Code) ;
GO

INSERT  INTO dbo.Codes
        ( Code ,
          Description
        )
VALUES  ( '1234567890' ,
          'Description for 1234567890'
        ) ;

-- Listing 3-31: The unchanged stored procedure retrieves the wrong row
EXEC dbo.SelectCode @Code = '1234567890' ;

