-- Listing 1-1: Creating and populating the Messages table and stored procedure
CREATE TABLE dbo.Messages
    (
      MessageID INT IDENTITY(1,1) NOT NULL
                                   PRIMARY KEY,
      Subject VARCHAR(30) NOT NULL ,
      Body VARCHAR(100) NOT NULL
    ) ;
GO

INSERT  INTO dbo.Messages
        ( Subject ,
          Body 
        )
        SELECT  'Next release delayed' ,
                'Still fixing bugs'
        UNION ALL
        SELECT  'New printer arrived' ,
                'By the kitchen area' ;
GO

CREATE PROCEDURE dbo.SelectMessagesBySubjectBeginning
    @SubjectBeginning VARCHAR(30)
AS 
    SET NOCOUNT ON ; 
    SELECT  Subject ,
            Body
    FROM    dbo.Messages
    WHERE   Subject LIKE @SubjectBeginning + '%' ;

-- Listing 1-2: A few simple tests against the provided test data

-- must return one row
EXEC dbo.SelectMessagesBySubjectBeginning
  @SubjectBeginning='Next';

-- must return one row
EXEC dbo.SelectMessagesBySubjectBeginning
  @SubjectBeginning='New';

-- must return two rows
EXEC dbo.SelectMessagesBySubjectBeginning
  @SubjectBeginning='Ne';

-- must return nothing
EXEC dbo.SelectMessagesBySubjectBeginning
  @SubjectBeginning='No Such Subject';

-- Listing 1-3: Our procedure fails to return "off topic" messages
INSERT  INTO dbo.Messages
        ( Subject ,
          Body
        )
        SELECT  '[OT] Great vacation in Norway!' ,
                'Pictures already uploaded'
        UNION ALL
        SELECT  '[OT] Great new camera' ,
                'Used it on my vacation' ;
GO
-- must return two rows
EXEC dbo.SelectMessagesBySubjectBeginning
    @SubjectBeginning = '[OT]' ;

-- Listing 1-4: Our procedure returns the wrong messages when the search pattern contains [OT]
INSERT  INTO dbo.Messages
        ( Subject ,
          Body
        )
        SELECT  'Ordered new water cooler' ,
                'Ordered new water cooler' ;
EXEC dbo.SelectMessagesBySubjectBeginning
    @SubjectBeginning = '[OT]' ;

-- Listing 1-5: Our stored procedure returns the wrong messages if the pattern contains %
INSERT  INTO dbo.Messages
        ( Subject ,
          Body
        )
        SELECT  '50% bugs fixed for V2' ,
                'Congrats to the developers!'
        UNION ALL
        SELECT  '500 new customers in Q1' ,
                'Congrats to all sales!' ;
GO
	
EXEC dbo.SelectMessagesBySubjectBeginning
    @SubjectBeginning = '50%' ;


-- Listing 1-6: Enforcing the "no special characters" assumption
BEGIN TRAN ;
DELETE  FROM dbo.Messages
WHERE   Subject LIKE '%[[]%'
        OR Subject LIKE '%[%]%' ;

ALTER TABLE dbo.Messages
ADD CONSTRAINT Messages_NoSpecialsInSubject
    CHECK(Subject NOT LIKE '%[[]%' 
      AND Subject NOT LIKE '%[%]%') ;

ROLLBACK TRAN ; 

-- Listing 1-7: Eliminating the "no special characters" assumption
ALTER PROCEDURE dbo.SelectMessagesBySubjectBeginning
    @SubjectBeginning VARCHAR(50)
AS 
    SET NOCOUNT ON ;
    DECLARE @ModifiedSubjectBeginning VARCHAR(150) ;
  SET @ModifiedSubjectBeginning = 
            REPLACE(REPLACE(@SubjectBeginning,
                           '[',
                           '[[]'),
                   '%',
                   '[%]') ;
    SELECT  @SubjectBeginning AS [@SubjectBeginning] ,
            @ModifiedSubjectBeginning AS 
                         [@ModifiedSubjectBeginning] ;
    SELECT  Subject ,
            Body
    FROM    dbo.Messages
    WHERE   Subject LIKE @ModifiedSubjectBeginning + '%' ;
