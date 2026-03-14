-- Listing 5-1: Creating the Sales table and populating it with test data
CREATE TABLE dbo.Sales
  (
    SalesID INT NOT NULL
                IDENTITY
                PRIMARY KEY ,
    StateCode CHAR(2) NOT NULL ,
    SaleDateTime DATETIME NOT NULL ,
    Amount DECIMAL(10, 2) NOT NULL
  ) ;
GO
SET NOCOUNT ON ; 
DECLARE @d DATETIME ,
  @i INT ;
SET @d = '20091002' ;
SET @i = 0 ;
WHILE @i < 40 
  BEGIN ;
    INSERT  INTO dbo.Sales
            ( StateCode ,
              SaleDateTime ,
              Amount
            )
            SELECT 'CA' ,
                   @d ,
                   case WHEN @d <'20091001' THEN 5000000
                         ELSE 5000
                    END
            UNION ALL
            SELECT 'OR' ,
                   @d ,
                   case WHEN @d <'20091001' THEN 1000000
                         ELSE 1000
                    END ;
    SELECT  @d = DATEADD(day, -1, @d) ,
            @i = @i + 1 ;
  END ;

-- Listing 5-2: The SelectTotalSalesPerStateForMonth stored procedure
CREATE PROCEDURE dbo.SelectTotalSalesPerStateForMonth 
  @AsOfDate DATETIME
AS 
  SELECT  SUM(Amount) AS SalesPerState ,
          StateCode
  FROM    dbo.Sales
-- month begins on the first calendar day of the month
  WHERE SaleDateTime >= DATEADD(month,
                                DATEDIFF(month, '19900101',
                                          @AsOfDate),
                                '19900101')
          AND SaleDateTime <= @AsOfDate
  GROUP BY StateCode ;

-- Listing 5-3: A simple adaptation of our "total sales" stored procedure 
CREATE PROCEDURE dbo.SelectAverageSalesPerStateForMonth
  @AsOfDate DATETIME
AS 
  SELECT  AVG(Amount) AS SalesPerState ,
          StateCode
  FROM    dbo.Sales
-- month begins on the first calendar day of the month
  WHERE   SaleDateTime >= DATEADD(month,
                                  DATEDIFF(month, '19900101',
                                            @AsOfDate),
                                  '19900101')
          AND SaleDateTime <= @AsOfDate
  GROUP BY StateCode ;

-- Listing 5-4: The modified SelectAverageSalesPerStateForMonth stored procedure
ALTER PROCEDURE dbo.SelectAverageSalesPerStateForMonth 
  @AsOfDate DATETIME
AS 
  SELECT  AVG(Amount) AS SalesPerState ,
          StateCode
  FROM    dbo.Sales
-- month means 30 calendar days
  WHERE   SaleDateTime >= DATEADD(day, -29, @AsOfDate)
          AND SaleDateTime <= @AsOfDate
  GROUP BY StateCode ;

-- Listing 5-5: The stored procedures produce different results
PRINT 'Total Sales Per State For Month:' ;
EXEC dbo.SelectTotalSalesPerStateForMonth
  @AsOfDate = '20091005' ;

PRINT 'Average Sales Per State For Month:' ;
EXEC dbo.SelectAverageSalesPerStateForMonth
  @AsOfDate = '20091005' ;

-- Listing 5-6: Implementing the definition of "sales for a given month" in an inline UDF
CREATE  FUNCTION dbo.SalesForMonth (@AsOfDate DATETIME)
RETURNS TABLE
AS 
RETURN
  ( SELECT  SalesID ,
            StateCode ,
            SaleDateTime ,
            Amount
    FROM    dbo.Sales
    WHERE   SaleDateTime >= DATEADD(day, -29, @AsOfDate)
            AND SaleDateTime <= @AsOfDate
  ) ;

-- Listing 5-7: Utilizing the new inline function in our two stored procedures
ALTER PROCEDURE dbo.SelectTotalSalesPerStateForMonth 
  @AsOfDate DATETIME
