SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserQuizStatus_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*

CALLS prcUserQuizStatus_Update_Quick

**/
CREATE   Procedure [prcUserQuizStatus_Update]
AS
Set Nocount On
declare @intHistoryID int

insert into tblModuleStatusUpdateHistory(startTime) values(getutcdate());
set @intHistoryID = @@identity


declare @cursor_OrgID	    int

DECLARE OrgList CURSOR
FOR
SELECT OrganisationID
from tblOrganisation
WHERE DATEDIFF (d,CourseStatusLastUpdated,dbo.udfUTCtoDaylightSavingTime(getutcdate(),OrganisationID)) > 0
order by OrganisationID desc

Open OrgList

FETCH NEXT FROM OrgList
Into
@cursor_OrgID

WHILE @@FETCH_STATUS = 0
BEGIN

exec prcUserQuizStatus_Update_Quick @cursor_OrgID
exec prcUserLessonStatus_Update_Quick @cursor_OrgID
print ''Completed Organisation: '' + Cast(@cursor_OrgID as varchar)

FETCH NEXT FROM OrgList Into @cursor_OrgID
END

CLOSE OrgList
DEALLOCATE OrgList



update tblModuleStatusUpdateHistory
set FinishTime = getutcdate()
where ModuleStatusUpdateHistoryID = @intHistoryID
' 
END
GO
