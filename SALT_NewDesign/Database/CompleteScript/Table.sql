SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblAppConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblAppConfig](
	[Name] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_tblAppConfig] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBulkInactiveUsers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBulkInactiveUsers](
	[UserID] [int] NOT NULL,
	[Processed] [bit] NOT NULL
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblBulkInactiveUsers_Processed]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblBulkInactiveUsers]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblBulkInactiveUsers_Processed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblBulkInactiveUsers] ADD  CONSTRAINT [DF_tblBulkInactiveUsers_Processed]  DEFAULT ((0)) FOR [Processed]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCCList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCCList](
	[CCId] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ScheduleId] [int] NOT NULL,
 CONSTRAINT [PK_tblCCList] PRIMARY KEY CLUSTERED 
(
	[CCId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClassification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblClassification](
	[ClassificationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClassificationTypeID] [int] NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_tblClassification] PRIMARY KEY NONCLUSTERED 
(
	[ClassificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblClassification_Active]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClassification]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblClassification_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblClassification] ADD  CONSTRAINT [DF_tblClassification_Active]  DEFAULT ((1)) FOR [Active]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCounters]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCounters](
	[OvernightJobCurrentOrg] [int] NULL
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCourse]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCourse](
	[CourseID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Notes] [nvarchar](1000) NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_tblCourse] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblCourse_Active]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblCourse]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblCourse_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblCourse] ADD  CONSTRAINT [DF_tblCourse_Active]  DEFAULT ((0)) FOR [Active]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblCourse_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblCourse]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblCourse_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblCourse] ADD  CONSTRAINT [DF_tblCourse_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCourseLicensing]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCourseLicensing](
	[CourseLicensingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NULL,
	[CourseID] [int] NULL,
	[LicenseNumber] [int] NULL,
	[DateStart] [datetime] NULL,
	[DateEnd] [datetime] NULL,
	[LicenseWarnEmail] [bit] NULL,
	[LicenseWarnNumber] [int] NULL,
	[DateLicenseWarnEmailSent] [datetime] NULL,
	[ExpiryWarnEmail] [bit] NULL,
	[DateWarn] [datetime] NULL,
	[DateExpiryWarnEmailSent] [datetime] NULL,
	[RepNameSalt] [nvarchar](200) NULL,
	[RepEmailSalt] [nvarchar](200) NULL,
	[RepNameOrg] [nvarchar](200) NULL,
	[RepEmailOrg] [nvarchar](200) NULL,
	[LangCode] [varchar](10) NULL,
 CONSTRAINT [PK_tblCourseLicensing] PRIMARY KEY CLUSTERED 
(
	[CourseLicensingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCourseLicensingUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCourseLicensingUser](
	[CourseLicensingUserID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CourseLicensingID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[LicenseDate] [datetime] NULL,
 CONSTRAINT [PK_tblCourseLicensingUser] PRIMARY KEY CLUSTERED 
(
	[CourseLicensingID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblCourseLicensingUser_LicenseDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblCourseLicensingUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblCourseLicensingUser_LicenseDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblCourseLicensingUser] ADD  CONSTRAINT [DF_tblCourseLicensingUser_LicenseDate]  DEFAULT (getutcdate()) FOR [LicenseDate]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCourseStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCourseStatus](
	[CourseStatusID] [int] IDENTITY(0,1) NOT FOR REPLICATION NOT NULL,
	[Status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblCourseStatus] PRIMARY KEY CLUSTERED 
(
	[CourseStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblDebugLessonSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblDebugLessonSession](
	[debuglesson_id] [int] IDENTITY(1,1) NOT NULL,
	[lessonsession_id] [varchar](50) NULL,
	[date_created] [datetime] NULL,
	[return_value] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[debuglesson_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblDebugQuizSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblDebugQuizSession](
	[debugquiz_id] [int] IDENTITY(1,1) NOT NULL,
	[quizsession_id] [varchar](50) NULL,
	[date_created] [datetime] NULL,
	[return_value] [bit] NULL,
 CONSTRAINT [PK_tblDebugQuizSession] PRIMARY KEY CLUSTERED 
(
	[debugquiz_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEmail](
	[EmailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[UserID] [int] NULL,
 CONSTRAINT [PK_tblEmail] PRIMARY KEY CLUSTERED 
(
	[EmailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblEmail_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblEmail]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblEmail_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblEmail] ADD  CONSTRAINT [DF_tblEmail_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END


End
GO


ALTER TABLE [dbo].[tblEmail] ADD  DEFAULT (NULL) FOR [UserID]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmailPurged]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEmailPurged](
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




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmailQueue]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEmailQueue](
	[EmailQueueID] [bigint] IDENTITY(1,1) NOT NULL,
	[organisationID] [int] NULL,
	[AddressTo] [nvarchar](255) NULL,
	[Subject] [nvarchar](255) NULL,
	[Body] [nvarchar](max) NULL,
	[QueuedTime] [datetime] NOT NULL,
	[SendStarted] [datetime] NULL,
	[AddressSender] [nvarchar](255) NULL,
	[AddressFrom] [nvarchar](255) NULL,
	[IsHTML] [bit] NULL,
	[AddressBccs] [nvarchar](max) NULL,
 CONSTRAINT [PK_tblEmailQueue] PRIMARY KEY CLUSTERED 
(
	[EmailQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblEmailQueue_QueuedTime]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblEmailQueue]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblEmailQueue_QueuedTime]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblEmailQueue] ADD  CONSTRAINT [DF_tblEmailQueue_QueuedTime]  DEFAULT (getutcdate()) FOR [QueuedTime]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmailQueueLinkedResource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEmailQueueLinkedResource](
	[EmailQueueID] [bigint] NOT NULL,
	[ContentID] [nvarchar](100) NOT NULL,
	[ByteStream] [varbinary](max) NULL,
 CONSTRAINT [PK_tblEmailQueueLinkedResource] PRIMARY KEY CLUSTERED 
(
	[EmailQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblErrorLevel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblErrorLevel](
	[ErrorLevelID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ErrorLevelDescription] [varchar](15) NOT NULL,
 CONSTRAINT [PK_tblErrorLevel] PRIMARY KEY CLUSTERED 
(
	[ErrorLevelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblErrorStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblErrorStatus](
	[ErrorStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ErrorStatusDescription] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblErrorStatus] PRIMARY KEY CLUSTERED 
(
	[ErrorStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblExpiredNewContent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblExpiredNewContent](
	[ExpiredContentID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_tblExpiredNewContent] PRIMARY KEY CLUSTERED 
(
	[ExpiredContentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLang]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLang](
	[LangID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LangName] [varchar](200) NULL,
	[LangCode] [varchar](10) NOT NULL,
	[ShowAdmin] [bit] NULL,
	[ShowUser] [bit] NULL,
	[UserCreated] [int] NULL,
	[UserModified] [int] NULL,
	[UserDeleted] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[DateDeleted] [datetime] NULL,
	[RecordLock] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblLang] PRIMARY KEY CLUSTERED 
(
	[LangCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLang_RecordLock]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLang]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLang_RecordLock]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLang] ADD  CONSTRAINT [DF_tblLang_RecordLock]  DEFAULT (newid()) FOR [RecordLock]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLangInterface]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLangInterface](
	[LangInterfaceID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LangInterfaceName] [varchar](200) NOT NULL,
	[InterfaceType] [varchar](20) NULL,
	[UserCreated] [int] NULL,
	[UserModified] [int] NULL,
	[UserDeleted] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[DateDeleted] [datetime] NULL,
	[RecordLock] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblLangInterface] PRIMARY KEY CLUSTERED 
(
	[LangInterfaceName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangInterface_InterfaceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLangInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangInterface_InterfaceType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLangInterface] ADD  CONSTRAINT [DF_tblLangInterface_InterfaceType]  DEFAULT ('') FOR [InterfaceType]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangInterface_RecordLock]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLangInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangInterface_RecordLock]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLangInterface] ADD  CONSTRAINT [DF_tblLangInterface_RecordLock]  DEFAULT (newid()) FOR [RecordLock]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLangResource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLangResource](
	[LangResourceID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LangResourceName] [varchar](200) NOT NULL,
	[ResourceType] [varchar](20) NULL,
	[Comment] [varchar](200) NULL,
	[UserCreated] [int] NULL,
	[UserModified] [int] NULL,
	[UserDeleted] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[DateDeleted] [datetime] NULL,
	[RecordLock] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblLangResource] PRIMARY KEY CLUSTERED 
(
	[LangResourceName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangResource_ResourceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLangResource]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangResource_ResourceType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLangResource] ADD  CONSTRAINT [DF_tblLangResource_ResourceType]  DEFAULT ('') FOR [ResourceType]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLangValue]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLangValue](
	[LangValueID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LangID] [int] NOT NULL,
	[LangInterfaceID] [int] NOT NULL,
	[LangResourceID] [int] NOT NULL,
	[LangEntryValue] [nvarchar](4000) NULL,
	[Active] [bit] NOT NULL,
	[UserCreated] [int] NULL,
	[UserModified] [int] NULL,
	[UserDeleted] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[DateDeleted] [datetime] NULL,
	[RecordLock] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblLangValue] PRIMARY KEY CLUSTERED 
(
	[LangID] ASC,
	[LangInterfaceID] ASC,
	[LangResourceID] ASC,
	[Active] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangValue_RecordLock]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLangValue]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangValue_RecordLock]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLangValue] ADD  CONSTRAINT [DF_tblLangValue_RecordLock]  DEFAULT (newid()) FOR [RecordLock]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLangValueArchive]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLangValueArchive](
	[LangValueArchiveID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LangID] [int] NULL,
	[LangInterfaceID] [int] NULL,
	[LangResourceID] [int] NULL,
	[LangEntryValue] [nvarchar](4000) NULL,
	[UserCreated] [int] NULL,
	[DateCreated] [datetime] NULL,
 CONSTRAINT [PK_tblLangValueArchive] PRIMARY KEY CLUSTERED 
(
	[LangValueArchiveID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLangValueArchive_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLangValueArchive]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLangValueArchive_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLangValueArchive] ADD  CONSTRAINT [DF_tblLangValueArchive_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLessonStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLessonStatus](
	[LessonStatusID] [int] IDENTITY(0,1) NOT FOR REPLICATION NOT NULL,
	[Status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblLessonStatus] PRIMARY KEY CLUSTERED 
(
	[LessonStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLogDaily]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLogDaily](
	[OrganisationID] [int] NOT NULL,
	[TimePeriod1] [int] NOT NULL,
	[TimePeriod2] [int] NOT NULL,
	[TimePeriod3] [int] NOT NULL,
	[TimePeriod4] [int] NOT NULL,
	[TimePeriod5] [int] NOT NULL,
	[TimePeriod6] [int] NOT NULL,
	[TimePeriod7] [int] NOT NULL,
	[TimePeriod8] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLogDaily_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLogDaily]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLogDaily_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLogDaily] ADD  CONSTRAINT [DF_tblLogDaily_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLogHourly]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLogHourly](
	[OrganisationID] [int] NOT NULL,
	[TimePeriod1] [int] NOT NULL,
	[TimePeriod2] [int] NOT NULL,
	[TimePeriod3] [int] NOT NULL,
	[TimePeriod4] [int] NOT NULL,
	[TimePeriod5] [int] NOT NULL,
	[TimePeriod6] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLogHourly_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLogHourly]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLogHourly_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLogHourly] ADD  CONSTRAINT [DF_tblLogHourly_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblModule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblModule](
	[ModuleID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CourseID] [int] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Sequence] [int] NULL,
	[Description] [nvarchar](1000) NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[DateCreated] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_tblModule] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblModule_tblCourse]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblModule]'))