GO

-- Listing 1-8: Our search now correctly handles [ ] and %

-- must return two rows
EXEC dbo.SelectMessagesBySubjectBeginning
  @SubjectBeginning = '[OT]' ;

-- must return one row
EXEC dbo.SelectMessagesBySubjectBeginning
  @SubjectBeginning='50%';

-- Listing 1-9: Creating and populating the Objects table
CREATE TABLE dbo.Objects
    (
      ObjectID INT NOT NULL PRIMARY KEY ,
      SizeInInches FLOAT NOT NULL ,
      WeightInPounds FLOAT NOT NULL
    ) ;
GO
INSERT  INTO dbo.Objects
        ( ObjectID ,
          SizeInInches ,
          WeightInPounds
        )
        SELECT  1 ,
                10 ,
                10
        UNION ALL
        SELECT  2 ,
                12 ,
                12
        UNION ALL
        SELECT  3 ,
                20 ,
                22 ;
GO

-- Listing 1-10: Logging updates to the Objects table
CREATE TABLE dbo.ObjectsChangeLog
  (
    ObjectsChangeLogID INT NOT NULL
                           IDENTITY ,
    ObjectID INT NOT NULL ,
    ChangedColumnName VARCHAR(20) NOT NULL ,
    ChangedAt DATETIME NOT NULL ,
    OldValue FLOAT NOT NULL ,
    CONSTRAINT PK_ObjectsChangeLog PRIMARY KEY 
                               ( ObjectsChangeLogID )
  ) ;
 GO

CREATE TRIGGER Objects_UpdTrigger ON dbo.Objects
  FOR UPDATE
AS
  BEGIN; 
    INSERT  INTO dbo.ObjectsChangeLog
            ( ObjectID ,
              ChangedColumnName ,
              ChangedAt ,
              OldValue
                
            )
            SELECT  i.ObjectID ,
                    'SizeInInches' ,
                    CURRENT_TIMESTAMP ,
                    d.SizeInInches
            FROM    inserted AS i
                    INNER JOIN deleted AS d ON 
                        i.ObjectID = d.ObjectID
            WHERE   i.SizeInInches <> d.SizeInInches
            UNION ALL
            SELECT  i.ObjectID ,
                    'WeightInPounds' ,
                    CURRENT_TIMESTAMP ,
                    d.WeightInPounds
            FROM    inserted AS i
                    INNER JOIN deleted AS d ON 
                        i.ObjectID = d.ObjectID
            WHERE i.WeightInPounds <> d.WeightInPounds ;
  END ; 

-- Listing 1-11: Testing the trigger
BEGIN TRAN ;

-- TRUNCATE TABLE can also be used here
DELETE  FROM dbo.ObjectsChangeLog ;
 
UPDATE  dbo.Objects
SET     SizeInInches = 12 ,
        WeightInPounds = 14
WHERE   ObjectID = 1 ;

-- we are selecting just enough columns 
-- to demonstrate that the trigger works

SELECT  ObjectID ,
        ChangedColumnName ,
        OldValue
FROM    dbo.ObjectsChangeLog ;

-- we do not want to change the data,
-- only to demonstrate how the trigger works
ROLLBACK ;
-- the data has not been modified by this script

-- Listing 1-12: Breaking the trigger by changing the value of ROWCOUNT
DELETE  FROM dbo.ObjectsChangeLog ;

SET ROWCOUNT 1 ;
-- do some other operation(s) 
-- for which we needed to set rowcount to 1
-- do not restore ROWCOUNT setting
-- to its default value
BEGIN TRAN ;

UPDATE  dbo.Objects
SET     SizeInInches = 12 ,
        WeightInPounds = 14
WHERE   ObjectID = 1 ;

-- make sure to restore ROWCOUNT setting
-- to its default value so that it does not affect the
-- following SELECT

SET ROWCOUNT 0 ;

SELECT  ObjectID ,
        ChangedColumnName ,
        OldValue
FROM    dbo.ObjectsChangeLog ;

ROLLBACK ;

-- Listing 1-13: Resetting ROWCOUNT at the start of the trigger
ALTER TRIGGER dbo.Objects_UpdTrigger ON dbo.Objects
    FOR UPDATE
