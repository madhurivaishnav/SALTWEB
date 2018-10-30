SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcReport_UnitCompliance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/**

Summary:		Get the compliance rules for all the modules attached to selected units.
Called by:		UnitComplianceReport.rdl
Example call:	exec prcreport_unitcompliance 109, 0, ''4463,4464,4465''

Author:			Mark Donald
Date created:	05/01/2010

Modification history
-----------------------------------------------------------
Author		Date			Description



**/
CREATE PROCEDURE [dbo].[prcReport_UnitCompliance]
(
@organisationID	int,
@IncludeInactive int,
@UnitIDs varchar(max)
)

AS

SET NOCOUNT ON

SELECT
hierarchyname as unitpathway, c.[name] as coursename, r.[name] AS modulename,
CASE lessonfrequency WHEN 0 THEN NULL ELSE lessonfrequency END AS lessonfrequency,
CASE quizfrequency WHEN 0 THEN NULL ELSE quizfrequency END AS quizfrequency,
lessoncompletiondate AS lessonexpirydate,
quizcompletiondate AS quizexpirydate,
quizpassmark AS passmark,
CASE usingdefault WHEN 1 THEN ''Yes'' ELSE ''No'' END AS ''default''
FROM
vwunitmodulerule r
LEFT JOIN tblunitmoduleaccess a ON a.unitid = r.unitid AND r.moduleid = deniedmoduleid,
tblunit u,
tblunithierarchy h,
tblcourse c,
tblModule m
WHERE
h.unitid = u.unitid
AND r.unitid = u.unitid
AND c.courseid = r.courseid
AND r.moduleid = m.moduleid
AND u.organisationid = @organisationid
AND (@includeinactive = 1 OR u.active = 1)
AND a.unitid IS NULL
AND u.unitid IN (SELECT * FROM dbo.udfcsvtoint(@unitids))
ORDER BY
unitpathway, coursename, [sequence], modulename


' 
END
GO
