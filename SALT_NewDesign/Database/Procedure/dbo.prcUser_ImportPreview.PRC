SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUser_ImportPreview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  StoredProcedure [dbo].[prcUser_ImportPreview]    Script Date: 07/15/2008 12:42:55 ******/

/*
Summary: Uploads the details from an XML document to the tblUser table
Parameters:
@userXML text The XML document containing the User data.
@ID Integer ID of either the Organisation or Unit
@hierachy VarChar(12) hierachy where the call to upload useres was made from. can only be Organisation or Unit.
@userID Integer = null -- ID of user inporting the xmlData
Returns:
two Result sets

One: The first result set has the totals for the Upload
Total of Records in the XML File
Total of Successfully Inserted Records
Total of Already Existing Records
Total of  Records with error details

Two: The second result set holds the detail of the records that failed to insert.
RecordNumber
Username
Password
Firstname
Lastname
Email
ExternalID
ClassificationName
ClassificationOption

Called By:
User.cs
Calls:
sp_xml_preparedocument -- system stored procedure to ALTER  an internal representation of the XML document.
sp_xml_removedocument -- system stored procesure to remove the previously created representation of the XML document.

Remarks: The XML document must be well formed otherwise the process will fail.

Process
--1. Get the Organisation ID and unit ID
--2. Get a list of users that will be imported
--3. Data Validation
any other validation???
--4. Insert valid user data to user  and  user classification tables
--5. Get the summary report of the imported users
--6. Get all records with details of errors found in the data records

Author: Peter Vranich
Date Created: 10th of February 2004

Modification History
-----------------------------------------------------------
v#	Author		Date		Description
#1	Peter Kneale	23/2/04		Changed name from prcImportUsers to prcUser_Import
#2	jack Liu	9/03/04		Reorganize the process and put comments
#3	Peter Kneale	2/12/2004	An empty Extenal ID is now treated as a null value.
#4	Jack Liu	14/09/2005	Validate UnitID, the unitID must be inside the specified organisation
UserName is unique per organisation
#5  Li Zhang	Jul	2008	added unique field for updating existing user data
#5  						the actual function of insert/update to the user data are not perform in this stored procedure
#5							it''s used to prepare preview user data record before importing user data records to tblUser

Test:
exec prcUser_Import @userXMLData = ''<BDWUserUpload><User Username="imported22" Firstname="Imported" Lastname="User1" Email="imported.user1@bdw.com" ExternalID="IU1">
<CustomClassifications><CustomClassification Name="State" Option="NSW"/></CustomClassifications>
</User>
<User Username="imported22" Firstname="Imported" Lastname="User2" Email="imported.user2@bdw.com" ExternalID="IU2">
<CustomClassifications><CustomClassification Name="State" Option="ACT"/></CustomClassifications>
</User></BDWUserUpload>'', @ID = 18, @hierachy = ''Organisation'', @userID = 1100
*/

CREATE    Procedure [prcUser_ImportPreview]
(
	@userXMLData nText = null, 	-- XML document
	@ID Integer = null,		-- ID
	@hierachy nVarChar(12) = null, 	-- hierachy where the call to upload useres was made from.
	--can only be Organisation or Unit.
	@userID Integer = null, 		-- ID of user importing the xmlData
	@uniqueField Integer = null
)

