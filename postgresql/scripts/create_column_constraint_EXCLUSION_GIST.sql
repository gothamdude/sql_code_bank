CREATE EXTENSION btree_gist;

create table EMP ( 
	Emp_Id INT PRIMARY KEY  NOT NULL,   
	Emp_Name  TEXT,   
	Emp_Address CHAR(50),   
	Emp_Age INT,   
	Emp_SALARY REAL,   
	EXCLUDE USING gist (Emp_Name WITH =,Emp_Age WITH <>)    
);

 