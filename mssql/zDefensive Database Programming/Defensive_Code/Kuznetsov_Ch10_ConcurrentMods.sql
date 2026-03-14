-- Listing 10-1: Creating the dbo.Tickets table
CREATE TABLE dbo.Tickets
    (
      TicketID INT NOT NULL ,
      Problem VARCHAR(50) NOT NULL ,
      CausedBy VARCHAR(50) NULL ,
      ProposedSolution VARCHAR(50) NULL ,
      AssignedTo VARCHAR(50) NOT NULL ,
      Status VARCHAR(50) NOT NULL ,
      CONSTRAINT PK_Tickets PRIMARY KEY ( TicketID )
    ) ;

-- Listing 10-2: The ticket in dbo.Tickets table, reporting a problem with the TPS report
INSERT  INTO dbo.Tickets
        ( TicketID ,
          Problem ,
          CausedBy ,
          ProposedSolution ,
          AssignedTo , 
          Status
        )
VALUES  ( 123 ,
          'TPS report for California not working' , 
          NULL , 
          NULL , 
          'TPS report team' , 
          'Opened'
        ) ; 

-- Listing 10-3: The SQL that was issued by Arne's bug tracking form
-- Arnie loads data into form
SELECT  TicketID ,
        Problem ,
        CausedBy ,
        ProposedSolution ,
        AssignedTo ,
        Status
FROM    dbo.Tickets
WHERE   TicketID = 123
GO

-- Arnie updates the form
BEGIN TRAN ;
UPDATE  dbo.Tickets
SET  AssignedTo = 'DBA team' ,
     CausedBy = 'The dbo.Customers table is empty' ,
     Problem = 'TPS report for California not working' ,
     ProposedSolution =
           'Restore dbo.Customers table from backup'
WHERE   TicketID = 123 ;
COMMIT ;

-- Listing 10-4: The SQL that was issued by Brian's bug tracking form
--Brian updates the form
BEGIN TRAN ;
UPDATE  dbo.Tickets
SET  AssignedTo = 'TPS report team' ,
     CausedBy = NULL ,
     Problem =
      'TPS report for California and Ohio not working' ,
     ProposedSolution = NULL
WHERE   TicketID = 123 ;
COMMIT ;

-- Listing 10-5: Brian proposes a poor solution, overwrites a much better one suggested by Arne.
UPDATE  dbo.Tickets
SET     Problem = 
      'TPS report for California and Ohio not working' ,
        ProposedSolution = 
    'Expose yesterdays'' TPS report instead of live one'
WHERE   TicketID = 123 ;

-- Listing 10-6: stored procedure only modifies if the ticket has not been changed.
CREATE PROCEDURE dbo.UpdateTicket
    @TicketID INT ,
    @Problem VARCHAR(50) ,
    @CausedBy VARCHAR(50) ,
    @ProposedSolution VARCHAR(50) ,
    @AssignedTo VARCHAR(50) ,
    @Status VARCHAR(50) ,
    @OldProblem VARCHAR(50) ,
    @OldCausedBy VARCHAR(50) ,
    @OldProposedSolution VARCHAR(50) ,
    @OldAssignedTo VARCHAR(50) ,
    @OldStatus VARCHAR(50)
AS 
    BEGIN ;
        SET NOCOUNT ON ;
        SET XACT_ABORT ON ;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;

        BEGIN TRANSACTION ;
        UPDATE  dbo.Tickets
        SET     Problem = @Problem ,
                CausedBy = @CausedBy ,
                ProposedSolution = @ProposedSolution ,
                AssignedTo = @AssignedTo ,
                Status = @Status
        WHERE   TicketID = @TicketID
                AND ( Problem = @OldProblem )
                AND ( AssignedTo = @OldAssignedTo )
                AND ( Status = @OldStatus ) 
                -- conditions for nullable columns 
                -- CausedBy and ProposedSolution
                -- are more complex
                AND ( CausedBy = @OldCausedBy
                      OR ( CausedBy IS NULL
                           AND @OldCausedBy IS NULL
                         )
                    )
                AND ( ProposedSolution =
                               @OldProposedSolution
                      OR ( ProposedSolution IS NULL
                        AND @OldProposedSolution IS NULL
                         )
                    ) ;
                    
        IF @@ROWCOUNT = 0 
            BEGIN ;
                ROLLBACK TRANSACTION ;
                RAISERROR('Ticker number %d not found
                 or modified after it was read',
                16, 1, @TicketID) ;
            END ;
        ELSE
            BEGIN ;
                COMMIT TRANSACTION ;
            END ;
    END ;