AS
    BEGIN;
-- the scope of this setting is the body of the trigger
        SET ROWCOUNT 0 ;
        INSERT  INTO dbo.ObjectsChangeLog
                ( ObjectID ,
                  ChangedColumnName ,
                  ChangedAt ,
                  OldValue
                )
                SELECT  i.ObjectID ,
                        'SizeInInches' ,
                        CURRENT_TIMESTAMP ,
                        d.SizeInInches
                FROM    inserted AS i
                        INNER JOIN deleted AS d ON
                            i.ObjectID = d.ObjectID
                WHERE   i.SizeInInches <> d.SizeInInches
                UNION ALL
                SELECT  i.ObjectID ,
                        'WeightInPounds' ,
                        CURRENT_TIMESTAMP ,
                        d.WeightInPounds
                FROM    inserted AS i
                        INNER JOIN deleted AS d ON
                            i.ObjectID = d.ObjectID
                WHERE   i.WeightInPounds <> 
                            d.WeightInPounds ;
    END ;
-- after the body of the trigger completes,
-- the original value of ROWCOUNT is restored
-- by the database engine

-- Listing 1-14: SET ROWCOUNT can break a stored procedure
SET ROWCOUNT 1 ;
-- must return two rows
EXEC dbo.SelectMessagesBySubjectBeginning
    @SubjectBeginning = 'Ne' ;

-- Listing 1-15: Creating the SelectObjectsChangeLogForDateRange stored procedure
CREATE PROCEDURE dbo.SelectObjectsChangeLogForDateRange
    @DateFrom DATETIME ,
    @DateTo DATETIME = NULL
AS 
    SET ROWCOUNT 0 ;
    SELECT  ObjectID ,
            ChangedColumnName ,
            ChangedAt ,
            OldValue
    FROM    dbo.ObjectsChangeLog
    WHERE ChangedAt BETWEEN @DateFrom
                  AND  COALESCE(@DateTo, '12/31/2099') ;
GO

-- Listing 1-16: Our stored procedure breaks under Norwegian language settings

-- we can populate this table via our trigger, but
-- I used INSERTs,to keep the example simple
INSERT  INTO dbo.ObjectsChangeLog
        ( ObjectID ,
          ChangedColumnName ,
          ChangedAt ,
          OldValue
        )
        SELECT  1 ,
                'SizeInInches' ,
-- the safe way to provide July 7th, 2009 
                '20090707', 
                12.34 ;
 GO

SET LANGUAGE 'us_english' ;
-- this convertion always works in the same way,
-- regardless of the language settings,
-- because the format is explicitly specified
EXEC dbo.SelectObjectsChangeLogForDateRange
      @DateFrom = '20090101';

SET LANGUAGE 'Norsk' ;

EXEC dbo.SelectObjectsChangeLogForDateRange
       @DateFrom = '20090101';

-- your actual error message may be different from mine,
-- depending on the version of SQL Server


-- Listing 1-17: Our stored procedure call returns different results, depending on language settings
INSERT  INTO dbo.ObjectsChangeLog
        ( ObjectID ,
          ChangedColumnName ,
          ChangedAt ,
          OldValue
        )
        SELECT  1 ,
                'SizeInInches' ,
                 -- this means June 15th, 2009
                '20090615', 
                12.3
        UNION ALL
        SELECT  1 ,
                'SizeInInches' ,
                -- this means September 15th, 2009 
                '20090915', 
                12.5 

SET LANGUAGE 'us_english' ;

-- this call returns rows from Jul 6th to Sep 10th, 2009
-- one log entry meets the criteria
EXEC SelectObjectsChangeLogForDateRange 
  @DateFrom = '07/06/2009',
  @DateTo = '09/10/2009' ;

SET LANGUAGE 'Norsk' ;

-- this call returns rows from Jun 7th to Oct 9th, 2009
-- three log entries meet the criteria
EXEC SelectObjectsChangeLogForDateRange
  @DateFrom = '07/06/2009',
  @DateTo = '09/10/2009' ;

-- because the stored procedure does not have an ORDER BY
-- clause, your results may show up in a different
-- order

