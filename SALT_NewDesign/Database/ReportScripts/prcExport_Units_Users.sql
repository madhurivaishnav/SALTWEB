if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcExport_Units_Users]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcExport_Units_Users]
GO

Create procedure prcExport_Units_Users
as

	Select 
	-- Normal Organisations
		1 			as 'tag',
		null			as 'parent',
		null			as 'OrganisationalStructure',
		org_id 			as 'Organisation!1!OrganisationID!hide',
		org_name 		as 'Organisation!1!Name',
		null 			as 'Unit!2!DivisionID!hide',
		null 			as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		null			as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		null			as 'User!5!UserName'
		
	from
		org 
UNION ALL
	-- Normal Divisions
	Select 
		2 			as 'tag',
		1			as 'parent',
		null			as 'OrganisationalStructure',
		div_org_id 		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		div_id			as 'Unit!2!DivisionID!hide',
		div_name		as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		null			as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		null			as 'User!5!UserName'
		

	from
		division 

UNION ALL
	-- Normal SubDivisions
	Select 
		3 			as 'tag',
		2			as 'parent',
		null			as 'OrganisationalStructure',
		division.div_org_id	as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		subdiv_div_id		as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		subdiv_id 		as 'Unit!3!SubDivisionID!hide',
		subdiv_name 		as 'Unit!3!Name',
		null			as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		null			as 'User!5!UserName'
		

	from
		subdivision 
	inner join
		division
	on 	
		subdivision.subdiv_div_id = division.div_id


UNION ALL
	-- Normal Units
	Select 
		4 			as 'tag',
		3			as 'parent',
		null			as 'OrganisationalStructure',
		org.org_id		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		division.div_id		as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		unit_subdiv_id 		as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		unitid			as 'Unit!4!ID!hide',
		unitname		as 'Unit!4!Name',
		null			as 'User!5!UserName'
		

	from
		unit
	inner join
		subdivision on unit.unit_subdiv_id = subdivision.subdiv_id
	inner join 
		division on subdivision.subdiv_div_id = division.div_id
	inner join
		org on division.div_org_id = org.org_id



/***********************************************************************************************
	SCREWEY ORG STRUCTURE
***********************************************************************************************/
UNION ALL
	-- Screwey SubDivisions that belong directly to organisations not divisions
	-- TYPE 1
	Select 
		2 			as 'tag',
		1			as 'parent',
		null			as 'OrganisationalStructure',
		subdiv_org_id		as 'Unit!1!OrganisationID!hide', 
		null 			as 'Unit!1!Name',
		subdiv_id		as 'Unit!2!DivisionID!hide',
		subdiv_name		as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		null			as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		null			as 'User!5!UserName'
		

	from
		subdivision 
	inner join
		org
	on 	
		subdivision.subdiv_org_id = org.org_id


UNION ALL
	-- Screwed up units - TYPE 2.
	-- These Units belong directly to Divisions instead of SubDivisions.
	Select 
		4 			as 'tag',
		2			as 'parent',
		null			as 'OrganisationalStructure',
		org.org_id		as 'Unit!1!OrganisationID!hide',
		null 			as 'Unit!1!Name',
		division.div_id		as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		unitid			as 'Unit!4!ID!hide',
		unitname		as 'Unit!4!Name',
		null			as 'User!5!UserName'
		

	from
		unit
	inner join 
		division on unit.unit_div_id = division.div_id
	inner join
		org on division.div_org_id = org.org_id


UNION ALL
	-- Screwed up units - TYPE 3.
	-- These Units belong directly to Organisations instead of SubDivisions.
	Select 
		4 			as 'tag',
		1			as 'parent',
		null			as 'OrganisationalStructure',
		org.org_id		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		null			as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		unitid			as 'Unit!4!ID!hide',
		unitname		as 'Unit!4!Name',
		null			as 'User!5!UserName'
		

	from
		unit
	inner join
		org on unit.unit_org_id = org.org_id


