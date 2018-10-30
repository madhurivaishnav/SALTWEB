--*************** populate unitHierarchy on test servers ****************
IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUnitHierarchy')
	BEGIN


		CREATE TABLE [dbo].[tblUnitHierarchy](
			[UnitID] [int] NOT NULL,
			[Hierarchy] [nvarchar](500) NULL,
			[HierarchyName] [nvarchar](2000) NULL,
		CONSTRAINT [PK_tblUnitHierarchy] PRIMARY KEY CLUSTERED 
		(
			[UnitID] ASC
		) ON [PRIMARY]
		) ON [PRIMARY]

		INSERT INTO tblUnitHierarchy (UnitID,Hierarchy,HierarchyName)
			SELECT UnitID,Hierarchy,dbo.udfGetUnitPathway(UnitID) FROM tblUnit
	END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[utg_UpdateUnitHierarchy]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [utg_UpdateUnitHierarchy] ON [tblUnit] AFTER INSERT, UPDATE AS
--Update Existing hierarchies
UPDATE 
	tblUnitHierarchy
SET
	Hierarchy = B.Hierarchy,
	HierarchyName = dbo.udfGetUnitPathway(B.UnitID)
FROM 
	tblUnitHierarchy A, tblUnit B
WHERE
	A.UnitID = B.UnitID AND
	B.UnitID IN (Select A.UnitID FROM tblUnit A, INSERTED B WHERE A.Hierarchy LIKE ''%'' + CAST(B.UnitID AS VARCHAR(10)) + ''%'')
	
--Insert new hierarchies
INSERT INTO 
	tblUnitHierarchy
SELECT 
	A.UnitID, A.Hierarchy, dbo.udfGetUnitPathway(A.UnitID)
FROM
	INSERTED A
WHERE
	A.UnitID NOT IN (SELECT B.UnitID FROM tblUnitHierarchy B WHERE B.UnitID = A.UnitID)


' 
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[utg_DeleteUnitHierarchy]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1)
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [utg_DeleteUnitHierarchy] ON [tblUnit] AFTER DELETE AS
DELETE FROM tblUnitHierarchy
WHERE UnitID IN (SELECT UnitID FROM Deleted)

' 
--*************** populate unitHierarchy on test servers ****************



--*************** update default email report email config ****************
INSERT INTO tblOrganisationConfig(OrganisationID,Name,Description,Value)
VALUES(NULL,'Policy_Email_Report_Accepted_To_Users','Policy_Email to Accepted Users','<BR>Hi,<BR>Thank You for taking the time to Read and accept the %POLICY% policy <BR><BR>Regards,<BR>%APP_NAME% Administrator')

INSERT INTO tblOrganisationConfig(OrganisationID,Name,Description,Value)
VALUES(NULL,'Policy_Email_Report_Not_Accepted_To_Users','Policy_Email to Not Accepted Users','<BR>Hi,<BR>Our Records show that you have not logged into %APP_NAME% to read and acknowledge the following policy: <BR> %POLICY% <BR> Please login into %APP_NAME% Online Compliance Training to access the policies assigned to you.<BR><BR>Regards,<BR>%APP_NAME% Administrator')
INSERT INTO tblOrganisationConfig(OrganisationID,Name,Description,Value)
VALUES(NULL,'Policy_Email_Report_Accepted_To_Administrators','Policy_Email to Accepted Users Administrators','<BR>Hi,<BR>The following users have accepted their %POLICY% policy between %DATE_FROM% and %DATE_TO%:<BR>%USER_LIST%<BR>Regards,<BR>%APP_NAME% Administrator')
INSERT INTO tblOrganisationConfig(OrganisationID,Name,Description,Value)
VALUES(NULL,'Policy_Email_Report_Not_Accepted_To_Administrators','Policy_Email to Not Accepted Users Administrators','<BR>Hi,<BR>The following users have not read their %POLICY% policy between %DATE_FROM% and %DATE_TO%:<BR>%USER_LIST%<BR>Regards,<BR>%APP_NAME% Administrator')


--*************** end update default email report email config ****************

