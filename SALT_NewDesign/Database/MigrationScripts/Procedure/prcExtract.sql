
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcExtract]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcExtract]
GO

Create Procedure prcExtract
	@OldOrganisationID int
as
 
truncate table [tblExtract]
 
INSERT INTO 
		[tblExtract]
		([OldUserID], [OldModuleID], [QuizMark], [QuizDate], [LessonComplete])
	
	SELECT 

		[salt_old].[dbo].uvw_userCompliance.UserID		as 'UserID', 
		[salt_old].[dbo].uvw_userCompliance.ModuleID	as 'ModuleID', 
		testreport_score								as 'QuizMark', 		
		testreport_date									as 'QuizDate', 
		CASE 
		      WHEN trainreport_state IS NULL THEN 0 	-- Incomplete
		      WHEN trainreport_state = 2 then 	1 	-- Complete
		      ELSE 'ERROR'				
		END 					as 'LessonComplete'
	
	FROM 
		[salt_old].[dbo].uvw_userCompliance 
	INNER JOIN 
		[salt_old].[dbo].application 
	ON 
		[salt_old].[dbo].uvw_userCompliance.applicationid = [salt_old].[dbo].application.applicationid 
	INNER JOIN 
		[salt_old].[dbo].[user]
	ON
		[salt_old].[dbo].[user].userID = [salt_old].[dbo].uvw_userCompliance.UserID
	LEFT OUTER JOIN 
		[salt_old].[dbo].trainreport 
	ON 
		[salt_old].[dbo].uvw_userCompliance.userid = trainreport_user_id 
		AND 	
		[salt_old].[dbo].uvw_userCompliance.moduleid = trainreport_module_id 
		AND 	
		trainreport_id = 
			(
			SELECT 
				max(trainreport_id) 
			FROM 
				[salt_old].[dbo].trainreport 
			WHERE 
				trainreport_user_id = [salt_old].[dbo].uvw_userCompliance.userid 
			AND 
				trainreport_module_id = [salt_old].[dbo].uvw_userCompliance.moduleid 
			AND 
				trainreport_state IN (2)
			) 
	LEFT OUTER JOIN 
		[salt_old].[dbo].testreport 
	ON 
		[salt_old].[dbo].uvw_userCompliance.userid = testreport_user_id 
	AND 	
		[salt_old].[dbo].uvw_userCompliance.moduleid = testreport_module_id 
	AND 	
		testreport_id = 
			(
			SELECT 
				max(testreport_id) 
			FROM 
				[salt_old].[dbo].testreport 
			WHERE 
				testreport_user_id = [salt_old].[dbo].uvw_userCompliance.userid 
				AND 
				testreport_module_id = [salt_old].[dbo].uvw_userCompliance.moduleid 
				AND 
				testreport_state IN (2)
			) 
	WHERE 
		(
		[salt_old].[dbo].[User].Status = 0 
		or
		[salt_old].[dbo].[User].Status = 1
		)
		and
	
		[salt_old].[dbo].uvw_userCompliance.status <> 2 
		and
		[salt_old].dbo.uvw_userCompliance.UnitID in
			(
				select [UnitID] from [salt_old].[dbo].unit where unit_subdiv_id in 
				(
					select subdiv_id from [salt_old].[dbo].subdivision where subdiv_div_id in 
					(
						select div_id from [salt_old].[dbo].division where div_org_id = @OldOrganisationID
					)
				)	
				union
				-- screwy sub division
				select [UnitID] from [salt_old].[dbo].unit where unit_subdiv_id in 
				(
					select subdiv_id from [salt_old].[dbo].subdivision where subdiv_org_id =@OldOrganisationID
					
				)	
				union
				-- screwey unit type 1
				select [UnitID] from [salt_old].[dbo].unit where unit_div_id in 
				(
					select div_id from [salt_old].[dbo].division where div_org_id = @OldOrganisationID
				)
				union
				-- screwey init type 2
				select [UnitID] from [salt_old].[dbo].unit where unit_org_id =@OldOrganisationID
			)
	ORDER BY 
		userId,
		trainreport_module_id


 
 
Declare @intCount int
Select @intCount = count(1) from [tblExtract]
Print 'User/module results extracted:'
Print cast(@intCount as varchar(20))
