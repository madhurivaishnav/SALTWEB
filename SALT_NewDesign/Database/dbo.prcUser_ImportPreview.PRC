
/****** Object:  StoredProcedure [dbo].[prcUser_ImportPreview]    Script Date: 07/15/2008 10:11:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcUser_ImportPreview] ') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcUser_ImportPreview] 
GO


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
#5							it's used to prepare preview user data record before importing user data records to tblUser

Test:
	exec prcUser_Import @userXMLData = '<BDWUserUpload><User Username="imported22" Firstname="Imported" Lastname="User1" Email="imported.user1@bdw.com" ExternalID="IU1">
		<CustomClassifications><CustomClassification Name="State" Option="NSW"/></CustomClassifications>
	</User>
	<User Username="imported22" Firstname="Imported" Lastname="User2" Email="imported.user2@bdw.com" ExternalID="IU2">
		<CustomClassifications><CustomClassification Name="State" Option="ACT"/></CustomClassifications>
	</User></BDWUserUpload>', @ID = 18, @hierachy = 'Organisation', @userID = 1100
*/

CREATE    Procedure [dbo].[prcUser_ImportPreview]
(
	@userXMLData nText = null, 	-- XML document
	@ID Integer = null,		-- ID
	@hierachy nVarChar(12) = null, 	-- hierachy where the call to upload useres was made from.
					--can only be Organisation or Unit.
	@userID Integer = null, 		-- ID of user importing the xmlData
	@uniqueField Integer = null
)

