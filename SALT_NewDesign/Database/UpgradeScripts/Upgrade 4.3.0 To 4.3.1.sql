IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblPreProcess]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [tblPreProcess](
	[PreProcessID] [bigint] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL
) ON [PRIMARY]
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcOvernightJobPreprocessOneOrg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [prcOvernightJobPreprocessOneOrg]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prcOvernightJobPreprocessOneOrg]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
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



IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[prc_cpu_percent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prc_cpu_percent]


AS
BEGIN

DECLARE @CPU_percent int

DECLARE @CPU_BUSY int, @IDLE int
SELECT @CPU_BUSY = @@CPU_BUSY, @IDLE = @@IDLE WAITFOR DELAY ''000:00:10''
SET @CPU_percent = (@@CPU_BUSY - @CPU_BUSY)/((@@IDLE - @IDLE + @@CPU_BUSY - @CPU_BUSY) *1.00) *100

SELECT @CPU_percent
RETURN @CPU_percent

END
' 
END
GO 