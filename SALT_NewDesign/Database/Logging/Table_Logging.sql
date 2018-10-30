
if exists (select * from dbo.sysobjects where id = object_id(N'[tblLogDaily]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [tblLogDaily]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[tblLogHourly]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [tblLogHourly]
GO

CREATE TABLE [dbo].[tblLogDaily] (
	[OrganisationID] [int] NOT NULL ,
	[TimePeriod1] [int] NOT NULL ,
	[TimePeriod2] [int] NOT NULL ,
	[TimePeriod3] [int] NOT NULL ,
	[TimePeriod4] [int] NOT NULL ,
	[TimePeriod5] [int] NOT NULL ,
	[TimePeriod6] [int] NOT NULL ,
	[TimePeriod7] [int] NOT NULL ,
	[TimePeriod8] [int] NOT NULL ,
	[DateCreated] [datetime] NOT NULL ,
	[ID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tblLogHourly] (
	[OrganisationID] [int] NOT NULL ,
	[TimePeriod1] [int] NOT NULL ,
	[TimePeriod2] [int] NOT NULL ,
	[TimePeriod3] [int] NOT NULL ,
	[TimePeriod4] [int] NOT NULL ,
	[TimePeriod5] [int] NOT NULL ,
	[TimePeriod6] [int] NOT NULL ,
	[DateCreated] [datetime] NOT NULL ,
	[ID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL 
) ON [PRIMARY]
GO



SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS OFF 
GO