-- Listing 10-7: Deleting modified test data.
DELETE FROM dbo.Tickets ;

-- Listing 10-8: Using the UpdateTicket stored procedure to save Arne's changes.
EXECUTE dbo.UpdateTicket
   @TicketID = 123 
  ,@Problem = 'TPS report for California not working' 
  ,@CausedBy = 'The Customers table is empty' 
  ,@ProposedSolution =  'Restore Customers table
                         from backup' 
  ,@AssignedTo = 'DBA team' 
  ,@Status = 'Opened'
  ,@OldProblem = 'TPS report for California not working' 
  ,@OldCausedBy = NULL
  ,@OldProposedSolution = NULL
  ,@OldAssignedTo = 'TPS report team'
  ,@OldStatus = 'Opened' ;

-- Listing 10-9: Stored procedure detects a lost update and does not save Brian's changes.
EXECUTE dbo.UpdateTicket
  @TicketID = 123
  ,@Problem = 'TPS report for California and Ohio
               not working'
  ,@CausedBy = NULL
  ,@ProposedSolution = 'Expose yesterdays'' TPS report'
  ,@AssignedTo = 'TPS report team'
  ,@Status = 'Opened'
  ,@OldProblem = 'TPS report for California not working'
  ,@OldCausedBy = NULL
  ,@OldProposedSolution = NULL
  ,@OldAssignedTo = 'TPS report team'
  ,@OldStatus = 'Opened' ;

Msg 50000, Level 16, State 1, Procedure UpdateTicket, Line 47
Ticker number 123 modified after it was read

-- Listing 10-10: Adding a ROWVERSION column to the Tickets table
ALTER TABLE dbo.Tickets
  ADD CurrentVersion ROWVERSION NOT NULL ;

-- Listing 10-11: The UpdateTicket stored procedure saves changes only if the saved ROWVERSION matches the current ROWVERSION of the row being modified
ALTER PROCEDURE dbo.UpdateTicket
    @TicketID INT ,
    @Problem VARCHAR(50) ,
    @CausedBy VARCHAR(50) ,
    @ProposedSolution VARCHAR(50) ,
    @AssignedTo VARCHAR(50) ,
    @Status VARCHAR(50) ,
    @version ROWVERSION
AS 
    BEGIN ;
        SET NOCOUNT ON ;
        SET XACT_ABORT ON ;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
        BEGIN TRANSACTION ;
        UPDATE  dbo.Tickets
        SET     Problem = @Problem ,
                CausedBy = @CausedBy ,
                ProposedSolution = @ProposedSolution ,
                AssignedTo = @AssignedTo ,
                Status = @Status
        WHERE   TicketID = @TicketID
                AND CurrentVersion = @version ;
                    
        IF @@ROWCOUNT = 0 
            BEGIN ;
                ROLLBACK TRANSACTION ;
                RAISERROR('Ticker number %d not found
                  or modified after it was read',
                  16, 1, @TicketID) ;
            END ;
        ELSE 
            BEGIN ;
                COMMIT TRANSACTION ;
            END ;
    END ;

-- Listing 10-12: Detecting and preventing lost updates with ROWVERSION.
DECLARE @version ROWVERSION ;

-- both Brian and Arne retrieve the same version
SELECT  @version = CurrentVersion
FROM    dbo.Tickets
WHERE   TicketID = 123 ;

-- Arne saves his changes
EXECUTE dbo.UpdateTicket @TicketID = 123,
  @Problem = 'TPS report for California not working',
  @CausedBy = 'The dbo.Customers table is empty',
  @ProposedSolution = 'Restore dbo.Customers table from
                       backup',
  @AssignedTo = 'DBA team', 
  @Status = 'Opened', 
  @version = @version ;

-- Brian tries to save his changes
EXECUTE dbo.UpdateTicket @TicketID = 123,
  @Problem = 'TPS report for California and Ohio not
              working',
  @CausedBy = NULL,
  @ProposedSolution = 'Expose yesterdays'' TPS report',
  @AssignedTo = 'TPS report team', 
  @Status = 'Opened', 
  @version = @version ;

-- Verify that Arne's changes are intact
SELECT ProposedSolution
FROM   dbo.Tickets
WHERE  TicketID = 123;

-- Listing 10-13: Adding test data.
DELETE  FROM dbo.Tickets ;

