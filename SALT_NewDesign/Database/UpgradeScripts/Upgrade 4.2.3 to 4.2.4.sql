If  exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locDue')) 
begin 
update tblLangValue 
set LangEntryValue = N'Quiz Due'
where (LangID =2)
and (LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx'))
and (LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locDue'))
end 
GO

If  exists (select * from tblLangValue where LangID = 2 and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locQuiz')) 
begin 
update tblLangValue 
set LangEntryValue = N'Quiz'
where (LangID =2)
and (LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/MyTraining.aspx'))
and (LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'locQuiz'))
end 
GO

/* Fix for Replication issue with large sized pdf reports */


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tblEmailQueue_QueuedTime]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tblEmailQueue] DROP CONSTRAINT [DF_tblEmailQueue_QueuedTime]
END

GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblEmailQueueLinkedResource_tblEmailQueue]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblEmailQueueLinkedResource]'))
ALTER TABLE [dbo].[tblEmailQueueLinkedResource] DROP CONSTRAINT [FK_tblEmailQueueLinkedResource_tblEmailQueue]
GO


/****** Object:  Table [dbo].[tblEmailQueue]    Script Date: 05/31/2012 10:53:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmailQueue]') AND type in (N'U'))
DROP TABLE [dbo].[tblEmailQueue]
GO

/****** Object:  Table [dbo].[tblEmailQueue]    Script Date: 05/31/2012 10:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblEmailQueue](
	[EmailQueueID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[organisationID] [int] NULL,
	[AddressTo] [nvarchar](255) NULL,
	[Subject] [nvarchar](255) NULL,
	[Body] [nvarchar](max) NULL,
	[QueuedTime] [datetime] NOT NULL,
	[SendStarted] [datetime] NULL,
	[AddressSender] [nvarchar](255) NULL,
	[AddressFrom] [nvarchar](255) NULL,
	[IsHTML] [bit] NULL,
	[AddressBccs] [nvarchar](max) NULL,
 CONSTRAINT [PK_tblEmailQueue] PRIMARY KEY CLUSTERED 
(
	[EmailQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblEmailQueue] ADD  CONSTRAINT [DF_tblEmailQueue_QueuedTime]  DEFAULT (getutcdate()) FOR [QueuedTime]
GO


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblEmailQueueLinkedResource_tblEmailQueue]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblEmailQueueLinkedResource]'))
ALTER TABLE [dbo].[tblEmailQueueLinkedResource] DROP CONSTRAINT [FK_tblEmailQueueLinkedResource_tblEmailQueue]
GO

/****** Object:  Table [dbo].[tblEmailQueueLinkedResource]    Script Date: 05/31/2012 10:53:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmailQueueLinkedResource]') AND type in (N'U'))
DROP TABLE [dbo].[tblEmailQueueLinkedResource]
GO

/****** Object:  Table [dbo].[tblEmailQueueLinkedResource]    Script Date: 05/31/2012 10:53:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblEmailQueueLinkedResource](
	[EmailQueueID] [bigint] NOT NULL,
	[ContentID] [nvarchar](100) NOT NULL,
	[ByteStream] [varbinary](max) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblEmailQueueLinkedResource]  WITH CHECK ADD  CONSTRAINT [FK_tblEmailQueueLinkedResource_tblEmailQueue] FOREIGN KEY([EmailQueueID])
REFERENCES [dbo].[tblEmailQueue] ([EmailQueueID])
GO

ALTER TABLE [dbo].[tblEmailQueueLinkedResource] CHECK CONSTRAINT [FK_tblEmailQueueLinkedResource_tblEmailQueue]
GO

/* ------------------------------------------------------ */