--*************** Language Translation *********************


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Users/UserDetails.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Users/UserDetails.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.Business') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.Business', 'business layer', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.AdminMenu.ascx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.AdminMenu.ascx', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.Misc') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.Misc', 'misc', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.Summary') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.Summary', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.GLOBAL') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.GLOBAL', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/About.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/About.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Certificate.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Certificate.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/MyTraining.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/MyTraining.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Disclaimer.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Disclaimer.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Links.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Links.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'LanguageNames') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'LanguageNames', 'language list', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Login.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Login.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/PasswordRecovery.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/PasswordRecovery.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/TermsOfUse.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/TermsOfUse.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/AdministrationHome.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/AdministrationHome.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Application/ApplicationAuditing.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Application/ApplicationAuditing.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/AddOrganisationAdministrator.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/AddOrganisationAdministrator.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/BulkAssignUsers.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/BulkAssignUsers.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/CourseAccess.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/CourseAccess.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/ImportUsers.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/ImportUsers.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/ImportUsersSample.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/ImportUsersSample.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/ModifyCustomClassification.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/ModifyCustomClassification.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/ModifyLinks.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/ModifyLinks.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/OrganisationAdministrators.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/OrganisationAdministrators.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/OrganisationConfiguration.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/OrganisationConfiguration.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/OrganisationDetails.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/OrganisationDetails.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/AddUnit.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/AddUnit.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/AddUnitAdministrator.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/AddUnitAdministrator.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/ComplianceRules.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/ComplianceRules.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/ImportUsers.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/ImportUsers.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/UnitAdministrators.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/UnitAdministrators.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/UnitDetails.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/UnitDetails.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/UnitManagement.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/UnitManagement.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/UnitModuleAccess.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/UnitModuleAccess.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Unit/UnitSearch.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Unit/UnitSearch.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Users/ApplicationAdministrators.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Users/ApplicationAdministrators.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Users/UserModuleAccess.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Users/UserModuleAccess.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Users/UserSearch.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Users/UserSearch.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Courses/AddCourse.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Courses/AddCourse.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Courses/CourseDetails.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Courses/CourseDetails.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/InfoPath/PublishInfoPathContent.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/InfoPath/PublishInfoPathContent.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Modules/ModuleDetails.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Modules/ModuleDetails.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Modules/UploadToolBookContent.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Modules/UploadToolBookContent.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/General/Errors/ErrorHandler.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/General/Errors/ErrorHandler.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/General/Errors/NoSuchPage.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/General/Errors/NoSuchPage.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/General/Errors/ValidationException.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/General/Errors/ValidationException.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/General/InfoPath/Rendering/TemplateQuiz.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/General/InfoPath/Rendering/TemplateQuiz.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/General/InfoPath/Rendering/TemplateLesson.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/General/InfoPath/Rendering/TemplateLesson.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/QuizHistory.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/QuizHistory.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/QuizResult.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/QuizResult.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/QuizSummary.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/QuizSummary.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/ReportingHome.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/ReportingHome.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Admin/AdministrationReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Admin/AdministrationReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Admin/AdminSummaryReportTesting.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Admin/AdminSummaryReportTesting.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/CompletedUsersReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/CompletedUsersReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/CourseStatusReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/CourseStatusReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/ActiveInactiveReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/ActiveInactiveReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/SummaryReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/SummaryReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/TrendReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/TrendReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/UnitPathReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/UnitPathReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/UserDetailReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/UserDetailReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/CompletedUsers/CompletedUsersReporting.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/CompletedUsers/CompletedUsersReporting.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Email/BuildEmailReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Email/BuildEmailReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Individual/IndividualReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Individual/IndividualReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Summary/SummaryReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Summary/SummaryReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Trend/TrendReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Trend/TrendReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/General/ToolBook/ToolBookListener.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/General/ToolBook/ToolBookListener.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.ImportUsers.ascx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.ImportUsers.ascx', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.Login.ascx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.Login.ascx', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.ReportCriteria.ascx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.ReportCriteria.ascx', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.Header.ascx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.Header.ascx', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.ReportsMenu.ascx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.ReportsMenu.ascx', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Help.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Help.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.CompletedUser') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.CompletedUser', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.CourseStatus') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.CourseStatus', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.ActiveInactive') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.ActiveInactive', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.Trend') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.Trend', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.UnitPathway') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.UnitPathway', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.UserDetail') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.UserDetail', 'report', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Application/ApplicationConfiguration.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Application/ApplicationConfiguration.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.TreeView') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.TreeView', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.QuizLessonEntry') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.QuizLessonEntry', 'user control', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Global.Common') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Global.Common', 'common', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Modules/ResetLesson.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Modules/ResetLesson.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Modules/ResetQuiz.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Modules/ResetQuiz.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Licensing/Default.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Licensing/Default.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ContentAdministration/Licensing/Detail.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ContentAdministration/Licensing/Detail.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/LicensingReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/LicensingReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.Licensing') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.Licensing', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Application/OrgModAccess.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Application/OrgModAccess.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.IncompleteUserWithDetails') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.IncompleteUserWithDetails', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Application/OrganisationApplicationAccess.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Application/OrganisationApplicationAccess.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/EmailSentReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/EmailSentReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Policy/policydefault.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Policy/policydefault.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Policy/policydetails.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Policy/policydetails.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Organisation/MoveUsersToUnit.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Organisation/MoveUsersToUnit.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Users/ArchiveUsers.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Users/ArchiveUsers.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/CPD/cpddefault.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/CPD/cpddefault.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/CPD/cpddetail.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/CPD/cpddetail.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/CPD/CPDReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/CPD/CPDReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/CPD/CPDEmailReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/CPD/CPDEmailReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Policy/PolicyBuilderReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Policy/PolicyBuilderReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'GLOBAL.UserControls.UserMenu.ascx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'GLOBAL.UserControls.UserMenu.ascx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.Policies') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.Policies', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Default.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Default.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.CPDReport') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.CPDReport', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/ViewPolicy.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/ViewPolicy.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Admin/UnitAdministratorReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Admin/UnitAdministratorReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.UnitAdministratorReport') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.UnitAdministratorReport', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Administration/Users/EmailUsers.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Administration/Users/EmailUsers.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/WarningReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/WarningReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.Warning') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.Warning', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.Administration') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.Administration', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/AtRiskReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/AtRiskReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.AtRisk') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.AtRisk', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Admin/UnitComplianceReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Admin/UnitComplianceReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.UnitComplianceReport') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.UnitComplianceReport', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Advanced/ProgressReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Advanced/ProgressReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:14 AM
GO


