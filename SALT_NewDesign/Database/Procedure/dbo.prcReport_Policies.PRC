SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_Policies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/******************************************************************************
**		File: dbo.prcReport_Policies.PRC
**		Name: prcReport_Policies
**		Desc: For reporting of Policy acceptance by users
**
**		Return values:
**			Policy
**			UnitPathway
**			Lastname
**			Firstname
**			Email
**			Accepted
**			DateAccepted
**
**		Called by:
**
**		Parameters:
**			@organisationID Integer = ''0''
**			@policyIDs varchar(8000) = ''0''
**			@unitIDs varchar(8000) = ''0''
**			@dateFrom datetime = Null
**			@dateTo datetime = Null
**			@acceptanceStatus varchar(20) = ''BOTH''
**			@includeInactiveUsers varchar(5) = ''false''
**
**		Input							Output
**     ----------							-----------
**
**		Auth: Chris Plewright
**		Date: 31 Jul 2008
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**		14/08/2009		Mark Donald				More detail in Order By clause
**												+ extra column (userid) in result set
**		09/06/2011		J hedlefs				tIMEZONE
*******************************************************************************/
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.

CREATE Procedure [dbo].[prcReport_Policies]
@organisationID Integer = ''0'',
@policyIDs varchar(8000) = ''0'',
@unitIDs varchar(max) = ''0'',
@dateFromOrg datetime = Null,
@dateToOrg datetime = Null,
@acceptanceStatus varchar(20) = ''BOTH'',
@includeInactiveUsers varchar(5) = ''false''
AS

BEGIN

SET NOCOUNT ON;
DECLARE @dateFrom 		datetime
DECLARE @dateTo 		datetime
SET @dateFrom = dbo.udfDaylightSavingTimeToUTC(@dateFromOrg,@OrganisationID)
SET @dateTo = dbo.udfDaylightSavingTimeToUTC(@dateToOrg,@OrganisationID)

select
Policy = pol.PolicyName + '' ('' + pol.PolicyFileName + '')'',
UnitPathway = tblUnitHierarchy.HierarchyName,
--tblUser.Lastname,
CASE
WHEN tblUser.Active = 0 then LastName + '' (I)''
ELSE LastName
END AS LastName,
tblUser.Firstname,
tblUser.Email,
tblUser.userid,
Accepted = case when ua1.Accepted = 1  and (ua1.DateAccepted >= @dateFrom and ua1.DateAccepted <= @dateTo) then ''Yes'' else ''No'' end,
case when ua1.DateAccepted >= @dateFrom and ua1.DateAccepted <= @dateTo then  dbo.udfUTCtoDaylightSavingTime(ua1.DateAccepted,@OrganisationID)  else null end as DateAccepted
from tblPolicy pol
join tblOrganisation org on org.OrganisationID = pol.Organisationid and org.OrganisationID = @OrganisationID
join tblUser on tblUser.OrganisationID = org.OrganisationID and (@includeInactiveUsers=''true'' or tblUser.Active=1) and tblUser.UnitID in (select IntValue from dbo.udfCsvToInt(@unitIDs))
join tblUserPolicyAccepted ua1 on pol.PolicyID = ua1.PolicyID and tblUser.UserID = ua1.UserID
join tblUnitHierarchy on tblUser.UnitID = tblUnitHierarchy.UnitID
left join tblUserPolicyAccess upa on upa.PolicyID = pol.PolicyID and upa.UserID = tblUser.Userid
where upa.granted = 1 and pol.Active = 1 and pol.Deleted = 0 and pol.uploaddate between @dateFrom and @dateTo
and pol.PolicyID in ( select IntValue from dbo.udfCsvToInt(@policyIDs ) )
and (
--Condition A - ACCEPTED
( @acceptanceStatus=''ACCEPTED'' and exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1 ) )
or
--Condition B - NOT_ACCEPTED
( @acceptanceStatus=''NOT_ACCEPTED'' and not exists(select * from tblUserPolicyAccepted where pol.PolicyID = tblUserPolicyAccepted.PolicyID and tblUser.UserID = tblUserPolicyAccepted.UserID and tblUserPolicyAccepted.DateAccepted >= @dateFrom and tblUserPolicyAccepted.DateAccepted <= @dateTo and tblUserPolicyAccepted.Accepted = 1) )
or
--Condition C - BOTH
@acceptanceStatus=''BOTH''
)
--and (@includeInactiveUsers=''true'' and exists )
ORDER BY policy, unitpathway, lastname, firstname

END
' 
END
GO