ALTER TABLE [dbo].[tblModule]  WITH CHECK ADD  CONSTRAINT [FK_tblModule_tblCourse] FOREIGN KEY([CourseID])
REFERENCES [dbo].[tblCourse] ([CourseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblModule_tblCourse]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblModule]'))
ALTER TABLE [dbo].[tblModule] CHECK CONSTRAINT [FK_tblModule_tblCourse]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblModuleStatusUpdateHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblModuleStatusUpdateHistory](
	[ModuleStatusUpdateHistoryID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[FinishTime] [datetime] NULL,
 CONSTRAINT [PK_tblModuleStatusUpdateHistory] PRIMARY KEY CLUSTERED 
(
	[ModuleStatusUpdateHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblModuleStatusUpdateHistory_StartTime]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblModuleStatusUpdateHistory]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblModuleStatusUpdateHistory_StartTime]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblModuleStatusUpdateHistory] ADD  CONSTRAINT [DF_tblModuleStatusUpdateHistory_StartTime]  DEFAULT (getutcdate()) FOR [StartTime]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisation]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[tblOrganisation](
		[OrganisationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
		[OrganisationName] [nvarchar](50) NOT NULL,
		[Logo] [varchar](100) NULL,
		[Notes] [nvarchar](4000) NULL,
		[DefaultLessonFrequency] [int] NOT NULL,
		[DefaultQuizFrequency] [int] NOT NULL,
		[DefaultQuizPassMark] [int] NOT NULL,
		[DefaultLessonCompletionDate] [datetime] NULL,
		[DefaultQuizCompletionDate] [datetime] NULL,
		[CreatedBy] [int] NOT NULL,
		[DateCreated] [datetime] NOT NULL,
		[UpdatedBy] [int] NULL,
		[DateUpdated] [datetime] NOT NULL,
		[AdvancedReporting] [bit] NOT NULL,
		[DomainName] [nvarchar](255) NULL,
		[CPDReportName] [nvarchar](255) NULL,
		[AllocatedDiskSpace] [bigint] NULL,
		[IncludeCertificateLogo] [bit] NULL,
		[PasswordLockout] [bit] NOT NULL,
		[TimeZoneID] [int] NOT NULL,
		[CourseStatusLastUpdated] [datetime] NOT NULL,
		[DelinquenciesLastNotified] [datetime] NOT NULL,
		[IncludeLogoOnCorrespondence] [bit] NOT NULL,
		[QuizDueDate] [datetime] NOT NULL,
		[StopEmails] [bit] NOT NULL,
		[ShowLastPassed] [bit] NOT NULL,
		[DisablePasswordField] [bit] NOT NULL,
		[DefaultEbookEmailNotification] [bit] NOT NULL,
	 CONSTRAINT [PK_tblOrganization] PRIMARY KEY CLUSTERED 
	(
		[OrganisationID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO




SET ANSI_PADDING OFF
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
	IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_DateCreated]') AND type = 'D')
	BEGIN
	ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
	END


End
GO


IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_DateUpdated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
	IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_DateUpdated]') AND type = 'D')
	BEGIN
		ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_DateUpdated]  DEFAULT (getutcdate()) FOR [DateUpdated]
	END
End
GO


IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_AdvancedReporting]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_AdvancedReporting]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_AdvancedReporting]  DEFAULT ((0)) FOR [AdvancedReporting]
END


End
GO


IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_PasswordLockout]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_PasswordLockout]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_PasswordLockout]  DEFAULT ((0)) FOR [PasswordLockout]
END


End
GO


IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tblOrgani__TimeZ__78B58678]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblOrgani__TimeZ__78B58678]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  DEFAULT ((1)) FOR [TimeZoneID]
END


End
GO

IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_CourseStatusLastUpdated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_CourseStatusLastUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_CourseStatusLastUpdated]  DEFAULT ('1 jan 2001') FOR [CourseStatusLastUpdated]
END


End
GO

IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_DelinquenciesLastNotified]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_DelinquenciesLastNotified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_DelinquenciesLastNotified]  DEFAULT ('1 jan 2001') FOR [DelinquenciesLastNotified]
END


End
GO

IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_IncludeLogoOnCorrespondence]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_IncludeLogoOnCorrespondence]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_IncludeLogoOnCorrespondence]  DEFAULT ((0)) FOR [IncludeLogoOnCorrespondence]
END


End
GO

IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tblOrgani__QuizD__0056A840]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblOrgani__QuizD__0056A840]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  DEFAULT (dateadd(dayofyear,(1),getdate())) FOR [QuizDueDate]
END


End
GO

IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_StopEmails]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_StopEmails]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_StopEmails]  DEFAULT ((0)) FOR [StopEmails]
END


End
GO

IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_ShowLastPassed]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_ShowLastPassed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_ShowLastPassed]  DEFAULT ((1)) FOR [ShowLastPassed]
END
end
GO

IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblOrganisation_DisablePasswordField]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblOrganisation_DisablePasswordField]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblOrganisation] ADD  CONSTRAINT [DF_tblOrganisation_DisablePasswordField]  DEFAULT ((0)) FOR [DisablePasswordField]
END
end
GO

