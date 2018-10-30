IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Salt_Migration')
	DROP DATABASE [Salt_Migration]
GO

CREATE DATABASE [Salt_Migration]  ON (NAME = N'Salt_Migration_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\Salt_Migration_Data.MDF' , SIZE = 1, FILEGROWTH = 10%) LOG ON (NAME = N'Salt_Migration_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL\data\Salt_Migration_Log.LDF' , SIZE = 1, FILEGROWTH = 10%)
 COLLATE Latin1_General_CI_AS
GO

exec sp_dboption N'Salt_Migration', N'autoclose', N'false'
GO

exec sp_dboption N'Salt_Migration', N'bulkcopy', N'false'
GO

exec sp_dboption N'Salt_Migration', N'trunc. log', N'false'
GO

exec sp_dboption N'Salt_Migration', N'torn page detection', N'true'
GO

exec sp_dboption N'Salt_Migration', N'read only', N'false'
GO

exec sp_dboption N'Salt_Migration', N'dbo use', N'false'
GO

exec sp_dboption N'Salt_Migration', N'single', N'false'
GO

exec sp_dboption N'Salt_Migration', N'autoshrink', N'false'
GO

exec sp_dboption N'Salt_Migration', N'ANSI null default', N'false'
GO

exec sp_dboption N'Salt_Migration', N'recursive triggers', N'false'
GO

exec sp_dboption N'Salt_Migration', N'ANSI nulls', N'false'
GO

exec sp_dboption N'Salt_Migration', N'concat null yields null', N'false'
GO

exec sp_dboption N'Salt_Migration', N'cursor close on commit', N'false'
GO

exec sp_dboption N'Salt_Migration', N'default to local cursor', N'false'
GO

exec sp_dboption N'Salt_Migration', N'quoted identifier', N'false'
GO

exec sp_dboption N'Salt_Migration', N'ANSI warnings', N'false'
GO

exec sp_dboption N'Salt_Migration', N'auto create statistics', N'true'
GO

exec sp_dboption N'Salt_Migration', N'auto update statistics', N'true'
GO

if( ( (@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 724) ) or ( (@@microsoftversion / power(2, 24) = 7) and (@@microsoftversion & 0xffff >= 1082) ) )
	exec sp_dboption N'Salt_Migration', N'db chaining', N'false'
GO

use [Salt_Migration]
GO

