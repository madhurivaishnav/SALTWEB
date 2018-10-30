SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcDatabaseMail_Setup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [prcDatabaseMail_Setup]

As

Set NoCount On

EXECUTE master.dbo.sp_configure ''show advanced options'', 1

reconfigure with override

EXECUTE  master.dbo.sp_configure ''Database Mail XPs'', 1

reconfigure

EXECUTE  master.dbo.sp_configure ''show advanced options'', 0

EXEC prcDatabaseMail_SetupProfile
' 
END
GO
