SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcgetEscalationConfigForCourse ]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [prcgetEscalationConfigForCourse ]
(
	@orgID int ,
	@courseID int	
)
AS
BEGIN
	
	
	select
		*
	from 
		tblReminderEscalation 
	where 
		CourseId =@courseID
		and OrgId= @orgID
	
END
' 
END
GO
