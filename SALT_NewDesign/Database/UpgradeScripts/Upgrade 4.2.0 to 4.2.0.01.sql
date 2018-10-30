DELETE FROM tblOrganisationConfig WHERE [Name] = 'Course_Completion_Certificate'
GO

INSERT INTO tblOrganisationConfig
           ([OrganisationID]
           ,[Name]
           ,[Description]
           ,[Value])
     VALUES
           (null
           ,'Course_Completion_Certificate'
           ,'Course Completion Certificate'
           ,'Congratulations %FirstName% %LastName% on passing the %APP_NAME%  %COURSE% , your completion certificate is attached or may be reprinted from the website at %URL%.')
GO

 IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ReportStartDate]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF_tblReportSchedule_ReportStartDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_OnceOnly]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF_tblReportSchedule_OnceOnly]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_Now]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF_tblReportSchedule_Now]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ParamLangCode]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF_tblReportSchedule_ParamLangCode]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblReport__Param__082CD432]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF__tblReport__Param__082CD432]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ParamProfilePeriodID]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF_tblReportSchedule_ParamProfilePeriodID]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_IsPeriodic]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF_tblReportSchedule_IsPeriodic]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_LastUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] DROP CONSTRAINT [DF_tblReportSchedule_LastUpdated]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReportSchedule]') AND type in (N'U'))
DROP TABLE [tblReportSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReportSchedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [tblReportSchedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ReportID] [int] NOT NULL,
	[LastRun] [datetime] NULL,
	[NextRun] [datetime] NULL,
	[ReportDuration] [int] NOT NULL,
	[ReportDurationPeriod] [char](1) NOT NULL,
	[ReportStartDate] [datetime] NOT NULL,
	[ReportEndDate] [datetime] NULL,
	[NumberOfReports] [int] NULL,
	[ReportFrequency] [int] NOT NULL,
	[ReportFrequencyPeriod] [char](1) NOT NULL,
	[DocumentType] [char](1) NOT NULL,
	[OnceOnly] [bit] NOT NULL,
	[Now] [bit] NOT NULL,
	[ReportTitle] [nvarchar](100) NULL,
	[ParamOrganisationID] [int] NOT NULL,
	[ParamCompleted] [char](1) NULL,
	[ParamStatus] [char](1) NULL,
	[ParamFailCount] [int] NULL,
	[ParamCourseIDs] [nvarchar](800) NULL,
	[ParamHistoricCourseIDs] [nvarchar](800) NULL,
	[ParamAllUnits] [char](1) NULL,
	[ParamTimeExpired] [int] NULL,
	[ParamTimeExpiredPeriod] [char](1) NULL,
	[ParamQuizStatus] [char](1) NULL,
	[ParamGroupBy] [char](1) NULL,
	[ParamGroupingOption] [int] NULL,
	[ParamFirstName] [nvarchar](200) NULL,
	[ParamLastName] [nvarchar](200) NULL,
	[ParamUserName] [nvarchar](200) NULL,
	[ParamEmail] [nvarchar](200) NULL,
	[ParamIncludeInactive] [char](1) NULL,
	[ParamSubject] [nvarchar](200) NULL,
	[ParamBody] [nvarchar](200) NULL,
	[ParamProfileID] [int] NULL,
	[ParamOnlyUsersWithShortfall] [char](1) NULL,
	[ParamEffectiveDate] [datetime] NULL,
	[ParamSortBy] [char](1) NULL,
	[ParamClassificationID] [int] NULL,
	[ParamUnitIDs] [nvarchar](max) NULL,
	[ParamLangCode] [nvarchar](10) NULL,
	[ParamDateTo] [datetime] NULL,
	[ParamDateFrom] [datetime] NULL,
	[ParamLicensingPeriod] [varchar](8000) NULL,
	[ParamProfilePeriodID] [int] NOT NULL,
	[ReportPeriodType] [int] NULL,
	[ReportFromDate] [datetime] NULL,
	[IsPeriodic] [char](1) NOT NULL,
	[LastUpdatedBy] [int] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
	[NumberDelivered] [int] NOT NULL,
	TerminatedNormally bit NOT NULL CONSTRAINT DF_tblReportSchedule_TerminatedNormally DEFAULT 0,
	[ParamPolicyIDs] [nvarchar](2000) NULL,
	[ParamAcceptance] [varchar](20) NULL
	[DateCreated] [datetime] NOT NULL,
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_NumberDelivered]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_NumberDelivered]  DEFAULT ((0)) FOR [NumberDelivered]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ReportStartDate]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_ReportStartDate]  DEFAULT (getutcdate()) FOR [ReportStartDate]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_OnceOnly]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_OnceOnly]  DEFAULT ((0)) FOR [OnceOnly]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_Now]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_Now]  DEFAULT ((0)) FOR [Now]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ParamLangCode]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_ParamLangCode]  DEFAULT (N'en-AU') FOR [ParamLangCode]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblReport__Param__082CD432]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF__tblReport__Param__082CD432]  DEFAULT ((0)) FOR [ParamLicensingPeriod]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ParamProfilePeriodID]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_ParamProfilePeriodID]  DEFAULT ((1)) FOR [ParamProfilePeriodID]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_IsPeriodic]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_IsPeriodic]  DEFAULT ('N') FOR [IsPeriodic]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_LastUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_LastUpdated]  DEFAULT (getutcdate()) FOR [LastUpdated]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END
GO

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUser ADD
	NotifyMgr bit NOT NULL CONSTRAINT DF_tblUser_NotifyMgr DEFAULT 0,
	NotifyUnitAdmin bit NOT NULL CONSTRAINT DF_tblUser_NotifyUnitAdmin DEFAULT 0,
	NotifyOrgAdmin bit NOT NULL CONSTRAINT DF_tblUser_NotifyOrgAdmin DEFAULT 0