INSERT  INTO dbo.Tickets
        ( TicketID ,
          Problem ,
          CausedBy ,
          ProposedSolution ,
          AssignedTo ,
          Status
        )
VALUES  ( 123 , 
          'TPS report for California not working' , 
          NULL , 
          'Restored Customers table from backup' , 
          'DBA team' , 
          'Closed'
        ) ; 

-- Listing 10-14: Opening transaction and reading ticket number 123.
SET TRANSACTION ISOLATION LEVEL SNAPSHOT ;
SET XACT_ABORT ON ;
BEGIN TRANSACTION ;

SELECT  TicketID ,
        Problem ,
        CausedBy ,
        ProposedSolution ,
        AssignedTo ,
        Status
FROM    dbo.Tickets
WHERE   TicketID = 123 ; 

/*
DELETE dbo.Tickets 
WHERE   TicketID = 123 ; 
COMMIT TRANSACTION ;
*/

-- Listing 10-15: Ticket number 123 is modified.
SET NOCOUNT OFF ;
UPDATE  dbo.Tickets 
SET     AssignedTo = 'ETL team' ,
        CausedBy = 'ETL truncates Customers table' ,
        Problem = 'TPS report for California not working' ,
        ProposedSolution = 'Fix ETL' ,
        Status = 'Opened'
WHERE   TicketID = 123 ;

-- Listing 10-17. Reading ticket 123 with UPDLOCK hint.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
SET XACT_ABORT ON ;
BEGIN TRANSACTION ;

SELECT  TicketID ,
        Problem ,
        CausedBy ,
        ProposedSolution ,
        AssignedTo ,
        Status 
FROM    dbo.Tickets WITH(UPDLOCK) 
WHERE   TicketID = 123 ; 

--DELETE dbo.Tickets 
--WHERE   TicketID = 123 ; 
--COMMIT TRANSACTION ;

-- Listing 10-18: Begin a transaction and acquire an application lock.
-- run this script in the first tab
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;

BEGIN TRANSACTION ; 

DECLARE @ret INT ;
SET @ret = NULL ;
EXEC @ret = sp_getapplock @Resource = 'TicketID = 123',
    @LockMode = 'Exclusive', @LockTimeout = 1000 ;

-- sp_getapplock return code values are: 
-- >= 0 (success), or < 0 (failure)
IF @ret < 0 
    BEGIN;
        RAISERROR('Failed to acquire lock', 16, 1) ;
        ROLLBACK ;
    END ;

--DELETE dbo.Tickets 
--WHERE   TicketID = 123 ; 
--COMMIT TRANSACTION ;

-- Listing 10-19: Begin a transaction, attempt to acquire an application lock and modify the ticket being archived, if the application lock has been acquired
-- run this script in the second tab
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;

BEGIN TRANSACTION ; 

DECLARE @ret INT ;
SET @ret = NULL ;

-- The @LockTimeout setting makes sp_getapplock
-- wait for 10 seconds for other connections 
-- to release the lock on ticket number 123
EXEC @ret = sp_getapplock @Resource = 'TicketID = 123',
    @LockMode = 'Exclusive', @LockTimeout = 10000 ;

-- sp_getapplock return code values are: 
-- >= 0 (success), or < 0 (failure)
IF @ret < 0 
    BEGIN ;
        RAISERROR('Failed to acquire lock', 16, 1) ;
        ROLLBACK ;
    END ;
ELSE 
    BEGIN ;

        UPDATE  dbo.Tickets
        SET     AssignedTo = 'TPS report team' ,
                CausedBy = 'Bug in TPS report' ,
                Problem = 'TPS report truncates
                           dbo.Customers' ,
                ProposedSolution = 'Fix TPS report' ,
                Status = 'Reopen'
        WHERE   TicketID = 123 ;

        IF @@ROWCOUNT = 0 
            BEGIN ;
                RAISERROR('Ticket not found', 16, 1) ;
            END ;	

        COMMIT ;

    END ;

-- Listing 10-20: Create and populate the WebPageStats table
CREATE TABLE dbo.WebPageStats
    (
      WebPageID INT NOT NULL PRIMARY KEY,
      NumVisits INT NOT NULL ,
      NumAdClicks INT NOT NULL ,
      version ROWVERSION NOT NULL
     ) ;
GO

SET NOCOUNT ON ;
INSERT  INTO dbo.WebPageStats
        ( WebPageID, NumVisits, NumAdClicks )
VALUES  ( 0, 0, 0 ) ;