ALTER TABLE [dbo].[tblOrganisation] ADD  DEFAULT ((0)) FOR [DefaultEbookEmailNotification]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblOrganisationConfig](
	[OrganisationID] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](4000) NULL,
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK__tblOrganisationC__4D2051A6] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationConfig_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationConfig]'))
ALTER TABLE [dbo].[tblOrganisationConfig]  WITH CHECK ADD  CONSTRAINT [FK_tblOrganisationConfig_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationConfig_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationConfig]'))
ALTER TABLE [dbo].[tblOrganisationConfig] CHECK CONSTRAINT [FK_tblOrganisationConfig_tblOrganisation]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationCourseAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblOrganisationCourseAccess](
	[OrganisationID] [int] NOT NULL,
	[GrantedCourseID] [int] NOT NULL,
 CONSTRAINT [PK_tblOrganisationCourseAccess] PRIMARY KEY CLUSTERED 
(
	[OrganisationID] ASC,
	[GrantedCourseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCourseAccess_tblCourse]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCourseAccess]'))
ALTER TABLE [dbo].[tblOrganisationCourseAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblOrganisationCourseAccess_tblCourse] FOREIGN KEY([GrantedCourseID])
REFERENCES [dbo].[tblCourse] ([CourseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCourseAccess_tblCourse]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCourseAccess]'))
ALTER TABLE [dbo].[tblOrganisationCourseAccess] CHECK CONSTRAINT [FK_tblOrganisationCourseAccess_tblCourse]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCourseAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCourseAccess]'))
ALTER TABLE [dbo].[tblOrganisationCourseAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblOrganisationCourseAccess_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCourseAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCourseAccess]'))
ALTER TABLE [dbo].[tblOrganisationCourseAccess] CHECK CONSTRAINT [FK_tblOrganisationCourseAccess_tblOrganisation]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationCPDAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblOrganisationCPDAccess](
	[OrganisationID] [int] NOT NULL,
	[GrantCPDAccess] [bit] NOT NULL,
 CONSTRAINT [PK_tblOrganisationCPDAccess] PRIMARY KEY CLUSTERED 
(
	[OrganisationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCPDAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCPDAccess]'))
ALTER TABLE [dbo].[tblOrganisationCPDAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblOrganisationCPDAccess_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationCPDAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationCPDAccess]'))
ALTER TABLE [dbo].[tblOrganisationCPDAccess] CHECK CONSTRAINT [FK_tblOrganisationCPDAccess_tblOrganisation]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationModuleAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblOrganisationModuleAccess](
	[OrganisationModuleAccessID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NULL,
	[PolicyBuilder] [bit] NULL,
 CONSTRAINT [PK_tblOrganisationModuleAccess] PRIMARY KEY CLUSTERED 
(
	[OrganisationModuleAccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationNotes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblOrganisationNotes](
	[OrganisationNotesID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[LanguageID] [int] NOT NULL,
	[Notes] [nvarchar](4000) NULL,
 CONSTRAINT [PK_tblOrganisationNotes] PRIMARY KEY CLUSTERED 
(
	[OrganisationNotesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblOrganisationPolicyAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblOrganisationPolicyAccess](
	[OrganisationID] [int] NOT NULL,
	[GrantPolicyAccess] [bit] NOT NULL,
 CONSTRAINT [PK_tblOrganisationPolicyAccess] PRIMARY KEY CLUSTERED 
(
	[OrganisationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationPolicyAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationPolicyAccess]'))
ALTER TABLE [dbo].[tblOrganisationPolicyAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblOrganisationPolicyAccess_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblOrganisationPolicyAccess_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblOrganisationPolicyAccess]'))
ALTER TABLE [dbo].[tblOrganisationPolicyAccess] CHECK CONSTRAINT [FK_tblOrganisationPolicyAccess_tblOrganisation]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblPolicy]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblPolicy](
	[PolicyID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[PolicyName] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[PolicyFileName] [nvarchar](255) NULL,
	[PolicyFileSize] [bigint] NULL,
	[UploadDate] [datetime] NULL,
	[ConfirmationMessage] [nvarchar](500) NULL,
 CONSTRAINT [PK_tblPolicy] PRIMARY KEY CLUSTERED 
(
	[PolicyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblPolicy_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblPolicy]'))
ALTER TABLE [dbo].[tblPolicy]  WITH CHECK ADD  CONSTRAINT [FK_tblPolicy_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblPolicy_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblPolicy]'))
ALTER TABLE [dbo].[tblPolicy] CHECK CONSTRAINT [FK_tblPolicy_tblOrganisation]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblProfile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblProfile](
	[ProfileID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProfileName] [nvarchar](255) NOT NULL,
	[OrganisationID] [int] NOT NULL,
 CONSTRAINT [PK_tblProfile] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblProfile_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblProfile]'))
ALTER TABLE [dbo].[tblProfile]  WITH CHECK ADD  CONSTRAINT [FK_tblProfile_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblProfile_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblProfile]'))
ALTER TABLE [dbo].[tblProfile] CHECK CONSTRAINT [FK_tblProfile_tblOrganisation]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblProfilePeriod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblProfilePeriod](
	[ProfilePeriodID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProfileID] [int] NOT NULL,
	[DateStart] [datetime] NULL,
	[DateEnd] [datetime] NULL,
	[Points] [numeric](10, 1) NULL,
	[EndOfPeriodAction] [char](1) NULL,
	[MonthIncrement] [int] NULL,
	[FutureDateStart] [datetime] NULL,
	[FutureDateEnd] [datetime] NULL,
	[FuturePoints] [numeric](10, 1) NULL,
	[ApplyToQuiz] [bit] NULL,
	[ApplyToLesson] [bit] NULL,
	[ProfilePeriodActive] [bit] NULL,
 CONSTRAINT [PK_tblProfilePeriod] PRIMARY KEY CLUSTERED 
(
	[ProfilePeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblProfilePeriod_tblProfile]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblProfilePeriod]'))
ALTER TABLE [dbo].[tblProfilePeriod]  WITH CHECK ADD  CONSTRAINT [FK_tblProfilePeriod_tblProfile] FOREIGN KEY([ProfileID])
REFERENCES [dbo].[tblProfile] ([ProfileID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblProfilePeriod_tblProfile]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblProfilePeriod]'))
ALTER TABLE [dbo].[tblProfilePeriod] CHECK CONSTRAINT [FK_tblProfilePeriod_tblProfile]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblProfilePoints]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblProfilePoints](
	[ProfilePointsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProfilePointsType] [nvarchar](1) NOT NULL,
	[TypeID] [int] NOT NULL,
	[ProfilePeriodID] [int] NOT NULL,
	[Points] [numeric](10, 1) NOT NULL,
	[Active] [bit] NOT NULL,
	[DateAssigned] [datetime] NOT NULL,
 CONSTRAINT [PK_tblProfilePoints] PRIMARY KEY CLUSTERED 
(
	[ProfilePointsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblProfilePoints_tblProfilePeriod]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblProfilePoints]'))
ALTER TABLE [dbo].[tblProfilePoints]  WITH CHECK ADD  CONSTRAINT [FK_tblProfilePoints_tblProfilePeriod] FOREIGN KEY([ProfilePeriodID])
REFERENCES [dbo].[tblProfilePeriod] ([ProfilePeriodID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblProfilePoints_tblProfilePeriod]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblProfilePoints]'))
ALTER TABLE [dbo].[tblProfilePoints] CHECK CONSTRAINT [FK_tblProfilePoints_tblProfilePeriod]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblProfilePoints_DateAssigned]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblProfilePoints]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblProfilePoints_DateAssigned]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblProfilePoints] ADD  CONSTRAINT [DF_tblProfilePoints_DateAssigned]  DEFAULT (getutcdate()) FOR [DateAssigned]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuiz]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuiz](
	[QuizID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ModuleID] [int] NOT NULL,
	[ToolbookID] [varchar](50) NOT NULL,
	[ToolbookLocation] [varchar](100) NOT NULL,
	[DatePublished] [datetime] NOT NULL,
	[LoadedBy] [int] NOT NULL,
	[DateLoaded] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
	[WorksiteID] [nvarchar](50) NULL,
	[Scorm1_2] [bit] NOT NULL,
	[LectoraBookmark] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tblQuiz] PRIMARY KEY CLUSTERED 
(
	[QuizID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuiz_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuiz]'))
ALTER TABLE [dbo].[tblQuiz]  WITH CHECK ADD  CONSTRAINT [FK_tblQuiz_tblModule] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuiz_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuiz]'))
ALTER TABLE [dbo].[tblQuiz] CHECK CONSTRAINT [FK_tblQuiz_tblModule]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblQuiz_DatePublished]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuiz]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblQuiz_DatePublished]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblQuiz] ADD  CONSTRAINT [DF_tblQuiz_DatePublished]  DEFAULT (getutcdate()) FOR [DatePublished]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblQuiz_DateLoaded]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuiz]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblQuiz_DateLoaded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblQuiz] ADD  CONSTRAINT [DF_tblQuiz_DateLoaded]  DEFAULT (getutcdate()) FOR [DateLoaded]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblQuiz_NewContent]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuiz]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblQuiz_NewContent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblQuiz] ADD  CONSTRAINT [DF_tblQuiz_NewContent]  DEFAULT ((0)) FOR [Active]
END


End
GO


ALTER TABLE [dbo].[tblQuiz] ADD  CONSTRAINT [DF_tblQuiz_Scorm1_2]  DEFAULT ((0)) FOR [Scorm1_2]
GO

ALTER TABLE [dbo].[tblQuiz] ADD  CONSTRAINT [DF_tblQuiz_LectoraBookmark]  DEFAULT ('A001_quiz.html') FOR [LectoraBookmark]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizExpiryAtRisk]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuizExpiryAtRisk](
	[UserID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[DaysToExpiry] [int] NULL,
	[OrganisationID] [int] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[PreExpiryNotified] [bit] NOT NULL,
	[ExpiryNotifications] [int] NOT NULL,
	[DateNotified] [datetime] NULL,
 CONSTRAINT [PK_tblQuizExpiryAtRisk] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ModuleID] ASC,
	[OrganisationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[tblQuizExpiryAtRisk] ADD  DEFAULT ((0)) FOR [PreExpiryNotified]
GO

ALTER TABLE [dbo].[tblQuizExpiryAtRisk] ADD  DEFAULT ((0)) FOR [ExpiryNotifications]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizQuestion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuizQuestion](
	[QuizQuestionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[QuizID] [int] NOT NULL,
	[ToolbookPageID] [varchar](50) NOT NULL,
	[Question] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_tblQuestion] PRIMARY KEY CLUSTERED 
(
	[QuizQuestionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizQuestion_tblQuiz]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizQuestion]'))
ALTER TABLE [dbo].[tblQuizQuestion]  WITH CHECK ADD  CONSTRAINT [FK_tblQuizQuestion_tblQuiz] FOREIGN KEY([QuizID])
REFERENCES [dbo].[tblQuiz] ([QuizID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizQuestion_tblQuiz]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizQuestion]'))
ALTER TABLE [dbo].[tblQuizQuestion] CHECK CONSTRAINT [FK_tblQuizQuestion_tblQuiz]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuizStatus](
	[QuizStatusID] [int] IDENTITY(0,1) NOT FOR REPLICATION NOT NULL,
	[Status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblQuizStatus] PRIMARY KEY CLUSTERED 
(
	[QuizStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblReminderEscalation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblReminderEscalation](
	[RemEscId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[IndividualNotification] [bit] NOT NULL,
	[PreExpInitEnrolment] [bit] NULL,
	[PreExpResitPeriod] [bit] NULL,
	[PostExpReminder] [bit] NULL,
	[PostExpInitEnrolment] [bit] NULL,
	[PostExpResitPeriod] [bit] NULL,
	[DateEnabled] [datetime] NULL,
 CONSTRAINT [PK_tblReminderEscalation_1] PRIMARY KEY CLUSTERED 
(
	[RemEscId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_DaysToCompleteCourse]  DEFAULT ((365)) FOR [DaysToCompleteCourse]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_RemindUsers]  DEFAULT ((0)) FOR [RemindUsers]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_NumOfRemNotfy]  DEFAULT ((0)) FOR [NumOfRemNotfy]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_RepeatRem]  DEFAULT ((365)) FOR [RepeatRem]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_NotifyMgr]  DEFAULT ((0)) FOR [NotifyMgr]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_IsCumulative]  DEFAULT ((0)) FOR [IsCumulative]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_QuizExpiryWarn]  DEFAULT ((0)) FOR [QuizExpiryWarn]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_DaysQuizExpiry]  DEFAULT ((0)) FOR [DaysQuizExpiry]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_LastNotified]  DEFAULT ('1 jan 2001') FOR [LastNotified]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_NotifyMgrDays]  DEFAULT ((1)) FOR [NotifyMgrDays]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  CONSTRAINT [DF_tblReminderEscalation_IndividualNotification]  DEFAULT ((0)) FOR [IndividualNotification]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  DEFAULT ((0)) FOR [PreExpInitEnrolment]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  DEFAULT ((0)) FOR [PreExpResitPeriod]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  DEFAULT ((0)) FOR [PostExpReminder]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  DEFAULT ((0)) FOR [PostExpInitEnrolment]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  DEFAULT ((0)) FOR [PostExpResitPeriod]
GO

