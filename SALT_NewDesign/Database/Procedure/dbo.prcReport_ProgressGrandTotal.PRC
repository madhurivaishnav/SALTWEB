SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_ProgressGrandTotal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/******************************************************************************
**		Name: prcReport_ProgressGrandTotal
**		Desc: a cut down copy of prcreport_Progress, with select statements
**				altered to return a total, instead of a list of data.
**
**		Return values: Grand Total distinct users in Progress report
**
**		Auth: Mark Donald
**		Date: 11 Jan 2010
**
*******************************************************************************/


CREATE       Procedure [dbo].[prcReport_ProgressGrandTotal]
(
@organisationID		int,
@unitIDs 		varchar(max),
@courseIDs 		varchar(8000),
@includeInactive int,
@classificationID int
)
AS
SET NOCOUNT ON;
BEGIN
SELECT
count(DISTINCT u.userid) TotalDistinctUsers
FROM
tblusercoursestatus s
INNER JOIN tblcourse c ON
c.courseid = s.courseid
AND c.courseid IN (SELECT IntValue FROM dbo.udfCsvToInt(@courseIDs))
INNER JOIN tbluser u ON
u.userid = s.userid
AND u.unitid IN (SELECT IntValue FROM dbo.udfCsvToInt(@unitIDs))
LEFT JOIN tbluserclassification g ON
g.userid = u.userid
WHERE
u.organisationid = @organisationID
AND (@includeInactive = 1 OR u.active = 1)
AND (@classificationID = 0 OR classificationID = @classificationID)
END

' 
END
GO