AS 
  BEGIN
    SELECT  SUM(Amount) AS SalesPerState ,
            StateCode
    FROM    dbo.SalesForMonth(@AsOfDate)
    GROUP BY StateCode ;
  END ;
GO
ALTER PROCEDURE dbo.SelectAverageSalesPerStateForMonth
  @AsOfDate DATETIME
AS 
  BEGIN
    SELECT  AVG(Amount) AS SalesPerState ,
            StateCode
    FROM    dbo.SalesForMonth(@AsOfDate)
    GROUP BY StateCode ;
  END ;

-- Listing 5-8: An inline UDF that implements the definition of reporting period
CREATE FUNCTION dbo.MonthReportingPeriodStart 
                         (@AsOfDate DATETIME )
RETURNS TABLE
AS 
RETURN
  ( SELECT  DATEADD(day, -29, @AsOfDate) AS PeriodStart
  ) ;

-- Listing 5-9: Altering SalesPerStateForMonth to utilize the new MonthReportingPeriodStart function
ALTER FUNCTION dbo.SalesForMonth ( @AsOfDate DATETIME )
RETURNS TABLE
AS 
RETURN
  ( SELECT  SalesID ,
            StateCode ,
            SaleDateTime ,
            Amount
    FROM    dbo.Sales AS s
            CROSS APPLY
            dbo.MonthReportingPeriodStart(@AsOfDate) AS ps
    WHERE   SaleDateTime >= ps.PeriodStart
            AND SaleDateTime <= @AsOfDate
  ) ;

-- Listing 5-10: Scalar UDF which implements the definition of reporting period
-- being defensive, we must drop the old implementation
-- so that reporting periods are implemented 
-- only in one place
DROP FUNCTION dbo.MonthReportingPeriodStart ; 
GO
CREATE FUNCTION dbo.MonthReportingPeriodStart 
                            ( @AsOfDate DATETIME )
RETURNS DATETIME
AS 
    BEGIN ;
      DECLARE @ret DATETIME ;
      SET @ret = DATEADD(day, -29, @AsOfDate) ;
      RETURN @ret ;
    END ;

-- Listing 5-11: Altering SalesForMonth to utilize the new scalar UDF MonthReportingPeriodStart
ALTER FUNCTION dbo.SalesForMonth ( @AsOfDate DATETIME )
RETURNS TABLE
AS 
RETURN
  ( SELECT  SalesID ,
            StateCode ,
            SaleDateTime ,
            Amount
    FROM    dbo.Sales AS s
    WHERE   SaleDateTime >= 
              dbo.MonthReportingPeriodStart(@AsOfDate)
            AND SaleDateTime <= @AsOfDate
  ) ;

-- Listing 5-12: Wrapping a query inside a view
CREATE VIEW dbo.TotalSalesByState
AS
SELECT SUM(Amount) AS TotalSales, StateCode
FROM dbo.Sales
GROUP BY StateCode ;

-- Listing 5-13: A stored procedure that returns all sales for the month
CREATE PROCEDURE dbo.SelectSalesForMonth @AsOfDate DATETIME
AS 
  BEGIN ;  
    SELECT  Amount ,
            StateCode
    FROM    dbo.Sales
    WHERE   SaleDateTime >= DATEADD(day, -29, @AsOfDate)
            AND SaleDateTime <= @AsOfDate ; 
  END ; 
GO

-- Listing 5-14: The SelectSalesPerStateForMonth stored procedure
CREATE PROCEDURE dbo.SelectSalesPerStateForMonth
  @AsOfDate DATETIME
AS 
  BEGIN ;  
    DECLARE @SalesForMonth TABLE
      (
        StateCode CHAR(2) ,
        Amount DECIMAL(10, 2)
      ) ; 

    INSERT  INTO @SalesForMonth
            ( Amount ,
              StateCode
            )
            EXEC dbo.SelectSalesForMonth @AsOfDate ;

    SELECT  SUM(Amount) AS TotalSalesForMonth ,
            StateCode
    FROM    @SalesForMonth
    GROUP BY StateCode
    ORDER BY StateCode ; 
  END ; 
