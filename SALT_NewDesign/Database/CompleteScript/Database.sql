IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'SALT')
	DROP DATABASE [SALT]
GO

CREATE DATABASE [SALT]  ON (NAME = N'SALT_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\SALT_Data.MDF' , SIZE = 6, FILEGROWTH = 10%) LOG ON (NAME = N'SALT_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\SALT_Log.LDF' , SIZE = 23, FILEGROWTH = 10%)
 COLLATE Latin1_General_CI_AS
GO

exec sp_dboption N'SALT', N'autoclose', N'false'
GO

exec sp_dboption N'SALT', N'bulkcopy', N'false'
GO

exec sp_dboption N'SALT', N'trunc. log', N'false'
GO

exec sp_dboption N'SALT', N'torn page detection', N'true'
GO

exec sp_dboption N'SALT', N'read only', N'false'
GO

exec sp_dboption N'SALT', N'dbo use', N'false'
GO

exec sp_dboption N'SALT', N'single', N'false'
GO

exec sp_dboption N'SALT', N'autoshrink', N'false'
GO

exec sp_dboption N'SALT', N'ANSI null default', N'false'
GO

exec sp_dboption N'SALT', N'recursive triggers', N'false'
GO

exec sp_dboption N'SALT', N'ANSI nulls', N'false'
GO

exec sp_dboption N'SALT', N'concat null yields null', N'false'
GO

exec sp_dboption N'SALT', N'cursor close on commit', N'false'
GO

exec sp_dboption N'SALT', N'default to local cursor', N'false'
GO

exec sp_dboption N'SALT', N'quoted identifier', N'false'
GO

exec sp_dboption N'SALT', N'ANSI warnings', N'false'
GO

exec sp_dboption N'SALT', N'auto create statistics', N'true'
GO

exec sp_dboption N'SALT', N'auto update statistics', N'true'
GO

if( ( (@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 724) ) or ( (@@microsoftversion / power(2, 24) = 7) and (@@microsoftversion & 0xffff >= 1082) ) )
	exec sp_dboption N'SALT', N'db chaining', N'false'
GO


if exists (select * from dbo.sysusers where name = N'salt_user')
exec sp_revokedbaccess N'salt_user'
GO

if not exists (select * from dbo.sysusers where name = N'salt_user' and uid < 16382)
	EXEC sp_grantdbaccess N'salt_user', N'salt_user'
GO