-- Tuesday, 25 May 2010 - 8:14:14 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'Report.Progress') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'Report.Progress', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangInterface where LangInterfaceName = N'/Reporting/Email/PolicyEmailReport.aspx') insert into tblLangInterface (LangInterfaceName, InterfaceType, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'/Reporting/Email/PolicyEmailReport.aspx', 'aspx', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblFirstName') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblFirstName', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblLastName') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblLastName', 'form label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblUserName') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblUserName', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblOldPassword') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblOldPassword', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblNewPassword') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblNewPassword', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblConfirmPassword') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblConfirmPassword', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblUserActive') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblUserActive', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblLastLoginLabel') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblLastLoginLabel', 'form label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblPasswordInstruction') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblPasswordInstruction', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblPageTitle') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblPageTitle', 'label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lnkReturnTo.3') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lnkReturnTo.3', 'link', 'link to return to previous page', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lnkReturnTo.5') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lnkReturnTo.5', 'link', 'link to return to previous page', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lnkReturnTo.6') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lnkReturnTo.6', 'link', 'link to return to previous page', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lnkReturnTo.7') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lnkReturnTo.7', 'link', 'link to return to previous page', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lnkReturnTo.8') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lnkReturnTo.8', 'link', 'link to return to previous page', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblMessage') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblMessage', 'message', 'Message on add of user', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblPageTitle.2') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblPageTitle.2', 'label', 'Title on add of user', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblPageTitle.3') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblPageTitle.3', 'label', 'Title on add of user', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblPageTitle.4') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblPageTitle.4', 'label', 'Title on edit user', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'lblLastLogin.Never') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'lblLastLogin.Never', 'codebehind label', '', 1, null, null, getdate(), null, null, newid()) 


