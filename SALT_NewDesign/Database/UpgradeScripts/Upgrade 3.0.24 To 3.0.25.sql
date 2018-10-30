-- Deleting triggers (if they exist) no longer in use (replaced by stored procs) as part of deadlocking issue --
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgQuizSessionCompleted]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgQuizSessionCompleted]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgUserQuizStatus]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgUserQuizStatus]
GO

