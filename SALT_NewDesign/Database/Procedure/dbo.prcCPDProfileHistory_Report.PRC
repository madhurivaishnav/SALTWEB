SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPDProfileHistory_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcCPDProfileHistory_Report]
(
@ProfileID  varchar(20),
@UserID		varchar(20)
)
as

select
convert(varchar (11),pp.DateStart,113) + '' - '' + convert( varchar(11),pp.DateEnd,113) as PeriodDesc,
sum(upt.Points) as PointsEarned,
pp.points as PointsRequired
from
tblProfilePeriod pp
join tblProfilePoints pt
on pt.profileperiodid =pp.profileperiodid
join tbluserCPDPoints upt
on upt.profilepointsID = pt.profilepointsid
where
pt.profilepointstype =''M''
and pp.profileid =@ProfileID
and upt.userid =@UserID
--and getutcdate() between pp.DateStart and pp.dateend
group by
convert(varchar (11),pp.DateStart,113) + '' - '' + convert( varchar(11),pp.DateEnd,113),pp.points


SET QUOTED_IDENTIFIER ON
' 
END
GO
