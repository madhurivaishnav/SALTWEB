SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPDModuleHistory_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [prcCPDModuleHistory_Report]
(
@ProfileID  varchar(20),
@ModuleID	varchar(20),
@UserID		varchar(20),
@OrgID		int
)
as

select
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(pp.DateStart, @OrgID),113) + '' - '' + convert( varchar(11),dbo.udfUTCtoDaylightSavingTime(pp.DateEnd, @OrgID),113) as PeriodDesc,
sum(upt.Points) as Points
from
tblProfilePeriod pp
join tblProfilePoints pt
on pt.profileperiodid =pp.profileperiodid
join tbluserCPDPoints upt
on upt.profilepointsID = pt.profilepointsid
where
pt.profilepointstype =''M''
and pt.typeid = @ModuleID
and pp.profileid =@ProfileID
and upt.userid =@UserID
--and GETUTCDATE() between pp.DateStart and pp.dateend
group by
convert(varchar (11),dbo.udfUTCtoDaylightSavingTime(pp.DateStart, @OrgID),113) + '' - '' + convert( varchar(11),dbo.udfUTCtoDaylightSavingTime(pp.DateEnd, @OrgID),113)


SET QUOTED_IDENTIFIER ON
' 
END
GO
