SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEscalationConfigForCourse_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcEscalationConfigForCourse_Update]
(
	@remEscID int = -1,
	@orgID int ,
	@courseIDs varchar(max)  = '''',
	@updateOption int =-1,
	@DaysToCompleteCourse int,
	@RemindUsers bit=0,
	@NumOfRemNotfy int =-1,
	@RepeatRem int =-1,
	@NotifyMgr bit =0,
	@IndividualNotification bit =0,
	@IsCumulative bit =0,
	@NotifyMgrDays int=-1,
	@QuizExpiryWarn bit =0,
	@DaysQuizExpiry int =-1,
	@preexpiryInitEnrolment bit =0,
	@postExpReminder bit = 0,
	@postExpInitEnrolment bit = 0,
	@postExpResitPeriod bit = 0,
	@preExpResitPeriod bit = 0
)
AS
BEGIN

		--update existing ones
		update
		tblReminderEscalation
		set
		DaysToCompleteCourse = @DaysToCompleteCourse,
		RemindUsers = @RemindUsers,
		NumOfRemNotfy = @NumOfRemNotfy,
		RepeatRem = @RepeatRem,
		NotifyMgr = @NotifyMgr,
		IsCumulative = @IsCumulative,
		QuizExpiryWarn = @QuizExpiryWarn,
		DaysQuizExpiry = @DaysQuizExpiry,		
		NotifyMgrDays = @NotifyMgrDays,
		IndividualNotification = @IndividualNotification,
		PreExpInitEnrolment = @preexpiryInitEnrolment,
		PostExpReminder =@postExpReminder,
		PostExpInitEnrolment = @postExpInitEnrolment,
		PostExpResitPeriod = @postExpResitPeriod,
		PreExpResitPeriod = @preExpResitPeriod
		
		where
		OrgId =@orgID
		and CourseId IN (SELECT * FROM dbo.udfCsvToInt(@courseIDs))
	
		insert into tblReminderEscalation (
		OrgId,
		CourseId,
		DaysToCompleteCourse,
		RemindUsers,
		NumOfRemNotfy,
		RepeatRem,
		NotifyMgr,
		IsCumulative,
		QuizExpiryWarn,
		DaysQuizExpiry,
		NotifyMgrDays,
		IndividualNotification,
		PreExpInitEnrolment,
		PostExpReminder,
		PostExpInitEnrolment,
		PostExpResitPeriod,
		PreExpResitPeriod,
		DateEnabled
		)
		select 
		@orgID,
		c.CourseID,
		@DaysToCompleteCourse,
		@RemindUsers,
		@NumOfRemNotfy,
		@RepeatRem,
		@NotifyMgr,
		@IsCumulative,
		@QuizExpiryWarn,
		@DaysQuizExpiry,
		@NotifyMgrDays,
		@IndividualNotification,
		@preexpiryInitEnrolment,
		@postExpReminder,
		@postExpInitEnrolment,
		@postExpResitPeriod,
		@preExpResitPeriod,
		GETUTCDATE()
		from tblCourse c
		left join tblReminderEscalation re on re.CourseId = c.CourseID and re.OrgId = @orgID
		where re.CourseId is null and c.CourseID IN (SELECT * FROM dbo.udfCsvToInt(@courseIDs))
		
END' 
END
GO
