-- Listing 8-1: Language settings can cause certain date queries to fail
CREATE VIEW dbo.NextNewYearEve AS 
SELECT DATEADD
        (YEAR,
         DATEDIFF(year, '12/31/2000', CURRENT_TIMESTAMP),
         '12/31/2000'
        ) AS NextNewYearEve ; 
GO 

SET LANGUAGE us_english ; 
SELECT  NextNewYearEve
FROM    dbo.NextNewYearEve ; 

SET LANGUAGE Norwegian ; 
SELECT  NextNewYearEve
FROM    dbo.NextNewYearEve ; 
GO 

DROP VIEW dbo.NextNewYearEve ;  

-- Listing 8-2: The Codes and CodeDescriptionsChangeLog tables
IF EXISTS ( SELECT  *
            FROM    INFORMATION_SCHEMA.TABLES
            WHERE   TABLE_NAME = 'Codes'
            AND TABLE_SCHEMA = 'dbo' )
  BEGIN;
    -- we used a Codes table in a previous chapter
    -- let us make sure that is does not exist any more
    DROP TABLE dbo.Codes ;
  END ;
GO
CREATE TABLE dbo.Codes
  (
    Code VARCHAR(10) NOT NULL ,
    Description VARCHAR(40) NULL ,
    CONSTRAINT PK_Codes PRIMARY KEY CLUSTERED ( Code )
  ) ; 
GO

-- we did not use this table name before in this book,
-- so there is no need to check if it already exists
CREATE TABLE dbo.CodeDescriptionsChangeLog
    (
      Code VARCHAR(10) NOT NULL ,
      ChangeDate DATETIME NOT NULL ,
      OldDescription VARCHAR(40) NULL ,
      NewDescription VARCHAR(40) NULL ,
      CONSTRAINT PK_CodeDescriptionsChangeLog PRIMARY KEY ( Code, ChangeDate )
    ) ;

-- Listing 8-3: The ChangeCodeDescription stored procedure
CREATE PROCEDURE dbo.ChangeCodeDescription
    @Code VARCHAR(10) ,
    @Description VARCHAR(40)
AS 
    BEGIN ; 
        INSERT  INTO dbo.CodeDescriptionsChangeLog
                ( Code ,
                  ChangeDate ,
                  OldDescription ,
                  NewDescription
                )
                SELECT  Code ,
                        CURRENT_TIMESTAMP ,
                        Description ,
                        @Description
                FROM    dbo.Codes
                WHERE   Code = @Code ; 

        UPDATE  dbo.Codes
        SET     Description = @Description
        WHERE   Code = @Code ; 
    END ;  

-- Listing 8-4: A smoke test on the ChangeCodeDescription stored procedure
INSERT  INTO dbo.Codes
        ( Code, Description )
VALUES  ( 'IL', 'Ill.' ) ; 
GO 

EXEC dbo.ChangeCodeDescription
  @Code = 'IL', 
  @Description = 'Illinois' ; 
GO 

SELECT  Code ,
        OldDescription + ', ' + NewDescription
FROM    dbo.CodeDescriptionsChangeLog ;  

-- Listing 8-5: An INSERT into CodeDescriptionsChangeLog fails, but the UPDATE of Codes succeeds
SET XACT_ABORT OFF ;
-- if  XACT_ABORT OFF were set to ON ,
-- the code below would behave differently.
-- We shall discuss it later in this chapter.

DELETE   FROM dbo.CodeDescriptionsChangeLog ;

BEGIN TRANSACTION ;
GO

-- This constraint temporarily prevents all inserts
-- and updates against the log table.
-- When the transaction is rolled back, the constraint
-- will be gone.
ALTER TABLE dbo.CodeDescriptionsChangeLog 
ADD CONSTRAINT CodeDescriptionsChangeLog_Immutable 
   CHECK(1<0) ;
GO

EXEC dbo.ChangeCodeDescription
  @Code = 'IL',
  @Description = 'other value' ; 
GO

-- dbo.Codes table has been updated
SELECT   Code ,
         Description
FROM     dbo.Codes ; 

-- dbo.CodeDescriptionsChangeLog has not been updated
SELECT   Code ,
         OldDescription + ', ' + NewDescription
FROM     dbo.CodeDescriptionsChangeLog ; 
GO

ROLLBACK ;

-- Listing 8-6: Using the XACT_ABORT setting and an explicit transaction
ALTER PROCEDURE dbo.ChangeCodeDescription
    @Code VARCHAR(10) ,
    @Description VARCHAR(40)
