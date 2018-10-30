SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcTranslate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcTranslate]
GO

Create procedure prcTranslate
as
	Print ''	
	Print '--------------------------------'
	Print '- Begin Translation            -'
	Print '--------------------------------'
	Print ''
	

	If Exists
		(select OldUserID from tblExtract where OldUserID not in (Select OldUserID from tblTranslate_User))
	Begin
		RaisError('OldUserID not found in Translation table',16,1)
		return
	End

	If Exists
		(select * from tblExtract where OldModuleID not in (Select OldModuleID from tblTranslate_Module))
	Begin
		RaisError('Module not found in Translation table',16,1)
		return
	End

	-- remove all load data from previous attempts.
	Truncate Table [tblLoad]
	
	
	Insert Into [tblLoad]([NewUserID], [NewModuleID], [QuizMark], [QuizDate], [LessonComplete])

	select NewUserID, NewModuleID, QuizMark, QuizDate, LessonComplete from tblExtract
	inner join
		tblTranslate_User on tblTranslate_User.OldUserID = tblExtract.OldUserID
	inner join
		tblTranslate_Module on tblTranslate_Module.OldModuleID = tblExtract.OldModuleID
	Where NewModuleID is not null -- odd why this wasnt working as a join?
	
	Print 'All user data translated from [tblExtract] to [tblLoad]'
	
	
	Print ''
	Print '--------------------------------'
	Print '- End Translation              -'
	Print '--------------------------------'
	Print ''
	