create procedure prcUser_ExportToCSV_V25
	@OrganisationID int
as

declare @UnitID int
declare @UnitName varchar(200)

/******
Declare Loop
*******/
DECLARE cursor_Units CURSOR
FOR

	-- normal units
	select [UnitID], [UnitName] from unit where unit_subdiv_id in 
	(
		select subdiv_id from subdivision where subdiv_div_id in 
		(
			select div_id from division where div_org_id = @OrganisationID
		)
	)	
	union
	-- screwy sub division
	select [UnitID], [UnitName] from unit where unit_subdiv_id in 
	(
		select subdiv_id from subdivision where subdiv_org_id =@OrganisationID
		
	)	
	union
	-- screwey unit type 1
	select [UnitID], [UnitName] from unit where unit_div_id in 
	(
		select div_id from division where div_org_id = @OrganisationID
	)
	union
	-- screwey init type 2
	select [UnitID], [UnitName] from unit where unit_org_id =@OrganisationID
	

Open cursor_Units

FETCH NEXT FROM cursor_Units Into @UnitID,@UnitName

/******
Begin Loop
*******/
WHILE @@FETCH_STATUS = 0
BEGIN
	/******
	Perform Export Query
	*******/
	Print @UnitName + ' [' + cast(@UnitID as varchar(3)) + ']'
	Print '-----------------------------------'
	SELECT 
		@UnitName,
		[UserName], 
		'welcome*', 
		[FirstName], 
		[LastName], 
		[UserEmail], 
		[UserID],
		@UnitName as 'UnitID',
		'State' as 'Classification',
		[UserState]
	FROM 
		[User]
	WHERE 
		[User].UnitID = @UnitID
	and
		(
		[User].Status = 0 
		or
		[User].Status = 1
		)
	ORDER BY 
		UserName

FETCH NEXT FROM cursor_Units Into @UnitID,@UnitName
END 
/******
Finalise
*******/
CLOSE cursor_Units
DEALLOCATE cursor_Units
