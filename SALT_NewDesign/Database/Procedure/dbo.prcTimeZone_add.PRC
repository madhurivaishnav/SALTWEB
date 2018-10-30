SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZone_add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [prcTimeZone_add]
(
@WrittenName nvarchar(60),
@OffsetUTC int,
@FLB_Name nvarchar(60)
)
as
DELETE FROM tblTimeZone
WHERE WrittenName = @WrittenName
DECLARE @TimezoneID int
exec prcTimeZone_GetTimeZoneID @WrittenName, @TimezoneID out
DELETE FROM tblTimeZoneDaylightSavingRules
WHERE TimezoneID = @TimezoneID
INSERT INTO tblTimeZone
(WrittenName
,OffsetUTC
,FLB_Name
,Active)
VALUES
(@WrittenName
,@OffsetUTC
,@FLB_Name
,''true'')
' 
END
GO
