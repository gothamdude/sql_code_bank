USE tempdb;
GO

-- I. PRIMARY KEY CONSTRAINT 
IF OBJECT_ID('table1') IS NOT NULL BEGIN DROP TABLE table1; END;
IF OBJECT_ID('table2') IS NOT NULL BEGIN DROP TABLE table2; END;
IF OBJECT_ID('table3') IS NOT NULL BEGIN DROP TABLE table3; END;

--2
CREATE TABLE table1 (col1 INT NOT NULL PRIMARY KEY, col2 VARCHAR(10));
--3
CREATE TABLE table2 (col1 INT NOT NULL, col2 VARCHAR(10) NOT NULL, col3 INT NULL, CONSTRAINT PK_table2_col1col2 PRIMARY KEY (col1, col2)
);
--4
CREATE TABLE table3 (col1 INT NOT NULL, col2 VARCHAR(10) NOT NULL, col3 INT NULL); 
--5
ALTER TABLE table3 ADD CONSTRAINT PK_table3_col1col2
PRIMARY KEY NONCLUSTERED (col1,col2);


-- II. UNIQUE CONSTRAINT 
--1
IF OBJECT_ID('table1') IS NOT NULL BEGIN DROP TABLE table1; END;
--2
CREATE TABLE table1 (col1 INT UNIQUE, col2 VARCHAR(20), col3 DATETIME);
GO
--3
ALTER TABLE table1 ADD CONSTRAINT unq_table1_col2_col3 UNIQUE (col2,col3);
--4
PRINT 'Statement 4'
INSERT INTO table1(col1,col2,col3)
VALUES (1,2,'1/1/2009'),(2,2,'1/2/2009');
--5
PRINT 'Statement 5'
INSERT INTO table1(col1,col2,col3)
VALUES (3,2,'1/1/2009');
--6
PRINT 'Statement 6'
INSERT INTO table1(col1,col2,col3)
VALUES (1,2,'1/2/2009');
--7
PRINT 'Statement 7'
UPDATE table1 SET col3 = '1/2/2009'
WHERE col1 = 1;


-- III. CHECK CONSTRAINT 
USE tempdb;
GO
--1
IF OBJECT_ID('table1') IS NOT NULL BEGIN DROP TABLE table1; END;
--2
CREATE TABLE table1 (col1 SMALLINT, col2 VARCHAR(20),CONSTRAINT ch_table1_col2_months
	CHECK (col2 IN ('January','February','March','April','May','June','July','August','September','October','November','December'))
);

ALTER TABLE table1 ADD CONSTRAINT ch_table1_col1
CHECK (col1 BETWEEN 1 and 12);
PRINT 'Janary';
--4
INSERT INTO table1 (col1,col2)
VALUES (1,'Janary');
PRINT 'February';
--5
INSERT INTO table1 (col1,col2)
VALUES (2,'February');
PRINT 'March';
--6
INSERT INTO table1 (col1,col2)
VALUES (13,'March');
PRINT 'Change 2 to 20';
--7
UPDATE table1 SET col1 = 20;

