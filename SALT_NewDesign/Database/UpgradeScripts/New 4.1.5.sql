-- check and only create if sql server 2005 as contains 2005 specific T-SQL
-- sql server 2005 = '9', sql server 2000 = '8'
if ((select left(cast(serverproperty('productversion') as varchar(20)),1)) = '9')

-- **** SETUP DATABASE MAIL ****
exec prcDatabaseMail_Setup
GO
-- /**** SETUP DATABASE MAIL ****
  