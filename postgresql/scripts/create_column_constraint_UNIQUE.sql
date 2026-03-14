
create table employess_with_unique_constraint(
	eid integer, 
	ename text,
	salary numeric check(salary>0),
	birthdate date, 
	date_of_joining date not null,
	email varchar(20) unique,
	constraint valid_joining check (birthdate>date_of_joining)
);

create table employess_with_unique_constraint_named(
	eid integer, 
	ename text,
	salary numeric check(salary>0),
	birthdate date, 
	date_of_joining date not null,
	email varchar(20),
	constraint valid_joining check (birthdate>date_of_joining),
	constraint unique_email unique (email)
);


