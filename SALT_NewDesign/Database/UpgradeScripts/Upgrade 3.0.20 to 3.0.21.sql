 /*
 Here is the change list to database
There are also lots of other change in the Component, TreeViewControl, ReportViewerControl and web site project, you can get latest version and compile it
 
The DomainName is added to the system, all work fine according to the func spec, please do more tests.
 
Please call me if you have any questions.
 
Jack
 
 
Procedure:                                       
dbo.prcOrganisation_UpdateDomainName.PRC                                               
dbo.prcOrganisation_GetList.PRC                                                        
dbo.prcUser_Import.PRC                                                                 
dbo.prcUser_Update.PRC                                                                 
dbo.prcUser_Create.PRC                                                                 
dbo.prcUser_Login.PRC                                                                  
dbo.prcUser_LogLogin.PRC                                                               
dbo.prcUserCourseStatus_REMOVEDUPLICATESTATUS.PRC                                      
dbo.prcToolbook_Import.PRC                                                             
dbo.prcToolbook_Preview.PRC                                                            
dbo.prcQuizSession_BeforeStartQuiz.PRC                                                 
dbo.prcLessonSession_StartLesson.PRC                                                   
dbo.prcLessonSession_EndLesson.PRC                                                     
dbo.prcLessonSession_BeforeStartLesson.PRC                                             
dbo.prcReport_Trend.PRC                                                                
dbo.prcQuizSession_EndQuiz.PRC                                                         
dbo.prcUnit_Search.PRC                                                                 
dbo.prcUserQuizStatus_Update.PRC

Table:                                           
dbo.tblOrganisation.TAB: Add new file DomainName                                                                
dbo.tblUser.TAB: Change unique constraint to username + OrganisationID                                                                        
dbo.trgUserQuizStatus.TRG: remove transaction 
*/
-- These three scripts relate to making a username unique by organisation
-- bug ID 607
ALTER TABLE dbo.tblOrganisation ADD
	DomainName varchar(255) NULL
GO

DROP INDEX [dbo].[tblUser].[IX_tblUser_Username_Unique]
GO

CREATE  UNIQUE  INDEX [IX_tblUser_Username_Unique] 
 ON [dbo].[tblUser]([UserName], [OrganisationID]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO
