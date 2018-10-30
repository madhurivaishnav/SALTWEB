SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcDatabaseMail_SetupProfile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  Procedure [prcDatabaseMail_SetupProfile]

As

Set NoCount On

-- **** SETUP DATABASE MAIL ****

DECLARE @ProfileName VARCHAR(255)
DECLARE @AccountName VARCHAR(255)
DECLARE @SMTPAddress VARCHAR(255)
DECLARE @EmailAddress VARCHAR(128)
DECLARE @DisplayUser VARCHAR(128)
DECLARE @principal_sid varbinary(85)

SET @ProfileName = ''Salt_MailAccount'';
SET @AccountName = ''Salt_MailAccount'';
SELECT @SMTPAddress = Value FROM tblAppConfig WHERE Name = ''MailServer''
SELECT @EmailAddress = Value FROM tblAppConfig WHERE Name = ''FromEmail''
SELECT @DisplayUser = Value FROM tblAppConfig WHERE Name = ''FromName''

IF @EmailAddress IS NULL
SELECT @EmailAddress = Value FROM tblAppConfig WHERE Name = ''SupportEmail''

IF @DisplayUser IS NULL
SELECT @DisplayUser = Value FROM tblAppConfig WHERE Name = ''SupportEmail''

IF EXISTS (SELECT * FROM msdb.dbo.sysmail_account a WHERE a.name = @AccountName)
EXECUTE msdb.dbo.sysmail_update_account_sp
@account_name = @AccountName
,@email_address = @EmailAddress
,@display_name = @DisplayUser
,@mailserver_name = @SMTPAddress
ELSE
EXECUTE msdb.dbo.sysmail_add_account_sp
@account_name = @AccountName
,@email_address = @EmailAddress
,@display_name = @DisplayUser
,@mailserver_name = @SMTPAddress

IF NOT EXISTS (	SELECT *
FROM msdb.dbo.sysmail_profile p
WHERE p.name = @ProfileName
)
EXECUTE msdb.dbo.sysmail_add_profile_sp
@profile_name = @ProfileName

IF NOT EXISTS (	SELECT *
FROM msdb.dbo.sysmail_profileaccount pa
JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id
JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id
WHERE p.name = @ProfileName AND a.name = @AccountName
)
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
@profile_name = @ProfileName
,@account_name = @AccountName
,@sequence_number = 1

SELECT @principal_sid = msdb.dbo.get_principal_sid(principal_id)
FROM msdb.sys.database_principals dp
WHERE dp.name = N''guest'' AND dp.type in (''U'',''S'',''G'')

IF NOT EXISTS (	SELECT *
FROM msdb.dbo.sysmail_principalprofile pp
JOIN msdb.dbo.sysmail_profile p ON pp.profile_id=p.profile_id
WHERE pp.principal_sid = @principal_sid AND p.name = @ProfileName
)
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
@principal_name=N''guest''
,@profile_name=@ProfileName
,@is_default=0
' 
END
GO
