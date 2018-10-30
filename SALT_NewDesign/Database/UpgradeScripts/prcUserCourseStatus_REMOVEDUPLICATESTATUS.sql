

Alter procedure prcUserCourseStatus_REMOVEDUPLICATESTATUS
AS
-- prcUserCourseStatus_REMOVEDUPLICATESTATUS
--Remove duplicated unassigned status records due to a bug inside the tblUserQuizStatus trigger

select UserID, courseID,min(UserCourseStatusID) as minID, max(UserCourseStatusID) as maxID
into #Duplicated
from tblUserCourseStatus
where  CourseStatusID=0
group by UserID, courseID
having min(UserCourseStatusID)<>max(UserCourseStatusID)
order by UserID, courseID


--Don't delete the following records if there are any other status between unassigned status
select d.*
into #DuplicatedError
from #Duplicated d
	inner join tblUserCourseStatus s on s.UserID=d.UserID and s.CourseID=d.CourseID and s.UserCourseStatusID>=d.minID and s.UserCourseStatusID<=d.MaxID
where s.CourseStatusID<>0

delete #Duplicated
from #Duplicated d
	inner join tblUserCourseStatus s on s.UserID=d.UserID and s.CourseID=d.CourseID and s.UserCourseStatusID>=d.minID and s.UserCourseStatusID<=d.MaxID
where s.CourseStatusID<>0


--Removed duplicated records, leave the first record 
delete tblUserCourseStatus
from tblUserCourseStatus s
	inner join #Duplicated d on s.UserID=d.UserID and s.CourseID=d.CourseID and s.UserCourseStatusID>d.minID and s.UserCourseStatusID<=d.MaxID
where s.CourseStatusID=0

select cast(@@rowCount as varchar) + ' duplicated status have been removed'

if (select count(*) from #DuplicatedError)>0
begin
	select 'The following user course status need to be manually removed'
	select * from #DuplicatedError
end

drop table #Duplicated
drop table #DuplicatedError


