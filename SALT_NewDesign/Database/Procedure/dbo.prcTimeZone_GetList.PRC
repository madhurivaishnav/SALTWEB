SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZone_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [prcTimeZone_GetList]

As

SELECT TimeZoneID
,WrittenName
,OffsetUTC
,FLB_Name
FROM tblTimeZone
' 
END
GO
