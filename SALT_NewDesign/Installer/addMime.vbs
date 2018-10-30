
'**************************************
' Name:			addMime.vbs
' Author:		Stephen Clark
' Created:		30 - April - 2004	
' Description:		Adds new MIME-types to IIS
' Called By:		deployment package
' Calls:		MS Axtive x objects and IIS
' Parameters:		none
'''''''''''''''''''''''''''''''''''''''''''''
' Modification History
'	Modified By:
'	Date:
'	Reason:
'	Reference:
'	Changes Made:
'	Efect:
'****************************************/
'On Error Resume Next


'===================================================================
' Variables
'===================================================================
Dim objMIME, arrMimeMap, oFS, strPath, LogFile


'===================================================================
' Constants
'===================================================================
Const ADS_PROPERTY_UPDATE=2
Const RETRIES = 2
Const errPathBusy = &H80070094


x=MsgBox("Do you wish to add MIME TYPES to IIS for .dhtml, .script and .* (application/octet-stream)",292,"add MIME TYPES")
 if 6=x Then
	'===================================================================
	' Create LogFile
	'===================================================================
	Set oFS = CreateObject("Scripting.FileSystemObject")
	strPath = oFS.BuildPath(".", "IIS_mimelog.txt")
	Set LogFile = oFS.OpenTextFile(strPath, 8, True)

	LogFile.writeLine "---- addMime.vbs log script run " & now()

	'===================================================================
	' Create MIMEmap object 
	'===================================================================
	Set objMIME = GetObject("IIS://LocalHost/MimeMap") 
	If Err.Number <> 0 Then
		DumpError "Failed get object 'IIS://localhost/MimeMap'"	
	End If

	'===================================================================
	' Get the current mappings from the MimeMap property 
	'===================================================================
	arrMimeMap = objMIME.GetEx("MimeMap") 
	If Err.Number <> 0 Then
		DumpError "Failed get property objMIME.GetEx(MimeMap)"
	End If

	' write the current mappings out to a file for recovery if there is a problem
	ShowMM objMIME, "Origional Mapping </br>"


	'===================================================================
	' Add a new MIME-type 
	'===================================================================

	call AddMime(".dhtml","application/octet-stream")
	call AddMime(".script","application/octet-stream")
	call AddMime(".*","application/octet-stream")

	' write the current mappings out to a file for recovery if there is a problem
	ShowMM objMIME, "Final Mapping </br>"
	' end of script

End If
'===================================================================
' Sub
' newMIME : Associated Extension
' newtype : Content Type (MIME)
'===================================================================
sub AddMime(newMIMEExtension,newtype)
	on error resume next
	Dim i, iRetry, iRetries, bMimeExistsWithDifferentEtn
	bMimeExistsWithDifferentEtn = false

	

	' check the existing mime types
	For Each objType in arrMimeMap
	    if trim(objType.Extension) = newMIMEExtension  then
		if trim(objType.MimeType) = newtype then
			' the type already exists - no need to add it
			LogFile.writeLine "the mime '" + objType.MimeType + "' already exists for extn: '" + objType.Extension + "'. It has not been changed<br />"
			exit sub
		else
			bMimeExistsWithDifferentEtn  = true
			LogFile.writeLine "the mime '" + objType.MimeType + "' already exists for extn: '" + objType.Extension + " ', it has not been updated to the required type:'" + newtype + "'. Plese review if this is appropriate for this server.<br />"
			msgbox "--------------------------------------------------------" & vbcrlf & _
				"     The deployment package has detected a problem." & vbcrlf & _
				" A mime type in IIS is not of the appropriate encoding" & vbcrlf & _
				"--------------------------------------------------------" & vbcrlf & _
				"--                   Details                          --" & vbcrlf & _
				"--------------------------------------------------------" & vbcrlf & _
				"Files with the extention: " & objType.Extension  & vbcrlf & _
				"Are presently associated with Mime: " & objType.MimeType  & vbcrlf & _
				"For the application to work it needs to be: " & newtype  & vbcrlf & _
				"This install will not overwite the existing type " & vbcrlf & _
				"But it is unlikly that the application will work unless" & vbcrlf & _
				"the mime is manually edited by a sysadmin." & vbcrlf & _
				"--------------------------------------------------------"
			
		end if
	    end if
	Next

''''''''''' Uncomment to alow modification of existing mime types -- i.e. do not uncomment
'	if bMimeExistsWithDifferentEtn then
'		dim aMimeMapNew() 
'		i = 0 
'	 	For Each MMItem in arrMimeMap
'		    If MMItem.Extension <> newMIMEExtension Then 
'    			 Redim Preserve aMimeMapNew(i) 
'      		 	 Set aMimeMapNew(i) = CreateObject("MimeMap") 
'      		 	 aMimeMapNew(i).Extension = objMimeMa.Extension 
'      			 aMimeMapNew(i).MimeType = objMimeMa.MimeType 
'			 i = i + 1 
'		    End If 
'		Next 
' 		arrMimeMap.PutEx ADS_PROPERTY_UPDATE, "MimeMap", aMimeMapNew 
'		arrMimeMap.SetInfo
'	end if
'
	if not bMimeExistsWithDifferentEtn then '<<<< comment to alow modification of existing mime types

	    i=UBound(arrMimeMap)+1
	    If Err.Number <> 0 Then
		    DumpError "Failed to get ubound of arrMimeMap Collection"
		    Exit sub
	    End If
    	
	    Redim Preserve arrMimeMap(i) 
    	
	    Set arrMimeMap(i)=CreateObject("MimeMap") 

	    If Err.Number <> 0 Then
		    DumpError "Failed add object CreateObject(MimeMap) to mime map collection"
		    exit sub
	    End If

	    arrMimeMap(i).Extension = newMIMEExtension

	    If Err.Number <> 0 Then
		    DumpError "Failed add new extention '" + newMIMEExtension + "' to mimemap"
		    exit sub
	    End If

	    arrMimeMap(i).MimeType = newtype 

	    If Err.Number <> 0 Then
		    DumpError "Failed to add new type '" + newtype + "' to mimemap"
		    exit sub
	    End If

	    objMIME.PutEx ADS_PROPERTY_UPDATE,"MimeMap",arrMimeMap

	    If Err.Number <> 0 Then
		    DumpError "Failed to objMIME.PutEx"
		    exit sub
	    End If


	    iRetry = 0
	    Do
		    Err.Clear
		    objMIME.SetInfo
		    iRetry = iRetry + 1
	    Loop While Err.Number = errPathBusy And iRetry <= RETRIES


	    If Err.Number <> 0 Then
		    DumpError "Failed to objMIME.SetInfo"
		    exit sub
	    else
		    LogFile.writeLine "the mime '" + newtype  + "' was added for for extn: '" + newMIMEExtension
	    End If

	end if '<<<< comment to alow modification of existing mime types

	err.clear