ALTER TABLE [dbo].[tblReminderEscalation] ADD  DEFAULT (NULL) FOR [DateEnabled]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblReportInterface]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblReportInterface](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [nvarchar](200) NOT NULL,
	[RDLname] [nvarchar](200) NOT NULL,
	[RequiresParamCompleted] [bit] NOT NULL,
	[RequiresParamStatus] [bit] NOT NULL,
	[RequiresParamFailCount] [bit] NOT NULL,
	[RequiresParamCourseIDs] [bit] NOT NULL,
	[RequiresParamCourseID] [bit] NOT NULL,
	[RequiresParamHistoricCourseIDs] [bit] NOT NULL,
	[RequiresParamUnitIDs] [bit] NOT NULL,
	[RequiresParamAllUnits] [bit] NOT NULL,
	[RequiresParamTimeExpired] [bit] NOT NULL,
	[RequiresParamTimeExpiredPeriod] [bit] NOT NULL,
	[RequiresParamQuizStatus] [bit] NOT NULL,
	[RequiresParamGroupBy] [bit] NOT NULL,
	[RequiresParamGroupingOption] [bit] NOT NULL,
	[RequiresParamFirstName] [bit] NOT NULL,
	[RequiresParamLastName] [bit] NOT NULL,
	[RequiresParamUserName] [bit] NOT NULL,
	[RequiresParamEmail] [bit] NOT NULL,
	[RequiresParamIncludeInactive] [bit] NOT NULL,
	[RequiresParamSubject] [bit] NOT NULL,
	[RequiresParamBody] [bit] NOT NULL,
	[RequiresParamDateTo] [bit] NOT NULL,
	[RequiresParamDateFrom] [bit] NOT NULL,
	[RequiresParamProfileID] [bit] NOT NULL,
	[RequiresParamOnlyUsersWithShortfall] [bit] NOT NULL,
	[ParamLangInterfaceName] [varchar](200) NOT NULL,
	[RequiresParamEffectiveDate] [bit] NOT NULL,
	[RequiresParamSortBy] [bit] NOT NULL,
	[RequiresParamClassificationID] [bit] NOT NULL,
	[RequiresParamOrganisationID] [bit] NOT NULL,
	[RequiresParamServerURL] [bit] NOT NULL,
	[RequiresParamFromDate] [bit] NOT NULL,
	[RequiresParamToDate] [bit] NOT NULL,
	[RequiresParamUserID] [bit] NOT NULL,
	[RequiresParamAdminUserID] [bit] NOT NULL,
	[RequiresParamLicensingPeriod] [bit] NOT NULL,
	[RequiresParamProfilePeriodID] [bit] NOT NULL,
	[RequiresParamPolicyIDs] [bit] NOT NULL,
	[RequiresParamAcceptanceStatus] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[lastupdated] [datetime] NOT NULL,
	[lastupdBy] [int] NOT NULL,
 CONSTRAINT [PK_tblReportInterface] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamCompleted]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamCompleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamCompleted]  DEFAULT ((0)) FOR [RequiresParamCompleted]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamStatus]  DEFAULT ((0)) FOR [RequiresParamStatus]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamFailCount]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamFailCount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamFailCount]  DEFAULT ((0)) FOR [RequiresParamFailCount]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamCurrentCourseIDs]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamCurrentCourseIDs]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamCurrentCourseIDs]  DEFAULT ((0)) FOR [RequiresParamCourseIDs]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamHistoricCourseIDs]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamHistoricCourseIDs]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamHistoricCourseIDs]  DEFAULT ((0)) FOR [RequiresParamHistoricCourseIDs]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamUnitIDs]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamUnitIDs]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamUnitIDs]  DEFAULT ((0)) FOR [RequiresParamUnitIDs]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamAllUnits]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamAllUnits]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamAllUnits]  DEFAULT ((0)) FOR [RequiresParamAllUnits]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamTimeExpired]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamTimeExpired]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamTimeExpired]  DEFAULT ((0)) FOR [RequiresParamTimeExpired]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamTimeExpiredPeriod]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamTimeExpiredPeriod]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamTimeExpiredPeriod]  DEFAULT ((0)) FOR [RequiresParamTimeExpiredPeriod]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamQuizStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamQuizStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamQuizStatus]  DEFAULT ((0)) FOR [RequiresParamQuizStatus]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamGroupBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamGroupBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamGroupBy]  DEFAULT ((0)) FOR [RequiresParamGroupBy]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamGroupingOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamGroupingOption]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamGroupingOption]  DEFAULT ((0)) FOR [RequiresParamGroupingOption]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamFirstName]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamFirstName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamFirstName]  DEFAULT ((0)) FOR [RequiresParamFirstName]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamLastName]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamLastName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamLastName]  DEFAULT ((0)) FOR [RequiresParamLastName]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamUserName]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamUserName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamUserName]  DEFAULT ((0)) FOR [RequiresParamUserName]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamEmail]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamEmail]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamEmail]  DEFAULT ((0)) FOR [RequiresParamEmail]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamIncludeInactive]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamIncludeInactive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamIncludeInactive]  DEFAULT ((0)) FOR [RequiresParamIncludeInactive]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamSubject]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamSubject]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamSubject]  DEFAULT ((0)) FOR [RequiresParamSubject]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamBody]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamBody]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamBody]  DEFAULT ((0)) FOR [RequiresParamBody]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamDateTo]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamDateTo]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamDateTo]  DEFAULT ((0)) FOR [RequiresParamDateTo]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamDateFrom]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamDateFrom]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamDateFrom]  DEFAULT ((0)) FOR [RequiresParamDateFrom]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamProfileID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamProfileID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamProfileID]  DEFAULT ((0)) FOR [RequiresParamProfileID]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamOnlyUsersWithShortfall]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamOnlyUsersWithShortfall]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamOnlyUsersWithShortfall]  DEFAULT ((0)) FOR [RequiresParamOnlyUsersWithShortfall]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamEffectiveDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamEffectiveDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamEffectiveDate]  DEFAULT ((0)) FOR [RequiresParamEffectiveDate]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamSortBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamSortBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamSortBy]  DEFAULT ((0)) FOR [RequiresParamSortBy]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamClassificationID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamClassificationID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamClassificationID]  DEFAULT ((0)) FOR [RequiresParamClassificationID]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamOrganisationID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamOrganisationID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamOrganisationID]  DEFAULT ((0)) FOR [RequiresParamOrganisationID]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamServerURL]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamServerURL]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamServerURL]  DEFAULT ((0)) FOR [RequiresParamServerURL]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamFromDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamFromDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamFromDate]  DEFAULT ((0)) FOR [RequiresParamFromDate]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamToDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamToDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamToDate]  DEFAULT ((0)) FOR [RequiresParamToDate]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tblReport__Requi__3E53DAB9]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblReport__Requi__3E53DAB9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  DEFAULT ((0)) FOR [RequiresParamLicensingPeriod]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamProfilePeriodID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamProfilePeriodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamProfilePeriodID]  DEFAULT ((0)) FOR [RequiresParamProfilePeriodID]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamPolicyIDs]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamPolicyIDs]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamPolicyIDs]  DEFAULT ((0)) FOR [RequiresParamPolicyIDs]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_RequiresParamAcceptanceStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_RequiresParamAcceptanceStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_RequiresParamAcceptanceStatus]  DEFAULT ((0)) FOR [RequiresParamAcceptanceStatus]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_Active]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_Active]  DEFAULT ((0)) FOR [Active]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_lastupdated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_lastupdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_lastupdated]  DEFAULT (getutcdate()) FOR [lastupdated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportInterface_lastupdBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportInterface]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportInterface_lastupdBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportInterface] ADD  CONSTRAINT [DF_tblReportInterface_lastupdBy]  DEFAULT ((1)) FOR [lastupdBy]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblReportSchedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ReportID] [int] NOT NULL,
	[LastRun] [datetime] NULL,
	[NextRun] [datetime] NULL,
	[ReportDuration] [int] NULL,
	[ReportDurationPeriod] [char](1) NULL,
	[ReportStartDate] [datetime] NOT NULL,
	[ReportEndDate] [datetime] NULL,
	[NumberOfReports] [int] NULL,
	[ReportFrequency] [int] NULL,
	[ReportFrequencyPeriod] [char](1) NULL,
	[DocumentType] [char](1) NOT NULL,
	[ReportTitle] [nvarchar](100) NOT NULL,
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
	[LastUpdatedBy] [int] NULL,
	[LastUpdated] [datetime] NULL,
	[NumberDelivered] [int] NOT NULL,
	[TerminatedNormally] [bit] NULL,
	[ParamPolicyIDs] [nvarchar](4000) NULL,
	[ParamAcceptance] [varchar](20) NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_tblReportSchedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_ReportStartDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ReportStartDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_ReportStartDate]  DEFAULT (getutcdate()) FOR [ReportStartDate]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_ReportTitle]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ReportTitle]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_ReportTitle]  DEFAULT ('?') FOR [ReportTitle]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_ParamLangCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ParamLangCode]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_ParamLangCode]  DEFAULT (N'en-AU') FOR [ParamLangCode]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tblReport__Param__082CD432]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblReport__Param__082CD432]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF__tblReport__Param__082CD432]  DEFAULT ((0)) FOR [ParamLicensingPeriod]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_ParamProfilePeriodID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_ParamProfilePeriodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_ParamProfilePeriodID]  DEFAULT ((1)) FOR [ParamProfilePeriodID]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_IsPeriodic]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_IsPeriodic]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_IsPeriodic]  DEFAULT ('M') FOR [IsPeriodic]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_LastUpdatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_LastUpdatedBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_LastUpdatedBy]  DEFAULT ((1)) FOR [LastUpdatedBy]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_LastUpdated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_LastUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_LastUpdated]  DEFAULT (getutcdate()) FOR [LastUpdated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_NumberDelivered]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_NumberDelivered]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_NumberDelivered]  DEFAULT ((0)) FOR [NumberDelivered]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_TerminatedNormally]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_TerminatedNormally]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_TerminatedNormally]  DEFAULT ((0)) FOR [TerminatedNormally]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblReportSchedule_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblReportSchedule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblReportSchedule_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblReportSchedule] ADD  CONSTRAINT [DF_tblReportSchedule_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblReportScheduleAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblReportScheduleAudit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleID] [int] NULL,
	[UserID] [int] NULL,
	[ReportID] [int] NULL,
	[LastRun] [datetime] NULL,
	[NextRun] [datetime] NULL,
	[ReportDuration] [int] NULL,
	[ReportDurationPeriod] [char](1) NULL,
	[ReportStartDate] [datetime] NULL,
	[ReportEndDate] [datetime] NULL,
	[NumberOfReports] [int] NULL,
	[ReportFrequency] [int] NULL,
	[ReportFrequencyPeriod] [char](1) NULL,
	[DocumentType] [char](1) NULL,
	[ReportTitle] [nvarchar](100) NULL,
	[ParamOrganisationID] [int] NULL,
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
	[ParamLicensingPeriod] [nvarchar](4000) NULL,
	[ParamProfilePeriodID] [int] NULL,
	[ReportPeriodType] [int] NULL,
	[ReportFromDate] [datetime] NULL,
	[IsPeriodic] [char](1) NULL,
	[LastUpdatedBy] [int] NULL,
	[LastUpdated] [datetime] NULL,
	[LastUpdAction] [char](1) NULL,
	[TerminatedNormally] [bit] NULL,
	[NumberDelivered] [int] NULL,
	[DateCreated] [datetime] NULL,
 CONSTRAINT [PK_tblReportScheduleAudit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblReportType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblReportType](
	[Type] [varchar](20) NULL,
	[Name] [varchar](200) NULL,
	[Description] [varchar](200) NULL,
	[ServerVersion] [varchar](200) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblSCORMcontent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblSCORMcontent](
	[contentID] [int] IDENTITY(1,1) NOT NULL,
	[LessonLaunchPoint] [nvarchar](100) NOT NULL,
	[QFS] [nvarchar](100) NOT NULL,
	[QuizLaunchPoint] [nvarchar](100) NULL,
	[CourseName] [nvarchar](100) NULL,
	[ModuleName] [nvarchar](100) NOT NULL
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblScormDME]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblScormDME](
	[UserID] [int] NOT NULL,
	[LessonID] [int] NOT NULL,
	[DME] [varchar](50) NOT NULL,
	[value] [varchar](4000) NOT NULL,
 CONSTRAINT [PK_tblScormDME] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[LessonID] ASC,
	[DME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblStatusUpdateEvents]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblStatusUpdateEvents](
	[StatusUpdateID] [int] IDENTITY(1,1) NOT NULL,
	[EventName] [nchar](10) NOT NULL,
	[EventID1] [int] NULL,
	[EventID2] [int] NULL
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblTimeZone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblTimeZone](
	[TimeZoneID] [int] IDENTITY(1,1) NOT NULL,
	[WrittenName] [nvarchar](60) NOT NULL,
	[OffsetUTC] [int] NOT NULL,
	[FLB_Name] [nchar](240) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_tblTimeZone] PRIMARY KEY CLUSTERED 