-- Tuesday, 25 May 2010 - 8:14:15 AM
GO


-- Tuesday, 25 May 2010 - 8:14:15 AM
if not exists (select * from tblLangResource where LangResourceName = N'chkUserStatus.ToolTip') insert into tblLangResource (LangResourceName, ResourceType, Comment, UserCreated, UserModified, UserDeleted, DateCreated, DateModified, DateDeleted, RecordLock) values (N'chkUserStatus.ToolTip', 'checkbox', '', 1, null, null, getdate(), null, null, newid()) 


--*************** End Language Translation *********************

--*************** Language Upgrade *********************
-- Friday, 9 April 2010 - 1:20:32 PM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('chkSelctAll.Select', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 9 April 2010 - 1:20:32 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkSelctAll.Select'), 
					'Select All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 9 April 2010 - 1:20:46 PM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('chkSelctAll.Deselect', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 9 April 2010 - 1:20:46 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkSelctAll.Deselect'), 
					'Deselect All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 23 April 2010 - 2:26:34 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkClearAll'), 
					'Clear All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Thursday, 13 May 2010 - 11:39:06 AM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('lbPolicyEmailReport', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Thursday, 13 May 2010 - 11:39:06 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'GLOBAL.UserControls.ReportsMenu.ascx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lbPolicyEmailReport'), 
					'Policy Email Report', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Thursday, 13 May 2010 - 1:57:34 PM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('lblPolicyEmailReport', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Thursday, 13 May 2010 - 1:57:34 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = 'GLOBAL.UserControls.ReportsMenu.ascx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPolicyEmailReport'), 
					'Policy Email Report', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]



-- Friday, 14 May 2010 - 10:58:14 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPageTitle'), 
					'Policy changes Email Report', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:23:28 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'btnBack'), 
					'Back', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:23:45 PM
UPDATE tblLangValue set LangEntryValue = 'Return', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'btnBackToMain')
				


-- Friday, 14 May 2010 - 12:24:04 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'btnBackToMain'), 
					'Return', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:24:42 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'btnGenerateEmail'), 
					'Preview Email', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:25:01 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'btnReset'), 
					'Reset', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:25:32 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'btnSendEmail'), 
					'Send Email', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:25:55 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkClearAll'), 
					'Clear All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:26:51 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkSelctAll.Deselect'), 
					'Deselect All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:27:20 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkSelctAll.Select'), 
					'Select All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:27:40 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkSelectAll'), 
					'Select All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:28:07 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'chkSelectAll.Deselect'), 
					'Deselect All', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]




-- Friday, 14 May 2010 - 12:28:57 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'EmailReportSent'), 
					'Email Report Sent', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:32:00 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'EmailUserCopyBody'), 
					'The following email text has been sent from {0} on {1}: \n {2}\n\nIt has been sent to the following users:\n{3}', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:32:19 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'From'), 
					'From', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:32:33 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblAnd'), 
					'and', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:32:50 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblBetween'), 
					'Between', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]





-- Friday, 14 May 2010 - 12:33:44 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblCustomClassification'), 
					'Grouping Option', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:34:02 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblEmailSent'), 
					'The email has been sent successfully.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:34:19 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblError.Caution'), 
					'Caution: Sending many emails may impact server performance.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:34:35 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblError.InvalidDate'), 
					'Error: Invalid date selected', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:35:05 PM
UPDATE tblLangValue set LangEntryValue = 'No policies exist within this organisation.', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblError.NoCourse')
				


-- Friday, 14 May 2010 - 12:35:52 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblError.NoUnit'), 
					'No units exist within this organisation.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:36:33 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblError.NoCourse'), 
					'No policies exist within this organisation.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:36:52 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblError.NoUser'), 
					'No users found.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:37:05 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblError.OneRecip'), 
					'To send an email you must have at least one recipient, an email subject and an email body.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:37:19 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblIncludeInactive'), 
					'Include Inactive Users', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:37:54 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblQuizDateRange'), 
					'Quiz Date Range', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:38:07 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblRecip'), 
					'Recipient', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:38:26 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblUnits'), 
					'Units<BR>(Blank for all units)', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:38:42 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'pagTitle'), 
					'Build Email Report', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]



