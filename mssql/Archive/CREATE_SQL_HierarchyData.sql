-- Listing 9-9. Creating a Hierarchy with HIERARCHYID
Use tempdb;
GO
--1
IF OBJECT_ID('SportsOrg') IS NOT NULL BEGIN
DROP TABLE SportsOrg;
END;
GO
--2
CREATE TABLE SportsOrg
(DivNode HIERARCHYID NOT NULL PRIMARY KEY CLUSTERED,
DivLevel AS DivNode.GetLevel(), --Calculated column
DivisionID INT NOT NULL,
Name VARCHAR(30) NOT NULL);
GO
--3
INSERT INTO SportsOrg(DivNode,DivisionID,Name)
VALUES(HIERARCHYID::GetRoot(),1,'State');
GO
--4
DECLARE @ParentNode HIERARCHYID, @LastChildNode HIERARCHYID;
--5
SELECT @ParentNode = DivNode
FROM SportsOrg
WHERE DivisionID = 1;
--6
SELECT @LastChildNode = max(DivNode)
FROM SportsOrg
WHERE DivNode.GetAncestor(1) = @ParentNode;

--7
INSERT INTO SportsOrg(DivNode,DivisionID,Name)
VALUES (@ParentNode.GetDescendant(@LastChildNode,NULL),
2,'Madison County');
--8
SELECT DivisionID,DivLevel,DivNode.ToString() AS Node,Name
FROM SportsOrg;



--Using Stored Procedures to Manage Hierarchical Data
USE tempdb;
GO
--1
IF OBJECT_ID('dbo.usp_AddDivision') IS NOT NULL BEGIN
DROP PROC dbo.usp_AddDivision;
END;
IF OBJECT_ID('dbo.SportsOrg') IS NOT NULL BEGIN
DROP TABLE dbo.SportsOrg;
END;
GO
--2
CREATE TABLE SportsOrg
(DivNode HierarchyID NOT NULL PRIMARY KEY CLUSTERED,
DivLevel AS DivNode.GetLevel(), --Calculated column
DivisionID INT NOT NULL,
Name VARCHAR(30) NOT NULL);
GO
--3
INSERT INTO SportsOrg(DivNode,DivisionID,Name)
VALUES(HIERARCHYID::GetRoot(),1,'State');
GO
--4
CREATE PROC usp_AddDivision @DivisionID INT,
@Name VARCHAR(50),@ParentID INT AS
DECLARE @ParentNode HierarchyID, @LastChildNode HierarchyID;
--Grab the parent node
SELECT @ParentNode = DivNode
FROM SportsOrg
WHERE DivisionID = @ParentID;
BEGIN TRANSACTION
--Find the last node added to the parent
SELECT @LastChildNode = max(DivNode)
FROM SportsOrg
WHERE DivNode.GetAncestor(1) = @ParentNode;
--Insert the new node using the GetDescendant function
INSERT INTO SportsOrg(DivNode,DivisionID,Name)
VALUES (@ParentNode.GetDescendant(@LastChildNode,NULL),
@DivisionID,@Name);
COMMIT TRANSACTION;
GO

--5
EXEC usp_AddDivision 2,'Madison County',1;
EXEC usp_AddDivision 3,'Macoupin County',1;
EXEC usp_AddDivision 4,'Green County',1;
EXEC usp_AddDivision 5,'Edwardsville',2;
EXEC usp_AddDivision 6,'Granite City',2;
EXEC usp_AddDivision 7,'Softball',5;
EXEC usp_AddDivision 8,'Baseball',5;
EXEC usp_AddDivision 9,'Basketball',5;
EXEC usp_AddDivision 10,'Softball',6;
EXEC usp_AddDivision 11,'Baseball',6;
EXEC usp_AddDivision 12,'Basketball',6;
EXEC usp_AddDivision 13,'Ages 10 - 12',7;
EXEC usp_AddDivision 14,'Ages 13 - 17',7;
EXEC usp_AddDivision 15,'Adult',7;
EXEC usp_AddDivision 16,'Preschool',8;
EXEC usp_AddDivision 17,'Grade School League',8;
EXEC usp_AddDivision 18,'High School League',8;
--6
SELECT DivNode.ToString() AS Node,
DivisionID, SPACE(DivLevel * 3) + Name AS Name
FROM SportsOrg
ORDER BY DivNode;