DECLARE @i INT ;
SET @i = 1 ;
WHILE @i < 1000000  
    BEGIN ;
        INSERT  INTO dbo.WebPageStats
                ( WebPageID ,
                  NumVisits ,
                  NumAdClicks 
                )
                SELECT  WebPageID + @i ,
                        NumVisits ,
                        NumAdClicks
                FROM    dbo.WebPageStats ;
        SET @i = @i * 2 ;
    END ;
GO

-- Listing 10-21: Inserting or updating rows in a loop
-- hit Ctrl+T to execute in text mode
SET NOCOUNT ON ;
DECLARE @WebPageID INT ,
    @MaxWebPageID INT ;
SET @WebPageID = 0 ;

SET @MaxWebPageID = ( SELECT    MAX(WebPageID)
                      FROM      dbo.WebPageStats
                    ) + 100000 ;

WHILE @WebPageID < @MaxWebPageID 
    BEGIN ;
        SET @WebPageID = ( SELECT   MAX(WebPageID)
                           FROM     dbo.WebPageStats
                         ) + 1 ;
        BEGIN TRY ;
            BEGIN TRANSACTION ;
            IF EXISTS ( SELECT  *
                        FROM
                        dbo.WebPageStats --WITH(UPDLOCK)
                        WHERE   WebPageID = @WebPageID )
                BEGIN ;
                    UPDATE  dbo.WebPageStats
                    SET     NumVisits = 1
                    WHERE   WebPageID = @WebPageID ;
                END ;
            ELSE 
                BEGIN ;
                    INSERT  INTO dbo.WebPageStats
                   ( WebPageID, NumVisits, NumAdClicks )
                    VALUES  ( @WebPageID, 0, 0 ) ;
                END ;
            COMMIT TRANSACTION ;
        END TRY
        BEGIN CATCH ;
            SELECT  ERROR_MESSAGE() ;
            ROLLBACK TRANSACTION ;
        END CATCH ;
    END ; 

-- Listing 10-22: Create the dbo.UpdateWebPageStats stored procedure
CREATE PROCEDURE dbo.UpdateWebPageStats
    @WebPageID INT ,
    @NumVisits INT ,
    @NumAdClicks INT ,
    @version ROWVERSION
AS 
    BEGIN ;
        SET NOCOUNT ON ;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
        SET XACT_ABORT ON ;
        DECLARE @ret INT ;
        BEGIN TRANSACTION ;
        IF EXISTS ( SELECT  * 
                    FROM    dbo.WebPageStats
                    WHERE   WebPageID = @WebPageID
                            AND version = @version ) 
            BEGIN ;
                UPDATE  dbo.WebPageStats
                SET     NumVisits = @NumVisits ,
                        NumAdClicks = @NumAdClicks
                WHERE   WebPageID = @WebPageID ;

                SET @ret = 0 ;
            END ;
        ELSE 
            BEGIN ;
                SET @ret = 1 ;
            END ;
        COMMIT ;
        RETURN @ret ;
    END ; 

-- Listing 10-23: Invoke UpdateWebPageStats to increment NumVisits for one and the same row 10,000 times in a loop
DECLARE @NumVisits INT ,
    @NumAdClicks INT ,
    @version ROWVERSION ,
    @count INT ,
    @ret INT ;
SET @count = 0 ;
WHILE @count < 10000 
    BEGIN ;
        SELECT  @NumVisits = NumVisits + 1 ,
                @NumAdClicks = NumAdClicks ,
                @version = version
        FROM    dbo.WebPageStats
        WHERE   WebPageID = 5 ;
        EXEC @ret = dbo.UpdateWebPageStats 5,
                    @NumVisits, @NumAdClicks, @version ;
        IF @ret = 0
            SET @count = @count + 1 ;
    END ;

-- Listing 10-24: A loop that invokes UpdateWebPageStats to increment NumAdClicks for the same row 10,000 times
DECLARE @NumVisits INT ,
    @NumAdClicks INT ,
    @version ROWVERSION ,
    @count INT ,
    @ret INT ;
SET @count = 0 ;
WHILE @count < 10000 
    BEGIN ;
        SELECT  @NumVisits = NumVisits ,
                @NumAdClicks = NumAdClicks + 1 ,
                @version = version
        FROM    dbo.WebPageStats
        WHERE   WebPageID = 5 ;
        EXEC @ret = dbo.UpdateWebPageStats 5,
                    @NumVisits, @NumAdClicks, @version ;
        IF @ret = 0
            SET @count = @count + 1 ;
    END ;

