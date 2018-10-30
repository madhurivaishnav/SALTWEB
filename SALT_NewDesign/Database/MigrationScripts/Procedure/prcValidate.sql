SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcValidate]
GO

Create Procedure prcValidate

as

	Print ''
	Print '--------------------------------'
	Print '- Begin Validation             -'
	Print '--------------------------------'
	Print ''
	
-- Error #101
	If exists 
		(
			Select 'Error #101' from tblTranslate_Module 
			Where 
				[OldModuleID] is null 
			and 
				[NewModuleID] is null 
		)
	Begin
		RaisError('Error #101',16,1)
		Return
	End
	
-- Error #110 
If exists 
		(
			Select ModuleID from [salt_old].[dbo].module where ModuleID not in (select OldModuleID from tblTranslate_Module)
		)
	Begin
		RaisError('Error #110',16,1)
		Return
	End
	
-- Error #111
If exists 
		(
			Select ModuleID from [salt_new].[dbo].[tblModule] where ModuleID not in (select NewModuleID from tblTranslate_Module)
		)
	Begin
		RaisError('Error #111',16,1)
		Return
	End
	
-- Error #112
If exists 
		(
			Select [OldModuleID] from tblExtract where OldModuleID not in (select OldModuleID from tblTranslate_Module where oldModuleID is not null)
		)
	Begin
		RaisError('Error #112',16,1)
		Return
	End
	
-- Error #113
If exists 
		(
			select count(1),OldModuleID from tblTranslate_Module where oldModuleID is not null group by OldModuleID having count(1) > 1
		)
	Begin
		RaisError('Error #113',16,1)
		Return
	End

-- Error #114
If exists 
		(
			select count(1),NewModuleID from tblTranslate_Module where newModuleID is not null group by newModuleID having count(1) > 1
		)
	Begin
		RaisError('Error #114',16,1)
		Return
	End
	
-- Error #201
	If exists 
		(
			Select 'Error #201' from tblTranslate_User where OldUserID not in (Select UserID from salt_old.dbo.[User])
		)
	Begin
		RaisError('Error #201',16,1)
		Return
	End

-- Error #202
	If exists 
		(
			Select 'Error #202' from  tblTranslate_User where OldUserID is null
		)
	Begin
		RaisError('Error #202',16,1)
	End

-- Error #203
	If exists 
		(
			Select 'Error #203' from tblTranslate_User where NewUserID not in (Select UserID from salt_new.dbo.[tblUser])
		)
	Begin
		RaisError('Error #203',16,1)
		Return
	End

-- Error #204
	-- This is redundant.

-- Error #205
	-- This is redundant.

-- Error #206
	If exists 
		(
			Select 'Error #202' from  tblTranslate_User where NewUserID is null
		)
	Begin
		RaisError('Error #202',16,1)
	End
	
-- Error #207
	-- This is redundant.

-- Error #208
	-- This is redundant.

  Print 'All rows in all tables verified'
  
  
	Print ''
	Print '--------------------------------'
	Print '- End Validation               -'
	Print '--------------------------------'
	Print ''
	
