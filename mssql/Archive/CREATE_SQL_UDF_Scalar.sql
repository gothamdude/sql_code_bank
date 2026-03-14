USE [CNRV5_1_Live]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetActionNamesCSV]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetActionNamesCSV]
GO

create function [dbo].[GetActionNamesCSV](@actionidcsv as varchar(255))
returns varchar(2000)
as
begin
declare @actionxml XML, @actionnamecsv varchar(2000);
		-- replace special XML characters that cause issues in SQL
	set @actionidcsv = replace(replace(@actionidcsv,'&', '&amp;'),'<', '&lt;')
	set @actionxml = '<Rows><Row><ACTION>'+
				replace(@actionidcsv,',','</ACTION></Row><Row><ACTION>')+
				'</ACTION></Row></Rows>'
	;with cte as
	(	
	select x.item.value('ACTION[1]','varchar(8)') [actionid]
	from @actionxml.nodes('/Rows/Row')AS x(item)
	)
	select @actionnamecsv = stuff((select ', ' + ra.code
	from cte c
	join dbo.Rule_Action ra
	on ra.actionid = c.actionid
	order by ra.code
	for xml path('')),1,2,'')

	return @actionnamecsv
end

GO