-- Listing 10-25: NumVisits and NumAdClicks should both be 10000, but they do not have the expected values
SELECT  NumVisits ,
        NumAdClicks
FROM    dbo.WebPageStats
WHERE   WebPageID = 5 ;

-- Listing 10-26: A loop that uses the UPDATE … IF (@@ROWCOUNT = 0) pattern
-- hit Ctrl+T to execute in text mode
SET NOCOUNT ON ;
DECLARE @WebPageID INT ,
    @MaxWebPageID INT ;
SET @WebPageID = 0 ;

SET @MaxWebPageID = ( SELECT    MAX(WebPageID)
                      FROM      dbo.WebPageStats
                    ) + 100000 ;

WHILE @WebPageID < @MaxWebPageID 
    BEGIN ;
        SET @WebPageID = ( SELECT   MAX(WebPageID)
                           FROM     dbo.WebPageStats
                         ) + 1 ;
        BEGIN TRY ;
            BEGIN TRANSACTION ;
            UPDATE  dbo.WebPageStats
            SET     NumVisits = 1
            WHERE   WebPageID = @WebPageID ;

            IF ( @@ROWCOUNT = 0 ) 
                BEGIN ;
                    INSERT  INTO dbo.WebPageStats
                   ( WebPageID, NumVisits, NumAdClicks )
                    VALUES  ( @WebPageID, 0, 0 ) ;
                END ;
            COMMIT TRANSACTION ;
        END TRY
        BEGIN CATCH ;
            SELECT  ERROR_MESSAGE() ;
            ROLLBACK TRANSACTION ;
        END CATCH ;
    END ; 

-- Listing 10-27: Implement our loop using the MERGE command
-- hit Ctrl+T to execute in text mode
SET NOCOUNT ON ;
DECLARE @WebPageID INT ,
    @MaxWebPageID INT ;
SET @WebPageID = 0 ;

SET @MaxWebPageID = ( SELECT    MAX(WebPageID)
                      FROM      dbo.WebPageStats
                    ) + 100000 ;

WHILE @WebPageID < @MaxWebPageID 
    BEGIN ;
        SET @WebPageID = ( SELECT   MAX(WebPageID)
                           FROM     dbo.WebPageStats
                         ) + 1 ;
        BEGIN TRY ;
            BEGIN TRANSACTION ;
            
            MERGE dbo.WebPageStats --WITH (HOLDLOCK)
                AS target
                USING 
                    ( SELECT    @WebPageID 
                     ) AS source ( WebPageID  )
                ON (target.WebPageID = source.WebPageID)
                WHEN MATCHED 
                    THEN 
                      UPDATE SET NumVisits = 1
                WHEN NOT MATCHED 
                    THEN	
                      INSERT( WebPageID, NumVisits,
                             NumAdClicks )
                         VALUES
                          ( @WebPageID ,
                            0 ,
                            0 
                          ) ;
            COMMIT TRANSACTION ;
        END TRY
        BEGIN CATCH ;
            SELECT  ERROR_MESSAGE() ;
            ROLLBACK TRANSACTION ;
        END CATCH ;
    END ; 

-- Listing 10-28: Creating the ChildTable table.
CREATE TABLE dbo.ChildTable
    (
      ChildID INT NOT NULL ,
      ParentID INT NOT NULL ,
      Amount INT NOT NULL ,
      CONSTRAINT PK_ChildTable PRIMARY KEY ( ChildID )
    ) ;

-- Listing 10-29: The modification to run in the first tab
BEGIN TRAN ;
INSERT  INTO dbo.ChildTable
        ( ChildID, ParentID, Amount )
VALUES  ( 1, 1, 1 ) ;
-- ROLLBACK TRAN ;

-- Listing 10-30: The modification to run in the second tab

BEGIN TRAN ;
INSERT  INTO dbo.ChildTable
        ( ChildID, ParentID, Amount )
VALUES  ( 2, 1, 1 ) ;
ROLLBACK TRAN ;

-- Listing 10-31: Create the indexed view
CREATE VIEW dbo.ChildTableTotals WITH SCHEMABINDING
AS
SELECT ParentID, 
COUNT_BIG(*) AS ChildRowsPerParent, 
SUM(Amount) AS SumAmount
FROM dbo.ChildTable
GROUP BY ParentID ;
GO

CREATE UNIQUE CLUSTERED INDEX ChildTableTotals_CI 
ON dbo.ChildTableTotals(ParentID) ;
