if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[utg_UpdateUnitHierarchy]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[utg_UpdateUnitHierarchy]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[utg_DeleteUnitHierarchy]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[utg_DeleteUnitHierarchy]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblUnitHierarchy]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblUnitHierarchy]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcJobMaintainUnitHierarchies]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcJobMaintainUnitHierarchies]
GO


CREATE TABLE [dbo].[tblUnitHierarchy] (
	[UnitID] [int] NOT NULL ,
	[Hierarchy] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL ,
	[HierarchyName] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblUnitHierarchy] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblUnitHierarchy] PRIMARY KEY  CLUSTERED 
	(
		[UnitID]
	)  ON [PRIMARY] 
GO

CREATE  INDEX [IX_tblUnitHierarchy] ON [dbo].[tblUnitHierarchy]([Hierarchy]) ON [PRIMARY]
GO


CREATE TRIGGER utg_UpdateUnitHierarchy ON tblUnit AFTER INSERT, UPDATE AS
--Update Existing hierarchies
UPDATE 
	tblUnitHierarchy
SET
	Hierarchy = B.Hierarchy,
	HierarchyName = dbo.udfGetUnitPathway(B.UnitID)
FROM 
	tblUnitHierarchy A, tblUnit B
WHERE
	A.UnitID = B.UnitID AND
	B.UnitID IN (Select A.UnitID FROM tblUnit A, INSERTED B WHERE A.Hierarchy LIKE '%' + CAST(B.UnitID AS VARCHAR(10)) + '%')
	
--Insert new hierarchies
INSERT INTO 
	tblUnitHierarchy
SELECT 
	A.UnitID, A.Hierarchy, dbo.udfGetUnitPathway(A.UnitID)
FROM
	INSERTED A
WHERE
	A.UnitID NOT IN (SELECT B.UnitID FROM tblUnitHierarchy B WHERE B.UnitID = A.UnitID)


GO

CREATE TRIGGER utg_DeleteUnitHierarchy ON tblUnit AFTER DELETE AS
DELETE FROM tblUnitHierarchy
WHERE UnitID IN (SELECT UnitID FROM Deleted)

GO

--Dummy to fill tblUnitHierarchy table
UPDATE tblUnit SET Hierarchy = Hierarchy
GO

CREATE PROCEDURE prcJobMaintainUnitHierarchies AS

if (select count(*) from sysobjects where [name] = 'tblUnitHierarchy') = 0
BEGIN

CREATE TABLE [dbo].[tblUnitHierarchy] (
	[UnitID] [int] NOT NULL ,
	[Hierarchy] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL ,
	[HierarchyName] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]


CREATE  INDEX [IX_tblUnitHierarchy] ON [dbo].[tblUnitHierarchy]([Hierarchy]) ON [PRIMARY]
END


if (select count(*) from sysobjects where [name] = 'utg_UpdateUnitHierarchy') = 0
BEGIN

	EXEC('CREATE TRIGGER utg_UpdateUnitHierarchy ON tblUnit AFTER INSERT, UPDATE AS ' +
	--Update Existing hierarchies
	'UPDATE ' +
		'tblUnitHierarchy ' +
	'SET ' +
		'Hierarchy = B.Hierarchy, ' +
		'HierarchyName = dbo.udfGetUnitPathway(B.UnitID) ' + 
	'FROM ' +
		'tblUnitHierarchy A, tblUnit B ' +
	'WHERE ' +
		'A.UnitID = B.UnitID AND ' +
		'B.UnitID IN (Select A.UnitID FROM tblUnit A, INSERTED B WHERE A.Hierarchy LIKE ''%'' + CAST(B.UnitID AS VARCHAR(10)) + ''%'') ' +
	'INSERT INTO ' +
		'tblUnitHierarchy ' +
	'SELECT ' +
		'A.UnitID, A.Hierarchy, dbo.udfGetUnitPathway(A.UnitID) ' +
	'FROM ' +
		'INSERTED A ' +
	'WHERE ' +
		'A.UnitID NOT IN (SELECT B.UnitID FROM tblUnitHierarchy B WHERE B.UnitID = A.UnitID)')
