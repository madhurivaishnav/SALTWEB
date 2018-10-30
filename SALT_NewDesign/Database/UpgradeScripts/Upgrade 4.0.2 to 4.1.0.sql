 

-- **** RENAME LICENSING REPORT ****
	-- RENAME LICENSING REPORT CRTIERIA INTERFACE
		UPDATE tblLangValue set LangEntryValue = 'Active / Inactive Users Report' 
		WHERE LangEntryValue = 'Licensing Report' 
		AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPageTitle')
		AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx')
		AND LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')


		UPDATE tblLangValue set LangEntryValue = 'Active / Inactive Users Report' 
		WHERE LangEntryValue = 'Licensing Report' 
		AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'pagTitle')
		AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx')
		AND LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')

		UPDATE tblLangInterface set LangInterfaceName = '/Reporting/Advanced/ActiveInactiveReport.aspx' WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'
		
	-- RENAME REPORT ON REPORT MENU
		UPDATE tblLangValue set LangEntryValue = 'Active / Inactive Users Report' 
		WHERE LangEntryValue = 'Licensing Report' 
		AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lbLicensingReport')
		AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'GLOBAL.UserControls.ReportsMenu.ascx')
		AND LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')

		UPDATE tblLangResource set LangResourceName = 'lbActiveInactiveReport' WHERE LangResourceName = 'lbLicensingReport'
		
	-- RENAME REPORTING SERVICES
		UPDATE tblLangValue set LangEntryValue = 'Active / Inactive Users Report' 
		WHERE LangEntryValue = 'Licensing Report' 
		AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptReportTitle')
		AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'REPORT.Licensing')
		AND LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')

		UPDATE tblLangInterface set LangInterfaceName = 'Report.ActiveInactive' WHERE LangInterfaceName = 'Report.Licensing'
-- /**** RENAME LICENSING REPORT ****


-- **** COURSE LICENSING ****
	CREATE TABLE [dbo].[tblCourseLicensing](
		[CourseLicensingID] [int] IDENTITY(1,1) NOT NULL,
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
	)
	) ON [PRIMARY]
	GO

	/****** Object:  Table [dbo].[tblCourseLicensingUser]    Script Date: 03/27/2008 11:06:14 ******/
	CREATE TABLE [dbo].[tblCourseLicensingUser](
		[CourseLicensingUserID] [int] IDENTITY(1,1) NOT NULL,
		[CourseLicensingID] [int] NOT NULL,
		[UserID] [int] NOT NULL,
		[LicenseDate] [datetime] NULL CONSTRAINT [DF_tblCourseLicensingUser_LicenseDate]  DEFAULT (getdate()),
	CONSTRAINT [PK_tblCourseLicensingUser] PRIMARY KEY CLUSTERED 
	(
		[CourseLicensingID] ASC,
		[UserID] ASC
	)
	) ON [PRIMARY]
	GO