AS 
    BEGIN ; 
        SET XACT_ABORT ON ;
        BEGIN TRANSACTION ; 
        INSERT  INTO dbo.CodeDescriptionsChangeLog
                ( Code ,
                  ChangeDate ,
                  OldDescription ,
                  NewDescription
                )
                SELECT  Code ,
                        current_timestamp ,
                        Description ,
                        @Description
                FROM    dbo.Codes
                WHERE   Code = @Code ; 
        PRINT 'First modifications succeeded' ;

        UPDATE  dbo.Codes
        SET     Description = @Description
        WHERE   Code = @Code ; 
  -- the following commands execute only if both
  -- modifications succeeded
        PRINT 'Both modifications succeeded, committing
               the transaction' ;
        COMMIT ;
    END ;

-- Listing 8-7: Testing the altered stored procedure
SET NOCOUNT ON ;
SET XACT_ABORT OFF ;

DELETE   FROM dbo.CodeDescriptionsChangeLog ;

BEGIN TRANSACTION ;
GO

-- This constraint temporarily prevents all inserts
-- and updates against the log table.
-- When the transaction is rolled back, the constraint
-- will be gone.
ALTER TABLE dbo.CodeDescriptionsChangeLog 
ADD CONSTRAINT CodeDescriptionsChangeLog_Immutable 
   CHECK(1<0) ;
GO

EXEC dbo.ChangeCodeDescription
  @Code = 'IL',
  @Description = 'other value' ; 
GO
-- transaction is rolled back automatically
SELECT @@TRANCOUNT AS [@@TRANCOUNT after stored procedure call] ;

-- dbo.Codes table has not been updated
SELECT   Code ,
         Description
FROM     dbo.Codes ; 

-- dbo.CodeDescriptionsChangeLog has not been updated
SELECT   Code ,
         OldDescription + ', ' + NewDescription
FROM     dbo.CodeDescriptionsChangeLog ; 

-- Listing 8-8: Altering the ChangeCodeDescription stored procedure so that it retries after a deadlock
ALTER PROCEDURE dbo.ChangeCodeDescription
  @Code VARCHAR(10) ,
  @Description VARCHAR(40)
AS 
  BEGIN ;
    DECLARE @tryCount INT ,
            @OldDescription VARCHAR(40) ;
    SET DEADLOCK_PRIORITY LOW ;
    SET XACT_ABORT OFF ;
    SET @tryCount = 1 ;
    WHILE @tryCount < 3 
      BEGIN 
        BEGIN TRY 
          BEGIN TRANSACTION ;
          SET @OldDescription = ( SELECT  Description
                                  FROM    dbo.Codes
                                  WHERE   Code = @Code
                                 ) ;
                    
          UPDATE  dbo.Codes
          SET     Description = @Description
          WHERE   Code = @Code ; 

          INSERT  INTO dbo.CodeDescriptionsChangeLog
                  ( Code ,
                    ChangeDate ,
                    OldDescription ,
                    NewDescription  
                  )
                  SELECT  @Code ,
                          CURRENT_TIMESTAMP ,
                          @OldDescription ,
                          @Description ; 
          PRINT 'Modifications succeeded' ;
          COMMIT ;
          RETURN 0 ;
        END TRY
        BEGIN CATCH
        -- transaction is not rolled back automatically
        -- we need to roll back explicitly
          IF @@TRANCOUNT <> 0 
            BEGIN ;
              PRINT 'Rolling back' ;
              ROLLBACK ;
            END ;
          IF ERROR_NUMBER() <> 1205 
            BEGIN 
        -- if this is not a deadlock, "rethrow" the error
              DECLARE @ErrorMessage NVARCHAR(4000) ;
              SET @ErrorMessage = ERROR_MESSAGE() ;
              RAISERROR('Error %s occurred in
                         SelectCodeChangeLogAndCode'
                         ,16,1,@ErrorMessage) ;
              RETURN -1 ;
            END ;
          ELSE 
            BEGIN ;
              PRINT 'Encountered a deadlock'
            END ;
        END CATCH ;
        SET @tryCount = @tryCount + 1 ;
      END ;	
    RETURN 0 ;
  END ;

-- Listing 8-9: Resetting the test data
-- reset our test data
DELETE  FROM dbo.CodeDescriptionsChangeLog ;
DELETE  FROM dbo.Codes ;
INSERT  INTO dbo.Codes
        ( Code, Description )
VALUES  ( 'IL', 'IL' ) ; 
GO 

EXEC dbo.ChangeCodeDescription
    @Code = 'IL',
    @Description = 'Ill.' ; 
GO

SELECT  Code ,
        Description
FROM    dbo.Codes ; 

SELECT  Code ,
        OldDescription + ', ' + NewDescription 
FROM    dbo.CodeDescriptionsChangeLog ;

-- Listing 8-10: Tab #1, Start a transaction against the CodeDescriptionsChangeLog table
SET DEADLOCK_PRIORITY HIGH ;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ;
BEGIN TRANSACTION ;
SELECT * FROM dbo.CodeDescriptionsChangeLog ;