GO

-- Listing 5-15: Testing the new stored procedures
EXEC dbo.SelectSalesForMonth @AsOfDate = '20091002' ;
EXEC dbo.SelectSalesPerStateForMonth @AsOfDate = '20091002' ;

-- Listing 5-16: Reusing SelectSalesPerStateForMonth procedure to get the state with most sales
CREATE PROCEDURE dbo.SelectStateWithBestSalesForMonth
  @AsOfDate DATETIME
AS 
  BEGIN ;
    DECLARE @SalesForMonth TABLE
      (
        TotalSales DECIMAL(10, 2) ,
        StateCode CHAR(2)
      ) ; 

    INSERT  INTO @SalesForMonth
            ( TotalSales ,
              StateCode
            )
            EXEC dbo.SelectSalesPerStateForMonth @AsOfDate ;

    SELECT TOP (1)
            TotalSales ,
            StateCode
    FROM    @SalesForMonth
    ORDER BY TotalSales DESC ; 
  END ;

-- Listing 5-17: An INSERT…EXEC statement cannot be nested.
EXEC dbo.SelectStateWithBestSalesForMonth
  @AsOfDate = '20091002' ;

-- Listing 5-18: Implementing the same functionality via inline UDFs
CREATE FUNCTION dbo.TotalSalesPerStateForMonth
  ( @AsOfDate DATETIME )
RETURNS TABLE
AS 
RETURN
  ( SELECT  StateCode ,
            SUM(Amount) AS TotalSales
    FROM    dbo.SalesPerStateForMonth(@AsOfDate)
    GROUP BY StateCode
  ) ;
GO

CREATE FUNCTION dbo.StateWithBestSalesForMonth
  ( @AsOfDate DATETIME )
RETURNS TABLE
AS 
RETURN
  ( SELECT TOP (1)
            StateCode ,
            TotalSales
    FROM    dbo.TotalSalesPerStateForMonth(@AsOfDate)
    ORDER BY TotalSales DESC
  ) ;

-- Listing 5-19: Testing the inline UDFs
SELECT * FROM dbo.TotalSalesPerStateForMonth ( '20091002' ) ;
SELECT * FROM dbo.StateWithBestSalesForMonth ( '20091002' ) ;

-- Listing 5-20: Creating and populating the Numbers helper table
CREATE TABLE dbo.Numbers
  (
    n INT NOT NULL ,
    CONSTRAINT PK_Numbers PRIMARY KEY ( n )
  ) ;  
GO 
DECLARE @i INT ; 
SET @i = 1 ; 
INSERT  INTO dbo.Numbers
        ( n )
VALUES  ( 1 ) ; 
WHILE @i < 100000 
  BEGIN ; 
    INSERT  INTO dbo.Numbers
            ( n )
            SELECT  @i + n
            FROM    dbo.Numbers ; 
    SET @i = @i * 2 ; 
  END ;

-- Listing 5-21: Create the Packages table and populate it with test data
CREATE TABLE dbo.Packages
  (
    PackageID INT NOT NULL ,
    WeightInPounds DECIMAL(5, 2) NOT NULL ,
    CONSTRAINT PK_Packages PRIMARY KEY ( PackageID )
  ) ; 
 GO
 
INSERT  INTO dbo.Packages
        ( PackageID ,
          WeightInPounds 
        )
        SELECT  n ,
                1.0 + ( n % 900 ) / 10
        FROM    dbo.Numbers ;

-- Listing 5-22: Calculating the shipping cost using a scalar UDF, GetShippingCost, and an inline UDF, GetShippingCose_inline
CREATE FUNCTION dbo.GetShippingCost
  (
    @WeightInPounds DECIMAL(5, 2)
  )
RETURNS DECIMAL(5, 2)
AS 
    BEGIN 
      DECLARE @ret DECIMAL(5, 2) ; 
      SET @ret = CASE WHEN @WeightInPounds < 5 THEN 1.00
                      ELSE 2.00
                 END ; 
      RETURN @ret ; 
    END ; 
