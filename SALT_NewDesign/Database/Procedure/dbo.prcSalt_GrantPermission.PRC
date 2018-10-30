SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcSalt_GrantPermission]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
Summary:
Grant all required permission to the website user
User don''t need to be an dbowner
Required Permission
1. Execute permission to all procedures
2. Select permission to all tables and views that are used in dynamic query
That permission is not required, all dynamic query need to be reviewed before set this permission

Parameters:
Returns:

Called By:
Calls:

Remarks:

Author: Jack Liu
Date Created: 25th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1


prcSalt_GrantPermission ''Salt_user''


select * from sysobjects
where xtype=''p''
order by name

prcSalt_GrantPermission
*/


CREATE   procedure [prcSalt_GrantPermission]
(
@login sysname
)
as
declare @userName sysname

declare @name varchar(100), @sql varchar(1000)

set nocount on

--1. Check whether the login has been granted access permission to this database
--If not, grant access permission
select @userName = u.name
from sysusers u
inner join master.dbo.syslogins  l
on u.sid = l.sid
where u.uid < 16382
and l.name=@login

if @userName is null
begin
-- If the db user name is used by other login, drop it
If exists(select 1 from sysusers where name=@login)
begin
EXEC sp_revokedbaccess @login
end

EXEC sp_grantdbaccess @login, @userName output
end


--2. Grant minimum permission
DECLARE Proc_Cursor CURSOR FOR
select name from sysobjects where xtype=''p'' and Category=0
OPEN Proc_Cursor
FETCH NEXT FROM Proc_Cursor
into @name
WHILE @@FETCH_STATUS = 0
BEGIN
set @sql=''GRANT execute ON [''+ @name + ''] TO ''+  @userName
exec(@sql)
FETCH NEXT FROM Proc_Cursor
into @name
END
CLOSE Proc_Cursor
DEALLOCATE Proc_Cursor

EXEC sp_droprolemember ''db_owner'', @userName




' 
END
GO
