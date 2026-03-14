USE tempdb;
GO


-- I. CREATING FOREIGN KEYS 
--1
IF OBJECT_ID('table2') IS NOT NULL BEGIN
	DROP TABLE table2;
END;
IF OBJECT_ID('table1') IS NOT NULL BEGIN
	DROP TABLE table1;
END;
--2
CREATE TABLE table1 (col1 INT NOT NULL PRIMARY KEY, col2 VARCHAR(20), col3 DATETIME);
--3
CREATE TABLE table2 (	col4 INT NULL, 
						col5 VARCHAR(20) NOT NULL, 
						CONSTRAINT pk_table2 PRIMARY KEY (col5),
						CONSTRAINT fk_table2_table1 FOREIGN KEY (col4) REFERENCES table1(col1)
);
GO
--4
PRINT 'Adding to table1';
INSERT INTO table1(col1,col2,col3)
VALUES(1,'a','1/1/2009'),(2,'b','1/2/2009'),(3,'c','1/3/2009');
--5
PRINT 'Adding to table2';
INSERT INTO table2(col4,col5)
VALUES(1,'abc'),(2,'def');

--6
PRINT 'Violating foreign key with insert';
INSERT INTO table2(col4,col5)
VALUES (7,'abc');
--7
PRINT 'Violating foreign key with update';
UPDATE table2 SET col4 = 6
WHERE col4 = 1;



-- II. CREATING FOREIGN KEYS  with DELETE/UPDATE CASCADE rules 
USE tempdb;
GO
--1
IF OBJECT_ID('table2') IS NOT NULL BEGIN
	DROP TABLE table2;
END;
IF OBJECT_ID('table1') IS NOT NULL BEGIN
	DROP TABLE table1;
END;
--2
CREATE TABLE table1 (col1 INT NOT NULL PRIMARY KEY, col2 VARCHAR(20), col3 DATETIME);
--3 default rules
PRINT 'No action by default';
CREATE TABLE table2 (col4 INT NULL DEFAULT 7,
					col5 VARCHAR(20) NOT NULL,
					CONSTRAINT pk_table2 PRIMARY KEY (col5),
					CONSTRAINT fk_table2_table1 FOREIGN KEY (col4) REFERENCES table1(col1)
			);
			
--4
PRINT 'Adding to table1';
INSERT INTO table1(col1,col2,col3)
VALUES(1,'a','1/1/2009'),(2,'b','1/2/2009'),(3,'c','1/3/2009'),(4,'d','1/4/2009'),(5,'e','1/6/2009'),(6,'g','1/7/2009'),(7,'g','1/8/2009');
--5
PRINT 'Adding to table2';
INSERT INTO table2(col4,col5)
VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl');
--6
SELECT col4, col5 FROM table2;
--7
PRINT 'Delete from table1'
DELETE FROM table1 WHERE col1 = 1;
--8
ALTER TABLE table2 DROP CONSTRAINT fk_table2_table1;
--9
PRINT 'Add CASCADE';
ALTER TABLE table2 ADD CONSTRAINT fk_table2_table1  FOREIGN KEY (col4) REFERENCES table1(col1)
			ON DELETE CASCADE
			ON UPDATE CASCADE;
--10
PRINT 'Delete from table1';
DELETE FROM table1 WHERE col1 = 1;
--11
PRINT 'Update table1';
UPDATE table1 SET col1 = 10 WHERE col1 = 4;

282
--12
ALTER TABLE table2 DROP CONSTRAINT fk_table2_table1;
--13
PRINT 'Add SET NULL';
ALTER TABLE table2 ADD CONSTRAINT fk_table2_table1
FOREIGN KEY (col4) REFERENCES table1(col1)
ON DELETE SET NULL
ON UPDATE SET NULL;
--14
DELETE FROM table1 WHERE col1 = 2;
--15
ALTER TABLE table2 DROP CONSTRAINT fk_table2_table1;
--16
PRINT 'Add SET DEFAULT';
ALTER TABLE table2 ADD CONSTRAINT fk_table2_table1
FOREIGN KEY (col4) REFERENCES table1(col1)
ON DELETE SET DEFAULT
ON UPDATE SET DEFAULT;
--17
PRINT 'Delete from table1';
DELETE FROM table1 WHERE col1 = 3;
--18
SELECT col4, col5 FROM table2;