(
	[TimeZoneID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblTimeZone_Active]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblTimeZone]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblTimeZone_Active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblTimeZone] ADD  CONSTRAINT [DF_tblTimeZone_Active]  DEFAULT ((1)) FOR [Active]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblTimeZoneDaylightSavingRules]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblTimeZoneDaylightSavingRules](
	[TimezoneID] [int] NOT NULL,
	[start_year] [smallint] NULL,
	[end_year] [smallint] NULL,
	[offset_mins] [int] NULL,
	[hours_start] [smallint] NULL,
	[day_start] [tinyint] NULL,
	[week_start] [tinyint] NULL,
	[month_start] [tinyint] NULL,
	[hours_end] [smallint] NULL,
	[day_end] [tinyint] NULL,
	[week_end] [tinyint] NULL,
	[month_end] [tinyint] NULL,
	[first_start_date] [datetime] NOT NULL,
	[last_end_date] [datetime] NOT NULL,
	[Last_updated] [datetime] NOT NULL,
	[TimezoneRuleID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_tblTimeZoneDaylightSavingRules] PRIMARY KEY CLUSTERED 
(
	[TimezoneID] ASC,
	[first_start_date] ASC,
	[last_end_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblTimeZoneDaylightSavingRules_first_start_date]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblTimeZoneDaylightSavingRules]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblTimeZoneDaylightSavingRules_first_start_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblTimeZoneDaylightSavingRules] ADD  CONSTRAINT [DF_tblTimeZoneDaylightSavingRules_first_start_date]  DEFAULT (getutcdate()) FOR [first_start_date]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblTimeZoneDaylightSavingRules_last_end_date]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblTimeZoneDaylightSavingRules]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblTimeZoneDaylightSavingRules_last_end_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblTimeZoneDaylightSavingRules] ADD  CONSTRAINT [DF_tblTimeZoneDaylightSavingRules_last_end_date]  DEFAULT (getutcdate()) FOR [last_end_date]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblTimeZoneDaylightSavingRules_Last_updated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblTimeZoneDaylightSavingRules]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblTimeZoneDaylightSavingRules_Last_updated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblTimeZoneDaylightSavingRules] ADD  CONSTRAINT [DF_tblTimeZoneDaylightSavingRules_Last_updated]  DEFAULT (getutcdate()) FOR [Last_updated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUnit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUnit](
	[UnitID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[ParentUnitID] [int] NULL,
	[Hierarchy] [nvarchar](500) NULL,
	[Level] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_tblUnit] PRIMARY KEY CLUSTERED 
(
	[UnitID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnit_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnit]'))
ALTER TABLE [dbo].[tblUnit]  WITH CHECK ADD  CONSTRAINT [FK_tblUnit_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnit_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnit]'))
ALTER TABLE [dbo].[tblUnit] CHECK CONSTRAINT [FK_tblUnit_tblOrganisation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnit_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnit]'))
ALTER TABLE [dbo].[tblUnit]  WITH CHECK ADD  CONSTRAINT [FK_tblUnit_tblUnit] FOREIGN KEY([ParentUnitID])
REFERENCES [dbo].[tblUnit] ([UnitID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnit_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnit]'))
ALTER TABLE [dbo].[tblUnit] CHECK CONSTRAINT [FK_tblUnit_tblUnit]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUnit_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnit]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUnit_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUnit] ADD  CONSTRAINT [DF_tblUnit_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUnit_DateUpdated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnit]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUnit_DateUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUnit] ADD  CONSTRAINT [DF_tblUnit_DateUpdated]  DEFAULT (getutcdate()) FOR [DateUpdated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUnitHierarchy]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUnitHierarchy](
	[UnitID] [int] NOT NULL,
	[Hierarchy] [nvarchar](500) NULL,
	[HierarchyName] [nvarchar](2000) NULL,
 CONSTRAINT [PK_tblUnitHierarchy] PRIMARY KEY CLUSTERED 
(
	[UnitID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUnitModuleAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUnitModuleAccess](
	[UnitID] [int] NOT NULL,
	[DeniedModuleID] [int] NOT NULL,
 CONSTRAINT [PK_tblUnitModuleAccess] PRIMARY KEY CLUSTERED 
(
	[UnitID] ASC,
	[DeniedModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitModuleAccess_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitModuleAccess]'))
ALTER TABLE [dbo].[tblUnitModuleAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblUnitModuleAccess_tblModule] FOREIGN KEY([DeniedModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitModuleAccess_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitModuleAccess]'))
ALTER TABLE [dbo].[tblUnitModuleAccess] CHECK CONSTRAINT [FK_tblUnitModuleAccess_tblModule]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitModuleAccess_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitModuleAccess]'))
ALTER TABLE [dbo].[tblUnitModuleAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblUnitModuleAccess_tblUnit] FOREIGN KEY([UnitID])
REFERENCES [dbo].[tblUnit] ([UnitID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitModuleAccess_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitModuleAccess]'))
ALTER TABLE [dbo].[tblUnitModuleAccess] CHECK CONSTRAINT [FK_tblUnitModuleAccess_tblUnit]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUnitPolicyAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUnitPolicyAccess](
	[UnitPolicyAccessID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PolicyID] [int] NOT NULL,
	[UnitID] [int] NOT NULL,
	[Granted] [bit] NOT NULL,
 CONSTRAINT [PK_tblUnitPolicyAccess] PRIMARY KEY CLUSTERED 
(
	[UnitPolicyAccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUnitProfilePeriodAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUnitProfilePeriodAccess](
	[UnitProfilePeriodAccessID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProfilePeriodID] [int] NOT NULL,
	[UnitID] [int] NOT NULL,
	[Granted] [bit] NOT NULL,
 CONSTRAINT [PK_tblUnitProfilePeriodAccess] PRIMARY KEY CLUSTERED 
(
	[UnitProfilePeriodAccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUnitRule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUnitRule](
	[UnitID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[LessonFrequency] [int] NOT NULL,
	[QuizFrequency] [int] NOT NULL,
	[QuizPassMark] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[DateUpdated] [datetime] NULL,
	[LessonCompletionDate] [datetime] NULL,
	[QuizCompletionDate] [datetime] NULL,
 CONSTRAINT [PK_tblUnitRule] PRIMARY KEY CLUSTERED 
(
	[UnitID] ASC,
	[ModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitRule_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitRule]'))
ALTER TABLE [dbo].[tblUnitRule]  WITH CHECK ADD  CONSTRAINT [FK_tblUnitRule_tblModule] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitRule_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitRule]'))
ALTER TABLE [dbo].[tblUnitRule] CHECK CONSTRAINT [FK_tblUnitRule_tblModule]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitRule_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitRule]'))
ALTER TABLE [dbo].[tblUnitRule]  WITH CHECK ADD  CONSTRAINT [FK_tblUnitRule_tblUnit] FOREIGN KEY([UnitID])
REFERENCES [dbo].[tblUnit] ([UnitID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitRule_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitRule]'))
ALTER TABLE [dbo].[tblUnitRule] CHECK CONSTRAINT [FK_tblUnitRule_tblUnit]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUnitRule_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitRule]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUnitRule_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUnitRule] ADD  CONSTRAINT [DF_tblUnitRule_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserCourseDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserCourseDetails](
	[UserID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[NumberOfDelinquencyNotifications] [int] NOT NULL,
	[NewStarterFlag] [bit] NULL,
	[AtRiskQuizList] [nvarchar](max) NOT NULL,
	[NotifiedModuleList] [nvarchar](max) NOT NULL,
	[LastDelinquencyNotification] [datetime] NULL,
	[UserCourseStatusID] [int] NOT NULL,
	[LastDelNoteToMgr] [bit] NOT NULL,
 CONSTRAINT [PK_tblUserCourseDetails] PRIMARY KEY CLUSTERED 
(
	[UserCourseStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCourseDetails_NumberOfDelinquencyNotifications]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCourseDetails_NumberOfDelinquencyNotifications]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCourseDetails] ADD  CONSTRAINT [DF_tblUserCourseDetails_NumberOfDelinquencyNotifications]  DEFAULT ((0)) FOR [NumberOfDelinquencyNotifications]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCourseDetails_AtRiskQuizList]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCourseDetails_AtRiskQuizList]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCourseDetails] ADD  CONSTRAINT [DF_tblUserCourseDetails_AtRiskQuizList]  DEFAULT ('') FOR [AtRiskQuizList]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCourseDetails_NotifiedAtRiskQuizList]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCourseDetails_NotifiedAtRiskQuizList]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCourseDetails] ADD  CONSTRAINT [DF_tblUserCourseDetails_NotifiedAtRiskQuizList]  DEFAULT ('') FOR [NotifiedModuleList]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCourseDetails_LastDelNoteToMgr]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCourseDetails_LastDelNoteToMgr]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCourseDetails] ADD  CONSTRAINT [DF_tblUserCourseDetails_LastDelNoteToMgr]  DEFAULT ((0)) FOR [LastDelNoteToMgr]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserPolicyAccepted]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserPolicyAccepted](
	[UserPolicyAcceptedID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PolicyID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Accepted] [bit] NOT NULL,
	[DateAccepted] [datetime] NULL,
 CONSTRAINT [PK_tblUserPolicyAccepted] PRIMARY KEY CLUSTERED 
(
	[UserPolicyAcceptedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserPolicyAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserPolicyAccess](
	[UserPolicyAccessID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PolicyID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Granted] [bit] NOT NULL,
 CONSTRAINT [PK_tblUserPolicyAccess] PRIMARY KEY CLUSTERED 
(
	[UserPolicyAccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserProfilePeriodAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserProfilePeriodAccess](
	[UserProfilePeriodAccessID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProfilePeriodID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Granted] [bit] NOT NULL,
 CONSTRAINT [PK_tblUserProfilePeriodAccess] PRIMARY KEY CLUSTERED 
(
	[UserProfilePeriodAccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserType](
	[UserTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Type] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblUserType] PRIMARY KEY CLUSTERED 
(
	[UserTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblVersion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblVersion](
	[Version] [varchar](50) NOT NULL,
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClassificationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblClassificationType](
	[ClassificationTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblClassificationTypeID] PRIMARY KEY CLUSTERED 
(
	[ClassificationTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClassificationType_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClassificationType]'))
ALTER TABLE [dbo].[tblClassificationType]  WITH CHECK ADD  CONSTRAINT [FK_tblClassificationType_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblClassificationType_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblClassificationType]'))
ALTER TABLE [dbo].[tblClassificationType] CHECK CONSTRAINT [FK_tblClassificationType_tblOrganisation]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblErrorLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblErrorLog](
	[ErrorLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Source] [varchar](1000) NOT NULL,
	[Module] [varchar](100) NULL,
	[Function] [varchar](100) NULL,
	[Code] [varchar](100) NULL,
	[Message] [varchar](500) NOT NULL,
	[StackTrace] [varchar](8000) NOT NULL,
	[ErrorLevel] [int] NOT NULL,
	[ErrorStatus] [int] NOT NULL,
	[Resolution] [varchar](1000) NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[DateUpdated] [smalldatetime] NOT NULL,
 CONSTRAINT [PK__tblErrorLog__ErrorLogID] PRIMARY KEY CLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblErrorLog_tblErrorLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
ALTER TABLE [dbo].[tblErrorLog]  WITH CHECK ADD  CONSTRAINT [FK_tblErrorLog_tblErrorLevel] FOREIGN KEY([ErrorLevel])
REFERENCES [dbo].[tblErrorLevel] ([ErrorLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblErrorLog_tblErrorLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
ALTER TABLE [dbo].[tblErrorLog] CHECK CONSTRAINT [FK_tblErrorLog_tblErrorLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblErrorLog_tblErrorStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
ALTER TABLE [dbo].[tblErrorLog]  WITH CHECK ADD  CONSTRAINT [FK_tblErrorLog_tblErrorStatus] FOREIGN KEY([ErrorStatus])
REFERENCES [dbo].[tblErrorStatus] ([ErrorStatusID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblErrorLog_tblErrorStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
ALTER TABLE [dbo].[tblErrorLog] CHECK CONSTRAINT [FK_tblErrorLog_tblErrorStatus]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tblErrorL__Level__2AA05119]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblErrorL__Level__2AA05119]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblErrorLog] ADD  CONSTRAINT [DF__tblErrorL__Level__2AA05119]  DEFAULT (2) FOR [ErrorLevel]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tblErrorL__Statu__2C88998B]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblErrorL__Statu__2C88998B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblErrorLog] ADD  CONSTRAINT [DF__tblErrorL__Statu__2C88998B]  DEFAULT (1) FOR [ErrorStatus]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblErrorLog_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblErrorLog_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblErrorLog] ADD  CONSTRAINT [DF_tblErrorLog_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblErrorLog_DateUpdated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblErrorLog]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblErrorLog_DateUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblErrorLog] ADD  CONSTRAINT [DF_tblErrorLog_DateUpdated]  DEFAULT (getdate()) FOR [DateUpdated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLesson]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLesson](
	[LessonID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ModuleID] [int] NOT NULL,
	[ToolbookID] [varchar](50) NOT NULL,
	[ToolbookLocation] [varchar](100) NOT NULL,
	[DatePublished] [datetime] NOT NULL,
	[LoadedBy] [int] NOT NULL,
	[DateLoaded] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
	[LWorkSiteID] [nvarchar](50) NULL,
	[QFWorkSiteID] [nvarchar](50) NULL,
	[Scorm1_2] [bit] NOT NULL,
	[QFSlocation] [varchar](100) NULL,
 CONSTRAINT [PK_tblLession] PRIMARY KEY CLUSTERED 
(
	[LessonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLesson_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLesson]'))
ALTER TABLE [dbo].[tblLesson]  WITH CHECK ADD  CONSTRAINT [FK_tblLesson_tblModule] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLesson_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLesson]'))
ALTER TABLE [dbo].[tblLesson] CHECK CONSTRAINT [FK_tblLesson_tblModule]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLesson_DatePublished]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLesson]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLesson_DatePublished]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLesson] ADD  CONSTRAINT [DF_tblLesson_DatePublished]  DEFAULT (getutcdate()) FOR [DatePublished]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLesson_DateLoaded]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLesson]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLesson_DateLoaded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLesson] ADD  CONSTRAINT [DF_tblLesson_DateLoaded]  DEFAULT (getutcdate()) FOR [DateLoaded]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLesson_NewContent]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLesson]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLesson_NewContent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLesson] ADD  CONSTRAINT [DF_tblLesson_NewContent]  DEFAULT ((0)) FOR [Active]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLessonPage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLessonPage](
	[LessonPageID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LessonID] [int] NOT NULL,
	[ToolbookPageID] [varchar](50) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_tblLessionPage] PRIMARY KEY CLUSTERED 
