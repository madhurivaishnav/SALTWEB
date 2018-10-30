SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcProfilePeriod_RollOver]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [prcProfilePeriod_RollOver]
as begin

-- AC notes:
-- Get all periods that are active and end date has passed then
-- a) if there are instructions to make a future period then populate a new
-- record with the future period (+ instructions with what to do with the period following
-- that

/*
-- b) if there are no instructions to make a future period then populate a new record
-- with no current period or future period instructions (so user can create a period
-- at a later time */
-- c) then make the active period inactive
-- d) following this need to go through all code that references profile periods and add
-- sql to that code to take into account the profileperiodactive field

declare @tmptable table
(
ppid int,
pid int,
newppid int
)

/*	get all the periods that have been,
and have a future period that havnt been created yet*/
/*insert into @tmptable (ppid, pid)
select
p2.profileperiodid, p2.profileid
from
tblprofileperiod p1
right join tblprofileperiod p2 on p1.profileid = p2.profileid
and p1.datestart = p2.futuredatestart and p1.dateend = p2.futuredateend
where
p1.profileperiodid is null
and dateadd(hh,24,p2.dateend) <getutcdate()
and p2.endofperiodaction in (2,3,4)*/

insert into @tmptable (ppid, pid)
select
profileperiodid, profileid
from
tblProfilePeriod
where
profileperiodactive = 1
and dateadd(hh,24,dateend) < getutcdate()
order by profileid



--	add them into the profile period table
insert into tblprofileperiod (profileid,datestart,dateend, points, applytoquiz, applytolesson, endofperiodaction, monthincrement, futuredatestart, futuredateend, futurepoints, profileperiodactive)
select
pid,
futuredatestart,
futuredateend,
futurepoints,
applytoquiz,
applytolesson,
case when endofperiodaction = 4 then 1
else endofperiodaction end
as futureendofperiodaction,
monthincrement,
case when endofperiodaction = 4 then null
else dateadd(day, 1, futuredateend) end
as newfuturedatestart,
case when endofperiodaction = 4 then null
when endofperiodaction = 3 then dateadd(month, monthincrement, futuredateend)
when endofperiodaction = 2 then dateadd(day, 1, dateadd(day, datediff(day, futuredatestart, futuredateend), futuredateend)) end
as newfuturedateend,
futurepoints,
1
from
tblprofileperiod
join @tmptable on ppid = profileperiodid


-- make the active period inactive
update tblprofileperiod
set
profileperiodactive = 0
where
profileperiodid in
(select ppid from @tmptable)


-- remove the ones we dont need to do anything with
delete from @tmptable where ppid not  in
(
select profileperiodid from
tblprofileperiod
join @tmptable on ppid = profileperiodid and endofperiodaction in (2,3,4)
)

-- get the ids for the new profile periods
update @tmptable set newppid = p1.profileperiodid
from
tblprofileperiod p1
--right join tblprofileperiod p2 on p1.profileid = p2.profileid
--and p1.datestart = p2.futuredatestart and p1.dateend = p2.futuredateend
join @tmptable t2 on t2.pid = p1.profileid
and p1.profileperiodactive = 1


--copy across the points from the previous period into the new one
insert into tblprofilepoints
(profileperiodid, profilepointstype,typeid, points,active, dateassigned)
select
newppid,
p1.profilepointstype,
p1.typeid,
p1.points,
p1.active,
getutcdate()
from
tblprofilepoints p1
join @tmptable on ppid = profileperiodid


/* initialise user access to the period
(will give the same users access as previously assigned)*/
insert into tbluserprofileperiodaccess
(profileperiodid, userid, granted)
select
newppid,
pa.userid,
pa.granted
from tbluserprofileperiodaccess pa
join @tmptable on ppid = profileperiodid

/* initialise unit access to the period
(will give the same unit access as previously assigned)*/
insert into tblunitprofileperiodaccess
(profileperiodid, unitid, granted)
select
newppid,
pa.unitid,
pa.granted
from tblunitprofileperiodaccess pa
join @tmptable on ppid = profileperiodid

end
' 
END
GO
