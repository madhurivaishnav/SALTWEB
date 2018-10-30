SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcOrganisation_GetNotesByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/*Summary:
Given a Course id return the Course notes
Returns:
Course Notes

Called By: Home.aspx via Businessservices.Organisation.GetOrganisationNotes
Calls:

Remarks:


Author:
Stephen Kennedy-Clark
Date Created: 6 Feb 2004

Modification History
-----------------------------------------------------------
v#	Author		Date			Description
#1

--------------------
prcOrganisation_GetNotesByUser   @organisationID=3

**/

CREATE   Proc [prcOrganisation_GetNotesByUser]
(
@LangCode varchar(10),
@organisationID Int = Null, 	-- organisation id 	- not required
@userID 	Int = Null		 	-- user id 		- not required
)
AS
------------------------------------------
Set Nocount On

------------------------------------------
-- Validate Requird Paramaters were supplied
------------------------------------------
If @organisationID Is Null And @userID Is Null
Begin
Raiserror (''Procedure prcOrganisation_GetNotesByUser expects at least one  the following pramaters: @userID or @organisationID'', 16, 1)
Return
End

------------------------------------------
-- Get OrganisationID if it was not Supplied
------------------------------------------
If @organisationID Is Null
Begin
Set @organisationID = (Select Top 1 organisationID From tblUser Where UserID = @userID)
End

------------------------------------------
-- Return select
------------------------------------------

--Select
--	Notes
--From
--	tblOrganisation
--Where
--	OrganisationID = @organisationID

select
Notes
from dbo.tblOrganisationNotes orgN
left Join dbo.tblLang l
on orgN.[LanguageID] = l.[LangID]
where orgN.[OrganisationID] = @OrganisationID
and l.[LangCode] = @LangCode




' 
END
GO
