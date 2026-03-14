create table department_primary_table(
	deptNo int primary key,
	deptName varchar(100)
);

create table employee_foreign_table(
	eid int primary key,
	ename varchar(20) not null, 
	salary real not null ,
	deptNo int references department_primary_table(deptNo)
);

-- these will both work 
insert into department_primary_table (deptNo,deptName)
values (10,'software'),(20,'hardware');
insert into employee_foreign_table(eid,ename,salary,deptNo)
values (101,'arina',45565,10),(102,'thomas',568445,20);

-- this will blow due to key
insert into employee_foreign_table(eid,ename,salary,deptNo)
values (103,'joey',89547,50);

/**
SQL Error [23503]: ERROR: insert or update on table "employee_foreign_table" violates foreign key constraint "employee_foreign_table_deptno_fkey"
  Detail: Key (deptno)=(50) is not present in table "department_primary_table".

Error position:
*/

create table another_employee_foreign_table(
	eid int primary key,
	ename varchar(20) not null, 
	salary real not null ,
	deptNo int,
	constraint fk_dept_emp foreign key (deptNo) references department_primary_table(deptNo)
);