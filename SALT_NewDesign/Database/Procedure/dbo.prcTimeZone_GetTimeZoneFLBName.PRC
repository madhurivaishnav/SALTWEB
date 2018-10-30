SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZone_GetTimeZoneFLBName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [prcTimeZone_GetTimeZoneFLBName]
(
@TimeZoneID int
)

As

select FLB_Name from tblTimeZone where TimeZoneID = @TimeZoneID
' 
END
GO