/*
UPDATE  dbo.Codes
SET     Description = 'Illinois'
WHERE   Code = 'IL' ; 
COMMIT ; 

*/

-- Listing 8-11: Tab #2, Invoke the ChangeCodeDescription stored procedure 
EXEC dbo.ChangeCodeDescription
     @code='IL', 
     @Description='?' ;

SELECT   Code ,
         Description
FROM     dbo.Codes ; 

SELECT   Code ,
         OldDescription + ', ' + NewDescription
FROM     dbo.CodeDescriptionsChangeLog ; 

-- Listing 8-13: An error with error number 245 gets a 50000 ERROR_NUMBER, when re-thrown.
CREATE PROCEDURE dbo.ConversionErrorDemo
AS 
    BEGIN TRY ;
        SELECT  CAST('abc' AS INT) ;
    -- some other code
    END TRY
    BEGIN CATCH ;
        DECLARE @ErrorNumber INT ,
            @ErrorMessage NVARCHAR(4000) ;
        SELECT  @ErrorNumber = ERROR_NUMBER() ,
                @ErrorMessage = ERROR_MESSAGE() ; 
        IF @ErrorNumber = 245 
            BEGIN ;
    -- we shall not handle conversion errors here
    -- let us try to rethrow the error, so that 
    -- it is handled elsewhere.
    -- This error has number 245, but we cannot
    -- have RAISERROR keep the number of the error.
                RAISERROR(@ErrorMessage, 16, 1) ;
            END ;
        ELSE 
            BEGIN ;
    -- handle all other errors here
                SELECT  @ErrorNumber AS ErrorNumber ,
                        @ErrorMessage AS ErrorMessage ; 
            END ;
    END CATCH ;
GO
EXEC dbo.ConversionErrorDemo ;

-- Listing 8-14: The re-thrown error is no longer assigned number 245.
BEGIN TRY ;
    EXEC dbo.ConversionErrorDemo ;
    -- some other code
END TRY
BEGIN CATCH ;
    DECLARE @ErrorNumber INT ,
        @ErrorMessage NVARCHAR(4000) ;
    SELECT  @ErrorNumber = error_number() ,
            @ErrorMessage = error_message() ; 
    IF @ErrorNumber = 245 
        BEGIN ;
            PRINT 'Conversion error caught';
        END ;
    ELSE 
        BEGIN ;
    -- handle all other errors here
            PRINT 'Some other error caught';
            SELECT  @ErrorNumber AS ErrorNumber ,
                    @ErrorMessage AS ErrorMessage ; 
        END ;
END CATCH ;
GO

-- Listing 8-15: Parsing the error message to catch a re-thrown error.
BEGIN TRY ;
    EXEC dbo.ConversionErrorDemo ;
    -- some other code
END TRY
BEGIN CATCH ;
    DECLARE @ErrorNumber INT ,
        @ErrorMessage NVARCHAR(4000) ;
    SELECT  @ErrorNumber = ERROR_NUMBER() ,
            @ErrorMessage = ERROR_MESSAGE() ; 
    IF @ErrorNumber = 245
        OR @ErrorMessage LIKE '%Conversion failed when
                                converting %' 
        BEGIN ;
            PRINT 'Conversion error caught' ;
        END ;
    ELSE 
        BEGIN ;
    -- handle all other errors here
            PRINT 'Some other error caught' ;
            SELECT  @ErrorNumber AS ErrorNumber ,
                    @ErrorMessage AS ErrorMessage ; 
        END ;
END CATCH ;