(
	[LessonPageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessionPage_tblLession]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonPage]'))
ALTER TABLE [dbo].[tblLessonPage]  WITH CHECK ADD  CONSTRAINT [FK_tblLessionPage_tblLession] FOREIGN KEY([LessonID])
REFERENCES [dbo].[tblLesson] ([LessonID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessionPage_tblLession]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonPage]'))
ALTER TABLE [dbo].[tblLessonPage] CHECK CONSTRAINT [FK_tblLessionPage_tblLession]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLink]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLink](
	[LinkID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[Caption] [nvarchar](100) NOT NULL,
	[Url] [nvarchar](200) NULL,
	[ShowDisclaimer] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[DateUpdated] [datetime] NULL,
	[LinkOrder] [int] NULL,
 CONSTRAINT [PK_tblLink] PRIMARY KEY NONCLUSTERED 
(
	[LinkID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLink_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLink]'))
ALTER TABLE [dbo].[tblLink]  WITH CHECK ADD  CONSTRAINT [FK_tblLink_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLink_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLink]'))
ALTER TABLE [dbo].[tblLink] CHECK CONSTRAINT [FK_tblLink_tblOrganisation]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLink_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLink]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLink_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLink] ADD  CONSTRAINT [DF_tblLink_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLink_LinkOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLink]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLink_LinkOrder]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLink] ADD  CONSTRAINT [DF_tblLink_LinkOrder]  DEFAULT ((0)) FOR [LinkOrder]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizAnswer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuizAnswer](
	[QuizAnswerID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[QuizQuestionID] [int] NOT NULL,
	[ToolbookAnswerID] [varchar](50) NOT NULL,
	[Answer] [nvarchar](1000) NOT NULL,
	[Correct] [bit] NOT NULL,
 CONSTRAINT [PK_tblQuizAnswer] PRIMARY KEY CLUSTERED 
(
	[QuizAnswerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAnswer_tblQuizQuestion]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizAnswer]'))
ALTER TABLE [dbo].[tblQuizAnswer]  WITH CHECK ADD  CONSTRAINT [FK_tblQuizAnswer_tblQuizQuestion] FOREIGN KEY([QuizQuestionID])
REFERENCES [dbo].[tblQuizQuestion] ([QuizQuestionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAnswer_tblQuizQuestion]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizAnswer]'))
ALTER TABLE [dbo].[tblQuizAnswer] CHECK CONSTRAINT [FK_tblQuizAnswer_tblQuizQuestion]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUser](
	[UserID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[ExternalID] [nvarchar](50) NULL,
	[OrganisationID] [int] NULL,
	[UnitID] [int] NULL,
	[UserTypeID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[DateArchived] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[DateUpdated] [datetime] NULL,
	[LastLogin] [datetime] NULL,
	[LoginFailCount] [int] NOT NULL,
	[TimeZoneID] [int] NULL,
	[DelinquencyManagerEmail] [nvarchar](100) NULL,
	[NewStarter] [bit] NOT NULL,
	[NotifyMgr] [bit] NOT NULL,
	[NotifyUnitAdmin] [bit] NOT NULL,
	[NotifyOrgAdmin] [bit] NOT NULL,
	[EbookNotification] [bit] NOT NULL,
 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUser_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [FK_tblUser_tblOrganisation] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tblOrganisation] ([OrganisationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUser_tblOrganisation]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [FK_tblUser_tblOrganisation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUser_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [FK_tblUser_tblUnit] FOREIGN KEY([UnitID])
REFERENCES [dbo].[tblUnit] ([UnitID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUser_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [FK_tblUser_tblUnit]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUser_tblUserType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [FK_tblUser_tblUserType] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[tblUserType] ([UserTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUser_tblUserType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [FK_tblUser_tblUserType]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [CK_tblUser] CHECK  (([Username]=[Username]))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [CK_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_UserTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_UserTypeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_UserTypeID]  DEFAULT ((4)) FOR [UserTypeID]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_Status]  DEFAULT ((1)) FOR [Active]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_DateUpdated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_DateUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_DateUpdated]  DEFAULT (getutcdate()) FOR [DateUpdated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_LoginFailCount]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_LoginFailCount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_LoginFailCount]  DEFAULT ((0)) FOR [LoginFailCount]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_NewStarter]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_NewStarter]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_NewStarter]  DEFAULT ((0)) FOR [NewStarter]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_NotifyMgr]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_NotifyMgr]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_NotifyMgr]  DEFAULT ((0)) FOR [NotifyMgr]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_NotifyUnitAdmin]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_NotifyUnitAdmin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_NotifyUnitAdmin]  DEFAULT ((0)) FOR [NotifyUnitAdmin]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUser_NotifyOrgAdmin]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUser]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUser_NotifyOrgAdmin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUser] ADD  CONSTRAINT [DF_tblUser_NotifyOrgAdmin]  DEFAULT ((0)) FOR [NotifyOrgAdmin]
END


End
GO


ALTER TABLE [dbo].[tblUser] ADD  DEFAULT ((0)) FOR [EbookNotification]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserClassification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserClassification](
	[UserID] [int] NOT NULL,
	[ClassificationID] [int] NOT NULL,
 CONSTRAINT [PK_tblUserClassification] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ClassificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserClassification_tblClassification]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserClassification]'))