END



if (select count(*) from sysobjects where [name] = 'utg_DeleteUnitHierarchy') = 0
BEGIN

EXEC('CREATE TRIGGER utg_DeleteUnitHierarchy ON tblUnit AFTER DELETE AS ' +
'DELETE FROM tblUnitHierarchy ' +
'WHERE UnitID IN (SELECT UnitID FROM Deleted) ')

END

--Dummy to fill tblUnitHierarchy table
UPDATE tblUnit SET Hierarchy = Hierarchy
GO



---Job added as part of SALT 3.5 optimisation project.
---This job maintains Unit Hierarchy List in tblUnitHierarchy
-- Parameters
-- {0} Databasename
-- {1} WEB SQL Login
BEGIN TRANSACTION            
  DECLARE @JobID BINARY(16)  
  DECLARE @ReturnCode INT    
  SELECT @ReturnCode = 0     
IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'Database Maintenance') < 1 
  EXECUTE msdb.dbo.sp_add_category @name = N'Database Maintenance'

  -- Delete the job with the same name (if it exists)
  SELECT @JobID = job_id     
  FROM   msdb.dbo.sysjobs    
  WHERE (name = N'{0}_JobMaintainUnitHierarchies')       
  IF (@JobID IS NOT NULL)    
  BEGIN  
  -- Check if the job is a multi-server job  
  IF (EXISTS (SELECT  * 
              FROM    msdb.dbo.sysjobservers 
              WHERE   (job_id = @JobID) AND (server_id <> 0))) 
  BEGIN 
    -- There is, so abort the script 
    RAISERROR (N'Unable to import job ''{0}_JobMaintainUnitHierarchies'' since there is already a multi-server job with this name.', 16, 1) 
    GOTO QuitWithRollback  
  END 
  ELSE 
    -- Delete the [local] job 
    EXECUTE msdb.dbo.sp_delete_job @job_name = N'{0}_JobMaintainUnitHierarchies' 
    SELECT @JobID = NULL
  END 

 

  -- Add the job
  --EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'{0}_JobMaintainUnitHierarchies', @owner_login_name = N'{1}', @description = N'No description available.', @category_name = N'Database Maintenance', @enabled = 1, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 2, @delete_level= 0
  --IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- Add the job steps
  --EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'STEP1', @command = N'prcJobMaintainUnitHierarchies', @database_name = N'{0}', @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 0, @retry_attempts = 0, @retry_interval = 1, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2
  --IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
  --EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 

  --IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- Add the job schedules
  --EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'SCHEDULE1', @enabled = 1, @freq_type = 4, @active_start_date = 20060629, @active_start_time = 40000, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 0, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959
  --IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- Add the Target Servers
  --EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)' 
  --IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 


COMMIT TRANSACTION 
GOTO   NextSave              
QuitWithRollback:
  IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 


NextSave:  
BEGIN TRANSACTION            
  SELECT @ReturnCode = 0     
IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'Web Assistant') < 1 
  EXECUTE msdb.dbo.sp_add_category @name = N'Web Assistant'

  -- Delete the job with the same name (if it exists)
  SELECT @JobID = job_id     
  FROM   msdb.dbo.sysjobs    
  WHERE (name = N'{0}_ModuleStatusUpdate')       
  IF (@JobID IS NOT NULL)    
  BEGIN  
  -- Check if the job is a multi-server job  
  IF (EXISTS (SELECT  * 
              FROM    msdb.dbo.sysjobservers 
              WHERE   (job_id = @JobID) AND (server_id <> 0))) 
  BEGIN 
    -- There is, so abort the script 
    RAISERROR (N'Unable to import job ''{0}_ModuleStatusUpdate'' since there is already a multi-server job with this name.', 16, 1) 
    GOTO QuitWithRollback2  
  END 
  ELSE 
    -- Delete the [local] job 
    EXECUTE msdb.dbo.sp_delete_job @job_name = N'{0}_ModuleStatusUpdate' 
    SELECT @JobID = NULL
  END 


COMMIT TRANSACTION          
         
GOTO   EndSave              
QuitWithRollback2:
  IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 
EndSave: 
GO


