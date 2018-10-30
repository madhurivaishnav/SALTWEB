SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcAppConfig_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Updates configuration details.

Parameters:


Returns:
None

Called By:
AppConfig.cs

Calls:
None

Remarks:
Exception:
0. Succeed
1. RecordNotFoundException
4. UniqueViolationException
5. MissingParameterException
10. BusinessServiceException (General)

Author: Jack Liu
Date Created: 24th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1
*/

CREATE  Procedure [prcAppConfig_Update]
(
@name nVarchar(50),
@value nvarchar(4000)
)

As
if (not exists(select name
from tblAppConfig
where name=@name))
begin
Select
1 As ''ErrorNumber'',
''Record not found'' As ''ErrorMessage''
end
else
begin
Update tblAppConfig
set value =@value
where name=@name

select	0 As ''ErrorNumber'',
'''' As ''ErrorMessage''

end




' 
END
GO
