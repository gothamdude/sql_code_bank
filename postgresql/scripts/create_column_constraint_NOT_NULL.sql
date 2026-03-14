create table employees_with_not_null_constraint (
	eid integer not null, 
	ename text,
	salary numeric check(salary>0),
	birthdate date not null, 
	date_of_joining date not null,
	email varchar(20),
	phone_number bigint,
	constraint valid_joining check (birthdate>date_of_joining),
	constraint email_phone unique (email,phone_number)
);


create table employees_with_not_null_constraint2 (
	eid integer not null, 
	ename text,
	salary numeric check(salary>0),
	birthdate date not null, 
	date_of_joining date not null,
	email varchar(20),
	phone_number bigint,
	constraint valid_joining check (birthdate>date_of_joining),
	constraint email_phone unique (email,phone_number)
);
