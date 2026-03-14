

alter table product_table 
add column discounted_price numeric;


alter table product_table 
drop column discounted_price;



alter table product_table 
rname column discounted_price to discounted_price_legacy;

