SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[prcUpdateOrgDeliquency]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Hitendra
-- Create date: 17/06/2011
-- Description:	Update Delinquency settings for Organisation
-- =============================================
CREATE PROCEDURE [prcUpdateOrgDeliquency]

@OrgID int,
@WarnMgrsofDeliquentUsers bit,
@WarnUsersofDelinquency bit,
@NumberOfReminders int,
@DelinquencyPeriod int,
@DelinquencyReminderPeriod int,
@DaysWarningBeforeExpiry int,
@IncludeLogo bit,
@QuizDueDate datetime

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

UPDATE tblOrganisation SET --WarnMgrsofDeliquentUsers = @WarnMgrsofDeliquentUsers,
--WarnUsersofDelinquency = @WarnUsersofDelinquency,
--NumberOfReminders = @NumberOfReminders,
--DelinquencyPeriod = @DelinquencyPeriod,
--DelinquencyReminderPeriod = @DelinquencyReminderPeriod,
--DaysWarningBeforeExpiry = @DaysWarningBeforeExpiry,
IncludeLogoOnCorrespondence = @IncludeLogo,
QuizDueDate = @QuizDueDate
WHERE OrganisationID = @OrgID
END
' 
END
GO
