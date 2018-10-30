declare @BaseUserID int
set @BaseUserID = 245

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


--			User		Module	Q_Score	Q_Date		L_Done	L_Date
Exec prcImport_Result 	@UserID_A,  	1,  	79,  	'1 Jan 2005',  	1,  	'1 Jan 2005'	-- Case A
Exec prcImport_Result 	@UserID_B,  	1,  	79,  	'1 Jan 1995',  	1,  	'1 Jan 2005'	-- Case B
Exec prcImport_Result 	@UserID_C,  	1,  	80,  	'1 Jan 2005',  	1,  	'1 Jan 2005'	-- Case C
Exec prcImport_Result   @UserID_D,  	1,  	80,  	'1 Jan 1995',  	1,  	'1 Jan 2005'	-- Case D
Exec prcImport_Result 	@UserID_E,  	1,  	81,  	'1 Jan 2005',  	1,  	'1 Jan 2005'	-- Case E
Exec prcImport_Result 	@UserID_F,  	1,  	81,  	'1 Jan 1995',  	1,  	'1 Jan 2005'	-- Case F
Exec prcImport_Result 	@UserID_G,  	1,	null,  	null,  		1,  	'1 Jan 2005'	-- Case G
Exec prcImport_Result 	@UserID_H,  	1,  	79,	'1 Jan 2005', 	1,  	'1 Jan 1995'	-- Case H
Exec prcImport_Result 	@UserID_I,  	1,  	79,  	'1 Jan 1995',  	1,  	'1 Jan 1995'	-- Case I
Exec prcImport_Result 	@UserID_J,  	1,  	80,  	'1 Jan 2005',  	1,  	'1 Jan 1995'	-- Case J
Exec prcImport_Result 	@UserID_K,  	1,  	80,  	'1 Jan 1995',  	1,  	'1 Jan 1995'	-- Case K
Exec prcImport_Result 	@UserID_L,  	1,  	81,  	'1 Jan 2005',  	1,  	'1 Jan 1995'	-- Case L
Exec prcImport_Result 	@UserID_M,  	1,  	81,  	'1 Jan 1995',  	1,  	'1 Jan 1995'	-- Case M
Exec prcImport_Result 	@UserID_N,  	1,  	null,  	null,  		1,  	'1 Jan 1995'	-- Case N
Exec prcImport_Result 	@UserID_O,  	1,  	79,  	'1 Jan 2005',  	null,	null		-- Case O
Exec prcImport_Result 	@UserID_P,  	1,  	79,  	'1 Jan 1995',  	null,	null		-- Case P
Exec prcImport_Result 	@UserID_Q,  	1,  	80,  	'1 Jan 2005',  	null,	null		-- Case Q
Exec prcImport_Result 	@UserID_R,  	1,  	80,  	'1 Jan 1995',  	null,	null		-- Case R
Exec prcImport_Result 	@UserID_S,  	1,  	81,  	'1 Jan 2005',  	null,	null		-- Case S
Exec prcImport_Result 	@UserID_T,  	1,  	81,  	'1 Jan 1995',  	null,	null		-- Case T
Exec prcImport_Result 	@UserID_U,  	1,  	null,  	null,  		null,	null		-- Case U