As

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
	Set @strRowPattern = '/BDWUserUpload/User'

	Declare @constant_EmailAddress int
	Declare @constant_UserName int

	set @constant_EmailAddress  = 1
	set @constant_UserName = 2
	
	--1. Get the Organisation ID and unit ID
	If(@hierachy = 'Unit')
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
		Username				nVarchar(50)  COLLATE database_default Not Null,
		Password				nVarchar(50)  COLLATE database_default Not Null,
		Firstname				nVarchar(50) COLLATE database_default,
		Lastname				nVarchar(50) COLLATE database_default,
		Email					nVarchar(50)COLLATE database_default  Not Null,
		ExternalID				nVarchar(50)  COLLATE database_default,
		ClassificationName			nVarchar(50) COLLATE database_default,
		ClassificationOption			Varchar(50)  COLLATE database_default,
		Status					int  default(Null),-- ErrorFound:1, Updated:2, Added:3
		Reason					varchar(1000)  COLLATE database_default,
		ErrField				varchar(255) default(Null),
		Archive					bit 
		
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
		ClassificationOption
		
	)
	Select
	*
	From
		OpenXml(@hdoc, @strRowPattern)
		With
		(
			UnitID					int		'@UnitID',
			Username				nVarchar(50) '@Username',
			Password				nVarchar(50) '@Password',
			Firstname				nVarchar(50) '@Firstname',
			Lastname				nVarchar(50) '@Lastname',
			Email					nVarchar(50) '@Email',
			ExternalID				nVarchar(50) '@ExternalID',
			Archive					bit		'@Archive',
			ClassificationName		Varchar(50) 'CustomClassifications/CustomClassification/@Name',
			ClassificationOption	Varchar(50) 'CustomClassifications/CustomClassification/@Option'
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
		ErrField = ''
		
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
			Reason = 'Reason1',
			ErrField = ';6'
		Where
			UnitID is not null
			and 
			UnitID not in (select UnitID from tblUnit Where OrganisationID = @intOrganisationID)		
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
			inner join tblUnitAdministrator as ua
				on (u.unitID=ua.unitID)
				and (ua.userID = @userID)
				
		-- update rows that arent present in the users list of administerbale units.
		Update 
			#xmlUserData
		Set
			Status = 1,
			Reason = 'Reason2',
			ErrField = #xmlUserData.ErrField + ';6'
		Where
			UnitID is not null
			and 
			UnitID not in (select UnitID from #AdministerableUnits)	
			
		Drop table #AdministerableUnits
	End
	
	-- Normal User
	if (@UserType = 4)
	Begin
		Select 'Status1' as 'Status'
		Select *, 0 as 'RecordNumber' from #xmlUserData
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
		Select 'Status2' as 'Status'
		Select *, 0 as 'RecordNumber' from #xmlUserData
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
		Reason = isNull(#xmlUserData.Reason+', ','')+ 'Reason3',
		ErrField = ';6'
	Where	UnitID is not null
		And
		UnitID not in (select UnitID from tblUnit Where Active=1 and OrganisationID = @intOrganisationID)

		
	-- Get a list of users whose user names already exist
	-- when unique field is username, and username is found in database, update record
	
	Update
		#xmlUserData
	Set
		Status = CASE @uniqueField WHEN @constant_UserName THEN 2 ELSE 1 END,
		Reason = CASE @uniqueField WHEN @constant_UserName THEN null ELSE isNull(#xmlUserData.Reason+', ','')+ 'Reason4' END,
		ErrField = CASE @uniqueField WHEN @constant_UserName THEN '' ELSE #xmlUserData.ErrField+';1' END
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
		Reason = CASE @uniqueField WHEN @constant_EmailAddress THEN null ELSE isNull(#xmlUserData.Reason+', ','')+ 'Reason5' END,
		Status = CASE @uniqueField WHEN @constant_EmailAddress THEN 2 ELSE 1 END,
		ErrField = CASE @uniqueField WHEN @constant_EmailAddress THEN #xmlUserData.ErrField ELSE #xmlUserData.ErrField + ';5' END
	From
		#xmlUserData
		inner Join tblUser As usr
			On #xmlUserData.Email = usr.Email

	--Get a list of users whose user name are duplicated in this batch
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+', ','')+ 'Reason6',
		Status = 1,
		ErrField = #xmlUserData.ErrField + ';1'
	From
		#xmlUserData
		inner  join #xmlUserData u2
			On #xmlUserData.Username = u2.Username
			and u2.TempUserID>#xmlUserData.TempUserID
	
	--Get a list of users whos username is the same as their password
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+', ','')+ 'Reason7',
		Status = 1,
		ErrField = #xmlUserData.ErrField + ';1;2'
	From
		#xmlUserData
	Where
		UserName = Password
			
	--Get a list of users whose email addresses are duplicated in this batch
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+', ','')+ 'Reason8',
		Status = 1,
		ErrField = #xmlUserData.ErrField + ';5'
	From
		#xmlUserData
		inner  join #xmlUserData u2
			On #xmlUserData.Email = u2.Email
			and u2.TempUserID>#xmlUserData.TempUserID

	-- Get a list of users who are missing a first or last name
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+', ','')+ 'Reason9',
		Status = 1,
		ErrField = #xmlUserData.ErrField +';3'
	Where
		len(FirstName) = 0 
		and Status <> 2 -- allow empty value with update user
		
		-- Get a list of users who are missing a first or last name
	Update
		#xmlUserData
	Set
		Reason = isNull(#xmlUserData.Reason+', ','')+ 'Reason9',
		Status = 1,
		ErrField = #xmlUserData.ErrField +';4'
	Where
		len(LastName) = 0 
		and Status <> 2 -- allow empty value with update user

	-- Change made for consistancy - see bug ID 269 for further info.
	-- Empty string values for External ID should be NULLs
	UPDATE #xmlUserData
		SET 
			[ExternalID]=NULL
		WHERE 
			[ExternalID]=''
	
				UPDATE #xmlUserData
				SET
				Status = 3
				--Reason = 'Add User'
			WHERE 
				Status is null
				and 
				Reason is null
			
		Select
			'Status' = 'Status5' 
		Select
			tmp.TempUserID As 'RowNumber',
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
			tmp.Archive		
		From 
			#xmlUserData As tmp
	
	drop table #xmlUserData	
		commit	
	

