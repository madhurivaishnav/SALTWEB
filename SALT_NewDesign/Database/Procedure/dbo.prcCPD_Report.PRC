SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcCPD_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[prcCPD_Report]
(
@profileid int = -1,
@profileperiodid int = -1,
@firstname varchar(200)='''',
@lastname varchar(200) ='''',
@username varchar(200)='''',
@shortfallusers smallint=0,
@UnitIDs varchar(max)='''',
@OrgID int
)
as begin


(select
hierarchyname as pathway
, u.lastname as lastname
, u.firstname as firstname
,u.username as username
,u.email as useremail
,c.name as coursee
,m.name collate database_default as module
,coalesce(upt.points,0) as points
,pf.profileid
,dbo.udfUTCtoDaylightSavingTime(upt.DateAssigned, @OrgID) as dateassigned
,m.sequence as modID
from tblProfile pf
join tblprofileperiod pp on pp.profileid = pf.profileid
join tbluserprofileperiodaccess upa on upa.profileperiodid = pp.profileperiodid
and granted = 1
join tbluser  u on u.userid = upa.userid
join tblunithierarchy uh on uh.unitid = u.unitid and u.unitid in (select IntValue from dbo.udfCsvToInt(@unitIDs))
left join tblProfilePoints ppt on ppt.profileperiodid =pp.profileperiodid
left join tblusercpdpoints upt on upt.userid = u.userid	 and upt.profilepointsid = ppt.profilepointsid
left join tblmodule m on m.moduleid = ppt.typeid and profilepointstype =''M''
left join tblcourse c on c.CourseID =  m.courseid
join vwusermoduleaccess uma on u.userid = uma.userid and m.moduleid = uma.moduleid
where
((@profileid= -1) or (pf.profileid = @profileid)) and
((@profileperiodid=-1) or (pp.profileperiodid  = @profileperiodid))and
((@firstname ='''') or (u.firstname=@firstname) ) and
((@lastname ='''') or (u.lastname =@lastname)) and
((@username ='''') or (u.username =@username)) and
((@shortfallusers =0)
or (
(select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid)<pp.points)
or (select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid) is null)
)

union

(select
hierarchyname as pathway
, u.lastname as lastname
, u.firstname as firstname
,u.username as username
,u.email as useremail
,case when policyname is null then '''' else ''Policy'' end as coursee
,coalesce(policyname,'''') collate database_default as module
,coalesce(upt.points,0) as points
,pf.profileid
,dbo.udfUTCtoDaylightSavingTime(upt.DateAssigned, @OrgID) as dateassigned
,null as modID
from tblProfile pf
join tblprofileperiod pp on pp.profileid = pf.profileid
join tbluserprofileperiodaccess upa on upa.profileperiodid = pp.profileperiodid
and granted = 1
join tbluser  u on u.userid = upa.userid
join tblunithierarchy uh on uh.unitid = u.unitid and u.unitid in (select IntValue from dbo.udfCsvToInt(@unitIDs))
left join tblProfilePoints ppt on ppt.profileperiodid =pp.profileperiodid
left join tblusercpdpoints upt on upt.userid = u.userid	 and upt.profilepointsid = ppt.profilepointsid
left join tblpolicy on tblPolicy.policyid = ppt.typeid and profilepointstype =''P''
join tblUserPolicyAccess upola on upola.userid = u.userid and upola.policyid = ppt.typeid and upola.granted = 1
where
(@profileid= -1 or pf.profileid = @profileid) and
(@profileperiodid=-1 or pp.profileperiodid  = @profileperiodid)and
(@firstname ='''' or u.firstname=@firstname ) and
(@lastname ='''' or u.lastname =@lastname) and
(@username ='''' or u.username =@username) and
(@shortfallusers =0
or (
(select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid)<pp.points)
or (select sum(u2.points) from tblusercpdpoints u2 where u2.userid = u.userid) is null)
)
Order by
coursee,
modID


end

SET QUOTED_IDENTIFIER OFF
' 
END
GO