-- Listing 8-16: Incorrectly handling a ticket-saving error as if it were a conversion error.
BEGIN TRY ;
    RAISERROR('Error saving ticket %s',16,1,
    'Saving discount blows up: ''Conversion failed when
                                  converting ...''') ;
    -- some other code
END TRY
BEGIN CATCH ;
    DECLARE @ErrorNumber INT ,
        @ErrorMessage NVARCHAR(4000) ;
    SELECT  @ErrorNumber = ERROR_NUMBER() ,
            @ErrorMessage = ERROR_MESSAGE() ; 
    IF @ErrorNumber = 245
        OR @ErrorMessage LIKE '%Conversion failed when
                               converting %' 
        BEGIN ;
            PRINT 'Conversion error caught' ;
        END ;
    ELSE 
        BEGIN ;
    -- handle all other errors here
            PRINT 'Some other error caught' ;
            SELECT  @ErrorNumber AS ErrorNumber ,
                    @ErrorMessage AS ErrorMessage ; 
        END ;
END CATCH ;
GO

-- Listing 8-17: TRY…CATCH behavior when a timeout occurs
SET XACT_ABORT OFF;
BEGIN TRY ;
  PRINT 'Beginning TRY block' ; 
  BEGIN TRANSACTION ; 
  WAITFOR DELAY '00:10:00' ; 
  COMMIT ; 
  PRINT 'Ending TRY block' ; 
END TRY 
BEGIN CATCH ;
  PRINT 'Entering CATCH block' ; 
END CATCH ; 
PRINT 'After the end of the CATCH block' ;  

-- Listing 8-18: The connection is in the middle of an outstanding transaction
SELECT  @@TRANCOUNT AS [@@TRANCOUNT] ;
ROLLBACK ;

-- Listing 8-19: Sometimes a CATCH block is bypassed when an error occurs
BEGIN TRY ;
  PRINT 'Beginning TRY block' ; 
  SELECT  COUNT(*)
  FROM    #NoSuchTempTable ; 
  PRINT 'Ending TRY block' ; 
END TRY  
BEGIN CATCH ;
  PRINT 'Entering CATCH block' ; 
END CATCH ; 
PRINT 'After the end of the CATCH block' ;

-- Listing 8-20: A transaction is doomed after a trivial error such as a conversion error.
SET XACT_ABORT OFF ;
SET NOCOUNT ON ;

BEGIN TRANSACTION ;
SELECT  1 ;
GO
BEGIN TRY ;
    SELECT  1 / 0 ;
END TRY
BEGIN CATCH
    PRINT 'Error occurred' ;
    SELECT error_message() AS ErrorMessage ;
END CATCH ;
GO
IF @@TRANCOUNT <> 0 
    BEGIN ;
        COMMIT ;
        PRINT 'Committed' ;
    END ;
GO

BEGIN TRANSACTION ;
SELECT  1 ;
GO
BEGIN TRY ;
	SELECT  cast('abc' AS INT ) ;
END TRY
BEGIN CATCH
    PRINT 'Error occurred' ;
    SELECT error_message() AS ErrorMessage ;
END CATCH ;
GO
IF @@TRANCOUNT <> 0 
    BEGIN ;
        COMMIT ;
        PRINT 'Committed' ;
    END ;

-- Listing 8-21: Using xact_state to determine if our transaction is committable or doomed
BEGIN TRY ;
  BEGIN TRANSACTION ;
  SELECT  CAST ('abc' AS INT) ;
  COMMIT ;
  PRINT 'Ending try block' ;
END TRY
BEGIN CATCH ;
  PRINT 'Entering CATCH block' ;
  IF XACT_STATE () = 1 
    BEGIN ;
      PRINT 'Transaction is committable' ;
      COMMIT ;
    END ; 
  IF XACT_STATE () = -1 
    BEGIN ;
      PRINT 'Transaction is not committable' ;
      ROLLBACK ;
    END ;
END CATCH ;
PRINT 'Ending batch' ;
GO
SELECT  @@TRANCOUNT AS [@@TRANCOUNT] ;
BEGIN TRY ;
  BEGIN TRANSACTION ;
  SELECT  1 / 0 ;
  COMMIT ;
  PRINT 'Ending try block' ;
END TRY
BEGIN CATCH ;
  PRINT 'Entering CATCH block' ;
  IF XACT_STATE () = 1 
    BEGIN ;
      PRINT 'Transaction is committable' ;
      COMMIT ;
    END ; 
  IF XACT_STATE () = -1 
    BEGIN ;
      PRINT 'Transaction is not committable' ;
      ROLLBACK ;
    END ;
END CATCH ;
PRINT 'Ending batch' ;
GO

-- Listing 8-23: Removing the retry logic from the ChangeCodeDescription stored procedure.
ALTER PROCEDURE dbo.ChangeCodeDescription
    @Code VARCHAR(10) ,
    @Description VARCHAR(40)
AS 
    BEGIN ;
        DECLARE @OldDescription VARCHAR(40) ;
        SET DEADLOCK_PRIORITY LOW ;
        SET XACT_ABORT ON ; 
        BEGIN TRANSACTION ;
        SET @OldDescription = ( SELECT  Description
                                FROM    dbo.Codes
                                WHERE   Code = @Code
                              ) ;
                    
        UPDATE  dbo.Codes
        SET     Description = @Description
        WHERE   Code = @Code ; 

        INSERT  INTO dbo.CodeDescriptionsChangeLog
                ( Code ,
                  ChangeDate ,
                  OldDescription ,
                  NewDescription
                )
                SELECT  @Code ,
                        current_timestamp ,
                        @OldDescription ,
                        @Description ; 
        PRINT 'Modifications succeeded' ;

        COMMIT ;
        RETURN 0 ;
    END ;

-- Listing 8-25: Checking that the data is in the expected state.
EXEC dbo.ChangeCodeDescription @code='IL', 
		@Description='?' ;
		
SELECT   Code ,
         Description
FROM     dbo.Codes ; 

SELECT   Code ,
         OldDescription + ', ' + NewDescription
FROM     dbo.CodeDescriptionsChangeLog ; 
