 -- **** SETUP DATABASE MAIL ****
	master.dbo.sp_configure 'show advanced options', 1
	GO
	reconfigure with override
	GO
	master.dbo.sp_configure 'Database Mail XPs', 1
	GO
	reconfigure 
	GO
	master.dbo.sp_configure 'show advanced options', 0
	GO


	DECLARE @SMTPAddress VARCHAR(255)
	DECLARE @EmailAddress VARCHAR(128)
	DECLARE @DisplayUser VARCHAR(128)



	SELECT @SMTPAddress = Value FROM tblAppConfig WHERE Name = 'MailServer'
	SELECT @EmailAddress = Value FROM tblAppConfig WHERE Name = 'FromEmail'
	SELECT @DisplayUser = Value FROM tblAppConfig WHERE Name = 'FromName'

	if (@EmailAddress IS NULL)
	BEGIN
		SELECT @EmailAddress = Value FROM tblAppConfig WHERE Name = 'SupportEmail'
	END

	if (@DisplayUser IS NULL)
	BEGIN
		SELECT @DisplayUser = Value FROM tblAppConfig WHERE Name = 'SupportEmail'
	END

	DECLARE @ProfileName VARCHAR(255)
	DECLARE @AccountName VARCHAR(255)
	SET @ProfileName = 'Salt_MailAccount';
	SET @AccountName = 'Salt_MailAccount';

	IF EXISTS
	(
	SELECT * FROM msdb.dbo.sysmail_profileaccount pa JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id
	WHERE p.name = @ProfileName AND a.name = @AccountName)
	BEGIN PRINT 'Deleting Profile Account' EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = @ProfileName, @account_name = @AccountName
	END

	IF EXISTS
	(
	SELECT * FROM msdb.dbo.sysmail_profile p 
	WHERE p.name = @ProfileName
	)
	BEGIN PRINT 'Deleting Profile.' EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = @ProfileName
	END

	IF EXISTS
	(
	SELECT * FROM msdb.dbo.sysmail_account a
	WHERE a.name = @AccountName
	)
	BEGIN PRINT 'Deleting Account.' EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = @AccountName
	END
	
	execute msdb.dbo.sp_addrolemember N'db_owner', 'salt_user'
	execute msdb.dbo.sp_addrolemember N'DatabaseMailUserRole', 'salt_user'

	EXECUTE msdb.dbo.sysmail_add_account_sp
	@account_name = @AccountName,
	@email_address = @EmailAddress,@display_name = @DisplayUser,
	@mailserver_name = @SMTPAddress

	EXECUTE msdb.dbo.sysmail_add_profile_sp
	@profile_name = @ProfileName 

	EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
	@profile_name = @ProfileName,
	@account_name = @AccountName,
	@sequence_number = 1 ;
	
	EXEC msdb.dbo.sysmail_add_principalprofile_sp @principal_name=N'guest', @profile_name=@ProfileName, @is_default=0
	go

-- /**** SETUP DATABASE MAIL ****