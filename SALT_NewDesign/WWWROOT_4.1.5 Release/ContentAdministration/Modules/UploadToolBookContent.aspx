<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="UploadToolBookContent.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ContentAdministration.Modules.UploadToolBookContent" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    </head>
    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout"
        onload="document.frmUploadNewContent.txtLocation.focus();">
        <form id="frmUploadNewContent" method="post" runat="server">
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="left" border="0">
                <!-- Header -->
                <tr valign="top" align="center" width="100%">
                    <td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr valign="top" align="left" height="100%">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
                    <!-- Body/Conent -->
                    <td class="DataContainer">
                        <Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Upload Content</Localized:Localizedlabel><br>
                        <table width="95%" align="left" border="0">
                            <tr>
                                <td class="formLabel"><Localized:LocalizedLabel id="lblNewLocation" runat="server"></Localized:LocalizedLabel>&nbsp;</td>
                                <td ><br><asp:textbox id="txtLocation" runat="server" width="80%" maxlength="200"></asp:textbox><Localized:Localizedrequiredfieldvalidator id="rvldName" runat="server" errormessage="You must enter a location to continue."
                                        controltovalidate="txtLocation" cssclass="ValidatorMessage"></Localized:Localizedrequiredfieldvalidator>
                                        
                                         <input class="browseButton" id="inputFile" type="file" name="inputFile" runat="server" visible="false">
                                    <Localized:LocalizedRequiredFieldValidator ID="rfvFile" runat="server" ErrorMessage="<br/>Select a file to upload"
                                        ControlToValidate="inputFile"></Localized:LocalizedRequiredFieldValidator>
                                        
                                        </td>
                                
                               
                               
                                <td>
                                    <asp:listbox id="lstUploads" runat="server" datatextfield="title" datavaluefield="launchpoint" selectionmode="Single"  Height="0px" Width="0px" AutoPostBack="true" OnTextChanged ="lstUploads_SelectedIndexChanged"></asp:listbox>
                                </td>
                            </tr>
                            <tr>
                                <td class="formLabel"><Localized:LocalizedLabel id="lblNewContent" runat="server"></Localized:LocalizedLabel>&nbsp;</td>
                                <td>
                                    <asp:radiobutton id="radInfoPath" checked="True" groupname="radType" runat="server" text="InfoPath" OnCheckedChanged="radSCORM_checkedChanged" AutoPostBack="True"/>
                                    <asp:radiobutton id="radToolbook" groupname="radType" runat="server" text="Toolbook" OnCheckedChanged="radSCORM_checkedChanged" AutoPostBack="True"/>
                                    <asp:radiobutton id="radSCORM" groupname="radType" runat="server" text="Lectora"   OnCheckedChanged="radSCORM_checkedChanged" AutoPostBack="True"/>
                                    <asp:radiobutton id="radAdaptive" groupname="radType" runat="server" text="Adaptive" Style="display:block;"   OnCheckedChanged="radSCORM_checkedChanged" AutoPostBack="True"/>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top"><Localized:LocalizedLabel id="lblDetails" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td>
                                    
                                    <Localized:LocalizedLabel id="lblFormatInstruction" runat="server"></Localized:LocalizedLabel>
                                    <br>
                                    <asp:label id="lblHint" runat="server" cssclass="formLabel"></asp:label><i>\DirectoryName</i>
                                    <br>
                                    <br>
                                    
                                    <Localized:LocalizedLabel id="lblFormatInstruction2" runat="server"></Localized:LocalizedLabel>
                                    <br>
                                    <asp:label id="lblHintExample" runat="server" cssclass="formLabel"></asp:label><i>\UpdatedContent</i>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <Localized:Localizedbutton cssclass="uploadButton" id="btnUpload" runat="server" text="Upload" onclick="btnUpload_Click"></Localized:Localizedbutton>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <Localized:Localizedlinkbutton runat="server" id="lnkReturnToModuleDetails" text="Return to Module Details"
                                        causesvalidation="False" onclick="lnkReturnToModuleDetails_Click"></Localized:Localizedlinkbutton>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- Footer -->
                <tr valign="bottom" align="center">
                    <td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
                </tr>
            </table>
        </form>
    </body>
</html>
