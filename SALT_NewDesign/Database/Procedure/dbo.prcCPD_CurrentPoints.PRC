SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPD_CurrentPoints]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcCPD_CurrentPoints]
(
@ProfileID  varchar(20),
@ModuleID	varchar(20),
@UserID		varchar(20)
)
as

select
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
and getutcdate() between pp.DateStart and dateadd(d,1,pp.dateend)
group by
convert(varchar (11),pp.DateStart,113) + '' - '' + convert( varchar(11),pp.DateEnd,113)

SET QUOTED_IDENTIFIER ON
' 
END
GO
