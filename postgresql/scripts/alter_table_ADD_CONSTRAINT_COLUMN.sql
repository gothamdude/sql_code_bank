

alter table employees_with_not_null_constraint add column gender varchar(10);


alter table employees_with_not_null_constraint add check (gender in ('Male','Female'));





