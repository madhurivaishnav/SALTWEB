SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcGetReminderEscalations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [prcGetReminderEscalations]
(
@orgID int,
@langcode varchar(10)
)

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
SET NOCOUNT ON


declare @enabled varchar(10)
declare @disabled varchar(10)

declare @enable varchar(10)
declare @disable varchar(10)

declare @edit varchar(10)
declare @delete varchar(10)


SELECT     @enabled = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''enabled'') AND (tblLangValue.Active = 1)


SELECT     @disabled = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''disabled'') AND (tblLangValue.Active = 1)



SELECT     @enable = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''enable'') AND (tblLangValue.Active = 1)


SELECT     @disable = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''disable'') AND (tblLangValue.Active = 1)



SELECT     @edit = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''edit'') AND (tblLangValue.Active = 1)


SELECT     @delete = tblLangValue.LangEntryValue
FROM         tblLang INNER JOIN
tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID INNER JOIN
tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID
WHERE     (tblLang.LangCode = @langcode) AND (tblLangInterface.LangInterfaceName = ''/Administration/Organisation/OrganisationMail.aspx'') AND
(tblLangResource.LangResourceName = ''delete'') AND (tblLangValue.Active = 1)



select
re.RemEscId,
re.CourseId,
c.Name as CourseName,
case when re.RemindUsers= 1 then @enabled else @disabled end as RemindUsers,
case when re.QuizExpiryWarn =1 then @enabled else @disabled end as QuizExpiryWarn,
case when re.PostExpReminder = 1 then @enabled else @disabled end as PostExpReminder,
case when dateEnabled is null then @enable else @disable end as dateEnabled,
@edit as coledit,
@delete as colDel
from
tblReminderEscalation re
join tblCourse c on c.CourseID = re.CourseId and c.Active = 1
inner Join tblOrganisationCourseAccess oca	on oca.GrantedCourseID = c.CourseID
and oca.organisationID = @orgID
where
OrgId = @orgID

END
' 
END
GO