UNION ALL
	-- Screwed up units - TYPE 4.
	-- These Units belong directly to SubDivisions that belong to Organisations instead of Divisions.
	Select 
		4 			as 'tag',
		1			as 'parent',
		null			as 'OrganisationalStructure',
		org.org_id		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		null			as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		unitid			as 'Unit!4!ID!hide',
		unitname		as 'Unit!4!Name',
		null			as 'User!5!UserName'
		

	from
		unit
	inner join
		subdivision on unit.unit_subdiv_id = subdivision.subdiv_id
	inner join
		org on subdivision.subdiv_org_id = org.org_id

/***********************************************************************************************
	USERS
***********************************************************************************************/

UNION ALL
	-- User in normal Units
	Select 
		5 			as 'tag',
		4			as 'parent',
		null			as 'OrganisationalStructure',
		org.org_id		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		division.div_id		as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		unit_subdiv_id 		as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		[user].[UnitID]		as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		[User].[FirstName] 
		+ ' ' + 
		[User].[LastName] 	as 'User!5!UserName'

	from
		[user]
	inner join
		unit on [user].UnitID = unit.unitid
	inner join
		subdivision on unit.unit_subdiv_id = subdivision.subdiv_id
	inner join 
		division on subdivision.subdiv_div_id = division.div_id
	inner join
		org on division.div_org_id = org.org_id


/***********************************************************************************************
	USERS in SCREWEY structures
***********************************************************************************************/
UNION ALL
	-- Users in Screwed up units - TYPE 2.
	-- These Units belong directly to Divisions instead of SubDivisions.
	Select 
		5 			as 'tag',
		4			as 'parent',
		null			as 'OrganisationalStructure',
		org.org_id		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		division.div_id		as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		[unit].unitid		as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		[User].[FirstName] 
		+ ' ' + 
		[User].[LastName] 	as 'User!5!UserName'
		

	from
		[user]
	inner join
		unit on [user].UnitID = unit.unitid
	inner join 
		division on unit.unit_div_id = division.div_id
	inner join
		org on division.div_org_id = org.org_id

UNION ALL
	-- Users in Screwed up units - TYPE 3.
	-- These Units belong directly to Organisations instead of SubDivisions.
	Select 
		5 			as 'tag',
		4			as 'parent',
		org.org_id		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		null			as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		[unit].unitid		as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		[User].[FirstName] 
		+ ' ' + 
		[User].[LastName] 	as 'User!5!UserName'
		

	from
		[user]
	inner join
		unit on [user].UnitID = unit.unitid
	inner join
		org on unit.unit_org_id = org.org_id


UNION ALL

	-- Users in Screwed up units - TYPE 4.
	-- These Units belong directly to SubDivisions that belong to Organisations instead of Divisions.
	Select 
		5 			as 'tag',
		4			as 'parent',
		org.org_id		as 'Organisation!1!OrganisationID!hide',
		null 			as 'Organisation!1!Name',
		null			as 'Unit!2!DivisionID!hide',
		null			as 'Unit!2!Name',
		null 			as 'Unit!3!SubDivisionID!hide',
		null 			as 'Unit!3!Name',
		[unit].unitid		as 'Unit!4!ID!hide',
		null			as 'Unit!4!Name',
		[User].[FirstName] 
		+ ' ' + 
		[User].[LastName] 	as 'User!5!UserName'
		

	from
		[user]
	inner join
		unit on [user].UnitID = unit.unitid
	inner join
		subdivision on unit.unit_subdiv_id = subdivision.subdiv_id
	inner join
		org on subdivision.subdiv_org_id = org.org_id

order by 
	'Organisation!1!OrganisationID!hide',
	'Unit!2!DivisionID!hide',
	'Unit!3!SubDivisionID!hide',
	'Unit!4!ID!hide',
	'User!5!UserName'

for xml EXPLICIT
