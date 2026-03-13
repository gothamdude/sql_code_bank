
CREATE TABLE text_test ( id serial PRIMARY KEY, x TEXT, y TEXT ); 


INSERT INTO text_test (x, y) 
VALUES ( 'Postgres', 'We are learning databse' ), 
( 'Essential Postgres', 'A guide for developers' );  


select * from text_test;