GO
ALTER TABLE dbo.tblUser
	DROP CONSTRAINT DF_tblUser_NotifyOfPendingDelinquencies
GO
ALTER TABLE dbo.tblUser
	DROP COLUMN NotifyOfPendingDelinquencies, EmailInOrgDomain
GO
ALTER TABLE dbo.tblUser SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReportScheduleAudit]') AND type in (N'U'))
DROP TABLE [tblReportScheduleAudit]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReportScheduleAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [tblReportScheduleAudit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleID] [int]  NULL,
	[UserID] [int]  NULL,
	[ReportID] [int]  NULL,
	[LastRun] [datetime] NULL,
	[NextRun] [datetime] NULL,
	[ReportDuration] [int]  NULL,
	[ReportDurationPeriod] [char](1)  NULL,
	[ReportStartDate] [datetime]  NULL,
	[ReportEndDate] [datetime] NULL,
	[NumberOfReports] [int] NULL,
	[ReportFrequency] [int]  NULL,
	[ReportFrequencyPeriod] [char](1)  NULL,
	[DocumentType] [char](1)  NULL,
	[OnceOnly] [bit]  NULL,
	[Now] [bit]  NULL,
	[ReportTitle] [nvarchar](100) NULL,
	[ParamOrganisationID] [int]  NULL,
	[ParamCompleted] [char](1) NULL,
	[ParamStatus] [char](1) NULL,
	[ParamFailCount] [int] NULL,
	[ParamCourseIDs] [nvarchar](800) NULL,
	[ParamHistoricCourseIDs] [nvarchar](800) NULL,
	[ParamAllUnits] [char](1) NULL,
	[ParamTimeExpired] [int] NULL,
	[ParamTimeExpiredPeriod] [char](1) NULL,
	[ParamQuizStatus] [char](1) NULL,
	[ParamGroupBy] [char](1) NULL,
	[ParamGroupingOption] [int] NULL,
	[ParamFirstName] [nvarchar](200) NULL,
	[ParamLastName] [nvarchar](200) NULL,
	[ParamUserName] [nvarchar](200) NULL,
	[ParamEmail] [nvarchar](200) NULL,
	[ParamIncludeInactive] [char](1) NULL,
	[ParamSubject] [nvarchar](200) NULL,
	[ParamBody] [nvarchar](200) NULL,
	[ParamProfileID] [int] NULL,
	[ParamOnlyUsersWithShortfall] [char](1) NULL,
	[ParamEffectiveDate] [datetime] NULL,
	[ParamSortBy] [char](1) NULL,
	[ParamClassificationID] [int] NULL,
	[ParamUnitIDs] [nvarchar](max) NULL,
	[ParamLangCode] [nvarchar](10) NULL,
	[ParamDateTo] [datetime] NULL,
	[ParamDateFrom] [datetime] NULL,
	[ParamLicensingPeriod] [varchar](8000) NULL,
	[ParamProfilePeriodID] [int]  NULL,
	[ReportPeriodType] [int] NULL,
	[ReportFromDate] [datetime] NULL,
	[IsPeriodic] [char](1)  NULL,
	[LastUpdatedBy] [int]  NULL,
	[LastUpdated] [datetime]  NULL,
	[LastUpdAction] [char](1)  NULL,
	[NumberDelivered] [int]  NULL,
	TerminatedNormally bit  NULL,
	DateCreated datetime NULL 

 CONSTRAINT [PK_tblReportScheduleAudit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_DaysToCompleteCourse]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_DaysToCompleteCourse]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_RemindUsers]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_RemindUsers]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_NumOfRemNotfy]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_NumOfRemNotfy]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_RepeatRem]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_RepeatRem]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_NotifyMgr]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_NotifyMgr]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_IsCumulative]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_IsCumulative]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_QuizExpiryWarn]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_QuizExpiryWarn]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_DaysQuizExpiry]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_DaysQuizExpiry]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_LastNotified]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_LastNotified]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_NotifyMgrDays]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_NotifyMgrDays]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_IndividualNotification]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [DF_tblReminderEscalation_IndividualNotification]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReminderEscalation]') AND type in (N'U'))
