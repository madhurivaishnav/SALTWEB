SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcPolicy_GetListByOrganisation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary: Gets a list of all Policies assigned within the Organisation
Parameters: @organisationID  int -- The organisation ID
Returns:

Called By: BusinessServices.Policy.GetPolicyListAccessableToOrg
Calls: None

Remarks: Cut and Paste of course SP

Author: John R
Date Created: 17th of May 2010

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE     Procedure [prcPolicy_GetListByOrganisation]
(
@organisationID  int -- The organisation ID

)

As

-------------------------------------------------------------
-- Return Select
-------------------------------------------------------------
Select
p.[PolicyID]
, p.[PolicyName]
, dbo.udfUTCtoDaylightSavingTime(p.[UploadDate], @organisationID)

From
[tblPolicy] p
WHERE     (p.Active = ''True'') AND (p.Deleted = ''False'')
and p.organisationID = @organisationID
order by p.PolicyName







' 
END
GO
