    --REDUNDANT





 --DROP TRIGGERS
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgQuizUpload]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgQuizUpload]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgLessonUpload]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgLessonUpload]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblLang]') and OBJECTPROPERTY(id, N'IsTable') = 1)
drop Table [dbo].[tblLang]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblLangInterface]') and OBJECTPROPERTY(id, N'IsTable') = 1)
drop Table [dbo].[tblLangInterface]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblLangResource]') and OBJECTPROPERTY(id, N'IsTable') = 1)
drop Table [dbo].[tblLangResource]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblLangValue]') and OBJECTPROPERTY(id, N'IsTable') = 1)
drop Table [dbo].[tblLangValue]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblLangValueArchive]') and OBJECTPROPERTY(id, N'IsTable') = 1)
drop Table [dbo].[tblLangValueArchive]
GO

--DROP TRIGGERS

 --LANGUAGE MODULE
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
[RecordLock] [uniqueidentifier] NULL CONSTRAINT [DF_tblLang_RecordLock]  DEFAULT (newid()),
CONSTRAINT [PK_tblLang] PRIMARY KEY CLUSTERED 
(
[LangCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[tblLangInterface](
[LangInterfaceID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
[LangInterfaceName] [varchar](200) NOT NULL,
[InterfaceType] [varchar](20) NULL CONSTRAINT [DF_tblLangInterface_InterfaceType]  DEFAULT (''),
[UserCreated] [int] NULL,
[UserModified] [int] NULL,
[UserDeleted] [int] NULL,
[DateCreated] [datetime] NULL,
[DateModified] [datetime] NULL,
[DateDeleted] [datetime] NULL,
[RecordLock] [uniqueidentifier] NULL CONSTRAINT [DF_tblLangInterface_RecordLock]  DEFAULT (newid()),
CONSTRAINT [PK_tblLangInterface] PRIMARY KEY CLUSTERED 
(
[LangInterfaceName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



CREATE TABLE [dbo].[tblLangResource](
[LangResourceID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
[LangResourceName] [varchar](200) NOT NULL,
[ResourceType] [varchar](20) NULL CONSTRAINT [DF_tblLangResource_ResourceType]  DEFAULT (''),
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

GO



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
[RecordLock] [uniqueidentifier] NULL CONSTRAINT [DF_tblLangValue_RecordLock]  DEFAULT (newid()),
CONSTRAINT [PK_tblLangValue] PRIMARY KEY CLUSTERED 
(
[LangID] ASC,
[LangInterfaceID] ASC,
[LangResourceID] ASC,
[Active] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[tblLangValueArchive](
[LangValueArchiveID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
[LangID] [int] NULL,
[LangInterfaceID] [int] NULL,
[LangResourceID] [int] NULL,
[LangEntryValue] [nvarchar](4000) NULL,
[UserCreated] [int] NULL,
[DateCreated] [datetime] NULL CONSTRAINT [DF_tblLangValueArchive_DateCreated]  DEFAULT (getdate()),
CONSTRAINT [PK_tblLangValueArchive] PRIMARY KEY CLUSTERED 
(
[LangValueArchiveID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
 --/LANGUAGE MODULE

 --tblAppConfig
BEGIN TRANSACTION
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Tmp_tblAppConfig]') and OBJECTPROPERTY(id, N'IsTable') = 1)
drop Table [dbo].[Tmp_tblAppConfig]
GO

CREATE TABLE dbo.Tmp_tblAppConfig
(
Name nvarchar(50) NOT NULL,
Value nvarchar(4000) NOT NULL
)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tblAppConfig)
EXEC('INSERT INTO dbo.Tmp_tblAppConfig (Name, Value)
SELECT CONVERT(nvarchar(50), Name), CONVERT(nvarchar(4000), Value) FROM dbo.tblAppConfig WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tblAppConfig
GO
EXECUTE sp_rename N'dbo.Tmp_tblAppConfig', N'tblAppConfig', 'OBJECT' 
GO
ALTER TABLE dbo.tblAppConfig ADD CONSTRAINT
PK_tblAppConfig PRIMARY KEY CLUSTERED 
(
Name
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT TRANSACTION
-- /tblAppConfig
GO

 --tblClassification

BEGIN TRANSACTION

ALTER TABLE dbo.tblClassification
DROP CONSTRAINT FK_tblClassification_tblClassificationTypeID
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION

ALTER TABLE dbo.tblClassification
DROP CONSTRAINT DF_tblClassification_Active
GO
CREATE TABLE dbo.Tmp_tblClassification
(
ClassificationID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
ClassificationTypeID int NOT NULL,
Value nvarchar(50) NOT NULL,
Active bit NOT NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblClassification ADD CONSTRAINT
DF_tblClassification_Active DEFAULT (1) FOR Active
GO
SET IDENTITY_INSERT dbo.Tmp_tblClassification ON
GO
IF EXISTS(SELECT * FROM dbo.tblClassification)
EXEC('INSERT INTO dbo.Tmp_tblClassification (ClassificationID, ClassificationTypeID, Value, Active)
SELECT ClassificationID, ClassificationTypeID, CONVERT(nvarchar(50), Value), Active FROM dbo.tblClassification WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblClassification OFF
GO
ALTER TABLE dbo.tblUserClassification
DROP CONSTRAINT FK_tblUserClassification_tblClassification
GO
DROP TABLE dbo.tblClassification
GO
EXECUTE sp_rename N'dbo.Tmp_tblClassification', N'tblClassification', 'OBJECT' 
GO
ALTER TABLE dbo.tblClassification ADD CONSTRAINT
PK_tblClassification PRIMARY KEY NONCLUSTERED 
(
ClassificationID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblClassification ADD CONSTRAINT
FK_tblClassification_tblClassificationTypeID FOREIGN KEY
(
ClassificationTypeID
) REFERENCES dbo.tblClassificationType
(
ClassificationTypeID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO


BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserClassification ADD CONSTRAINT
FK_tblUserClassification_tblClassification FOREIGN KEY
(
ClassificationID
) REFERENCES dbo.tblClassification
(
ClassificationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

 --/tblClassification

 --tblClassificationType
BEGIN TRANSACTION

ALTER TABLE dbo.tblClassificationType
DROP FK_tblClassificationType_tblOrganisation
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION

CREATE TABLE dbo.Tmp_tblClassificationType
(
ClassificationTypeID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
OrganisationID int NOT NULL,
Name nvarchar(50) NOT NULL
)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tblClassificationType ON
GO
IF EXISTS(SELECT * FROM dbo.tblClassificationType)
EXEC('INSERT INTO dbo.Tmp_tblClassificationType (ClassificationTypeID, OrganisationID, Name)
SELECT ClassificationTypeID, OrganisationID, CONVERT(nvarchar(50), Name) FROM dbo.tblClassificationType WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblClassificationType OFF
GO
ALTER TABLE dbo.tblClassification
DROP CONSTRAINT FK_tblClassification_tblClassificationTypeID
GO
DROP TABLE dbo.tblClassificationType
GO
EXECUTE sp_rename N'dbo.Tmp_tblClassificationType', N'tblClassificationType', 'OBJECT' 
GO
ALTER TABLE dbo.tblClassificationType ADD CONSTRAINT
PK_tblClassificationTypeID PRIMARY KEY CLUSTERED 
(
ClassificationTypeID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblClassificationType ADD CONSTRAINT
FK_tblClassificationType_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
 --/tblClassificationType


 --tblCourse
BEGIN TRANSACTION

ALTER TABLE dbo.tblCourse
DROP CONSTRAINT DF_tblCourse_Active
GO
--ALTER TABLE dbo.tblCourse
--DROP CONSTRAINT MSrepl_tran_version_default_5FE0E7CB_BAF5_4BDF_B09D_0DF767AA0991_197575742
--GO
CREATE TABLE dbo.Tmp_tblCourse
(
CourseID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
Name nvarchar(50) NOT NULL,
Notes nvarchar(1000) NULL,
Active bit NOT NULL,
CreatedBy int NOT NULL,
DateCreated datetime NOT NULL,
UpdatedBy int NULL,
DateUpdated datetime NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCourse ADD CONSTRAINT
DF_tblCourse_Active DEFAULT (0) FOR Active
GO
SET IDENTITY_INSERT dbo.Tmp_tblCourse ON
GO
IF EXISTS(SELECT * FROM dbo.tblCourse)
BEGIN
EXEC('INSERT INTO dbo.Tmp_tblCourse (CourseID, Name, Notes, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated)
SELECT CourseID, CONVERT(nvarchar(50), Name), CONVERT(nvarchar(1000), Notes), Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated FROM dbo.tblCourse WITH (HOLDLOCK TABLOCKX)')
END
GO
SET IDENTITY_INSERT dbo.Tmp_tblCourse OFF
GO
ALTER TABLE dbo.tblModule
DROP CONSTRAINT FK_tblModule_tblCourse
GO
ALTER TABLE dbo.tblOrganisationCourseAccess
DROP CONSTRAINT FK_tblOrganisationCourseAccess_tblCourse
GO
ALTER TABLE dbo.tblUserCourseStatus
DROP CONSTRAINT FK_tblUserCourseStatus_tblCourse
GO
DROP TABLE dbo.tblCourse
GO
EXECUTE sp_rename N'dbo.Tmp_tblCourse', N'tblCourse', 'OBJECT' 
GO
ALTER TABLE dbo.tblCourse ADD CONSTRAINT
PK_tblCourse PRIMARY KEY CLUSTERED 
(
CourseID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserCourseStatus ADD CONSTRAINT
FK_tblUserCourseStatus_tblCourse FOREIGN KEY
(
CourseID
) REFERENCES dbo.tblCourse
(
CourseID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblOrganisationCourseAccess ADD CONSTRAINT
FK_tblOrganisationCourseAccess_tblCourse FOREIGN KEY
(
GrantedCourseID
) REFERENCES dbo.tblCourse
(
CourseID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblModule ADD CONSTRAINT
FK_tblModule_tblCourse FOREIGN KEY
(
CourseID
) REFERENCES dbo.tblCourse
(
CourseID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

 --/tblCourse

-- tblEmail
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblEmail
DROP CONSTRAINT DF_tblEmail_DateCreated
GO
CREATE TABLE dbo.Tmp_tblEmail
(
EmailId int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
ToEmail nvarchar(1000) NOT NULL,
ToName nvarchar(128) NULL,
FromEmail nvarchar(128) NOT NULL,
FromName nvarchar(128) NULL,
CC nvarchar(1000) NULL,
BCC nvarchar(1000) NULL,
Subject nvarchar(256) NOT NULL,
Body ntext NULL,
DateCreated smalldatetime NOT NULL,
OrganisationID int NOT NULL
)  ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblEmail ADD CONSTRAINT
DF_tblEmail_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
SET IDENTITY_INSERT dbo.Tmp_tblEmail ON
GO
IF EXISTS(SELECT * FROM dbo.tblEmail)
EXEC('INSERT INTO dbo.Tmp_tblEmail (EmailId, ToEmail, ToName, FromEmail, FromName, CC, BCC, Subject, Body, DateCreated, OrganisationID)
SELECT EmailId, CONVERT(nvarchar(1000), ToEmail), CONVERT(nvarchar(128), ToName), CONVERT(nvarchar(128), FromEmail), CONVERT(nvarchar(128), FromName), CONVERT(nvarchar(1000), CC), CONVERT(nvarchar(1000), BCC), CONVERT(nvarchar(256), Subject), CONVERT(ntext, Body), DateCreated, OrganisationID FROM dbo.tblEmail WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblEmail OFF
GO
DROP TABLE dbo.tblEmail
GO
EXECUTE sp_rename N'dbo.Tmp_tblEmail', N'tblEmail', 'OBJECT' 
GO
ALTER TABLE dbo.tblEmail ADD CONSTRAINT
PK_tblEmail PRIMARY KEY CLUSTERED 
(
EmailId
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT TRANSACTION
GO

 --/tblEmail


 --tblLesson
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLesson
DROP CONSTRAINT FK_tblLesson_tblModule
GO
COMMIT TRANSACTION
GO


BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLesson
DROP CONSTRAINT DF_tblLesson_NewContent
GO
CREATE TABLE dbo.Tmp_tblLesson
(
LessonID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
ModuleID int NOT NULL,
ToolbookID varchar(50) NOT NULL,
ToolbookLocation varchar(100) NOT NULL,
DatePublished datetime NOT NULL,
LoadedBy int NOT NULL,
DateLoaded datetime NOT NULL,
Active bit NOT NULL,
LWorkSiteID nvarchar(50) NULL,
QFWorkSiteID nvarchar(50) NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblLesson ADD CONSTRAINT
DF_tblLesson_NewContent DEFAULT (0) FOR Active
GO
SET IDENTITY_INSERT dbo.Tmp_tblLesson ON
GO
IF EXISTS(SELECT * FROM dbo.tblLesson)
EXEC('INSERT INTO dbo.Tmp_tblLesson (LessonID, ModuleID, ToolbookID, ToolbookLocation, DatePublished, LoadedBy, DateLoaded, Active, LWorkSiteID, QFWorkSiteID)
SELECT LessonID, ModuleID, ToolbookID, ToolbookLocation, DatePublished, LoadedBy, DateLoaded, Active, CONVERT(nvarchar(50), LWorkSiteID), CONVERT(nvarchar(50), QFWorkSiteID) FROM dbo.tblLesson WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblLesson OFF
GO
ALTER TABLE dbo.tblLessonPage
DROP CONSTRAINT FK_tblLessionPage_tblLession
GO
ALTER TABLE dbo.tblLessonSession
DROP CONSTRAINT FK_tblLessonSession_tblLesson
GO
DROP TABLE dbo.tblLesson
GO
EXECUTE sp_rename N'dbo.Tmp_tblLesson', N'tblLesson', 'OBJECT' 
GO
ALTER TABLE dbo.tblLesson ADD CONSTRAINT
PK_tblLession PRIMARY KEY CLUSTERED 
(
LessonID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tblLesson_Module ON dbo.tblLesson
(
ModuleID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblLesson ADD CONSTRAINT
FK_tblLesson_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO


CREATE TRIGGER trgLessonUpload ON dbo.tblLesson
FOR Insert
AS
set nocount on

--Only fire the trigger if there is only one record updated
if ((select count(LessonID) from inserted)=1)
begin
if exists(select l.lessonID
from inserted  nl
inner join tblLesson l
on l.ModuleID = nl.ModuleID)
begin

insert into tblUserLessonStatus
(
UserID,
ModuleID,
LessonStatusID,
LessonFrequency
)
Select uls.UserID,
uls.ModuleID,
5 as LessonStatusID, --Expired(New Content)(5)
umr.LessonFrequency
from inserted  nl
inner join vwUserLessonStatus uls
on uls.ModuleID  = nl.ModuleID
and uls.LessonStatusID in (2, 3, 4)   --started (In Progress(2), Completed(3), Expired(Time Expired)(4))
inner join tblUser u
on u.UserID = uls.UserID
inner join vwUnitModuleRule umr --Get Rules
on umr.ModuleID = nl.ModuleID
and umr.UnitID=u.UnitID
end
end
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLessonSession ADD CONSTRAINT
FK_tblLessonSession_tblLesson FOREIGN KEY
(
LessonID
) REFERENCES dbo.tblLesson
(
LessonID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO


BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLessonPage ADD CONSTRAINT
FK_tblLessionPage_tblLession FOREIGN KEY
(
LessonID
) REFERENCES dbo.tblLesson
(
LessonID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
 --/tblLesson
GO


 --tblLessonPage
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLessonPage
DROP CONSTRAINT FK_tblLessionPage_tblLession
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblLessonPage
(
LessonPageID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
LessonID int NOT NULL,
ToolbookPageID varchar(50) NOT NULL,
Title nvarchar(255) NOT NULL
)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tblLessonPage ON
GO
IF EXISTS(SELECT * FROM dbo.tblLessonPage)
EXEC('INSERT INTO dbo.Tmp_tblLessonPage (LessonPageID, LessonID, ToolbookPageID, Title)
SELECT LessonPageID, LessonID, ToolbookPageID, CONVERT(nvarchar(255), Title) FROM dbo.tblLessonPage WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblLessonPage OFF
GO
ALTER TABLE dbo.tblLessonPageAudit
DROP CONSTRAINT FK_tblLessionAuditPage_tblLessionPage
GO
ALTER TABLE dbo.tblBookmark
DROP CONSTRAINT FK_tblLessionPage_tblBookmark
GO
DROP TABLE dbo.tblLessonPage
GO
EXECUTE sp_rename N'dbo.Tmp_tblLessonPage', N'tblLessonPage', 'OBJECT' 
GO
ALTER TABLE dbo.tblLessonPage ADD CONSTRAINT
PK_tblLessionPage PRIMARY KEY CLUSTERED 
(
LessonPageID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tblLessonPage_Lesson ON dbo.tblLessonPage
(
LessonID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblLessonPage ADD CONSTRAINT
FK_tblLessionPage_tblLession FOREIGN KEY
(
LessonID
) REFERENCES dbo.tblLesson
(
LessonID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblBookmark ADD CONSTRAINT
FK_tblLessionPage_tblBookmark FOREIGN KEY
(
LessonPageID
) REFERENCES dbo.tblLessonPage
(
LessonPageID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLessonPageAudit ADD CONSTRAINT
FK_tblLessionAuditPage_tblLessionPage FOREIGN KEY
(
LessonPageID
) REFERENCES dbo.tblLessonPage
(
LessonPageID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

 --/tblLessonPage


 --tblLink
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLink
DROP CONSTRAINT FK_tblLink_tblOrganisation
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLink
DROP CONSTRAINT DF_tblLink_DateCreated
GO
CREATE TABLE dbo.Tmp_tblLink
(
LinkID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
OrganisationID int NOT NULL,
Caption nvarchar(100) NOT NULL,
Url nvarchar(200) NULL,
ShowDisclaimer bit NOT NULL,
CreatedBy int NOT NULL,
DateCreated datetime NOT NULL,
UpdatedBy int NULL,
DateUpdated datetime NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblLink ADD CONSTRAINT
DF_tblLink_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
SET IDENTITY_INSERT dbo.Tmp_tblLink ON
GO
IF EXISTS(SELECT * FROM dbo.tblLink)
EXEC('INSERT INTO dbo.Tmp_tblLink (LinkID, OrganisationID, Caption, Url, ShowDisclaimer, CreatedBy, DateCreated, UpdatedBy, DateUpdated)
SELECT LinkID, OrganisationID, CONVERT(nvarchar(100), Caption), CONVERT(nvarchar(200), Url), ShowDisclaimer, CreatedBy, DateCreated, UpdatedBy, DateUpdated FROM dbo.tblLink WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblLink OFF
GO
DROP TABLE dbo.tblLink
GO
EXECUTE sp_rename N'dbo.Tmp_tblLink', N'tblLink', 'OBJECT' 
GO
ALTER TABLE dbo.tblLink ADD CONSTRAINT
PK_tblLink PRIMARY KEY NONCLUSTERED 
(
LinkID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE CLUSTERED INDEX IX_tblLink_Organisation ON dbo.tblLink
(
OrganisationID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblLink ADD CONSTRAINT
FK_tblLink_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
-- /tblLink
GO


-- tblModule
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblModule
DROP CONSTRAINT FK_tblModule_tblCourse
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblModule
(
ModuleID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
CourseID int NOT NULL,
Name nvarchar(50) NOT NULL,
Sequence int NULL,
Description nvarchar(1000) NULL,
Active bit NOT NULL,
CreatedBy int NULL,
DateCreated datetime NULL,
UpdatedBy int NULL,
DateUpdated datetime NULL
)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tblModule ON
GO
IF EXISTS(SELECT * FROM dbo.tblModule)
EXEC('INSERT INTO dbo.Tmp_tblModule (ModuleID, CourseID, Name, Sequence, Description, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated)
SELECT ModuleID, CourseID, CONVERT(nvarchar(50), Name), Sequence, CONVERT(nvarchar(1000), Description), Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated FROM dbo.tblModule WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblModule OFF
GO
ALTER TABLE dbo.tblUserModuleAccess
DROP CONSTRAINT FK_tblUserModuleAccess_tblModule
GO
ALTER TABLE dbo.tblUnitRule
DROP CONSTRAINT FK_tblUnitRule_tblModule
GO
ALTER TABLE dbo.tblLesson
DROP CONSTRAINT FK_tblLesson_tblModule
GO
ALTER TABLE dbo.tblUserQuizStatus
DROP CONSTRAINT FK_tblUserQuizStatus_tblModule
GO
ALTER TABLE dbo.tblUserLessonStatus
DROP CONSTRAINT FK_tblUserLessonStatus_tblModule
GO
ALTER TABLE dbo.tblQuiz
DROP CONSTRAINT FK_tblQuiz_tblModule
GO
ALTER TABLE dbo.tblUnitModuleAccess
DROP CONSTRAINT FK_tblUnitModuleAccess_tblModule
GO
DROP TABLE dbo.tblModule
GO
EXECUTE sp_rename N'dbo.Tmp_tblModule', N'tblModule', 'OBJECT' 
GO
ALTER TABLE dbo.tblModule ADD CONSTRAINT
PK_tblModule PRIMARY KEY CLUSTERED 
(
ModuleID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tblModule_Course ON dbo.tblModule
(
CourseID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblModule ADD CONSTRAINT
FK_tblModule_tblCourse FOREIGN KEY
(
CourseID
) REFERENCES dbo.tblCourse
(
CourseID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnitModuleAccess ADD CONSTRAINT
FK_tblUnitModuleAccess_tblModule FOREIGN KEY
(
DeniedModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuiz ADD CONSTRAINT
FK_tblQuiz_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserLessonStatus ADD CONSTRAINT
FK_tblUserLessonStatus_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserQuizStatus ADD CONSTRAINT
FK_tblUserQuizStatus_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLesson ADD CONSTRAINT
FK_tblLesson_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnitRule ADD CONSTRAINT
FK_tblUnitRule_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserModuleAccess ADD CONSTRAINT
FK_tblUserModuleAccess_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
 --/tblModule
GO


 --tblOrganisation
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblOrganisation
DROP CONSTRAINT DF_tblOrganisation_DateCreated
GO
ALTER TABLE dbo.tblOrganisation
DROP CONSTRAINT DF_tblOrganisation_DateUpdated
GO
ALTER TABLE dbo.tblOrganisation
DROP CONSTRAINT DF_tblOrganisation_AdvancedReporting
GO
CREATE TABLE dbo.Tmp_tblOrganisation
(
OrganisationID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
OrganisationName nvarchar(50) NOT NULL,
Logo varchar(100) NULL,
Notes nvarchar(1000) NOT NULL,
DefaultLessonFrequency int NOT NULL,
DefaultQuizFrequency int NOT NULL,
DefaultQuizPassMark int NOT NULL,
DefaultLessonCompletionDate datetime NULL,
DefaultQuizCompletionDate datetime NULL,
CreatedBy int NOT NULL,
DateCreated datetime NOT NULL,
UpdatedBy int NULL,
DateUpdated datetime NOT NULL,
AdvancedReporting bit NOT NULL,
DomainName nvarchar(255) NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblOrganisation ADD CONSTRAINT
DF_tblOrganisation_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
ALTER TABLE dbo.Tmp_tblOrganisation ADD CONSTRAINT
DF_tblOrganisation_DateUpdated DEFAULT (getdate()) FOR DateUpdated
GO
ALTER TABLE dbo.Tmp_tblOrganisation ADD CONSTRAINT
DF_tblOrganisation_AdvancedReporting DEFAULT ((0)) FOR AdvancedReporting
GO
SET IDENTITY_INSERT dbo.Tmp_tblOrganisation ON
GO
IF EXISTS(SELECT * FROM dbo.tblOrganisation)
BEGIN
EXEC('INSERT INTO dbo.Tmp_tblOrganisation (OrganisationID, OrganisationName, Logo, Notes, DefaultLessonFrequency, DefaultQuizFrequency, DefaultQuizPassMark, DefaultLessonCompletionDate, DefaultQuizCompletionDate, CreatedBy, DateCreated, UpdatedBy, DateUpdated, AdvancedReporting, DomainName)
SELECT OrganisationID, CONVERT(nvarchar(50), OrganisationName), Logo, CONVERT(nvarchar(1000), Notes), DefaultLessonFrequency, DefaultQuizFrequency, DefaultQuizPassMark, null, null, CreatedBy, DateCreated, UpdatedBy, DateUpdated, AdvancedReporting, CONVERT(nvarchar(255), DomainName) FROM dbo.tblOrganisation WITH (HOLDLOCK TABLOCKX)')
END
GO
SET IDENTITY_INSERT dbo.Tmp_tblOrganisation OFF
GO
ALTER TABLE dbo.tblClassificationType
DROP CONSTRAINT FK_tblClassificationType_tblOrganisation
GO
ALTER TABLE dbo.tblLink
DROP CONSTRAINT FK_tblLink_tblOrganisation
GO
ALTER TABLE dbo.tblUnit
DROP CONSTRAINT FK_tblUnit_tblOrganisation
GO
ALTER TABLE dbo.tblOrganisationCourseAccess
DROP CONSTRAINT FK_tblOrganisationCourseAccess_tblOrganisation
GO
ALTER TABLE dbo.tblOrganisationConfig
DROP CONSTRAINT FK_tblOrganisationConfig_tblOrganisation
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT FK_tblUser_tblOrganisation
GO
DROP TABLE dbo.tblOrganisation
GO
EXECUTE sp_rename N'dbo.Tmp_tblOrganisation', N'tblOrganisation', 'OBJECT' 
GO
ALTER TABLE dbo.tblOrganisation ADD CONSTRAINT
PK_tblOrganization PRIMARY KEY CLUSTERED 
(
OrganisationID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX IX_tblOrganisation_Name_Unique ON dbo.tblOrganisation
(
OrganisationName
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUser ADD CONSTRAINT
FK_tblUser_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblOrganisationConfig ADD CONSTRAINT
FK_tblOrganisationConfig_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblOrganisationCourseAccess ADD CONSTRAINT
FK_tblOrganisationCourseAccess_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnit ADD CONSTRAINT
FK_tblUnit_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLink ADD CONSTRAINT
FK_tblLink_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblClassificationType ADD CONSTRAINT
FK_tblClassificationType_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
 --/tblOrganisation
GO

 --tblOrganisationConfig
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblOrganisationConfig
DROP CONSTRAINT FK_tblOrganisationConfig_tblOrganisation
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblOrganisationConfig
(
OrganisationID int NULL,
Name nvarchar(255) NOT NULL,
Description nvarchar(255) NOT NULL,
Value nvarchar(4000) NULL,
ID numeric(18, 0) NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION
)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tblOrganisationConfig ON
GO
IF EXISTS(SELECT * FROM dbo.tblOrganisationConfig)
EXEC('INSERT INTO dbo.Tmp_tblOrganisationConfig (OrganisationID, Name, Description, Value, ID)
SELECT OrganisationID, CONVERT(nvarchar(255), Name), CONVERT(nvarchar(255), Description), CONVERT(nvarchar(4000), Value), ID FROM dbo.tblOrganisationConfig WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblOrganisationConfig OFF
GO
DROP TABLE dbo.tblOrganisationConfig
GO
EXECUTE sp_rename N'dbo.Tmp_tblOrganisationConfig', N'tblOrganisationConfig', 'OBJECT' 
GO
ALTER TABLE dbo.tblOrganisationConfig ADD CONSTRAINT
PK__tblOrganisationC__4D2051A6 PRIMARY KEY CLUSTERED 
(
ID
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblOrganisationConfig ADD CONSTRAINT
FK_tblOrganisationConfig_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
 --/tblOrganisationConfig
GO

 --tblQuiz
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuiz
DROP CONSTRAINT FK_tblQuiz_tblModule
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuiz
DROP CONSTRAINT DF_tblQuiz_NewContent
GO
CREATE TABLE dbo.Tmp_tblQuiz
(
QuizID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
ModuleID int NOT NULL,
ToolbookID varchar(50) NOT NULL,
ToolbookLocation varchar(100) NOT NULL,
DatePublished datetime NOT NULL,
LoadedBy int NOT NULL,
DateLoaded datetime NOT NULL,
Active bit NOT NULL,
WorksiteID nvarchar(50) NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblQuiz ADD CONSTRAINT
DF_tblQuiz_NewContent DEFAULT (0) FOR Active
GO
SET IDENTITY_INSERT dbo.Tmp_tblQuiz ON
GO
IF EXISTS(SELECT * FROM dbo.tblQuiz)
EXEC('INSERT INTO dbo.Tmp_tblQuiz (QuizID, ModuleID, ToolbookID, ToolbookLocation, DatePublished, LoadedBy, DateLoaded, Active, WorksiteID)
SELECT QuizID, ModuleID, ToolbookID, ToolbookLocation, DatePublished, LoadedBy, DateLoaded, Active, CONVERT(nvarchar(50), WorksiteID) FROM dbo.tblQuiz WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblQuiz OFF
GO
ALTER TABLE dbo.tblQuizSession
DROP CONSTRAINT FK_tblQuizSession_tblQuiz
GO
ALTER TABLE dbo.tblQuizQuestion
DROP CONSTRAINT FK_tblQuizQuestion_tblQuiz
GO
DROP TABLE dbo.tblQuiz
GO
EXECUTE sp_rename N'dbo.Tmp_tblQuiz', N'tblQuiz', 'OBJECT' 
GO
ALTER TABLE dbo.tblQuiz ADD CONSTRAINT
PK_tblQuiz PRIMARY KEY CLUSTERED 
(
QuizID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tblQuiz_Module ON dbo.tblQuiz
(
ModuleID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblQuiz ADD CONSTRAINT
FK_tblQuiz_tblModule FOREIGN KEY
(
ModuleID
) REFERENCES dbo.tblModule
(
ModuleID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
/*Summary:
Expire user Quiz status when a new Quiz content is uploaded

Returns:

Called By:

Calls:
Nothing

Remarks:


When a new Quiz content uploaded , If there are Quizs existed for that module
It means new content is uploaded.

If the existing Quizs have already been started(Passed(2),Failed(3), Expired(Time Expired)(4)),
the current user Quiz status need to be expired (Expired(New Content)(5))


Author: Jack Liu
Date Created: 21 Feb 2004

Modification History
-
v#AuthorDateDescription


**/

CREATE TRIGGER trgQuizUpload ON dbo.tblQuiz
FOR Insert
AS
set nocount on

--Only fire the trigger if there is only one record updated
if ((select count(QuizID) from inserted)=1)
begin
if exists(select q.QuizID
from inserted  nq
inner join tblQuiz q
on q.ModuleID = nq.ModuleID)
begin

insert into tblUserQuizStatus
(
UserID,
ModuleID,
QuizStatusID,
QuizFrequency,
QuizPassMark
)
Select uqs.UserID,
uqs.ModuleID,
5 as QuizStatusID, --Expired(New Content)(5)
umr.QuizFrequency,
umr.QuizPassMark
from inserted  nq
inner join vwUserQuizStatus uqs
on uqs.ModuleID  = nq.ModuleID
and uqs.QuizStatusID in (2, 3, 4)   --started Passed(2),Failed(3), Expired(Time Expired)(4)
inner join tblUser u  --Get Unit ID
on u.UserID = uqs.UserID
inner join vwUnitModuleRule umr --Get Rules
on umr.ModuleID = nq.ModuleID
and umr.UnitID=u.UnitID
end
end
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuizQuestion ADD CONSTRAINT
FK_tblQuizQuestion_tblQuiz FOREIGN KEY
(
QuizID
) REFERENCES dbo.tblQuiz
(
QuizID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuizSession ADD CONSTRAINT
FK_tblQuizSession_tblQuiz FOREIGN KEY
(
QuizID
) REFERENCES dbo.tblQuiz
(
QuizID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

 --/tblQuiz

 --tblQuizAnswer
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuizAnswer
DROP CONSTRAINT FK_tblQuizAnswer_tblQuizQuestion
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblQuizAnswer
(
QuizAnswerID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
QuizQuestionID int NOT NULL,
ToolbookAnswerID varchar(50) NOT NULL,
Answer nvarchar(1000) NOT NULL,
Correct bit NOT NULL
)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tblQuizAnswer ON
GO
IF EXISTS(SELECT * FROM dbo.tblQuizAnswer)
EXEC('INSERT INTO dbo.Tmp_tblQuizAnswer (QuizAnswerID, QuizQuestionID, ToolbookAnswerID, Answer, Correct)
SELECT QuizAnswerID, QuizQuestionID, ToolbookAnswerID, CONVERT(nvarchar(1000), Answer), Correct FROM dbo.tblQuizAnswer WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblQuizAnswer OFF
GO
ALTER TABLE dbo.tblQuizAnswerAudit
DROP CONSTRAINT FK_tblQuizAnswerAudit_tblQuizAnswer
GO
DROP TABLE dbo.tblQuizAnswer
GO
EXECUTE sp_rename N'dbo.Tmp_tblQuizAnswer', N'tblQuizAnswer', 'OBJECT' 
GO
ALTER TABLE dbo.tblQuizAnswer ADD CONSTRAINT
PK_tblQuizAnswer PRIMARY KEY CLUSTERED 
(
QuizAnswerID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tblQuizAnswer_Question ON dbo.tblQuizAnswer
(
QuizQuestionID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblQuizAnswer ADD CONSTRAINT
FK_tblQuizAnswer_tblQuizQuestion FOREIGN KEY
(
QuizQuestionID
) REFERENCES dbo.tblQuizQuestion
(
QuizQuestionID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuizAnswerAudit ADD CONSTRAINT
FK_tblQuizAnswerAudit_tblQuizAnswer FOREIGN KEY
(
QuizAnswerID
) REFERENCES dbo.tblQuizAnswer
(
QuizAnswerID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION

 --/tblQuizAnswer

 --tblQuizQuestion
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuizQuestion
DROP CONSTRAINT FK_tblQuizQuestion_tblQuiz
GO
COMMIT TRANSACTION
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblQuizQuestion
(
QuizQuestionID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
QuizID int NOT NULL,
ToolbookPageID varchar(50) NOT NULL,
Question nvarchar(1000) NOT NULL
)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tblQuizQuestion ON
GO
IF EXISTS(SELECT * FROM dbo.tblQuizQuestion)
EXEC('INSERT INTO dbo.Tmp_tblQuizQuestion (QuizQuestionID, QuizID, ToolbookPageID, Question)
SELECT QuizQuestionID, QuizID, ToolbookPageID, CONVERT(nvarchar(1000), Question) FROM dbo.tblQuizQuestion WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblQuizQuestion OFF
GO
ALTER TABLE dbo.tblQuizAnswer
DROP CONSTRAINT FK_tblQuizAnswer_tblQuizQuestion
GO
DROP TABLE dbo.tblQuizQuestion
GO
EXECUTE sp_rename N'dbo.Tmp_tblQuizQuestion', N'tblQuizQuestion', 'OBJECT' 
GO
ALTER TABLE dbo.tblQuizQuestion ADD CONSTRAINT
PK_tblQuestion PRIMARY KEY CLUSTERED 
(
QuizQuestionID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tblQuizQuestion_Quiz ON dbo.tblQuizQuestion
(
QuizID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblQuizQuestion ADD CONSTRAINT
FK_tblQuizQuestion_tblQuiz FOREIGN KEY
(
QuizID
) REFERENCES dbo.tblQuiz
(
QuizID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuizAnswer ADD CONSTRAINT
FK_tblQuizAnswer_tblQuizQuestion FOREIGN KEY
(
QuizQuestionID
) REFERENCES dbo.tblQuizQuestion
(
QuizQuestionID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

 --/tblQuizQuestion


 --tblUnit
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnit
DROP CONSTRAINT FK_tblUnit_tblOrganisation
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnit
DROP CONSTRAINT DF_tblUnit_Level
GO
ALTER TABLE dbo.tblUnit
DROP CONSTRAINT DF_tblUnit_DateCreated
GO
ALTER TABLE dbo.tblUnit
DROP CONSTRAINT DF_tblUnit_DateUpdated
GO
CREATE TABLE dbo.Tmp_tblUnit
(
UnitID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
OrganisationID int NOT NULL,
Name nvarchar(100) NOT NULL,
ParentUnitID int NULL,
Hierarchy nvarchar(500) NULL,
[Level] int NULL,
Active bit NOT NULL,
CreatedBy int NOT NULL,
DateCreated datetime NOT NULL,
UpdatedBy int NULL,
DateUpdated datetime NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblUnit ADD CONSTRAINT
DF_tblUnit_Level DEFAULT (0) FOR [Level]
GO
ALTER TABLE dbo.Tmp_tblUnit ADD CONSTRAINT
DF_tblUnit_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
ALTER TABLE dbo.Tmp_tblUnit ADD CONSTRAINT
DF_tblUnit_DateUpdated DEFAULT (getdate()) FOR DateUpdated
GO
SET IDENTITY_INSERT dbo.Tmp_tblUnit ON
GO
IF EXISTS(SELECT * FROM dbo.tblUnit)
EXEC('INSERT INTO dbo.Tmp_tblUnit (UnitID, OrganisationID, Name, ParentUnitID, Hierarchy, [Level], Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated)
SELECT UnitID, OrganisationID, CONVERT(nvarchar(100), Name), ParentUnitID, CONVERT(nvarchar(500), Hierarchy), [Level], Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated FROM dbo.tblUnit WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblUnit OFF
GO
ALTER TABLE dbo.tblUnitRule
DROP CONSTRAINT FK_tblUnitRule_tblUnit
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT FK_tblUser_tblUnit
GO
ALTER TABLE dbo.tblUnitAdministrator
DROP CONSTRAINT FK_tblUnitAdministrator_tblUnit
GO
ALTER TABLE dbo.tblUnitModuleAccess
DROP CONSTRAINT FK_tblUnitModuleAccess_tblUnit
GO
ALTER TABLE dbo.tblUnit
DROP CONSTRAINT FK_tblUnit_tblUnit
GO
DROP TABLE dbo.tblUnit
GO
EXECUTE sp_rename N'dbo.Tmp_tblUnit', N'tblUnit', 'OBJECT' 
GO
ALTER TABLE dbo.tblUnit ADD CONSTRAINT
PK_tblUnit PRIMARY KEY CLUSTERED 
(
UnitID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tblUnit_Organisation ON dbo.tblUnit
(
OrganisationID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblUnit ADD CONSTRAINT
FK_tblUnit_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
ALTER TABLE dbo.tblUnit ADD CONSTRAINT
FK_tblUnit_tblUnit FOREIGN KEY
(
ParentUnitID
) REFERENCES dbo.tblUnit
(
UnitID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION

GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnitModuleAccess ADD CONSTRAINT
FK_tblUnitModuleAccess_tblUnit FOREIGN KEY
(
UnitID
) REFERENCES dbo.tblUnit
(
UnitID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnitAdministrator ADD CONSTRAINT
FK_tblUnitAdministrator_tblUnit FOREIGN KEY
(
UnitID
) REFERENCES dbo.tblUnit
(
UnitID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUser ADD CONSTRAINT
FK_tblUser_tblUnit FOREIGN KEY
(
UnitID
) REFERENCES dbo.tblUnit
(
UnitID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION

GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnitRule ADD CONSTRAINT
FK_tblUnitRule_tblUnit FOREIGN KEY
(
UnitID
) REFERENCES dbo.tblUnit
(
UnitID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO


 --/tblUnit


 --tblUser
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT FK_tblUser_tblUnit
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT FK_tblUser_tblOrganisation
GO
COMMIT TRANSACTION

GO


BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT FK_tblUser_tblUserType
GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT DF_tblUser_UserTypeID
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT DF_tblUser_Status
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT DF_tblUser_DateCreated
GO
ALTER TABLE dbo.tblUser
DROP CONSTRAINT DF_tblUser_DateUpdated
GO
CREATE TABLE dbo.Tmp_tblUser
(
UserID int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
FirstName nvarchar(50) NULL,
LastName nvarchar(50) NULL,
UserName nvarchar(100) NOT NULL,
Password nvarchar(50) NOT NULL,
Email nvarchar(100) NULL,
ExternalID nvarchar(50) NULL,
OrganisationID int NULL,
UnitID int NULL,
UserTypeID int NOT NULL,
Active bit NOT NULL,
CreatedBy int NOT NULL,
DateCreated datetime NOT NULL,
UpdatedBy int NULL,
DateUpdated datetime NULL,
LastLogin datetime NULL
)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblUser ADD CONSTRAINT
DF_tblUser_UserTypeID DEFAULT (4) FOR UserTypeID
GO
ALTER TABLE dbo.Tmp_tblUser ADD CONSTRAINT
DF_tblUser_Status DEFAULT (1) FOR Active
GO
ALTER TABLE dbo.Tmp_tblUser ADD CONSTRAINT
DF_tblUser_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
ALTER TABLE dbo.Tmp_tblUser ADD CONSTRAINT
DF_tblUser_DateUpdated DEFAULT (getdate()) FOR DateUpdated
GO
SET IDENTITY_INSERT dbo.Tmp_tblUser ON
GO
IF EXISTS(SELECT * FROM dbo.tblUser)
EXEC('INSERT INTO dbo.Tmp_tblUser (UserID, FirstName, LastName, UserName, Password, Email, ExternalID, OrganisationID, UnitID, UserTypeID, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated, LastLogin)
SELECT UserID, CONVERT(nvarchar(50), FirstName), CONVERT(nvarchar(50), LastName), CONVERT(nvarchar(100), UserName), CONVERT(nvarchar(50), Password), CONVERT(nvarchar(100), Email), CONVERT(nvarchar(50), ExternalID), OrganisationID, UnitID, UserTypeID, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated, LastLogin FROM dbo.tblUser WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblUser OFF
GO
ALTER TABLE dbo.tblUserModuleAccess
DROP CONSTRAINT FK_tblUserModuleAccess_tblUser
GO
ALTER TABLE dbo.tblUserQuizStatus
DROP CONSTRAINT FK_tblUserQuizStatus_tblUser
GO
ALTER TABLE dbo.tblUserLessonStatus
DROP CONSTRAINT FK_tblUserLessonStatus_tblUser
GO
ALTER TABLE dbo.tblLessonSession
DROP CONSTRAINT FK_tblLessonSession_tblUser
GO
ALTER TABLE dbo.tblBookmark
DROP CONSTRAINT FK_tblBookmark_tblUser
GO
ALTER TABLE dbo.tblQuizSession
DROP CONSTRAINT FK_tblQuizSession_tblUser
GO
ALTER TABLE dbo.tblUnitAdministrator
DROP CONSTRAINT FK_tblUnitAdministrator_tblUser
GO
ALTER TABLE dbo.tblUserClassification
DROP CONSTRAINT FK_tblUserClassification_tblUser
GO
ALTER TABLE dbo.tblUserCourseStatus
DROP CONSTRAINT FK_tblUserCourseStatus_tblUser
GO
DROP TABLE dbo.tblUser
GO
EXECUTE sp_rename N'dbo.Tmp_tblUser', N'tblUser', 'OBJECT' 
GO
ALTER TABLE dbo.tblUser ADD CONSTRAINT
PK_tblUser PRIMARY KEY CLUSTERED 
(
UserID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX IX_tblUser_Username_Unique ON dbo.tblUser
(
UserName,
OrganisationID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_tblUser_Unit ON dbo.tblUser
(
UnitID
) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tblUser ADD CONSTRAINT
CK_tblUser CHECK (([Username] = [Username]))
GO
ALTER TABLE dbo.tblUser ADD CONSTRAINT
FK_tblUser_tblUserType FOREIGN KEY
(
UserTypeID
) REFERENCES dbo.tblUserType
(
UserTypeID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
ALTER TABLE dbo.tblUser ADD CONSTRAINT
FK_tblUser_tblOrganisation FOREIGN KEY
(
OrganisationID
) REFERENCES dbo.tblOrganisation
(
OrganisationID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
ALTER TABLE dbo.tblUser ADD CONSTRAINT
FK_tblUser_tblUnit FOREIGN KEY
(
UnitID
) REFERENCES dbo.tblUnit
(
UnitID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION

GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserCourseStatus ADD CONSTRAINT
FK_tblUserCourseStatus_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION

GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserClassification ADD CONSTRAINT
FK_tblUserClassification_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnitAdministrator ADD CONSTRAINT
FK_tblUnitAdministrator_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblQuizSession ADD CONSTRAINT
FK_tblQuizSession_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION

GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblBookmark ADD CONSTRAINT
FK_tblBookmark_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblLessonSession ADD CONSTRAINT
FK_tblLessonSession_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserLessonStatus ADD CONSTRAINT
FK_tblUserLessonStatus_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserQuizStatus ADD CONSTRAINT
FK_tblUserQuizStatus_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO


BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUserModuleAccess ADD CONSTRAINT
FK_tblUserModuleAccess_tblUser FOREIGN KEY
(
UserID
) REFERENCES dbo.tblUser
(
UserID
) ON UPDATE  NO ACTION 
ON DELETE  NO ACTION 

GO
COMMIT TRANSACTION
GO
 --/tblUser