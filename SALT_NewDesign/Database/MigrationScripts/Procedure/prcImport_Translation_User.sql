SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcImport_Translation_User]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcImport_Translation_User]
GO

Create Procedure prcImport_Translation_User
	@organisationID int
as 
	
	Print ''
	Print '-------------------------------------'
	Print '- Begin importing user translations -'
	Print '-------------------------------------'
	Print ''
	
	
-- remove previous loads.
	truncate table [tblTranslate_User] 
	print 'Removed all user translations.'
	
-- Load Users
	Insert into 
		[tblTranslate_User] 
	select 
		cast ([salt_new].[dbo].[tblUser].[ExternalID] as int)	as 'OldUserID', 
		[salt_new].[dbo].[tblUser].[UserID]						as 'NewUserID' 
	from 
		[salt_new].[dbo].tblUser
	where
		[salt_new].[dbo].tblUser.OrganisationID = @organisationID
		
		
	print 'Imported all user translations.'
	
	
	Print ''
	Print '-----------------------------------'
	Print '- End importing user translations -'
	Print '-----------------------------------'
	Print ''
	
