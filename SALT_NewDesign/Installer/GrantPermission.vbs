'1. Get The Process User Name
x=MsgBox("Do you wish to grant a Windows security account (user) Permission to access the directories of the SALT Website",292,"IIS Directory Permissions")
 if 6=x Then
strUser =""
While strUser ="" 
	strUser  = InputBox ("Typically for Windows Server 2003 and 2008 it is ""Network Service"".", "Enter the windows security account that runs SALT ", "")
	strUser  = Trim(strUser)
	If strUser ="" Then
		MsgBox "The account name is required for installation", 48,"Error"
	End If
Wend

'2. Get The website root from customActionData
strRoot  = property("CustomActionData")
'MsgBox("About to modify permissions under the path: "+strRoot)


'3. Grant Change permission to the 4 folders
'MsgBox("About to modify permissions under the path: "+strRoot+"General\Images\Header")
GrantPermission strRoot+"General\Images\Header", strUser

'MsgBox("About to modify permissions under the path: "+strRoot+"General\ToolBook\Content")
GrantPermission strRoot+"General\ToolBook\Content", strUser

'MsgBox("About to modify permissions under the path: "+strRoot+"General\UploadedFile")
GrantPermission strRoot+"General\UploadedFile", strUser

'MsgBox("About to modify permissions under the path: "+strRoot+"General\Errors")
GrantPermission strRoot+"General\Errors", strUser

'MsgBox("About to modify permissions under the path: "+strRoot+"General\InfoPath\Publishing")
GrantPermission strRoot+"General\InfoPath\Publishing", strUser

'MsgBox("Success!")

End If


sub GrantPermission(strDirectoryPath, strUser)

dim strCommand       ' used to hold the command string to be executed
dim intReturnValue   ' captures the return values
dim strErrorMessage  ' for the error message should it be needed

    ' Window script object used to issue commands
	Set objWSH = CreateObject("WScript.Shell")
	
	' cacls with the /E /T /G switches will attempt to grant the user permissions
	' to the desired folder and all subdirectories
	' The :C on the end says that we wish to add the 'Change' permission which
	' effectively gives us Create/Read/Write/Modify abilities.
	strCommand = "cacls " + """" + strDirectoryPath + """" + " /E /T /P """ + strUser + """:C"
	
	' Run the command
	intReturnValue = objWSH.Run (strCommand, 0, true)
	if intReturnValue <> 0 then
		strErrorMessage=                    "Error while attempting to update directory permissions" + vbcrlf
		strErrorMessage = strErrorMessage + "Directory path: '" + strDirectoryPath + "'" + vbcrlf
		strErrorMessage = strErrorMessage + "User: '" + strUser + "'" + vbcrlf
		strErrorMessage = strErrorMessage + "Error Code: '" + cstr(intReturnValue) + "'"
		msgbox(strErrorMessage)
	end if
end sub