-- Friday, 14 May 2010 - 12:40:41 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'radRecipientType.1'), 
					'Administrators', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:40:56 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'radRecipientType.2'), 
					'Users', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:41:05 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'Recipients'), 
					'Recipients', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:41:24 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'ReportRunAt'), 
					'Report run at', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:41:40 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'ReportRunBy'), 
					'Report run by', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:41:50 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'To'), 
					'To', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Friday, 14 May 2010 - 12:42:01 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'UnitPathway'), 
					'Unit Pathway', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Monday, 17 May 2010 - 8:38:36 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/BuildEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblStatus'), 
					'Status', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Monday, 17 May 2010 - 8:38:52 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblStatus'), 
					'Status', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]

				


-- Monday, 17 May 2010 - 9:23:23 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPolicy'), 
					'Policy to report on:', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Monday, 17 May 2010 - 9:24:22 AM
UPDATE tblLangValue set LangEntryValue = 'Quiz Date Range', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPolicyDateRange')
				


-- Monday, 17 May 2010 - 9:25:00 AM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('lblPolicyDateRange', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Monday, 17 May 2010 - 9:25:00 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPolicyDateRange'), 
					'Policy Date range:', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Monday, 17 May 2010 - 9:25:25 AM
UPDATE tblLangValue set LangEntryValue = 'Policy Date Range', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPolicyDateRange')
				


-- Monday, 17 May 2010 - 9:26:57 AM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('lblPolicyStatus', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Monday, 17 May 2010 - 9:26:57 AM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPolicyStatus'), 
					'Policy Status', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Monday, 17 May 2010 - 9:37:12 AM
UPDATE tblLangValue set LangEntryValue = 'Policy to report on', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPolicy')
				
				


-- Tuesday, 18 May 2010 - 12:25:52 PM
UPDATE tblLangValue set LangEntryValue = 'Accepted - All students who have accepted the most recent Policy', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'radPolicyModuleStatus.1')
				


-- Tuesday, 18 May 2010 - 12:27:01 PM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('radPolicyModuleStatus.1', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Tuesday, 18 May 2010 - 12:27:01 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'radPolicyModuleStatus.1'), 
					'Accepted - All students who have accepted the lastest Policy Document.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Tuesday, 18 May 2010 - 12:28:37 PM
INSERT INTO tblLangResource (LangResourceName, Comment, UserCreated, DateCreated, RecordLock) VALUES('radPolicyModuleStatus.2', '', 1, getdate(), newid());SELECT @@IDENTITY AS [@@IDENTITY]


-- Tuesday, 18 May 2010 - 12:28:37 PM
INSERT INTO tblLangValue(LangID, LangInterfaceID, LangResourceID, LangEntryValue, Active, UserCreated, DateCreated, RecordLock)
					SELECT (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU'), 
					(SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx'), 
					(SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'radPolicyModuleStatus.2'), 
					'All students who have NOT accepted the latest Policy Document.', 1, 1, getdate(), newid();SELECT @@IDENTITY AS [@@IDENTITY]


-- Tuesday, 18 May 2010 - 12:46:02 PM
UPDATE tblLangValue set LangEntryValue = 'Not Accepted - All students who have NOT accepted the latest Policy Document.', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'radPolicyModuleStatus.2')
				


-- Wednesday, 19 May 2010 - 1:19:24 PM
UPDATE tblLangValue set LangEntryValue = 'Policy Email Report', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'pagTitle')
				


-- Thursday, 20 May 2010 - 8:40:59 AM
UPDATE tblLangValue set LangEntryValue = 'Policy Email Report', DateModified = getdate() 
					WHERE LangID = (SELECT LangID FROM tblLang WHERE LangCode = 'en-AU')
						AND LangInterfaceID = (SELECT LangInterfaceID FROM tblLangInterface WHERE LangInterfaceName = '/Reporting/Email/PolicyEmailReport.aspx')
						AND LangResourceID = (SELECT LangResourceID FROM tblLangResource WHERE LangResourceName = 'lblPageTitle')
				



--*************** End Language Upgrade *********************