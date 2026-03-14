declare @temp1 table(ID1 int not null, ID2 int not null)

set nocount off

insert into @temp1 values(1453,931)
insert into @temp1 values(1454,931)
insert into @temp1 values(1455,931)
insert into @temp1 values(2652,1101)
insert into @temp1 values(2653,1101)
insert into @temp1 values(2654,1101)
insert into @temp1 values(2655,1101)
insert into @temp1 values(2656,1101)
insert into @temp1 values(3196,1165)
insert into @temp1 values(3899,1288)
insert into @temp1 values(3900,1288)
insert into @temp1 values(3901,1288)
insert into @temp1 values(3902,1288)

--select * from @temp1

select ID1,ID2, ROW_NUMBER() over(partition by ID2 order by ID1) as RowNum1
from @temp1