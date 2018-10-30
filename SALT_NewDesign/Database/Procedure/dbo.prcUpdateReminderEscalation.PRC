SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUpdateReminderEscalation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure  [prcUpdateReminderEscalation](@remescid int, @act int)
as
begin

if @act = 0  begin
update tblReminderEscalation set DateEnabled = case when DateEnabled IS null then GETUTCDATE() else null end where RemEscId = @remescid
end
else if @act = 1 begin
delete from tblReminderEscalation where RemEscId = @remescid
end


end

' 
END
GO
 