end sub


'===================================================================
' Subroutine to display the mappings in a table. 
'===================================================================
 Sub ShowMM(MMObj, strMessage)
	 LogFile.writeLine strMessage
	 aMM = MMObj.GetEx("MimeMap") 
	'Set up table to display mappings. 
	  LogFile.writeLine "<HR><TABLE BORDER><CAPTION><B>" + strMessage + "</B></CAPTION>" 
	  LogFile.writeLine "<TR><TH>Type</TH><TH>Extension</TH>" 
	'Display the mappings in the table. 
	  For Each MM in aMM 
	    LogFile.writeLine "<TR><TD>" & MM.MimeType & "</TD>" 
	    LogFile.writeLine "<TD>" & MM.Extension & "</TD></TR>" 
	  Next 
	  LogFile.writeLine "</TABLE>"
 End Sub 


'===================================================================
' Sub DumpError
' newMIME : Associated Extension
' newtype : Content Type (MIME)
'===================================================================
sub DumpError(Text)
	Dim str, num, strDesc, oFS
	num = Err.Number
	strDesc = Err.Description
	On Error Resume Next
	if not isobject(LogFile) then
		Set oFS = CreateObject("Scripting.FileSystemObject")
		strPath = oFS.BuildPath(".", "IIS_mimelog.txt")
		Set LogFile = oFS.OpenTextFile(strPath, 8, True)
	end if
	str = Text & " -- Error Number=" & Hex(num) & " (" & num & ")  String=" & strDesc
	If IsObject(LogFile) Then LogFile.writeLine str
	Err.Clear
End Sub
 


