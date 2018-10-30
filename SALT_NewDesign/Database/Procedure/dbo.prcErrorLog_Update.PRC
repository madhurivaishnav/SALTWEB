SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcErrorLog_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
Create Procedure [prcErrorLog_Update]

@ErrorLogID	int,
@ErrorLevel	int,
@ErrorStatus	int,
@Resolution	varchar(1000)
as

UPDATE [tblErrorLog]

SET

[ErrorLevel]=@ErrorLevel,
[ErrorStatus]=@ErrorStatus,
[Resolution]=@Resolution

WHERE
[ErrorLogID] = @ErrorLogID

' 
END
GO