-- Listing 1-18: Fixing the stored procedure
ALTER PROCEDURE dbo.SelectObjectsChangeLogForDateRange
    @DateFrom DATETIME ,
    @DateTo DATETIME = NULL
AS 
    SET ROWCOUNT 0 ; 
    SELECT  ObjectID ,
            ChangedColumnName ,
            ChangedAt ,
            OldValue
    FROM    dbo.ObjectsChangeLog
    WHERE   ChangedAt BETWEEN @DateFrom
                      AND     COALESCE(@DateTo,
                              '20991231') ;

-- Listing 1-19: The Employee table and SetEmployeeManager stored procedure
CREATE TABLE dbo.Employee
  (
    EmployeeID INT NOT NULL ,
    ManagerID INT NULL ,
    FirstName VARCHAR(50) NULL ,
    LastName VARCHAR(50) NULL ,
    CONSTRAINT PK_Employee_EmployeeID
        PRIMARY KEY CLUSTERED ( EmployeeID ASC ) ,
    CONSTRAINT FK_Employee_EmployeeID_ManagerID
        FOREIGN KEY ( ManagerID )
            REFERENCES dbo.Employee ( EmployeeID )
  ) ;
GO

CREATE PROCEDURE dbo.SetEmployeeManager
  @FirstName VARCHAR(50) ,
  @LastName VARCHAR(50) ,
  @ManagerID INT
AS 
  SET NOCOUNT ON ;
  UPDATE  dbo.Employee
  SET     ManagerID = @ManagerID
  WHERE   FirstName = @FirstName
          AND LastName = @LastName ;

-- Listing 1-20: Using unambiguous search criteria
ALTER PROCEDURE dbo.SetEmployeeManager
    @EmployeeID INT ,
    @ManagerID INT
AS 
    SET NOCOUNT ON ;
    UPDATE  dbo.Employee
    SET     ManagerID = @ManagerID
    WHERE   EmployeeID = @EmployeeID ;

-- Listing 1-21: Creating the Codes and CodesStaging tables
CREATE TABLE dbo.Codes
    (
      Code VARCHAR(5) NOT NULL ,
      Description VARCHAR(40) NOT NULL ,
      CONSTRAINT PK_Codes PRIMARY KEY ( Code )
    ) ;
GO

CREATE TABLE dbo.CodesStaging
    (
      Code VARCHAR(10) NOT NULL ,
      Description VARCHAR(40) NOT NULL
    ) ; 
GO

-- Listing 1-22: Populating the Codes and CodesStaging tables
DELETE  FROM dbo.Codes ;
INSERT  INTO dbo.Codes
        ( Code ,
          Description
        )
        SELECT  'AR' ,
                'Old description for Arkansas'
        UNION ALL
        SELECT  'IN' ,
                'Old description for Indiana' ;

DELETE  FROM dbo.CodesStaging ;
INSERT  INTO dbo.CodesStaging
        ( Code ,
          Description
        )
        SELECT  'AR' ,
                'description for Argentina'
        UNION ALL
        SELECT  'AR' ,
                'new description for Arkansas'
        UNION ALL
        SELECT  'IN' ,
                'new description for Indiana ' ;

-- Listing 1-23: An ambiguous UPDATE…FROM
UPDATE  dbo.Codes
SET Description = s.Description
FROM    dbo.Codes AS c INNER JOIN dbo.CodesStaging AS s
           ON c.Code = s.Code ;

SELECT  Code ,
        Description
FROM    dbo.Codes ;


-- Listing 1-24: An ambiguous update of an inline view
WITH    c AS ( SELECT   c.Code ,
                        c.Description ,
                        s.Description AS NewDescription
               FROM     dbo.Codes AS c
                        INNER JOIN dbo.CodesStaging AS s
                             ON c.Code = s.Code
             )
    UPDATE  c
    SET     Description = NewDescription ;

SELECT  Code ,
        Description
FROM    dbo.Codes ;

-- Listing 1-25: MERGE detects an ambiguity in incoming data
MERGE INTO dbo.Codes AS c
    USING dbo.CodesStaging AS s
    ON c.Code = s.Code
    WHEN MATCHED 
        THEN UPDATE
          SET       c.Description = s.Description ;