-- /**** COURSE LICENSING ****

-- **** tblUser - Add DateArchived field ****
	/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
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
	ALTER TABLE dbo.tblUser
		DROP CONSTRAINT FK_tblUser_tblUnit
	GO
	COMMIT
	BEGIN TRANSACTION
	GO
	ALTER TABLE dbo.tblUser
		DROP CONSTRAINT FK_tblUser_tblOrganisation
	GO
	COMMIT
	BEGIN TRANSACTION
	GO
	ALTER TABLE dbo.tblUser
		DROP CONSTRAINT FK_tblUser_tblUserType
	GO
	COMMIT
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
		DateArchived datetime NULL,
		CreatedBy int NOT NULL,
		DateCreated datetime NOT NULL,
		UpdatedBy int NULL,
		DateUpdated datetime NULL,
		LastLogin datetime NULL
		)  ON [PRIMARY]
	GO
	ALTER TABLE dbo.Tmp_tblUser ADD CONSTRAINT
		DF_tblUser_UserTypeID DEFAULT ((4)) FOR UserTypeID
	GO
	ALTER TABLE dbo.Tmp_tblUser ADD CONSTRAINT
		DF_tblUser_Status DEFAULT ((1)) FOR Active
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
			SELECT UserID, FirstName, LastName, UserName, Password, Email, ExternalID, OrganisationID, UnitID, UserTypeID, Active, CreatedBy, DateCreated, UpdatedBy, DateUpdated, LastLogin FROM dbo.tblUser WITH (HOLDLOCK TABLOCKX)')
	GO
	SET IDENTITY_INSERT dbo.Tmp_tblUser OFF
	GO
	ALTER TABLE dbo.tblUserCourseStatus
		DROP CONSTRAINT FK_tblUserCourseStatus_tblUser
	GO
	ALTER TABLE dbo.tblUserClassification
		DROP CONSTRAINT FK_tblUserClassification_tblUser
	GO
	ALTER TABLE dbo.tblUnitAdministrator
		DROP CONSTRAINT FK_tblUnitAdministrator_tblUser
	GO
	ALTER TABLE dbo.tblQuizSession
		DROP CONSTRAINT FK_tblQuizSession_tblUser
	GO
	ALTER TABLE dbo.tblBookmark
		DROP CONSTRAINT FK_tblBookmark_tblUser
	GO
	ALTER TABLE dbo.tblLessonSession
		DROP CONSTRAINT FK_tblLessonSession_tblUser
	GO
	ALTER TABLE dbo.tblUserLessonStatus
		DROP CONSTRAINT FK_tblUserLessonStatus_tblUser
	GO
	ALTER TABLE dbo.tblUserQuizStatus
		DROP CONSTRAINT FK_tblUserQuizStatus_tblUser
	GO
	ALTER TABLE dbo.tblUserModuleAccess
		DROP CONSTRAINT FK_tblUserModuleAccess_tblUser
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
		CK_tblUser CHECK (([Username]=[Username]))
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
	COMMIT
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
	COMMIT
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
	COMMIT
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
	COMMIT
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
	COMMIT
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
	COMMIT
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
	COMMIT
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
	COMMIT
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
	COMMIT
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
	COMMIT
-- /**** tblUser - Add DateArchived field ****


-- **** LANGUAGES ADDED FOR LICENSING
	-- Tuesday, 19 February 2008 - 11:14:42 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock)
		SELECT 'hypLicensing', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 19 February 2008 - 11:14:42 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'GLOBAL.UserControls.AdminMenu.ascx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'hypLicensing'), 'Course Licensing', 1, 1, getdate(), newid()


	-- Tuesday, 19 February 2008 - 11:29:12 AM
	INSERT INTO tblLangInterface(LangInterfaceName, InterfaceType, UserCreated, DateCreated, RecordLock)
		SELECT '/ContentAdministration/Licensing/Default.aspx', 'aspx', 1, getdate(), newid()


	-- Tuesday, 19 February 2008 - 11:30:09 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'pagTitle'),  'Course Licensing', 1, 1, getdate(), newid()


	-- Tuesday, 19 February 2008 - 11:30:39 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPageTitle'), 'Course Licensing', 1, 1, getdate(), newid()


	-- Tuesday, 19 February 2008 - 11:35:02 AM
	INSERT INTO tblLangInterface(LangInterfaceName, InterfaceType, UserCreated, DateCreated, RecordLock) 
		SELECT '/ContentAdministration/Licensing/Detail.aspx', 'aspx', 1, getdate(), newid()


	-- Tuesday, 19 February 2008 - 11:36:35 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Detail.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'pagTitle'),  'Course Licencing Detail', 1, 1, getdate(), newid()


	-- Tuesday, 19 February 2008 - 11:37:08 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Detail.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPageTitle'), 'Course Licensing Detail', 1, 1, getdate(), newid()


	-- Thursday, 28 February 2008 - 4:14:45 PM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'Email_LicenseWarn', '{0} is receipient name, {1} is the license warning amount, {2} course name, {3} license limit, {4} name of contact person', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 28 February 2008 - 4:14:45 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'Email_LicenseWarn'), 'Dear {0}

	This is to inform you that you have now exceeded {1} users for the course: {2}.

	Your license limit for Anti Money Laundering is: {3}.

	Please Contact {4} to further discuss this matter.

	Kind Regards

	Your Salt Team', 1, 1, getdate(), newid()

	-- Friday, 29 February 2008 - 11:20:06 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'Email_ExpiryWarn', '{0} Receipient Name, {1} number days till expiry, {2} course name, {3} expiry date, {4} Salt rep name', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Friday, 29 February 2008 - 11:20:06 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'Email_ExpiryWarn'), 'Dear {0}

	This is a to inform you that your Salt license is due to expire within the next {1} days for the course: {2}

	The date of expiry is: {3}

	If you are currently actioning this, please disregard this email otherwise please contact {4} to further discuss this matter. 

	Kind Regards

	Your Salt Team
	', 1, 1, getdate(), newid()


	-- Friday, 29 February 2008 - 11:22:25 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'Email_ExpiryWarn_Subject', '{0} is course name', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Friday, 29 February 2008 - 11:22:25 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'Email_ExpiryWarn_Subject'), 'License expiry warning for {0}', 1, 1, getdate(), newid()


	-- Friday, 29 February 2008 - 11:23:00 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'Email_LicenseWarn_Subject', '{0} is course name', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Friday, 29 February 2008 - 11:23:00 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'Email_LicenseWarn_Subject'), 'License usage warning for {0}', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 9:25:34 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lnkLicensingReport', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 9:25:34 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'GLOBAL.UserControls.ReportsMenu.ascx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lnkLicensingReport'), 'Licensing Report', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 9:39:33 AM
	INSERT INTO tblLangInterface(LangInterfaceName, InterfaceType, UserCreated, DateCreated, RecordLock) 
		SELECT '/Reporting/Advanced/LicensingReport.aspx', 'aspx', 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 9:39:56 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'pagTitle'),  'Licensing Report', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 9:40:19 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPageTitle'), 'Licensing Report', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 10:53:29 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lnkReportPeriod', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 10:53:29 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lnkReportPeriod'), 'Run Report', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 11:24:29 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'butRunAll', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 11:24:29 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'butRunAll'), 'Report All', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 11:25:46 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblNote'), '(runs for all courses for current active period)', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 11:49:24 AM
	INSERT INTO tblLangInterface(LangInterfaceName, InterfaceType, UserCreated, DateCreated, RecordLock) 
		SELECT 'Report.Licensing', 'aspx', 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 11:50:10 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptReportTitle'), 'Licensing Report', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 3:07:56 PM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'rptPeriod', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 3:07:56 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptPeriod'), 'Period', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 3:08:20 PM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'rptLicenseQuota', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 3:08:20 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptLicenseQuota'), 'License Quota', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 3:08:38 PM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'rptLicensesUsed', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 3:08:38 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptLicensesUsed'), 'Licenses Used', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 3:08:54 PM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'rptLicensesRemaining', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 3:08:54 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptLicensesRemaining'), 'Licenses Remaining', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 3:20:33 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptUserFullName'), 'User Full Name', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 3:21:06 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptCourseName'), 'Course Name', 1, 1, getdate(), newid()


	-- Tuesday, 4 March 2008 - 3:21:22 PM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'rptDateCreated', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Tuesday, 4 March 2008 - 3:21:22 PM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptDateCreated'), 'Date Created', 1, 1, getdate(), newid()

	-- Thursday, 6 March 2008 - 8:25:26 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'rptArchive', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 8:25:26 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptArchive'), 'Archived', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 8:25:35 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'rptYes', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 8:25:35 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'Report.Licensing'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'rptYes'), 'Yes', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:14:09 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblCourseName', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:14:09 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblCourseName'), 'Course Name', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:15:15 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblPeriod', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:15:15 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPeriod'), 'Period', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:15:23 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblAction', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:15:23 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Advanced/LicensingReport.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblAction'), 'Action', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:17:17 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblCourseName'), 'Course Name', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:17:29 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblCurrentPeriod', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:17:29 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblCurrentPeriod'), 'Current Period', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:17:45 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblFuturePeriod', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:17:45 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblFuturePeriod'), 'Future Period', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:17:59 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblAction'), 'Action', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:20:07 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'hypEdit', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:20:07 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'hypEdit'), 'Edit', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:20:52 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblLegendNote', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:20:52 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblLegendNote'), 'The left column indicates the status of the course licensing.', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:21:45 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblNormal', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:21:45 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblNormal'), 'Within normal license parameters', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:21:55 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblExceededWarn', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:21:55 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblExceededWarn'), 'Warning, the course has exceeded warning license number or warning date', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:22:03 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblExceeded', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:22:03 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblExceeded'), 'The course has exceeded the licensing number', 1, 1, getdate(), newid()


	-- Thursday, 6 March 2008 - 9:22:12 AM
	INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) 
		SELECT 'lblNoPeriod', '', 1, getdate(), newid(); SELECT @@IDENTITY AS [@@IDENTITY]


	-- Thursday, 6 March 2008 - 9:22:12 AM
	INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock) 
		SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/ContentAdministration/Licensing/Default.aspx'), (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblNoPeriod'), 'The course has no current licensing period', 1, 1, getdate(), newid()
GO
-- /**** LANGUAGES ADDED FOR LICENSING

-- **** SETUP DATABASE MAIL ****
	master.dbo.sp_configure 'show advanced options', 1
	GO
	reconfigure with override
	GO
	master.dbo.sp_configure 'Database Mail XPs', 1
	GO
	reconfigure 
	GO
	master.dbo.sp_configure 'show advanced options', 0
	GO

	DECLARE @ProfileName VARCHAR(255)
	DECLARE @AccountName VARCHAR(255)
	DECLARE @SMTPAddress VARCHAR(255)
	DECLARE @EmailAddress VARCHAR(128)
	DECLARE @DisplayUser VARCHAR(128)

	SET @ProfileName = 'Salt_MailAccount';
	SET @AccountName = 'Salt_MailAccount';
	SELECT @SMTPAddress = Value FROM tblAppConfig WHERE Name = 'MailServer'
	SELECT @EmailAddress = Value FROM tblAppConfig WHERE Name = 'FromEmail'
	SELECT @DisplayUser = Value FROM tblAppConfig WHERE Name = 'FromName'

	if (@EmailAddress IS NULL)
	BEGIN
		SELECT @EmailAddress = Value FROM tblAppConfig WHERE Name = 'SupportEmail'
	END

	if (@DisplayUser IS NULL)
	BEGIN
		SELECT @DisplayUser = Value FROM tblAppConfig WHERE Name = 'SupportEmail'
	END

	IF EXISTS
	(
	SELECT * FROM msdb.dbo.sysmail_profileaccount pa JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id
	WHERE p.name = @ProfileName AND a.name = @AccountName)
	BEGIN PRINT 'Deleting Profile Account' EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = @ProfileName, @account_name = @AccountName
	END

	IF EXISTS
	(
	SELECT * FROM msdb.dbo.sysmail_profile p 
	WHERE p.name = @ProfileName
	)
	BEGIN PRINT 'Deleting Profile.' EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = @ProfileName
	END

	IF EXISTS
	(
	SELECT * FROM msdb.dbo.sysmail_account a
	WHERE a.name = @AccountName
	)
	BEGIN PRINT 'Deleting Account.' EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = @AccountName
	END
	
	use [msdb]

	if NOT EXISTS(select [name] from sysusers where [name] = '{databaseUser}')
	BEGIN
		CREATE USER [{databaseUser}] FOR LOGIN [{databaseUser}]
	END

	
	execute msdb.dbo.sp_addrolemember N'db_owner', '{databaseUser}'
	execute msdb.dbo.sp_addrolemember N'DatabaseMailUserRole', '{databaseUser}'

	
	EXECUTE msdb.dbo.sysmail_add_account_sp
	@account_name = @AccountName,
	@email_address = @EmailAddress,@display_name = @DisplayUser,
	@mailserver_name = @SMTPAddress

	EXECUTE msdb.dbo.sysmail_add_profile_sp
	@profile_name = @ProfileName 

	EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
	@profile_name = @ProfileName,
	@account_name = @AccountName,
	@sequence_number = 1 ;
	
	EXEC msdb.dbo.sysmail_add_principalprofile_sp @principal_name=N'guest', @profile_name=@ProfileName, @is_default=0

	use [{database}]
	go
-- /**** SETUP DATABASE MAIL ****

-- **** ORGANISATION MODULE ACCESS ****

	CREATE TABLE [dbo].[tblOrganisationModuleAccess](
		[OrganisationModuleAccessID] [int] IDENTITY(1,1) NOT NULL,
		[OrganisationID] [int] NULL,
		[PolicyBuilder] [bit] NULL,
	CONSTRAINT [PK_tblOrganisationModuleAccess] PRIMARY KEY CLUSTERED 
	(
		[OrganisationModuleAccessID] ASC
	)
	) ON [PRIMARY]

	go
-- /**** ORGANISATION MODULE ACCESS ****