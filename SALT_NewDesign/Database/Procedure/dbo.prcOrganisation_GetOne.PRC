SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Gets othe details of one Organisation
Parameters: @orgID integer
Returns: OrganisationID, OrganisationName,  Logo, Notes, DefaultLessonFrequency, DefaultQuizFrequency, DefaultQuizPassMark, CreatedBy, DateCreated,  UpdatedBy, DateUpdated

Called By: Organisation.cs
Calls: None

Remarks: Raises an error if the parameter is null

Author: Peter Vranich
Date Created: 4th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1	aaronc		May 2008		Added retrieval of CPDReportName
#2	aaronc		June2008		Added retrieval of AllocatedDiskSpace
*/

CREATE procedure [prcOrganisation_GetOne]
(
	@LangCode nvarchar(10),
	@orgID Integer = null -- OrganisationID
)

As
BEGIN

	If @orgID Is Null
	Begin
		Raiserror(''''''''''The Parameter @orgID was null.  @orgID does not accept Null values.'''''''''', 16, 1)
		Return
	End

	Select
		o.OrganisationID,
		o.OrganisationName,
		o.Logo,
		orgN.Notes,
		o.DefaultLessonFrequency,
		o.DefaultQuizFrequency,
		o.DefaultQuizPassMark,
		dbo.udfUTCtoDaylightSavingTime(o.DefaultLessonCompletionDate, o.OrganisationID) as DefaultLessonCompletionDate,
		dbo.udfUTCtoDaylightSavingTime(o.DefaultQuizCompletionDate, o.OrganisationID) as DefaultQuizCompletionDate,
		o.AdvancedReporting,
		o.CreatedBy,
		dbo.udfUTCtoDaylightSavingTime(o.DateCreated, o.OrganisationID) as DateCreated,
		o.UpdatedBy,
		dbo.udfUTCtoDaylightSavingTime(o.DateUpdated, o.OrganisationID)as DateUpdated,
		o.CPDReportName,
		o.AllocatedDiskSpace,
		o.IncludeCertificateLogo,
		o.PasswordLockout,
		o.TimeZoneID,
		o.IncludeLogoOnCorrespondence,
		o.QuizDueDate,
		o.ShowLastPassed,
		o.DisablePasswordField,
		o.DefaultEbookEmailNotification
	From
		tblOrganisation o
		left join tblOrganisationNotes orgN	on o.OrganisationID = orgN.OrganisationID
		left join tblLang l	on orgN.LanguageID = l.LangID
	Where
		o.OrganisationID = @orgID
		and l.LangCode = @LangCode

END

' 
END
GO
