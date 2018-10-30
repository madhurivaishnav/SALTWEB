SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_UpdateDomainName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Updates the domain name for a orgaisation.
The domain name must be unique

This func is only available for Salt Admin

It is used for login

Remarks:
Exception:
0. Succeed
1. RecordNotFoundException
4. UniqueViolationException
5. MissingParameterException
10. BusinessServiceException (General)

Author: Jack Liu
Date Created: 16th of Sept  2005

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcOrganisation_UpdateDomainName]
(
@organisationID int,
@domainName nvarchar(100)
)

As

if exists(select 1
from tblOrganisation
where domainName=@domainName
and organisationID<>@organisationID)
begin
Select
4 As ''ErrorNumber'',
''Domain name is used by another organisation'' As ''ErrorMessage''
return
end
begin
Update tblOrganisation
set domainName =@domainName
where organisationID=@organisationID

select	0 As ''ErrorNumber'',
'''' As ''ErrorMessage''

end


' 
END
GO
