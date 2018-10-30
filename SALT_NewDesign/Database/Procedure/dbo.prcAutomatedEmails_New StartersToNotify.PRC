SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAutomatedEmails_New StartersToNotify]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [prcAutomatedEmails_New StartersToNotify]
(
@OrganisationID int
)


AS
Set Xact_Abort On
BEGIN


declare @stopEmails bit
set @stopEmails = 0
select @stopEmails = StopEmails from tblOrganisation where OrganisationID = @OrganisationID

-- New Starter
SELECT userid,email,(SELECT dbo.udfUser_GetAdministratorsEmailAddress (U.UserID)) as SenderEmail, (SELECT Value + '' login details '' FROM tblAppConfig where Name = ''AppName'') as subject, 
coalesce
(
(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID = @OrganisationID AND Name = ''Student_Summary_NewStarter'')
,
(SELECT  Value FROM tblOrganisationConfig WHERE OrganisationID IS NULL AND Name = ''Student_Summary_NewStarter'')
) as body
, -- Sender"On Behalf Of" Email Address
(SELECT dbo.udfUser_GetAdministratorsOnBehalfOfEmailAddress (U.UserID))  as OnBehalfOfEmail

from tblUser U where  U.OrganisationID = @OrganisationID and U.active = 1 and U.NewStarter = 1
  and @stopEmails = 0 

update tblUser set NewStarter = 0  where  OrganisationID = @OrganisationID and active = 1 and NewStarter = 1


END
' 
END
GO
