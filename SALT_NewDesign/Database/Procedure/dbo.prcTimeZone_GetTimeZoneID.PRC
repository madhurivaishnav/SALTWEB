SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcTimeZone_GetTimeZoneID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE Procedure [prcTimeZone_GetTimeZoneID]
(
@WrittenName varchar(60),
@TimeZoneID int output
)

As

select @TimeZoneID = coalesce(TimeZoneID,1) from tblTimeZone where upper(WrittenName) = upper(@WrittenName)
select @TimeZoneID

' 
END
GO
