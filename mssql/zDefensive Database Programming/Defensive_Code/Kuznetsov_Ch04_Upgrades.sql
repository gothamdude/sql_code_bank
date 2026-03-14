-- Listing 4-1: Enabling snapshot isolation
-- Replace Test with the name of your database
-- in both commands and make sure that no other
-- connections are accessing the database

-- as a result of this command,
-- READ_COMMITTED_SNAPSHOT becomes 
-- the default isolation level.
ALTER DATABASE Test  SET READ_COMMITTED_SNAPSHOT ON ;
GO

-- as a result of this command,
-- we can explitly specify that SNAPSHOT is 
-- the current isolation level,
-- but it does not affect the default behaviour.
ALTER DATABASE Test  SET ALLOW_SNAPSHOT_ISOLATION ON ;
GO

-- Listing 4-2: Creating and populating TestTable
CREATE TABLE dbo.TestTable
    (
      ID INT NOT NULL
             PRIMARY KEY ,
      Comment VARCHAR(100) NOT NULL
    ) ;
GO
INSERT  INTO dbo.TestTable
        ( ID ,
          Comment
        )
VALUES  ( 1 ,
          'row committed before transaction began'
        ) ;

-- Listing 4-3: Tab 1, an open transaction that inserts a row into TestTable
BEGIN TRANSACTION ;
INSERT  INTO dbo.TestTable
        ( ID ,
          Comment
        )
VALUES  ( 2 ,
          'row committed after transaction began'
        ) ;
        
-- COMMIT ;        

-- Listing 4-4: Tab2, when not using Snapshot isolation, a query is blocked by Tab1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

SELECT  ID ,
        Comment
FROM    dbo.TestTable ;
-- This statement hangs in lock waiting state.
-- Cancel the query.

-- Listing 4-5: Tab2, when using SNAPSHOT isolation, the same query completes
IF @@TRANCOUNT = 0 
    BEGIN ;
        SET TRANSACTION ISOLATION LEVEL SNAPSHOT ;
        PRINT 'Beginning transaction' ;
        BEGIN TRANSACTION ; 
    END ;

SELECT  ID ,
        Comment
FROM    dbo.TestTable ;
--COMMIT ;

-- Listing 4-6: Tab3, when using READ_COMMITTED_SNAPSHOT isolation, the query also completes
IF @@TRANCOUNT = 0 
    BEGIN ;
-- this is actually READ_COMMITTED_SNAPSHOT because
-- we have already set READ_COMMITTED_SNAPSHOT to ON
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
        PRINT 'Beginning transaction' ;
        BEGIN TRANSACTION ; 
    END ;

SELECT  ID ,
        Comment
FROM    dbo.TestTable ;

--COMMIT ;

-- Listing 4-7: Creating the Developers and Tickets tables
CREATE TABLE dbo.Developers
  (
    DeveloperID INT NOT NULL ,
    FirstName VARCHAR(30) NOT NULL ,
    Lastname VARCHAR(30) NOT NULL ,
    Status VARCHAR(10) NOT NULL ,
    CONSTRAINT PK_Developers PRIMARY KEY (DeveloperID) ,
    CONSTRAINT CHK_Developers_Status CHECK ( Status IN
                                           ( 'Active',
                                          'Vacation' ) )
    ) ; 
GO 
CREATE TABLE dbo.Tickets
  (
    TicketID INT NOT NULL ,
    AssignedToDeveloperID INT NULL ,
    Description VARCHAR(50) NOT NULL ,
    Status VARCHAR(10) NOT NULL ,
    CONSTRAINT PK_Tickets PRIMARY KEY ( TicketID ) ,
    CONSTRAINT FK_Tickets_Developers
      FOREIGN KEY ( AssignedToDeveloperID )
        REFERENCES dbo.Developers ( DeveloperID ) ,
    CONSTRAINT CHK_Tickets_Status
      CHECK ( Status IN ( 'Active', 'Closed' ) )
    ) ;

-- Listing 4-8: The Developers_Upd trigger
CREATE  TRIGGER dbo.Developers_Upd ON dbo.Developers
    AFTER UPDATE