ALTER TABLE [dbo].[tblUserClassification]  WITH CHECK ADD  CONSTRAINT [FK_tblUserClassification_tblClassification] FOREIGN KEY([ClassificationID])
REFERENCES [dbo].[tblClassification] ([ClassificationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserClassification_tblClassification]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserClassification]'))
ALTER TABLE [dbo].[tblUserClassification] CHECK CONSTRAINT [FK_tblUserClassification_tblClassification]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserClassification_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserClassification]'))
ALTER TABLE [dbo].[tblUserClassification]  WITH CHECK ADD  CONSTRAINT [FK_tblUserClassification_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserClassification_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserClassification]'))
ALTER TABLE [dbo].[tblUserClassification] CHECK CONSTRAINT [FK_tblUserClassification_tblUser]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserCourseStatus](
	[UserCourseStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[CourseStatusID] [int] NOT NULL,
	[ModulesAssigned] [varchar](1000) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_tblUserCourseStatus] PRIMARY KEY NONCLUSTERED 
(
	[UserCourseStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCourseStatus_tblCourse]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]'))
ALTER TABLE [dbo].[tblUserCourseStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCourseStatus_tblCourse] FOREIGN KEY([CourseID])
REFERENCES [dbo].[tblCourse] ([CourseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCourseStatus_tblCourse]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]'))
ALTER TABLE [dbo].[tblUserCourseStatus] CHECK CONSTRAINT [FK_tblUserCourseStatus_tblCourse]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCourseStatus_tblCourseStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]'))
ALTER TABLE [dbo].[tblUserCourseStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCourseStatus_tblCourseStatus] FOREIGN KEY([CourseStatusID])
REFERENCES [dbo].[tblCourseStatus] ([CourseStatusID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCourseStatus_tblCourseStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]'))
ALTER TABLE [dbo].[tblUserCourseStatus] CHECK CONSTRAINT [FK_tblUserCourseStatus_tblCourseStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCourseStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]'))
ALTER TABLE [dbo].[tblUserCourseStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCourseStatus_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCourseStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]'))
ALTER TABLE [dbo].[tblUserCourseStatus] CHECK CONSTRAINT [FK_tblUserCourseStatus_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCourseStatus_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCourseStatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCourseStatus_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCourseStatus] ADD  CONSTRAINT [DF_tblUserCourseStatus_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserCPDPoints]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserCPDPoints](
	[UserCPDPointsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProfilePointsID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Points] [numeric](10, 2) NOT NULL,
	[DateAssigned] [datetime] NOT NULL,
	[LessonQuizStatus] [int] NULL,
 CONSTRAINT [PK_tblUserCPDPoints] PRIMARY KEY CLUSTERED 
(
	[UserCPDPointsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCPDPoints_tblProfilePoints]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCPDPoints]'))
ALTER TABLE [dbo].[tblUserCPDPoints]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCPDPoints_tblProfilePoints] FOREIGN KEY([ProfilePointsID])
REFERENCES [dbo].[tblProfilePoints] ([ProfilePointsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCPDPoints_tblProfilePoints]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCPDPoints]'))
ALTER TABLE [dbo].[tblUserCPDPoints] CHECK CONSTRAINT [FK_tblUserCPDPoints_tblProfilePoints]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCPDPoints_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCPDPoints]'))
ALTER TABLE [dbo].[tblUserCPDPoints]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCPDPoints_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCPDPoints_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCPDPoints]'))
ALTER TABLE [dbo].[tblUserCPDPoints] CHECK CONSTRAINT [FK_tblUserCPDPoints_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCPDPoints_DateAssigned]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCPDPoints]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCPDPoints_DateAssigned]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCPDPoints] ADD  CONSTRAINT [DF_tblUserCPDPoints_DateAssigned]  DEFAULT (getutcdate()) FOR [DateAssigned]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserCurrentLessonStatus](
	[UserLessonStatusID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[LessonStatusID] [int] NOT NULL,
	[LessonFrequency] [int] NULL,
	[DateCreated] [datetime] NOT NULL,
	[LessonCompletionDate] [datetime] NULL,
	[Excluded] [bit] NULL,
 CONSTRAINT [PK_tblUserCurrentLessonStatus] PRIMARY KEY NONCLUSTERED 
(
	[UserLessonStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCurrentLessonStatus_tblLessonStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
ALTER TABLE [dbo].[tblUserCurrentLessonStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCurrentLessonStatus_tblLessonStatus] FOREIGN KEY([LessonStatusID])
REFERENCES [dbo].[tblLessonStatus] ([LessonStatusID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCurrentLessonStatus_tblLessonStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
ALTER TABLE [dbo].[tblUserCurrentLessonStatus] CHECK CONSTRAINT [FK_tblUserCurrentLessonStatus_tblLessonStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCurrentLessonStatus_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
ALTER TABLE [dbo].[tblUserCurrentLessonStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCurrentLessonStatus_tblModule] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCurrentLessonStatus_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
ALTER TABLE [dbo].[tblUserCurrentLessonStatus] CHECK CONSTRAINT [FK_tblUserCurrentLessonStatus_tblModule]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCurrentLessonStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
ALTER TABLE [dbo].[tblUserCurrentLessonStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserCurrentLessonStatus_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserCurrentLessonStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
ALTER TABLE [dbo].[tblUserCurrentLessonStatus] CHECK CONSTRAINT [FK_tblUserCurrentLessonStatus_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCurrentLessonStatus_EffectiveDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCurrentLessonStatus_EffectiveDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCurrentLessonStatus] ADD  CONSTRAINT [DF_tblUserCurrentLessonStatus_EffectiveDate]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserCurrentLessonStatus_Excluded]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserCurrentLessonStatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserCurrentLessonStatus_Excluded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserCurrentLessonStatus] ADD  CONSTRAINT [DF_tblUserCurrentLessonStatus_Excluded]  DEFAULT ((0)) FOR [Excluded]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserLessonStatus](
	[UserLessonStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[LessonStatusID] [int] NOT NULL,
	[LessonFrequency] [int] NULL,
	[DateCreated] [datetime] NOT NULL,
	[LessonCompletionDate] [datetime] NULL,
	[Excluded] [bit] NULL,
 CONSTRAINT [PK_tblUserLessonStatus] PRIMARY KEY NONCLUSTERED 
(
	[UserLessonStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserLessonStatus_tblLessonStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
ALTER TABLE [dbo].[tblUserLessonStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserLessonStatus_tblLessonStatus] FOREIGN KEY([LessonStatusID])
REFERENCES [dbo].[tblLessonStatus] ([LessonStatusID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserLessonStatus_tblLessonStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
ALTER TABLE [dbo].[tblUserLessonStatus] CHECK CONSTRAINT [FK_tblUserLessonStatus_tblLessonStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserLessonStatus_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
ALTER TABLE [dbo].[tblUserLessonStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserLessonStatus_tblModule] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserLessonStatus_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
ALTER TABLE [dbo].[tblUserLessonStatus] CHECK CONSTRAINT [FK_tblUserLessonStatus_tblModule]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserLessonStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
ALTER TABLE [dbo].[tblUserLessonStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserLessonStatus_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserLessonStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
ALTER TABLE [dbo].[tblUserLessonStatus] CHECK CONSTRAINT [FK_tblUserLessonStatus_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserLessonStatus_EffectiveDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserLessonStatus_EffectiveDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserLessonStatus] ADD  CONSTRAINT [DF_tblUserLessonStatus_EffectiveDate]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserLessonStatus_Excluded]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserLessonStatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserLessonStatus_Excluded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserLessonStatus] ADD  CONSTRAINT [DF_tblUserLessonStatus_Excluded]  DEFAULT ((0)) FOR [Excluded]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserModuleAccess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserModuleAccess](
	[UserID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[Granted] [bit] NOT NULL,
 CONSTRAINT [PK_tblUserModuleAccess] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserModuleAccess_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserModuleAccess]'))
ALTER TABLE [dbo].[tblUserModuleAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblUserModuleAccess_tblModule] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserModuleAccess_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserModuleAccess]'))
ALTER TABLE [dbo].[tblUserModuleAccess] CHECK CONSTRAINT [FK_tblUserModuleAccess_tblModule]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserModuleAccess_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserModuleAccess]'))
ALTER TABLE [dbo].[tblUserModuleAccess]  WITH CHECK ADD  CONSTRAINT [FK_tblUserModuleAccess_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserModuleAccess_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserModuleAccess]'))
ALTER TABLE [dbo].[tblUserModuleAccess] CHECK CONSTRAINT [FK_tblUserModuleAccess_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserModuleAccess_Granted]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserModuleAccess]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserModuleAccess_Granted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserModuleAccess] ADD  CONSTRAINT [DF_tblUserModuleAccess_Granted]  DEFAULT (1) FOR [Granted]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUserQuizStatus](
	[UserQuizStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[QuizStatusID] [int] NOT NULL,
	[QuizFrequency] [int] NULL,
	[QuizPassMark] [int] NULL,
	[QuizScore] [int] NULL,
	[QuizSessionID] [uniqueidentifier] NULL,
	[DateCreated] [datetime] NOT NULL,
	[QuizCompletionDate] [datetime] NULL,
	[Excluded] [bit] NULL,
	[DateLastReset] [datetime] NULL,
 CONSTRAINT [PK_tblUserQuizStatus] PRIMARY KEY NONCLUSTERED 
(
	[UserQuizStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserQuizStatus_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
ALTER TABLE [dbo].[tblUserQuizStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserQuizStatus_tblModule] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tblModule] ([ModuleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserQuizStatus_tblModule]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
ALTER TABLE [dbo].[tblUserQuizStatus] CHECK CONSTRAINT [FK_tblUserQuizStatus_tblModule]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserQuizStatus_tblQuizStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
ALTER TABLE [dbo].[tblUserQuizStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserQuizStatus_tblQuizStatus] FOREIGN KEY([QuizStatusID])
REFERENCES [dbo].[tblQuizStatus] ([QuizStatusID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserQuizStatus_tblQuizStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
ALTER TABLE [dbo].[tblUserQuizStatus] CHECK CONSTRAINT [FK_tblUserQuizStatus_tblQuizStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserQuizStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
ALTER TABLE [dbo].[tblUserQuizStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblUserQuizStatus_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUserQuizStatus_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
ALTER TABLE [dbo].[tblUserQuizStatus] CHECK CONSTRAINT [FK_tblUserQuizStatus_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserQuizStatus_EffectiveDate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserQuizStatus_EffectiveDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserQuizStatus] ADD  CONSTRAINT [DF_tblUserQuizStatus_EffectiveDate]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUserQuizStatus_Excluded]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUserQuizStatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUserQuizStatus_Excluded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUserQuizStatus] ADD  CONSTRAINT [DF_tblUserQuizStatus_Excluded]  DEFAULT ((0)) FOR [Excluded]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBookmark]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBookmark](
	[BookmarkID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LessonPageID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[DateCreated] [datetime] NULL,
 CONSTRAINT [PK_tblBookmark] PRIMARY KEY CLUSTERED 
(
	[BookmarkID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblBookmark_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblBookmark]'))
ALTER TABLE [dbo].[tblBookmark]  WITH CHECK ADD  CONSTRAINT [FK_tblBookmark_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblBookmark_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblBookmark]'))
ALTER TABLE [dbo].[tblBookmark] CHECK CONSTRAINT [FK_tblBookmark_tblUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessionPage_tblBookmark]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblBookmark]'))
ALTER TABLE [dbo].[tblBookmark]  WITH CHECK ADD  CONSTRAINT [FK_tblLessionPage_tblBookmark] FOREIGN KEY([LessonPageID])
REFERENCES [dbo].[tblLessonPage] ([LessonPageID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessionPage_tblBookmark]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblBookmark]'))
ALTER TABLE [dbo].[tblBookmark] CHECK CONSTRAINT [FK_tblLessionPage_tblBookmark]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tblBookma__DateC__3E3D3572]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblBookmark]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tblBookma__DateC__3E3D3572]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblBookmark] ADD  CONSTRAINT [DF__tblBookma__DateC__3E3D3572]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLessonSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLessonSession](
	[LessonSessionID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[UserID] [int] NOT NULL,
	[LessonID] [int] NOT NULL,
	[DateTimeStarted] [datetime] NULL,
	[DateTimeCompleted] [datetime] NULL,
	[Duration] [int] NULL,
 CONSTRAINT [PK_tblLessonSession] PRIMARY KEY CLUSTERED 
(
	[LessonSessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessonSession_tblLesson]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonSession]'))
ALTER TABLE [dbo].[tblLessonSession]  WITH CHECK ADD  CONSTRAINT [FK_tblLessonSession_tblLesson] FOREIGN KEY([LessonID])
REFERENCES [dbo].[tblLesson] ([LessonID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessonSession_tblLesson]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonSession]'))
ALTER TABLE [dbo].[tblLessonSession] CHECK CONSTRAINT [FK_tblLessonSession_tblLesson]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessonSession_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonSession]'))
ALTER TABLE [dbo].[tblLessonSession]  WITH CHECK ADD  CONSTRAINT [FK_tblLessonSession_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessonSession_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonSession]'))
ALTER TABLE [dbo].[tblLessonSession] CHECK CONSTRAINT [FK_tblLessonSession_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLessonSession_LessonSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonSession]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLessonSession_LessonSessionID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLessonSession] ADD  CONSTRAINT [DF_tblLessonSession_LessonSessionID]  DEFAULT (newid()) FOR [LessonSessionID]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuizSession](
	[QuizSessionID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[UserID] [int] NOT NULL,
	[QuizID] [int] NOT NULL,
	[DateTimeStarted] [datetime] NULL,
	[DateTimeCompleted] [datetime] NULL,
	[Duration] [int] NULL,
	[QuizScore] [int] NULL,
	[QuizPassMark] [int] NULL,
 CONSTRAINT [PK_tblQuizSession] PRIMARY KEY CLUSTERED 
(
	[QuizSessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizSession_tblQuiz]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizSession]'))
ALTER TABLE [dbo].[tblQuizSession]  WITH CHECK ADD  CONSTRAINT [FK_tblQuizSession_tblQuiz] FOREIGN KEY([QuizID])
REFERENCES [dbo].[tblQuiz] ([QuizID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizSession_tblQuiz]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizSession]'))
ALTER TABLE [dbo].[tblQuizSession] CHECK CONSTRAINT [FK_tblQuizSession_tblQuiz]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizSession_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizSession]'))
ALTER TABLE [dbo].[tblQuizSession]  WITH CHECK ADD  CONSTRAINT [FK_tblQuizSession_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizSession_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizSession]'))
ALTER TABLE [dbo].[tblQuizSession] CHECK CONSTRAINT [FK_tblQuizSession_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblQuizSession_QuizSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizSession]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblQuizSession_QuizSessionID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblQuizSession] ADD  CONSTRAINT [DF_tblQuizSession_QuizSessionID]  DEFAULT (newid()) FOR [QuizSessionID]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUnitAdministrator]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUnitAdministrator](
	[UnitID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Propagate] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_tblUnitAdministrator] PRIMARY KEY CLUSTERED 
(
	[UnitID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitAdministrator_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitAdministrator]'))
ALTER TABLE [dbo].[tblUnitAdministrator]  WITH CHECK ADD  CONSTRAINT [FK_tblUnitAdministrator_tblUnit] FOREIGN KEY([UnitID])
REFERENCES [dbo].[tblUnit] ([UnitID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitAdministrator_tblUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitAdministrator]'))
ALTER TABLE [dbo].[tblUnitAdministrator] CHECK CONSTRAINT [FK_tblUnitAdministrator_tblUnit]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitAdministrator_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitAdministrator]'))
ALTER TABLE [dbo].[tblUnitAdministrator]  WITH CHECK ADD  CONSTRAINT [FK_tblUnitAdministrator_tblUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUser] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblUnitAdministrator_tblUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitAdministrator]'))
ALTER TABLE [dbo].[tblUnitAdministrator] CHECK CONSTRAINT [FK_tblUnitAdministrator_tblUser]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUnitAdministrator_Propagate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitAdministrator]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUnitAdministrator_Propagate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUnitAdministrator] ADD  CONSTRAINT [DF_tblUnitAdministrator_Propagate]  DEFAULT (0) FOR [Propagate]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblUnitAdministrator_DateCreated]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblUnitAdministrator]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblUnitAdministrator_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblUnitAdministrator] ADD  CONSTRAINT [DF_tblUnitAdministrator_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblLessonPageAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblLessonPageAudit](
	[LessonSessionID] [uniqueidentifier] NOT NULL,
	[LessonPageID] [int] NOT NULL,
	[DateAccessed] [datetime] NOT NULL,
 CONSTRAINT [PK_tblLessionAuditPage] PRIMARY KEY CLUSTERED 
(
	[LessonSessionID] ASC,
	[LessonPageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessionAuditPage_tblLessionPage]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonPageAudit]'))
ALTER TABLE [dbo].[tblLessonPageAudit]  WITH CHECK ADD  CONSTRAINT [FK_tblLessionAuditPage_tblLessionPage] FOREIGN KEY([LessonPageID])
REFERENCES [dbo].[tblLessonPage] ([LessonPageID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessionAuditPage_tblLessionPage]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonPageAudit]'))
ALTER TABLE [dbo].[tblLessonPageAudit] CHECK CONSTRAINT [FK_tblLessionAuditPage_tblLessionPage]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessonAudit_tblLessonSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonPageAudit]'))
ALTER TABLE [dbo].[tblLessonPageAudit]  WITH CHECK ADD  CONSTRAINT [FK_tblLessonAudit_tblLessonSession] FOREIGN KEY([LessonSessionID])
REFERENCES [dbo].[tblLessonSession] ([LessonSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblLessonAudit_tblLessonSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonPageAudit]'))
ALTER TABLE [dbo].[tblLessonPageAudit] CHECK CONSTRAINT [FK_tblLessonAudit_tblLessonSession]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblLessonAudit_DateAccessed]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblLessonPageAudit]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblLessonAudit_DateAccessed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblLessonPageAudit] ADD  CONSTRAINT [DF_tblLessonAudit_DateAccessed]  DEFAULT (getutcdate()) FOR [DateAccessed]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizQuestionAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuizQuestionAudit](
	[QuizSessionID] [uniqueidentifier] NOT NULL,
	[QuizQuestionID] [int] NOT NULL,
	[Duration] [int] NULL,
	[DateAccessed] [datetime] NOT NULL,
 CONSTRAINT [PK_tblQuizAudit_1] PRIMARY KEY CLUSTERED 
(
	[QuizSessionID] ASC,
	[QuizQuestionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAudit_tblQuizSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizQuestionAudit]'))
ALTER TABLE [dbo].[tblQuizQuestionAudit]  WITH CHECK ADD  CONSTRAINT [FK_tblQuizAudit_tblQuizSession] FOREIGN KEY([QuizSessionID])
REFERENCES [dbo].[tblQuizSession] ([QuizSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAudit_tblQuizSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizQuestionAudit]'))
ALTER TABLE [dbo].[tblQuizQuestionAudit] CHECK CONSTRAINT [FK_tblQuizAudit_tblQuizSession]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tblQuizQuestionAudit_DateAccessed]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizQuestionAudit]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblQuizQuestionAudit_DateAccessed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblQuizQuestionAudit] ADD  CONSTRAINT [DF_tblQuizQuestionAudit_DateAccessed]  DEFAULT (getutcdate()) FOR [DateAccessed]
END