GO 

CREATE FUNCTION dbo.GetShippingCost_Inline
  (
    @WeightInPounds DECIMAL(5, 2)
  )
RETURNS TABLE
AS 
RETURN
  ( SELECT  CAST(CASE WHEN @WeightInPounds < 5 THEN 1.00
                      ELSE 2.00
                 END AS DECIMAL(5, 2)) AS ShippingCost
  ) ;  

-- Listing 5-23: A simple benchmark to compare the performance of the scalar and inline UDFs vs. the copy-and-paste approach
SET STATISTICS TIME ON ; 
SET NOCOUNT ON ; 

PRINT 'Using a scalar UDF' ; 
SELECT  SUM(dbo.GetShippingCost(WeightInPounds))
    AS TotalShippingCost
FROM    dbo.Packages ; 

PRINT 'Using an inline UDF' ; 
SELECT  SUM(s.ShippingCost) AS TotalShippingCost
FROM    dbo.Packages AS p CROSS APPLY 
           dbo.GetShippingCost_Inline(p.WeightInPounds) AS s ;

PRINT 'Not using any funtions at all' ; 
SELECT  SUM(CASE WHEN p.WeightInPounds < 5 THEN 1.00
                 ELSE 2.00
            END) AS TotalShippingCost
FROM    dbo.Packages AS p ; 

SET STATISTICS TIME OFF ;

-- Listing 5-25: Creating the Teams table
CREATE TABLE dbo.Teams
  (
    TeamID INT NOT NULL ,
    Name VARCHAR(50) NOT NULL ,
    CONSTRAINT PK_Teams PRIMARY KEY ( TeamID )
  ) ;

-- Listing 5-26: The InsertTeam stored procedure inserts a team, if the team name does not already exist in the table
CREATE PROCEDURE dbo.InsertTeam
  @TeamID INT ,
  @Name VARCHAR(50)
AS 
  BEGIN ; 
        -- This is not a fully-functional stored
        -- procedure. Error handling is skipped to keep 
        -- the example short. 
        -- Also potential race conditions 
        -- are not considered in this simple module
    INSERT  INTO dbo.Teams
            ( TeamID ,
              Name
            )
            SELECT  @TeamID ,
                    @Name
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   dbo.Teams
                                 WHERE  Name = @Name ) ; 
          -- we also need to raise an error if we  
         -- already have a team with such name 
  END ;  

-- Listing 5-27: The UNQ_Teams_Name constraint enforces the uniqueness of team names
ALTER TABLE dbo.Teams 
  ADD CONSTRAINT UNQ_Teams_Name UNIQUE(Name) ;

-- Listing 5-28: Creating the TeamMembers table
CREATE TABLE dbo.TeamMembers
  (
    TeamMemberID INT NOT NULL ,
    TeamID INT NOT NULL ,
    Name VARCHAR(50) NOT NULL ,
    IsTeamLead CHAR(1) NOT NULL ,
    CONSTRAINT PK_TeamMembers PRIMARY KEY ( TeamMemberID ) ,
    CONSTRAINT FK_TeamMembers_Teams 
      FOREIGN KEY ( TeamID ) REFERENCES dbo.Teams ( TeamID ) ,
    CONSTRAINT CHK_TeamMembers_IsTeamLead
      CHECK ( IsTeamLead IN ( 'Y', 'N' ) )
  ) ;

-- Listing 5-29: The TeamMembers_TeamSizeLimitTrigger trigger ensures that the teams do not exceed the maximum size
CREATE TRIGGER dbo.TeamMembers_TeamSizeLimitTrigger
    ON dbo.TeamMembers
  FOR INSERT, UPDATE
