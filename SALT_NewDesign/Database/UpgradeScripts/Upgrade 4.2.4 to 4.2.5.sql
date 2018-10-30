
/*  Fix for defect #77694 Email Queue not deleted issue Date: 18/06/2012 */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblEmailQueueLinkedResource_tblEmailQueue]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblEmailQueueLinkedResource]'))
ALTER TABLE [dbo].[tblEmailQueueLinkedResource] DROP CONSTRAINT [FK_tblEmailQueueLinkedResource_tblEmailQueue]
GO

/* ------------------------------------------------------ */
 