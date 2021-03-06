SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcDeadLock_PartA]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcDeadLock_PartA]
GO






CREATE      PROCEDURE [dbo].[prcDeadLock_PartA]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @err int; 

    -- Insert statements for procedure here
	Begin Transaction tranA
	--set deadlock_priority LOW

	Print 'Process A is Updating Table A...'
	Update tblDeadLockPartA Set Text = 'Updated by Process A'
	Print 'Process A Updated Table A.'
	
	Print 'Process A is waiting...'
	WAITFOR DELAY '00:00:10';
	Print 'Process A waited.'
		
	Print 'Process A is Updating Table B...'
	--Test Locking with PartB
	Update tblDeadLockPartB Set Text = 'Updated by Process A'
--Test locking with prcQuizSession_EndQuiz:
--	update tblQuizSession Set QuizPassMark=81

	Print 'Process A Updated Table B.'
	Print 'Process A is committing...'
	--Select for queries with output
	select * from tblDeadLockPartA for xml auto
	declare @intError int
	set @intError = @@Error
	if (@intError =0)
		Begin
			Commit 
			Print 'Process A is Commited.'
		End
	Else
		Begin
			Rollback
			Print 'Process A is Rolled Back.'
		End
	
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

