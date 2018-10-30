SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUserLessonStatus_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE Procedure [prcUserLessonStatus_Update]
AS
Set Nocount On


declare @cursor_OrgID	    int

DECLARE OrgList CURSOR
FOR
SELECT OrganisationID from tblOrganisation order by OrganisationID desc

Open OrgList

FETCH NEXT FROM OrgList
Into
@cursor_OrgID

WHILE @@FETCH_STATUS = 0
BEGIN

exec prcUserLessonStatus_Update_Quick @cursor_OrgID

FETCH NEXT FROM OrgList Into @cursor_OrgID
END

CLOSE OrgList
DEALLOCATE OrgList


' 
END
GO
