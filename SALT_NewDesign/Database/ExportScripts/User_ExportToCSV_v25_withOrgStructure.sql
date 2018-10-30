 
	-- Remember to update the ORG ID harded coded below

	SELECT 
		[Org].org_id,
		[Org].org_name,
		[Division].div_id,
		[Division].div_name,
		[SubDivision].subdiv_id,
		[SubDivision].subdiv_name,
		[Unit].unitid,
		[Unit].unitname,
		CASE PermissionStatus
			WHEN -1 THEN 'Salt Administrator'
			WHEN 0 THEN 'Org Administrator'
			WHEN 1 THEN 'Unit Administrator'
			WHEN 2 THEN 'Normal User'
			ELSE 'UNKNOWN!'
		END AS UserType,
		-- Begin export file
		-- UserName, Password, First Name, Last Name, Email, External ID, Classification Name, Classification Value 

		[UserName], 
		'welcome*' as 'password', 
		[FirstName], 
		[LastName], 
		[UserEmail], 
		[UserID]			as 'UserID',
		'State' 			as 'ClassificationType',
		[States].state_name		as 'ClassificationValue'
	
	FROM 
		[User]
	
	inner join unit on [unit].unitid = [User].[UnitID] 
	left join subdivision on unit.unit_subdiv_id = SubDivision.subdiv_id
	left join division on unit.unit_div_id = division.div_id

	inner join org on 
		unit.unit_org_id = org.org_id
		or	
		subdivision.subdiv_org_id= org.org_id
		or
		division.div_org_id = org.org_id

	left join states on states.state_id = [User].UserState
	and
		(
		[User].Status = 0 -- Active
		or
		[User].Status = 1 -- Locked
		)
	where
		(
		unit.unit_org_id != 1
		or	
		subdivision.subdiv_org_id != 1
		or
		division.div_org_id != 1
		)
	ORDER BY 
		-- Org
		[Unit].unit_org_id,
		[subdivision].subdiv_org_id,
		[division].div_org_id, 
		
		-- Div
		[Unit].unit_div_id,
		[subdivision].subdiv_div_id,
		[division].div_id,
	
		-- Sub DIv
		[Unit].unit_subdiv_id,
		[subdivision].subdiv_id,

		[Unit].UnitID,	
		[User].UserName

	