DROP TABLE [tblReminderEscalation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblReminderEscalation]') AND type in (N'U'))
BEGIN
CREATE TABLE [tblReminderEscalation](
	[RemEscId] [int] IDENTITY(1,1) NOT NULL,
	[OrgId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[DaysToCompleteCourse] [int] NOT NULL,
	[RemindUsers] [bit] NOT NULL,
	[NumOfRemNotfy] [int] NOT NULL,
	[RepeatRem] [int] NOT NULL,
	[NotifyMgr] [bit] NOT NULL,
	[IsCumulative] [bit] NOT NULL,
	[QuizExpiryWarn] [bit] NOT NULL,
	[DaysQuizExpiry] [int] NOT NULL,
	[LastNotified] [datetime] NOT NULL,
	[NotifyMgrDays] [int] NOT NULL,
	[IndividualNotification] [bit] NOT NULL
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_DaysToCompleteCourse]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_DaysToCompleteCourse]  DEFAULT ((365)) FOR [DaysToCompleteCourse]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_RemindUsers]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_RemindUsers]  DEFAULT ((0)) FOR [RemindUsers]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_NumOfRemNotfy]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_NumOfRemNotfy]  DEFAULT ((0)) FOR [NumOfRemNotfy]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_RepeatRem]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_RepeatRem]  DEFAULT ((365)) FOR [RepeatRem]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_NotifyMgr]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_NotifyMgr]  DEFAULT ((0)) FOR [NotifyMgr]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_IsCumulative]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_IsCumulative]  DEFAULT ((0)) FOR [IsCumulative]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_QuizExpiryWarn]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_QuizExpiryWarn]  DEFAULT ((0)) FOR [QuizExpiryWarn]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_DaysQuizExpiry]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_DaysQuizExpiry]  DEFAULT ((0)) FOR [DaysQuizExpiry]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_LastNotified]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_LastNotified]  DEFAULT ('1 jan 2001') FOR [LastNotified]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_NotifyMgrDays]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_NotifyMgrDays]  DEFAULT ((1)) FOR [NotifyMgrDays]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReminderEscalation_IndividualNotification]') AND type = 'D')
BEGIN
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_IndividualNotification]  DEFAULT ((0)) FOR [IndividualNotification]
END

GO








IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblEmailPurged]') AND type in (N'U'))
DROP TABLE [tblEmailPurged]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblEmailPurged]') AND type in (N'U'))
BEGIN
CREATE TABLE [tblEmailPurged](
	[EmailId] [int] IDENTITY(1,1) NOT NULL,
	[ToEmail] [nvarchar](1000) NOT NULL,
	[ToName] [nvarchar](128) NULL,
	[FromEmail] [nvarchar](128) NOT NULL,
	[FromName] [nvarchar](128) NULL,
	[CC] [nvarchar](1000) NULL,
	[BCC] [nvarchar](1000) NULL,
	[Subject] [nvarchar](256) NOT NULL,
	[Body] [ntext] NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[OrganisationID] [int] NOT NULL,
 CONSTRAINT [PK_tblEmailPurged] PRIMARY KEY CLUSTERED 
(
	[EmailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblCCList]') AND type in (N'U'))
DROP TABLE [tblCCList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[tblCCList]') AND type in (N'U'))
BEGIN
CREATE TABLE [tblCCList](
	[CCId] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[ScheduleId] [int] NOT NULL,
 CONSTRAINT [PK_tblCCList] PRIMARY KEY CLUSTERED 
(
	[CCId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblCCList]') AND name = N'IX_tblCCList')
DROP INDEX [IX_tblCCList] ON [tblCCList] WITH ( ONLINE = OFF )
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblCCList]') AND name = N'IX_tblCCList')
CREATE NONCLUSTERED INDEX [IX_tblCCList] ON [tblCCList] 
(
	[ScheduleId] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_StopEmail]') AND type = 'D')
BEGIN
ALTER TABLE dbo.tblOrganisation ADD
	StopEmails bit NOT NULL CONSTRAINT DF_tblOrganisation_StopEmails DEFAULT 0
END
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_ShowLastPassed]') AND type = 'D')
BEGIN
ALTER TABLE dbo.tblOrganisation ADD
	ShowLastPassed bit NOT NULL CONSTRAINT DF_tblOrganisation_ShowLastPassed DEFAULT 1
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_GetNext]') AND type in (N'P', N'PC'))
DROP PROCEDURE [prcEmail_GetNext]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcEmail_GetNext]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [prcEmail_GetNext]
AS
BEGIN

  select
  tblEmailQueue.EmailQueueID
  into
  #tblEmailsToPurge
  FROM tblEmailQueue
  inner join tblOrganisation on tblOrganisation.OrganisationID = tblEmailQueue.organisationID
  where (tblOrganisation.StopEmails = 1)

  INSERT INTO tblEmailPurged
           ([ToEmail]
           ,[ToName]
           ,[FromEmail]
           ,[FromName]
           ,[CC]
           ,[BCC]
           ,[Subject]
           ,[Body]
           ,[DateCreated]
           ,[OrganisationID])
     
  SELECT  case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,CHARINDEX (''<'',AddressTo)+1,CHARINDEX (''>'',AddressTo)-CHARINDEX (''<'',AddressTo)-1) else AddressTo end

      ,case when ((CHARINDEX (''>'',AddressTo) > 0) and (CHARINDEX (''<'',AddressTo) > 0)) then SUBSTRING(AddressTo,1,CHARINDEX (''<'',AddressTo)-1) else AddressTo end
	  ,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,CHARINDEX (''<'',AddressFrom)+1,CHARINDEX (''>'',AddressFrom)-CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
      ,case when ((CHARINDEX (''>'',AddressFrom) > 0) and (CHARINDEX (''<'',AddressFrom) > 0)) then SUBSTRING(AddressFrom,1,CHARINDEX (''<'',AddressFrom)-1) else AddressFrom end
      ,''''
      ,AddressBccs
      ,Subject
      ,Body
      ,QueuedTime
      ,tblEmailQueue.organisationID
  FROM tblEmailQueue inner join
  #tblEmailsToPurge ON tblEmailQueue.EmailQueueID = #tblEmailsToPurge.EmailQueueID
  DELETE FROM tblEmailQueue WHERE EmailQueueID in (SELECT EmailQueueID FROM #tblEmailsToPurge) 

  DECLARE  @EmailQueueID INT
  SELECT @EmailQueueID = MIN (EmailQueueID)
  FROM tblEmailQueue
  WHERE ((SendStarted is NULL) OR (DATEADD(DAY,1,SendStarted) < GETUTCDATE()))
-- A SINGLE INSTANCE  WILL BE UPDATING THE TABLE SO DO NO MULTIUSER CODE
  SELECT TOP (1) EmailQueueID,OrganisationID,AddressTo,AddressBCCs,[Subject],body,AddressSender,AddressFrom,IsHTML,CASE WHEN DATEDIFF(d,QueuedTime,GETUTCDATE()) > 1 THEN 1 ELSE 0 END AS Retry
  FROM tblEmailQueue  WHERE @EmailQueueID =  EmailQueueID
  UPDATE tblEmailQueue SET SendStarted = GETUTCDATE()  WHERE @EmailQueueID =  EmailQueueID

END
' 
END
GO

INSERT [tblOrganisationConfig] ([OrganisationID], [Name], [Description], [Value]) VALUES (NULL, N'Overdue_Summary_Header_Individual', N'Overdue Summary Header - Individual Emails', N'Hi %FirstName%, The Following student is now Overdue for their %APP_NAME% course/s:')
GO

UPDATE tblOrganisationConfig
SET       Value = REPLACE(Value, 'Hi,', 'Hi %FirstName%,')
WHERE (OrganisationID IS NULL)
GO


If  exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/PeriodicReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblFrequency')) 
begin update tblLangValue set LangEntryValue = 'Every' where LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/PeriodicReport.aspx')
and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblFrequency')  and LangID = 2 end
GO


UPDATE tblReportInterface
   SET 
     RequiresParamLicensingPeriod = 1
 WHERE ReportID = 30
GO

UPDATE tblReportInterface
   SET 
     RequiresParamLicensingPeriod = 1
 WHERE ReportID = 20
GO

UPDATE tblReportInterface
   SET 
     RequiresParamCourseID = 0
 WHERE ReportID = 20
GO

DELETE FROM tblReportType
      WHERE TYPE = 'X'
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblEmailQueue]') AND name = N'PK_tblEmailQueue')
ALTER TABLE [tblEmailQueue] DROP CONSTRAINT [PK_tblEmailQueue]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblEmailQueue]') AND name = N'PK_tblEmailQueue')
ALTER TABLE [tblEmailQueue] ADD  CONSTRAINT [PK_tblEmailQueue] PRIMARY KEY CLUSTERED 
(
	[EmailQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblEmailQueue]') AND name = N'IX_tblEmailQueue')
DROP INDEX [IX_tblEmailQueue] ON [tblEmailQueue] WITH ( ONLINE = OFF )
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblEmailQueue]') AND name = N'IX_tblEmailQueue')
CREATE NONCLUSTERED INDEX [IX_tblEmailQueue] ON [tblEmailQueue] 
(
	[SendStarted] ASC,
	[EmailQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblReminderEscalation]') AND name = N'PK_tblReminderEscalation_1')
ALTER TABLE [tblReminderEscalation] DROP CONSTRAINT [PK_tblReminderEscalation_1]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblReminderEscalation]') AND name = N'PK_tblReminderEscalation_1')
ALTER TABLE [tblReminderEscalation] ADD  CONSTRAINT [PK_tblReminderEscalation_1] PRIMARY KEY CLUSTERED 
(
	[RemEscId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblReminderEscalation]') AND name = N'IX_tblReminderEscalation')
DROP INDEX [IX_tblReminderEscalation] ON [tblReminderEscalation] WITH ( ONLINE = OFF )
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblReminderEscalation]') AND name = N'IX_tblReminderEscalation')
CREATE NONCLUSTERED INDEX [IX_tblReminderEscalation] ON [tblReminderEscalation] 
(
	[OrgId] ASC,
	[CourseId] ASC,
	[IndividualNotification] ASC,
	[NotifyMgr] ASC,
	[DaysToCompleteCourse] ASC,
	[NotifyMgrDays] ASC,
	[RepeatRem] ASC,
	[NumOfRemNotfy] ASC,
	[LastNotified] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblEmailQueueLinkedResource]') AND name = N'PK_tblEmailQueueLinkedResource')
ALTER TABLE [tblEmailQueueLinkedResource] DROP CONSTRAINT [PK_tblEmailQueueLinkedResource]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblEmailQueueLinkedResource]') AND name = N'PK_tblEmailQueueLinkedResource')
ALTER TABLE [tblEmailQueueLinkedResource] ADD  CONSTRAINT [PK_tblEmailQueueLinkedResource] PRIMARY KEY CLUSTERED 
(
	[EmailQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblReportInterface]') AND name = N'PK_tblReportInterface')
ALTER TABLE [tblReportInterface] DROP CONSTRAINT [PK_tblReportInterface]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[tblReportInterface]') AND name = N'PK_tblReportInterface')
ALTER TABLE [tblReportInterface] ADD  CONSTRAINT [PK_tblReportInterface] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


 
if not exists (select * from tblAppConfig where Name ='Email_OnBehalfOf') begin
	insert into tblAppConfig (Name, Value) values('Email_OnBehalfOf','ENTER_ON_BEHALF_OF_EMAIL@ADDRESS.HERE')
end
GO



DELETE FROM tblReportType
WHERE (Name LIKE '%html%')
GO