End
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblQuizAnswerAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblQuizAnswerAudit](
	[QuizSessionID] [uniqueidentifier] NOT NULL,
	[QuizQuestionID] [int] NOT NULL,
	[QuizAnswerID] [int] NOT NULL,
 CONSTRAINT [PK_tblQuizAnswerAudit] PRIMARY KEY CLUSTERED 
(
	[QuizSessionID] ASC,
	[QuizQuestionID] ASC,
	[QuizAnswerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAnswerAudit_tblQuizAnswer]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizAnswerAudit]'))
ALTER TABLE [dbo].[tblQuizAnswerAudit]  WITH CHECK ADD  CONSTRAINT [FK_tblQuizAnswerAudit_tblQuizAnswer] FOREIGN KEY([QuizAnswerID])
REFERENCES [dbo].[tblQuizAnswer] ([QuizAnswerID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAnswerAudit_tblQuizAnswer]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizAnswerAudit]'))
ALTER TABLE [dbo].[tblQuizAnswerAudit] CHECK CONSTRAINT [FK_tblQuizAnswerAudit_tblQuizAnswer]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAnswerAudit_tblQuizQuestionAudit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizAnswerAudit]'))
ALTER TABLE [dbo].[tblQuizAnswerAudit]  WITH CHECK ADD  CONSTRAINT [FK_tblQuizAnswerAudit_tblQuizQuestionAudit] FOREIGN KEY([QuizSessionID], [QuizQuestionID])
REFERENCES [dbo].[tblQuizQuestionAudit] ([QuizSessionID], [QuizQuestionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblQuizAnswerAudit_tblQuizQuestionAudit]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblQuizAnswerAudit]'))
ALTER TABLE [dbo].[tblQuizAnswerAudit] CHECK CONSTRAINT [FK_tblQuizAnswerAudit_tblQuizQuestionAudit]
GO





