<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PublishAdaptive.aspx.cs"
    Inherits="Bdw.Application.Salt.Web.ContentAdministration.Adaptive.PublishAdaptive" %>

<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head runat="server">
    <title id="pagTitle" runat="server"></title>
    <Style:style id="ucStyle" runat="server">
    </Style:style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <form id="frmAdaptiveCourse" method="post" runat="server">
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <!-- Header -->
        <tr valign="top" align="center" width="100%">
            <td valign="top" align="center" width="100%" colspan="2">
                <navigation:header id="ucHeader" runat="server">
                </navigation:header>
            </td>
        </tr>
        <tr valign="top" align="left" height="100%">
            <!-- Left Navigation -->
            <td class="AdminMenuContainer">
                <navigation:adminmenu id="ucAdminMenu" runat="server">
                </navigation:adminmenu>
            </td>
            <!-- Body/Content -->
            <td class="DataContainer">
                <Localized:LocalizedLabel ID="lblPageTitle1" runat="server">Publish Adaptive Content</Localized:LocalizedLabel><br />
                <table width="80%" border="0">
                    <tr>
                        <td>
                        Course Name
                        </td>
                        <td>
                            <asp:DropDownList ID="cboCourses" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                    <td>
                        Browse Salt Course
                        </td>
                        <td>
                         <input class="browseButton" id="inputFile" type="file" name="inputFile" runat="server">
                                    <Localized:LocalizedRequiredFieldValidator ID="rfvFile" runat="server" ErrorMessage="<br/>Select a file to upload"
                                        ControlToValidate="inputFile"></Localized:LocalizedRequiredFieldValidator>
                        </td>
                        
                    </tr>
                    <tr>
                    <td colspan=2 style="text-align:center;">
                        <asp:Button ID="btnPublish" runat="server" Text="Publish" 
                            onclick="btnPublish_Click" />
                             <asp:Label ID="lblUploadMessage" runat="server"></asp:Label>
                    </td>
                    </tr>
                </table>
            </td>
        </tr>
        <!-- Footer -->
        <tr valign="bottom" align="center">
            <td valign="middle" align="center" colspan="2">
                <navigation:footer id="ucFooter" runat="server">
                </navigation:footer>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
