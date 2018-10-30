if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prcTestData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prcTestData]
GO

Create Procedure prcTestData
	@BaseUserID int
as
	Print ''
	Print '--------------------------------'
	Print '- Begin importing test data    -'
	Print '--------------------------------'
	Print ''
	

truncate table [Salt_Migration].[dbo].[tblExtract]



-- Create module translation
Declare @ModuleID int
set @ModuleID = 2

Declare @UserID_A  int
Declare @UserID_B  int
Declare @UserID_C  int
Declare @UserID_D  int
Declare @UserID_E  int
Declare @UserID_F  int
Declare @UserID_G  int
Declare @UserID_H  int
Declare @UserID_I  int
Declare @UserID_J  int
Declare @UserID_K  int
Declare @UserID_L  int
Declare @UserID_M  int
Declare @UserID_N  int
Declare @UserID_O  int
Declare @UserID_P  int
Declare @UserID_Q  int
Declare @UserID_R  int
Declare @UserID_S  int
Declare @UserID_T  int
Declare @UserID_U  int

Set @UserID_A = @BaseUserID 
Set @UserID_B = @BaseUserID + 1
Set @UserID_C = @BaseUserID + 2
Set @UserID_D = @BaseUserID + 3
Set @UserID_E = @BaseUserID + 4
Set @UserID_F = @BaseUserID + 5
Set @UserID_G = @BaseUserID + 6
Set @UserID_H = @BaseUserID + 7
Set @UserID_I = @BaseUserID + 8
Set @UserID_J = @BaseUserID + 9
Set @UserID_K = @BaseUserID + 10
Set @UserID_L = @BaseUserID + 11
Set @UserID_M = @BaseUserID + 12
Set @UserID_N = @BaseUserID + 13
Set @UserID_O = @BaseUserID + 14
Set @UserID_P = @BaseUserID + 15
Set @UserID_Q = @BaseUserID + 16
Set @UserID_R = @BaseUserID + 17
Set @UserID_S = @BaseUserID + 18
Set @UserID_T = @BaseUserID + 19
Set @UserID_U = @BaseUserID + 20


--														User	Module	Q_Score	Q_Date			L_Done	L_Date
INSERT INTO [Salt_Migration].[dbo].[tblExtract]		VALUES(@UserID_A,  	@ModuleID,  	79,  		'1 Jan 2005',  		1)	-- Case A
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_B,  	@ModuleID,  	79,  		'1 Jan 1995',  		1)	-- Case B
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_C,  	@ModuleID,  	80,  		'1 Jan 2005',  		1)	-- Case C
INSERT INTO [Salt_Migration].[dbo].[tblExtract]		VALUES(@UserID_D,  	@ModuleID,  	80,  		'1 Jan 1995',  		1)	-- Case D
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_E,  	@ModuleID,  	81,  		'1 Jan 2005',  		1)	-- Case E
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_F,  	@ModuleID,  	81,  		'1 Jan 1995',  		1)	-- Case F
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_G,  	@ModuleID,		null,  				null,  		1)	-- Case G
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_H,  	@ModuleID,  	79,			'1 Jan 2005', 		1)	-- Case H
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_I,  	@ModuleID,  	79,  		'1 Jan 1995',		1)	-- Case I
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_J,  	@ModuleID,  	80,  	'1 Jan 2005',  	1)			-- Case J
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_K,  	@ModuleID,  	80,  	'1 Jan 1995',  	1)			-- Case K
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_L,  	@ModuleID,  	81,  	'1 Jan 2005',  	1)			-- Case L
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_M,  	@ModuleID,  	81,  	'1 Jan 1995',  	1)			-- Case M
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_N,  	@ModuleID,  	null,  			null,  	1)			-- Case N
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_O,  	@ModuleID,  	79,  	'1 Jan 2005',  	0)			-- Case O
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_P,  	@ModuleID,  	79,  	'1 Jan 1995',  	0)			-- Case P
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_Q,  	@ModuleID,  	80,  	'1 Jan 2005',  	0)			-- Case Q
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_R,  	@ModuleID,  	80,  	'1 Jan 1995',  	0)			-- Case R
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_S,  	@ModuleID,  	81,  	'1 Jan 2005',  	0)			-- Case S
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_T,  	@ModuleID,  	81,  	'1 Jan 1995',  	0)			-- Case T
INSERT INTO [Salt_Migration].[dbo].[tblExtract] 	VALUES(@UserID_U,  	@ModuleID,  	null,  			null,  	0)			-- Case U


Print 'Loaded test user results into [tblExtract]'
	
	Print ''
	Print '--------------------------------'
	Print '- End importing test data    -'
	Print '--------------------------------'
	Print ''
	