create table voting_eligibility( 
	person_id int primary key,
	age int, 
	eligible boolean not null 
);

insert into voting_eligibility 
values(101,12,'f'),
(102,'35',true), 
(301,43, 't'),   
(401,66, '1'),
(501, 73,'y'),   
(601, 31,'yes'),   
(701, 17,'no'),   
(801, 15,'0');

 
select * from voting_eligibility