AS
    BEGIN ; 
        IF EXISTS ( SELECT  * 
                    FROM    inserted AS i
                            INNER JOIN dbo.Tickets AS t
                            ON i.DeveloperID = 
                              t.AssignedToDeveloperID
                    WHERE   i.Status = 'Vacation'
                            AND t.Status = 'Active' ) 
            BEGIN ;

-- this string has been wrapped for readability here
-- it appears on a single line in the code download file
                RAISERROR ('Developers must assign their
                              active tickets to someone
                              else before going on
                              vacation', 16, 1 ) ; 
                ROLLBACK ; 
            END ; 
    END ; 

-- Listing 4-9: The Tickets_Upd trigger
CREATE TRIGGER dbo.Tickets_Upd ON dbo.Tickets
    AFTER UPDATE
AS
    BEGIN ;
        IF EXISTS (SELECT *
                    FROM  inserted AS i
                          INNER JOIN dbo.Developers AS d 
                          ON i.AssignedToDeveloperID = 
                                          d.DeveloperID
                    WHERE   d.Status = 'Vacation'
                            AND i.Status = 'Active' ) 
            BEGIN ;
                RAISERROR ( 'Cannot change status to 
                                Active if the developer in
                                charge is on vacation',
                             16, 1 ) ; 
                ROLLBACK ; 
            END ; 
    END ;

-- Listing 4-10: Make sure that READ_COMMITTED_SNAPSHOT is turned off
-- Replace Test with the name of your database
-- it must not be tempdb

-- Before running this code, close or disconnect any 
-- tabs conneted to the same database

ALTER DATABASE Test SET READ_COMMITTED_SNAPSHOT OFF ;

-- Listing 4-11: Adding test data to the Developers and Tickets tables
INSERT  INTO dbo.Developers
        (
          DeveloperID,
          FirstName,
          Lastname,
          Status
        )
        SELECT  1,
                'Arnie',
                'Brown',
                'Active'
        UNION ALL
        SELECT  2,
                'Carol',
                'Dale',
                'Active' ; 
GO 
INSERT  INTO dbo.Tickets
        (
          TicketID,
          AssignedToDeveloperID,
          Description,
          Status
        )
        SELECT  1,
                1,
                'Order entry form blows up',
                'Active'
        UNION ALL
        SELECT  2,
                2,
                'Incorrect totals in monthly report',
                'Closed' ;

-- Listing 4-12: Testing the Developers_Upd trigger
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;
UPDATE  dbo.Developers
SET     Status = 'Vacation'
WHERE   DeveloperID = 1 ;

-- Listing 4-13: Testing out the Tickets_Upd trigger
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ;

-- make sure Carol's ticket is closed
UPDATE  dbo.Tickets
SET     Status = 'Closed'
WHERE   TicketID = 2 ; 

-- Carol can now go on vacation
UPDATE  dbo.Developers
SET     Status = 'Vacation'
WHERE   DeveloperID = 2 ; 

-- can we reopen Carol's ticket?
UPDATE  dbo.Tickets
SET     Status = 'Active'
WHERE   TicketID = 2 ;

-- Listing 4-14: Arnie is on vacation, but the change has not committed yet
-- Tab 1
-- reset the test data; close Arnie's ticket
UPDATE  dbo.Tickets
SET     Status = 'Closed'
WHERE   TicketID = 1 ; 

-- start the transaction that sends Arnie on vacation
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ; 
BEGIN TRANSACTION ;  
UPDATE  dbo.Developers
SET     Status = 'Vacation'
WHERE   DeveloperID = 1 ;

-- COMMIT ;

-- Listing 4-15: Attempting to reopen a ticket assigned to Arnie
-- Tab 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED ; 
BEGIN TRANSACTION ;  
UPDATE  dbo.Tickets
SET     Status = 'Active'
WHERE   TicketID = 1 ;

-- COMMIT ;

-- Listing 4-16: The code in the Tab 1 begins a transaction to set Arnie's status to Vacation
-- Tab 1
SET TRANSACTION ISOLATION LEVEL SNAPSHOT ; 

-- reset the  test data 
UPDATE  dbo.Tickets
SET     Status = 'Closed'
WHERE   TicketID = 1 ; 
UPDATE  dbo.Developers
SET     Status = 'Active'
WHERE   DeveloperID = 1 ;  

-- begin the transaction
BEGIN TRANSACTION ;  
UPDATE  dbo.Developers
SET     Status = 'Vacation'
WHERE   DeveloperID = 1 ; 

-- COMMIT ; 

-- Listing 4-17: The code in Tab 2 starts a transaction to reopen a ticket that is assigned to Arnie
-- Tab 2
SET TRANSACTION ISOLATION LEVEL SNAPSHOT ; 
BEGIN TRANSACTION ;  
UPDATE  dbo.Tickets
SET     Status = 'Active'
WHERE   TicketID = 1 ;  

-- COMMIT ;

-- Listing 4-18: Data integrity is violated; we have an active ticket assigned to the developer who is on vacation
SELECT  d.DeveloperID,
        d.Status AS DeveloperStatus,
        t.TicketID,
        t.Status AS TicketStatus
FROM    dbo.Developers AS d
        INNER JOIN dbo.Tickets AS t
            ON t.AssignedToDeveloperID = d.DeveloperID ;

-- Listing 4-19: Modifying the Tickets_Upd trigger
ALTER TRIGGER dbo.Tickets_Upd ON dbo.Tickets
    AFTER UPDATE
AS
    BEGIN ;
        SELECT  d.DeveloperID ,
                d.Status AS DeveloperStatus ,
                t.TicketID ,
                t.Status AS TicketStatus
        FROM    dbo.Developers AS d
                 INNER JOIN inserted AS t
            ON t.AssignedToDeveloperID = d.DeveloperID ;

        IF EXISTS (SELECT *
                    FROM  inserted AS i
                          INNER JOIN dbo.Developers AS d 
                          ON i.AssignedToDeveloperID = 
                                          d.DeveloperID
                    WHERE   d.Status = 'Vacation'
                            AND i.Status = 'Active' ) 
            BEGIN ;
                RAISERROR ( 'Cannot change status to 
                               Active if the developer in
                               charge is on vacation',
                             16, 1 ) ; 
                ROLLBACK ; 
            END ; 
    END ;

-- Listing 4-20: The Tickets_Upd trigger does not see the uncommitted changes from the other transaction
SET TRANSACTION ISOLATION LEVEL SNAPSHOT ; 
BEGIN TRANSACTION ;  
UPDATE  dbo.Tickets
SET     Status = 'Active'
WHERE   TicketID = 1 ;

-- COMMIT ;

-- Listing 4-21: Adding the READCOMMITTEDLOCK hint to the Tickets_Upd trigger
ALTER TRIGGER dbo.Tickets_Upd ON dbo.Tickets
    AFTER UPDATE
AS
    BEGIN ;
        IF EXISTS (SELECT *
                    FROM  inserted AS i
                          INNER JOIN dbo.Developers AS d
                            WITH ( READCOMMITTEDLOCK )
                          ON i.AssignedToDeveloperID = 
                                          d.DeveloperID
                    WHERE   d.Status = 'Vacation'
                            AND i.Status = 'Active' ) 
            BEGIN ;
                RAISERROR ( 'Cannot change status to 
                                Active if the developer in
                                charge is on vacation',
                             16, 1 ) ; 
                ROLLBACK ; 
            END ; 
    END ;

-- Listing 4-22: The FrontPageArticles table, with test data
CREATE TABLE dbo.FrontPageArticles
    (
      ArticleID INT NOT NULL PRIMARY KEY ,
      Title VARCHAR(30) NOT NULL ,
      Author VARCHAR(30) NULL ,
      NumberOfViews INT NOT NULL
    ) ;
GO
INSERT  dbo.FrontPageArticles
        ( ArticleID ,
          Title ,
          Author ,
          NumberOfViews
        )
VALUES  ( 1 ,
          'Road Construction on Rt 59' ,
          'Lynn Lewis' ,
          0
        ) ;

-- Listing 4-23: Demonstrating the MERGE command (SQL 2008 and upwards)
MERGE dbo.FrontPageArticles AS target
    USING 
        ( SELECT  1 AS ArticleID ,
                  'Road Construction on Rt 53' AS Title
          UNION ALL
          SELECT  2 AS ArticleID ,
                  'Residents are reaching out' AS Title
        ) AS source ( ArticleID, Title )
    ON ( target.ArticleID = source.ArticleID )
    WHEN MATCHED 
        THEN  UPDATE
          SET  Title = source.Title
    WHEN NOT MATCHED 
        THEN INSERT
                     (
                      ArticleID ,
                      Title ,
                      NumberOfViews
                     )
             VALUES  ( source.ArticleID ,
                      source.Title ,
                      0
                     ) ;
SELECT  ArticleID ,
        Title ,
        NumberOfViews
FROM    dbo.FrontPageArticles ; 

-- Listing 4-24: Creating the CannotDeleteMoreThanOneRow trigger
CREATE TRIGGER CannotDeleteMoreThanOneArticle 
  ON dbo.FrontPageArticles
    FOR DELETE
AS
    BEGIN ;
        IF @@ROWCOUNT > 1 
            BEGIN ;
                RAISERROR ( 'Cannot Delete More Than One
                               Row', 16, 1 ) ; 
            END ; 
    END ; 

-- Listing 4-25: Our trigger allows us to delete one row, but prevents us from deleting two rows
-- this fails. We cannot delete more than one row:
BEGIN TRY ;
    BEGIN TRAN ;
    DELETE  FROM dbo.FrontPageArticles ;
    PRINT 'Previous command failed;this will not print';
    COMMIT ;
END TRY
BEGIN CATCH ;
    SELECT  ERROR_MESSAGE() ;
    ROLLBACK ;
END CATCH ;

-- this succeeds:  
BEGIN TRY ;
    BEGIN TRAN ;
    DELETE  FROM dbo.FrontPageArticles
    WHERE   ArticleID = 1 ;
    PRINT 'The second DELETE completed' ;
-- we are rolling back the change, because
-- we still need the original data in the next listing 
    ROLLBACK ; 
END TRY
BEGIN CATCH ;
    SELECT  ERROR_MESSAGE() ;
    ROLLBACK ;
END CATCH ;
-- Listing 4-26: The MERGE command intends to delete only one row (and to modify another one) but falls foul of our trigger.
BEGIN TRY ;
    BEGIN TRAN ;
    
    MERGE dbo.FrontPageArticles AS target
        USING 
            ( SELECT  2 AS ArticleID ,
                  'Residents are reaching out!' AS Title
            ) AS source ( ArticleID, Title )
        ON ( target.ArticleID = source.ArticleID )
        WHEN MATCHED 
            THEN UPDATE
            SET Title = source.Title
        WHEN NOT MATCHED BY SOURCE 
            THEN DELETE ;

    PRINT 'MERGE Completed' ;

    SELECT  ArticleID ,
            Title ,
            NumberOfViews
    FROM    dbo.FrontPageArticles ;

-- we are rolling back the change, because
-- we still need the original data in the next examples.
    ROLLBACK ; 
END TRY
BEGIN CATCH ;
    SELECT  ERROR_MESSAGE() ;
    ROLLBACK ;
END CATCH ;

-- Listing 4-27: Dropping the trigger before rerunning the MERGE command
DROP TRIGGER dbo.CannotDeleteMoreThanOneArticle ;

-- Listing 4-28: The improved trigger 
CREATE TRIGGER CannotDeleteMoreThanOneArticle
  ON dbo.FrontPageArticles
    FOR DELETE
AS
    BEGIN ;

-- these two queries are provided for better
-- understanding of the contents of inserted and deleted
-- virtual tables.
-- They should be removed before deploying!
        SELECT  ArticleID ,
                Title
        FROM    inserted ;
        
        SELECT  ArticleID ,
                Title
        FROM    deleted ;    

        IF ( SELECT COUNT(*)
             FROM   deleted 
           ) > 1 
            BEGIN ;
                RAISERROR ( 'Cannot Delete More Than One
                               Row', 16, 1 ) ; 
            END ; 
    END ; 
