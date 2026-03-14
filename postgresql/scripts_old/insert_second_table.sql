SELECT * FROM public.address
ORDER BY id ASC ;

SELECT * FROM public.customers
ORDER BY id ASC ;

/*
1	"Jimmy"	"Beam"	62
2	"George"	"Goob"	19
3	"Kath"	"Grub"	42
5	"Liz"	"Prune"	39
6	"Tom"	"Pott"	33
*/

begin transaction;

insert into address(customer_id, street, city, state)
values (1,'212 Mulberry','New York','NY');

insert into address(customer_id, street, city, state)
values (2,'95 Wisteria Lane','Phoenix','AZ');

insert into address(customer_id, street, city, state)
values (3,'578 Bubb Road','Cupertino','CA');

insert into address(customer_id, street, city, state)
values (5,'800 Poplar St','Ridgefield','WY');

insert into address(customer_id, street, city, state)
values (6,'75 Dominion Ave','Fort Bragg','IH');

commit transaction;



