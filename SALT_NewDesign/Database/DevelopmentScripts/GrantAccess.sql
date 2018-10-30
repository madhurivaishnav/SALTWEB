declare @userName sysname
declare @login varchar(100)
Set @login = 'salt_user'
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
select name from sysobjects where xtype='p' and Category=0
OPEN Proc_Cursor
FETCH NEXT FROM Proc_Cursor
into @name
WHILE @@FETCH_STATUS = 0
BEGIN
	set @sql='GRANT execute ON '+ @name + ' TO '+  @userName
	exec(@sql)
	FETCH NEXT FROM Proc_Cursor
	into @name
END
CLOSE Proc_Cursor
DEALLOCATE Proc_Cursor

EXEC sp_droprolemember 'db_owner', @userName
