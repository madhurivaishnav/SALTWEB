SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOvernightJobPreprocessOneOrg]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE Procedure [prcOvernightJobPreprocessOneOrg]
AS
BEGIN


declare @cursor_OrgID	    int
-- get the next OrgID (prcOvernightJobGetNextPreprocessingOrg remembers the last OrgID to be preprocessed)
exec @cursor_OrgID = dbo.prcOvernightJobGetNextPreprocessingOrg

-- update the UserLessonStatus for this org (handles the administrative changes to modules assigned to students)
--(originally this appears to have been done by triggers but it appears that the triggers slowed the ASP.NET WebPage too much and were replaced by the overnight job)
INSERT INTO tblPreProcess
           (StartTime)
     VALUES
           (getdate())
declare @preprocessID bigint
select @preprocessID = max (PreProcessID) FROM tblPreProcess
exec prcUserLessonStatus_Update_Quick @cursor_OrgID

exec prcPreprocessOneOrgUnassignedCourses @cursor_OrgID
exec prcPreprocessOneOrgAssignedCourses @cursor_OrgID
exec prcPreprocessOneOrgNoLongerPassedCourses @cursor_OrgID
exec prcPreprocessOneOrgNoLongerFailedCourses @cursor_OrgID
update tblPreProcess set EndTime = getdate() where @preprocessID = PreProcessID
END' 
END
GO