AS
  IF EXISTS ( SELECT  *
              FROM    ( SELECT  TeamID ,
                                TeamMemberID
                        FROM    inserted
                        UNION
                        SELECT  TeamID ,
                                TeamMemberID
                        FROM    dbo.TeamMembers
                        WHERE   TeamID IN ( SELECT  TeamID
                                            FROM    inserted )
                      ) AS t
              GROUP BY TeamID
              HAVING  COUNT(*) > 2 ) 
    BEGIN ;
      RAISERROR('Team size exceeded limit',16, 10) ; 
      ROLLBACK TRAN ; 
    END ;

-- Listing 5-30: Adding some test data to Teams table
INSERT  INTO dbo.Teams
        ( TeamID ,
          Name
        )
        SELECT  1 ,
                'Red Bulls'
        UNION ALL
        SELECT  2 ,
                'Blue Tigers'
        UNION ALL
        SELECT  3 ,
                'Pink Panthers' ;

-- Listing 5-31: Testing the _TeamSizeLimitTrigger trigger with valid INSERTs
-- adding team members to new teams
INSERT  INTO dbo.TeamMembers
        ( TeamMemberID ,
          TeamID ,
          Name ,
          IsTeamLead
        )
        SELECT  1 ,
                1 ,
                'Jill Hansen' ,
                'N'
        UNION ALL
        SELECT  2 ,
                1 ,
                'Sydney Hobart' ,
                'N'
        UNION ALL
        SELECT  3 ,
                2 ,
                'Hobart Sydney' ,
                'N' ;  

-- add more team members to existing teams 
BEGIN TRANSACTION ; 
INSERT  INTO dbo.TeamMembers
        ( TeamMemberID ,
          TeamID ,
          Name ,
          IsTeamLead
        )
        SELECT  4 ,
                2 ,
                'Lou Larry' ,
                'N' ; 
ROLLBACK TRANSACTION ;

-- Listing 5-32: Testing the _TeamSizeLimitTrigger trigger with valid UPDATEs
BEGIN TRANSACTION ; 
UPDATE  dbo.TeamMembers
SET     TeamID = TeamID + 1 ; 
ROLLBACK ;
 
BEGIN TRANSACTION ; 
UPDATE  dbo.TeamMembers
SET     TeamID = 3 - TeamID ; 
ROLLBACK ;   

-- Listing 5-33: Testing the _TeamSizeLimitTrigger trigger with invalid INSERTs
-- attempt to add too many team members  
-- to a team which already has members 
INSERT  INTO dbo.TeamMembers
        ( TeamMemberID ,
          TeamID ,
          Name ,
          IsTeamLead
        )
        SELECT  4 ,
                2 ,
                'Calvin Lee' ,
                'N'
        UNION ALL
        SELECT  5 ,
                2 ,
                'Jim Lee' ,
                'N' ;
GO 
    -- attempt to add too many team members to an empty team 
INSERT  INTO dbo.TeamMembers
        ( TeamMemberID ,
          TeamID ,
          Name ,
          IsTeamLead
        )
        SELECT  4 ,
                3 ,
                'Calvin Lee' ,
                'N'
        UNION ALL
        SELECT  5 ,
                3 ,
                'Jim Lee' ,
                'N'
        UNION ALL
        SELECT  6 ,
                3 ,
                'Jake Lee' ,
                'N' ;

-- Listing 5-34: Testing the _TeamSizeLimitTrigger trigger with invalid UPDATEs
-- attempt to transfer members from other teams  
-- to a team which is full to capacity   
UPDATE  dbo.TeamMembers
SET     TeamID = 1
WHERE   TeamMemberID = 3 ; 
GO
    -- attempt to transfer too many team members 
    -- to a team that is not full yet 
UPDATE  dbo.TeamMembers
SET     TeamID = 2
WHERE   TeamMemberID IN ( 1, 2 ) ;
GO 
    -- attempt to transfer too many team members 
    -- to an empty team  
UPDATE  dbo.TeamMembers
SET     TeamID = 3 ;  
-- Listing 5-35: The TeamLeads filtered index ensures that each team has at most one team lead
CREATE UNIQUE NONCLUSTERED INDEX TeamLeads 
ON dbo.TeamMembers(TeamID) 
WHERE IsTeamLead='Y' ;

