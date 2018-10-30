
DECLARE @NewOrganisationID int
DECLARE @OldOrganisationID int
set @NewOrganisationID = xxx
set @OldOrganisationID = xxx


 
--	Step 1
--	Extract the user training records from the Old Salt 2.5 database.
--	Each user is extracted along with their most recent result on each module that they have attempted.
/*
	EXEC [Salt_Migration].[dbo].[prcExtract] @OldOrganisationID
*/



--	Step 2
--	Translate the UserID's from the 2.5 ID to the 3.5 ID
--	This inserts rows for each and every user into [tblTranslate_User]
--	Each user will have one row with two values, 
--		The first is their Salt 3.5 ID. This is taken from tblUser.UserID column.
--		The second is their Salt 2.5 ID. This is taken from tblUser.ExternalID column. 
/*
	EXEC [Salt_Migration].[dbo].[prcImport_Translation_User] @NewOrganisationID
*/

--	Step 3
-- Import module translations using DTS Package. Import Salt Module Translations.




--	Step 4
--  This validates that the data is ready for a translation.*/
/*
	EXEC [Salt_Migration].[dbo].[prcValidate]
*/




--	Step 5
--  This step performs the actual translation and populates the tblLoad table.
--	The 'translation' is the task of taking 2.5 result for a 2.5 user on a 2.5 module
--	and loading the load table with a 3.5 result for a 3.5 user on a 3.5 module.
--  
/*
	EXEC [Salt_Migration].[dbo].[prcTranslate] 
*/


--	Step 6
--	Perform the import.
--	The dates and times are just to provide an indicating of the run time expected.
/*
	Declare @DateStart datetime
	Declare @DateEnd datetime

	Set @DateStart = GetDate()
	EXEC  [Salt_Migration].[dbo].[prcImportUserResults] 
	Set @DateEnd = GetDate()

	Print @DateStart
	Print @DateEnd
 */
 