As
Begin

	Set NoCount On

	Set Xact_Abort On
	Begin Transaction


	--Declarations
	-- OrganisationID of the Unit that the Users are being imported too.
	Declare @intOrganisationID Integer
	Declare @intUnitID Integer

	Declare @hdoc Integer 			-- Is the document handle of the internal representation of an XML document.
	Declare @strRowPattern Varchar(19) 	-- The row pattern to be used with the OPENXML statement.
	Declare @intRecordCountTotal Integer 	-- Number of rows inserted
	-- Set the rowpattern for the Openxml statement.
	Set @strRowPattern = ''/BDWUserUpload/User''

	Declare @constant_EmailAddress int
	Declare @constant_UserName int

	set @constant_EmailAddress  = 1
	set @constant_UserName = 2

	--1. Get the Organisation ID and unit ID
	If(@hierachy = ''Unit'')
	Begin
		set @intUnitID = @ID
		-- Get the OrganisationID for this Unit.
		Select
		@intOrganisationID = OrganisationID
		From
		tblUnit
		Where
		UnitID = @ID
	end
	else
		begin
		set @intUnitID = null
		set @intOrganisationID = @ID
	end

	--2. Get a list of users that will be imported
	-- Create a temp table to hold the values from the XML document
	Create Table #xmlUserData
	(
		TempUserID				Integer Identity(1, 1),
		UnitID					int default(null),
		Username				nVarchar(50) COLLATE database_default Not Null,
		Password				nVarchar(50) COLLATE database_default Not Null,
		Firstname				nVarchar(50) COLLATE database_default,
		Lastname				nVarchar(50) COLLATE database_default,
		Email					nVarchar(50) COLLATE database_default  Not Null,
		ExternalID				nVarchar(50) COLLATE database_default,
		ClassificationName		nVarchar(50) COLLATE database_default,
		ClassificationOption	Varchar(50)  COLLATE database_default,
		Status					int  default(Null),-- ErrorFound:1, Updated:2, Added:3
		Reason					varchar(1000)  COLLATE database_default,
		ErrField				varchar(255) default(Null),
		Archive					varchar (1) default(''2''),
		NotifyUnitAdmin			nVarchar(3) COLLATE database_default default(''No''),
		NotifyOrgAdmin			nVarchar(3) COLLATE database_default default(''No''),
		ManagerNotification		nVarchar(3) COLLATE database_default default(''No''),
		ManagerToNotify			nVarchar(50) COLLATE database_default default(null),
		UpdField				varchar(255) default ('''')
	)


	Exec sp_xml_preparedocument @hdoc Output, @userXMLData

	-- Get the records from the XML file and insert them into the temp table.

	Insert Into #xmlUserData
	(
		UnitID,
		Username,
		Password,
		Firstname,
		Lastname,
		Email,
		ExternalID,
		Archive,
		ClassificationName,
		ClassificationOption,
		NotifyUnitAdmin,
		NotifyOrgAdmin,
		ManagerNotification,
		ManagerToNotify
	)
	Select
		*
	From
		OpenXml(@hdoc, @strRowPattern)
	With
	(
		UnitID					int		''@UnitID'',
		Username				nVarchar(50) ''@Username'',
		Password				nVarchar(50) ''@Password'',
		Firstname				nVarchar(50) ''@Firstname'',
		Lastname				nVarchar(50) ''@Lastname'',
		Email					nVarchar(50) ''@Email'',
		ExternalID				nVarchar(50) ''@ExternalID'',
		Archive					nVarchar (1)		''@Archive'',
		ClassificationName		Varchar(50) ''CustomClassifications/CustomClassification/@Name'',
		ClassificationOption	Varchar(50) ''CustomClassifications/CustomClassification/@Option'',
		NotifyUnitAdmin			nVarchar (3)		''@NotifyUnitAdmin'',
		NotifyOrgAdmin			nVarchar (3)		''@NotifyOrgAdmin'',
		ManagerNotification		nVarchar (3)		''@ManagerNotification'',
		ManagerToNotify			nVarchar (50)		''@ManagerToNotify''
	)


	-- Ensure that any values that should be null havent been cast to 0 instead of NULL
	Update
		#xmlUserData
	Set
		UnitID = null
	Where
		UnitID = 0

	Update
		#xmlUserData
	Set
		ErrField = ''''

	--======================================================--
	-- SECURITY												--
	--======================================================--
	Declare @UserType int	-- the type of the user

	-- Get user type
	Select @UserType = UserTypeID from tblUser Where UserID = @UserID

	-- Salt Administrator
	-----------------------------
	--IF (@UserType = 1)
	-- This user is allowed to perform any action


	-- Organisation Administrator
	-----------------------------
	IF (@UserType = 2)
	Begin
		-- See if any units in the temp table are not found in this organisation
		Update
			#xmlUserData
		Set
			Status = 1,
			Reason = ''Reason1'',
			ErrField = '';6''
		Where
			UnitID is not null
			and UnitID not in (select UnitID from tblUnit Where OrganisationID = @intOrganisationID)
	End

	-- Unit Administrator
	IF (@UserType = 3)
	Begin
		-- A table of units that this user can administer
		Create Table #AdministerableUnits
		(
			UnitID int
		)

		-- populate the list
		Insert into
			#AdministerableUnits
		select
			u.UnitID
		from
			tblUnit as u
			inner join tblUnitAdministrator as ua on (u.unitID=ua.unitID) and (ua.userID = @userID)

		-- update rows that arent present in the users list of administerbale units.
		Update
			#xmlUserData
		Set
			Status = 1,
			Reason = ''Reason2'',
			ErrField = #xmlUserData.ErrField + '';6''
		Where
			UnitID is not null
			and
			UnitID not in (select UnitID from #AdministerableUnits)
		
		--check that the unitadmin is not updating the org admin
		
		if @uniqueField= @constant_EmailAddress  
		begin
			-- join on the email address
			update 
				#xmlUserData
			set
				Status= 1,
				Reason = ''Reason2'',
				ErrField = #xmlUserData.ErrField +'';1''
			From
				#xmlUserData
				inner Join tblUser As usr
					On #xmlUserData.Email = usr.Email and usr.UserTypeID <3
		end
		else begin
			-- join on the username
			update 
				#xmlUserData
			set
				Status= 1,
				Reason = ''Reason2'',
				ErrField = #xmlUserData.ErrField +'';1''
			From
				#xmlUserData
				inner Join tblUser As usr
					On #xmlUserData.Username = usr.Username and usr.UserTypeID <3
		end
		
		
		Drop table #AdministerableUnits
	End

	-- Normal User
	if (@UserType = 4)
	Begin
		Select ''Status1'' as ''Status''
		Select *, 0 as ''RecordNumber'' from #xmlUserData
		Rollback
		return
	End
	--======================================================--
	-- SECURITY FINISHED									--
	--======================================================--


	-- Get the total number of records to be processed.
	Set @intRecordCountTotal = @@Rowcount
	if ((select count(1) from #xmlUserData) > 1000)
	Begin
		Select ''Status2'' as ''Status''
		Select *, 0 as ''RecordNumber'' from #xmlUserData
		Rollback
		return
	End
	-- remove the internal representation of the XML Document.
	Exec sp_xml_removedocument @hdoc

	--3. Data Validation

	-- Validate that specified units exist (not active or not in this organisation).
	-- and the unitID must be inside the specified organisation -#4
	Update
		#xmlUserData
	Set
		Status = 1,
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason3'',
		ErrField = '';6''
	Where	
		UnitID is not null
		And
		UnitID not in (select UnitID from tblUnit Where Active=1 and OrganisationID = @intOrganisationID)


	--fields that connot be deleted and have a ^ to be treated as NC

	update 
		#xmlUserData
	set
		--UnitID = case when UnitID=''^'' then '''' else unitid end,
		Username= case when Username = ''^''  or username is null then '''' else Username end,
		Password = case when Password = ''^'' then '''' else password end,
		Firstname= case when Firstname =  ''^'' then '''' else firstname end,
		Lastname = case when Lastname = ''^'' then '''' else lastname end,
		Email = case when Email = ''^'' OR Email IS NULL then '''' else email end,
		Archive = case when Archive = ''^'' then '''' else archive end,
		NotifyUnitAdmin = case when NotifyUnitAdmin = ''^'' then '''' else notifyunitadmin end,
		NotifyOrgAdmin = case when NotifyOrgAdmin  = ''^'' then '''' else NotifyOrgAdmin end,
		ManagerNotification = case when ManagerNotification = ''^'' then '''' else ManagerNotification end
		
	
	
	/*-- if the unique field is email address and its blank then error
	if @uniqueField = @constant_EmailAddress 
	begin
		update 
			#xmlUserData
		set
			Reason = ''Reason10'', -- change this to the correct reason
			Status = 1,
			ErrField  = '';5''
		where Email =''''
	end
	
	
	if @uniqueField = @constant_UserName
	begin 
		update 
			#xmlUserData
		set
			Reason = ''Reason10'', -- change this to the correct reason
			Status = 1,
			ErrField  = '';1''
		where Username =''''
	
	end */
	
	
	-- Get a list of users whose user names already exist
	-- when unique field is username, and username is found in database, update record
	Update
		#xmlUserData
	Set
		Status = CASE @uniqueField 
			WHEN @constant_UserName THEN
				ISNULL(#xmlUserData.Status,2)
			ELSE
				case when usr.email = #xmlUserData.Email then
					ISNULL(#xmlUserData.Status,2)
				else
					1
				end
			END,
		Reason = CASE @uniqueField 
			WHEN @constant_UserName	THEN
				#xmlUserData.Reason
			ELSE
				case when usr.email = #xmlUserData.Email then
					#xmlUserData.Reason
				else
					isNull(#xmlUserData.Reason+''; '','''')+ ''Reason4''
				end
			END,
		ErrField = CASE @uniqueField 
			WHEN @constant_UserName THEN
				#xmlUserData.ErrField
			ELSE
				case when usr.email = #xmlUserData.Email then
					#xmlUserData.ErrField
				else
					#xmlUserData.ErrField+'';1''
				end
			END
	From
		#xmlUserData
		inner Join tblUser As usr
			On #xmlUserData.Username = usr.Username and (usr.OrganisationID = @intOrganisationID or usr.OrganisationID is null)


	-- Get a list of users whose email addresses already exist
	-- Business logic changed:
	--when unique field is email address, and email address is exists, update record
	Update
		#xmlUserData
	Set
		Reason = CASE @uniqueField 
				WHEN @constant_EmailAddress THEN
					case when  (@intOrganisationID = usr.organisationid) then
						#xmlUserData.Reason
					else
						isNull(#xmlUserData.Reason+''; '','''')+ ''Reason5''
					end
				ELSE
					case when #xmlUserData.Email = usr.Email and @intOrganisationID = usr.organisationid then
						#xmlUserData.Reason
					else
						isNull(#xmlUserData.Reason+''; '','''')+ ''Reason5''
					end
				END,
		Status = CASE @uniqueField WHEN @constant_EmailAddress THEN
					case when  (@intOrganisationID = usr.organisationid) then
						ISNULL(#xmlUserData.Status,2)
					else
						1
					end
				ELSE
					case when #xmlUserData.Email = usr.Email and @intOrganisationID = usr.organisationid then
						ISNULL(#xmlUserData.Status,2)
					else
						1
					end
				END,
		ErrField = CASE @uniqueField WHEN @constant_EmailAddress THEN
						case when  (@intOrganisationID = usr.organisationid) then
							#xmlUserData.ErrField
						else
							#xmlUserData.ErrField + '';5''
						end
					ELSE
						case when #xmlUserData.Email = usr.Email and @intOrganisationID = usr.organisationid	then
							#xmlUserData.ErrField
						else
							#xmlUserData.ErrField + '';5''
						end
					END
	From
		#xmlUserData
		inner Join tblUser As usr On #xmlUserData.Email = usr.Email

	--Get a list of users whose user name are duplicated in this batch
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason6'',
		Status = 1,
		ErrField = #xmlUserData.ErrField + '';1''
	From
		#xmlUserData
		inner  join #xmlUserData u2 On #xmlUserData.Username = u2.Username and u2.TempUserID>#xmlUserData.TempUserID

	-- This adds the reason code to the other records with the duplicated user name
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason6'',
		Status = 1,
		ErrField = #xmlUserData.ErrField + '';1''
	From
		#xmlUserData
		inner  join #xmlUserData u2 On #xmlUserData.Username = u2.Username and u2.TempUserID<#xmlUserData.TempUserID 
			and #xmlUserData.TempUserID not in
				(	select u3.TempUserID 
					from #xmlUserData u3
						inner  join #xmlUserData u4 On u3.Username = u4.Username 
									and u4.TempUserID>u3.TempUserID
				)

	--Get a list of users whos username is the same as their password
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason7'',
		Status = 1,
		ErrField = #xmlUserData.ErrField + '';1;2''
	From
		#xmlUserData
	Where
		UserName = Password

	--Get a list of users whose email addresses are duplicated in this batch
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason8'',
		Status = 1,
		ErrField = #xmlUserData.ErrField + '';5''
	From
		#xmlUserData
		inner  join #xmlUserData u2 On #xmlUserData.Email = u2.Email 
					and u2.TempUserID>#xmlUserData.TempUserID
	where #xmlUserData.Email <>''''

	-- This adds the reason code to the other records with the duplicated emails
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason8'',
		Status = 1,
		ErrField = #xmlUserData.ErrField + '';5''
	From
		#xmlUserData
		inner  join #xmlUserData u2 on #xmlUserData.Email = u2.Email and u2.TempUserID<#xmlUserData.TempUserID
					and #xmlUserData.TempUserID not in
						(	select u3.TempUserID 
							from #xmlUserData u3
								inner  join #xmlUserData u4	On u3.Email = u4.Email
										and u4.TempUserID>u3.TempUserID
						)
	where #xmlUserData.Email <>''''


	-- Get a list of users who are missing a first or last name
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason9'',
		Status = 1,
		ErrField = #xmlUserData.ErrField +'';3''
	Where
		len(FirstName) = 0
		and Status <> 2 -- allow empty value with update user

	-- Get a list of users who are missing a first or last name
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason9'',
		Status = 1,
		ErrField = #xmlUserData.ErrField +'';4''
	Where
		len(LastName) = 0
		and Status <> 2 -- allow empty value with update user

	-- check that the archive bit has been set
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+''; '','''')+ ''Reason11'',
		Status = 1,
		ErrField = #xmlUserData.ErrField +'';7'',
		Archive = null
	Where
		Archive = 2

	-- Change made for consistancy - see bug ID 269 for further info.
	-- Empty string values for External ID should be NULLs
	UPDATE 
		#xmlUserData
	SET
		[ExternalID]=NULL
	WHERE
		[ExternalID]=''''

	UPDATE 
		#xmlUserData
	SET
		Status = 3
		--Reason = ''Add User''
	WHERE
		Status is null 
		and	Reason is null
		
		
		
	-- flag the fields that have changed using email as unique field (ie email clearly is not being changed)
	if (@uniqueField = @constant_EmailAddress) begin
	

		-- username has changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.Username != u.UserName and xd.Username != '''' then xd.UpdField +'';1'' else xd.UpdField end						
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		-- password has changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.Password!=u.Password  and xd.password != '''' then xd.UpdField +'';2'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
			
		-- firstname change
		update
			#xmlUserData
		set 
			UpdField = case when xd.Firstname!=u.FirstName  and xd.firstname != '''' then xd.UpdField +'';3'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		-- last name changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.Lastname!=u.LastName and xd.lastname != '''' then xd.UpdField +'';4'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		--external id changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.externalid!=u.externalID  and xd.externalid != '''' then xd.UpdField +'';6'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2	
		
		
		-- unit id changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.UnitID!=u.UnitID  and xd.unitid != '''' then xd.UpdField +'';7'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
			
		
		-- archive bit changed	
		update
			#xmlUserData
		set 
			UpdField = case when xd.Archive = u.Active and xd.archive != '''' then xd.UpdField +'';8'' else xd.UpdField end -- if archive 1 then active 0
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		-- user classification type or value has changed
		update
			#xmlUserData
		set 
			UpdField = case when (xd.ClassificationName !=ct.Name) or (xd.ClassificationOption != c.Value)  then xd.UpdField +'';9'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and xd.ErrField is null and xd.Status = 2
			join tblUserClassification uc on uc.UserID = u.UserID
			join tblClassification c on c.ClassificationID = uc.ClassificationID
			join tblClassificationType ct on ct.ClassificationTypeID = c.ClassificationTypeID
			
		
		-- unit admin notification flag has changed
		update
			#xmlUserData
		set 
			UpdField = case when (case when xd.NotifyUnitAdmin =''Yes'' then 1 when xd.NotifyUnitAdmin =''No'' then 0 else '''' end) != u.NotifyUnitAdmin and xd.NotifyUnitAdmin != '''' then xd.UpdField +'';10'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		
		-- org admin notification flag has changed
		update
			#xmlUserData
		set 
			UpdField = case when (case when xd.NotifyOrgAdmin= ''Yes'' then 1 when xd.NotifyOrgAdmin =''No'' then 0 else '''' end )!= u.NotifyOrgAdmin and xd.NotifyOrgAdmin != '''' then xd.UpdField +'';11'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		
		-- manager notification flag has changed
		update
			#xmlUserData
		set 
			UpdField = case when (case when xd.ManagerNotification = ''Yes'' then 1 when xd.ManagerNotification =''No'' then 0 else '''' end ) != u.NotifyMgr and xd.ManagerNotification != '''' then xd.UpdField +'';12'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		
		-- notification managers email has changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.ManagerToNotify != u.DelinquencyManagerEmail and xd.ManagerToNotify != '''' then xd.UpdField +'';13'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Email = u.Email and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
			
		
		
	end
	else if (@uniqueField = @constant_UserName) 
	begin
	
		-- password has changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.Password!=u.Password  and xd.password  != '''' then xd.UpdField +'';2'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''') and xd.Status = 2
			
		-- firstname changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.Firstname!=u.FirstName and xd.firstname != '''' then xd.UpdField +'';3'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		-- last name changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.Lastname!=u.LastName and xd.lastname != ''''  then xd.UpdField +'';4'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		-- email changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.Email!=u.Email and xd.email != '''' then xd.UpdField +'';5'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		--external id changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.externalid!=coalesce(u.externalID,'''')  and xd.externalid != '''' then xd.UpdField +'';6'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2	
			
		-- unit id changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.UnitID!=u.UnitID  and xd.unitid != '''' then xd.UpdField +'';7'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
			
		-- archive bit changed	
		update
			#xmlUserData
		set 
			UpdField = case when xd.Archive = u.Active and xd.archive  != '''' then xd.UpdField +'';8'' else xd.UpdField end -- if archive 1 then active 0
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2		
			
		-- user classification type or value has changed
		update
			#xmlUserData
		set 
			UpdField = case when (xd.ClassificationName !=ct.Name) or (xd.ClassificationOption != c.Value)  then xd.UpdField +'';9'' else xd.UpdField end
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
			join tblUserClassification uc on uc.UserID = u.UserID
			join tblClassification c on c.ClassificationID = uc.ClassificationID
			join tblClassificationType ct on ct.ClassificationTypeID = c.ClassificationTypeID
			
		
		-- unit admin notification flag has changed
		update
			#xmlUserData
		set 
			UpdField = case when (case when xd.NotifyUnitAdmin = ''Yes'' then 1 when xd.NotifyUnitAdmin =''No'' then 0 else '''' end) != u.NotifyUnitAdmin and xd.NotifyUnitAdmin != '''' then xd.UpdField +'';10'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		
		-- org admin notification flag has changed
		update
			#xmlUserData
		set 
			UpdField = case when (case when xd.NotifyOrgAdmin = ''Yes'' then 1 when xd.NotifyOrgAdmin =''No'' then 0 else '''' end ) != u.NotifyOrgAdmin and xd.NotifyOrgAdmin != '''' then xd.UpdField +'';11'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		
		-- manager notification flag has changed
		update
			#xmlUserData
		set 
			UpdField = case when (case when xd.ManagerNotification = ''Yes'' then 1 when xd.ManagerNotification= ''No'' then 0 else '''' end ) != u.NotifyMgr and xd.ManagerNotification != '''' then xd.UpdField +'';12'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		
		-- notification managers email has changed
		update
			#xmlUserData
		set 
			UpdField = case when xd.ManagerToNotify != u.DelinquencyManagerEmail and xd.ManagerToNotify != '''' then xd.UpdField +'';13'' else xd.UpdField end 
		from 
			#xmlUserData xd join tblUser u  on xd.Username = u.UserName and (xd.ErrField is null or xd.ErrField = '''')  and xd.Status = 2
		
		
	end
	
	
	Select
		''Status'' = ''Status5''
		
	Select
		tmp.TempUserID As ''RowNumber'',
		tmp.Username,
		tmp.Password,
		tmp.Firstname,
		tmp.Lastname,
		tmp.Email,
		UnitID,
		tmp.Status,
		tmp.Reason as Reason,
		tmp.ClassificationOption,
		tmp.ClassificationName,
		tmp.ExternalID,
		tmp.ErrField,
		tmp.UpdField,
		tmp.Archive,
		tmp.NotifyUnitAdmin,
		tmp.NotifyOrgAdmin,
		tmp.ManagerNotification,
		tmp.ManagerToNotify
	From
		#xmlUserData As tmp

	drop table #xmlUserData
	commit

	SET ANSI_NULLS ON
END' 
END
GO
