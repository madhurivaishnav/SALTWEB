
create procedure prcUser_ExportToCSV_V35
	@OrganisationID int
as

declare @UnitID int
declare @UnitName varchar(200)

-- select Value from tblClassification where ClassificationTypeID = 5 order by Value

/******
Declare Loop
*******/
DECLARE cursor_Units CURSOR
FOR
	select
	UnitID, [Name]
	from
	tblUnit
	where
	OrganisationID = @OrganisationID
	and
	Active = 1

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
	Print 'Unit Name:' + @UnitName
	Print '-----------------------------------'
	select 
		@UnitName
		,
		[UserName] 
		,
		'welcome*' 
		,
		FirstName 
		,
		LastName 
		,
		Email 
		,
		ExternalID
		,
		tblClassificationType.[Name] 
		,
		tblClassification.[Value]
	
	from 
		tblUser
	
	left join
		tblUserClassification on tblUserClassification.UserID = tblUser.UserID
	left join	
		tblClassification on tblUserClassification.ClassificationID = tblClassification.ClassificationID
	left join
		tblClassificationType on tblClassification.ClassificationTypeID = tblClassificationType.ClassificationTypeID
	where 
		tblUser.UnitID = @UnitID
	and
		tblUser.Active = 1
	order by userName

FETCH NEXT FROM cursor_Units Into @UnitID,@UnitName
END 
/******
Finalise
*******/
CLOSE cursor_Units


DEALLOCATE cursor_Units