-- Listing 1-26: An ANSI Standard UPDATE command, which raises an error when there is an ambiguity

-- rerun the code from Listing 1-22 
-- before executing this code
UPDATE  dbo.Codes 
SET     Description =
            ( SELECT  Description
              FROM    dbo.CodesStaging 
              WHERE   Codes.Code = CodesStaging.Code
            )
WHERE   EXISTS ( SELECT *
                 FROM   dbo.CodesStaging AS s
                 WHERE   Codes.Code = s.Code
               ) ;


-- Listing 1-27: Using a subquery to ignore ambiguities when updating an inline view

-- rerun the code from Listing 1-22 
-- before executing this code
BEGIN TRAN ;

WITH  c AS ( SELECT c.Code ,
                    c.Description ,
                    s.Description AS NewDescription
             FROM   dbo.Codes AS c
                    INNER JOIN dbo.CodesStaging AS s
                        ON c.Code = s.Code
                            AND ( SELECT COUNT(*)
                            FROM  dbo.CodesStaging AS s1
                            WHERE c.Code = s1.Code
                                 ) = 1
           )
  UPDATE  c
  SET     Description = NewDescription ;

ROLLBACK ;

-- Listing 1-28: Using PARTITION BY to ignore ambiguities when updating an inline view

-- rerun the code from Listing 1-22 
-- before executing this code
BEGIN TRAN ;

WITH c AS ( SELECT c.Code ,
                   c.Description ,
                   s.Description AS NewDescription ,
                   COUNT(*) OVER ( PARTITION BY s.Code )
                                       AS NumVersions
             FROM   dbo.Codes AS c
                    INNER JOIN dbo.CodesStaging AS s
                         ON c.Code = s.Code
           )
  UPDATE  c
  SET     Description = NewDescription
  WHERE   NumVersions = 1 ;

ROLLBACK ;

-- Listing 1-29: An UPDATE command using an inline view and raising a divide by zero error when there is an ambiguity

-- rerun the code from Listing 1-22 
-- before executing this code
DECLARE @ambiguityDetector INT ;
WITH c AS ( SELECT c.Code ,
                   c.Description ,
                   s.Description AS NewDescription ,
                   COUNT(*) OVER ( PARTITION BY s.Code )
                                        AS NumVersions
             FROM   dbo.Codes AS c
                    INNER JOIN dbo.CodesStaging AS s
                         ON c.Code = s.Code
           )
  UPDATE  c
  SET     Description = NewDescription ,
          @ambiguityDetector = CASE WHEN NumVersions = 1
                                    THEN 1
-- if we have ambiguities, the following branch executes
-- and raises the following error:
-- Divide by zero error encountered. 
                                    ELSE 1 / 0
                               END ;

-- Listing 1-30: Using a subquery to ignore ambiguities when using UPDATE…FROM

-- rerun the code from Listing 1-22
-- before executing this code
BEGIN TRAN ;
UPDATE  dbo.Codes
SET     Description = 'Old Description' ;

UPDATE  dbo.Codes
SET     Description = s.Description
FROM    dbo.Codes AS c
        INNER JOIN dbo.CodesStaging AS s
             ON c.Code = s.Code
                AND ( SELECT COUNT(*)
                      FROM   dbo.CodesStaging AS s1
                      WHERE  s.Code = s1.Code
                     ) = 1 ;
SELECT  Code ,
        Description
FROM    dbo.Codes ;
ROLLBACK ;

-- Listing 1-31: Using an analytical function to detect and ignore ambiguities when using UPDATE…FROM

-- rerun the code from Listing 1-22 
-- before executing this code
BEGIN TRAN ;
UPDATE  dbo.Codes
SET     Description = 'Old Description' ;

UPDATE dbo.Codes
SET    Description = s.Description
FROM   dbo.Codes AS c
       INNER JOIN ( SELECT Code ,
                     Description ,
                     COUNT(*) OVER ( PARTITION BY Code )
                                        AS NumValues
              FROM   dbo.CodesStaging
            ) AS s
                   ON c.Code = s.Code
                      AND NumValues = 1 ;
SELECT  Code ,
        Description
FROM    dbo.Codes ;
ROLLBACK ;
