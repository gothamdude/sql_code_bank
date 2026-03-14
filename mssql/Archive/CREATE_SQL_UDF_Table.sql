USE [CNRV5_1_Live]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HasMatchingLOB]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[HasMatchingLOB]
GO

create function [dbo].[HasMatchingLOB](@lobidcsv as nvarchar(255), @lobidfilterxml as xml)
returns @rowcount table(noofrows int)
as
begin
	declare @lobxml XML;
	-- replace special XML characters that cause issues in SQL
	set @lobidcsv = replace(replace(@lobidcsv,'&', '&amp;'),'<', '&lt;')
	set @lobxml = '<Rows><Row><LOB>'+
				replace(@lobidcsv,',','</LOB></Row><Row><LOB>')+
				'</LOB></Row></Rows>'
	;with cte as
	(	
	select x.item.value('LOB[1]','nvarchar(12)') [lobid]
	from @lobxml.nodes('/Rows/Row')AS x(item)
	)
	insert into @rowcount
	select 
	count(1)
	from cte c
	join (select x.item.value('LOB[1]','nvarchar(12)') [lobidfilter]
	from @lobidfilterxml.nodes('/Rows/Row')AS x(item)) lobfilter
	on lobfilter.lobidfilter = c.lobid
	where lobid != ''
	return
end

GO

