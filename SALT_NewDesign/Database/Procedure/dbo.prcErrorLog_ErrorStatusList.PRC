SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcErrorLog_ErrorStatusList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


Create  Procedure [prcErrorLog_ErrorStatusList]


as

SELECT
[ErrorStatusID],
[ErrorStatusDescription]
FROM
[tblErrorStatus]


' 
END
GO
