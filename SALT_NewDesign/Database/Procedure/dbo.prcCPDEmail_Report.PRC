SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPDEmail_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcCPDEmail_Report]
(
@ProfileID  int,
@UnitIDs varchar(MAX)
)
as
select  distinct pf.profileid
, u.userid
, u.lastname
, u.firstname
,hierarchyname = dbo.udfGetUnitPathway(u.UnitID)
,u.email as useremail
from tblProfile pf
join tblprofileperiod pp on pp.profileid = pf.profileid
join tbluserprofileperiodaccess upa on upa.profileperiodid = pp.profileperiodid
and granted = 1
join tbluser  u on u.userid = upa.userid
left join tblusercpdpoints upt on upt.userid = u.userid
where pf.profileid = @ProfileID and
pp.profileperiodactive = 1 and
getutcdate() between pp.datestart and dateadd(d,1,pp.dateend) and
pp.points > coalesce(upt.points,0) and
u.unitid in (select IntValue from dbo.udfCsvToInt(@UnitIDs)) and
u.userid in
(-- users for a course
select distinct uma.userid from
tblProfile p
join tblProfilePeriod pp
on p.profileid = pp.profileid
join tblProfilePoints ppts
on pp.profileperiodid = ppts.profileperiodid
join tblModule m on ppts.typeid = m.moduleid
join vwUserModuleAccess uma on uma.courseid = m.courseid and u.userid=uma.userid
where p.profileid = @profileid
and pp.profileperiodactive = 1
and ppts.profilepointstype = ''M'')
' 
END
GO
