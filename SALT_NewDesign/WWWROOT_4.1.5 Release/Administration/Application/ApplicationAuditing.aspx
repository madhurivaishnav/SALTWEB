<%@ Page language="c#" Codebehind="ApplicationAuditing.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.ApplicationAuditing" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
    <HEAD>
        <title id="pagTitle" runat="server"></title>
        <Style:Style id="ucStyle" runat="server"></Style:Style>
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<script language="javascript">
		//This must be placed on each page where you want to use the client-side resource manager
		var ResourceManager = new RM();
		function RM()
		{
		this.list = new Array();
		};
		RM.prototype.AddString = function(key, value)
		{
		this.list[key] = value;
		};
		RM.prototype.GetString = function(key)
		{
		var result = this.list[key];  
		for (var i = 1; i < arguments.length; ++i)
		{
			result = result.replace("{" + (i-1) + "}", arguments[i]);
		}
		return result;
		};
		</script>
        <script language="javascript">
		<!--
			function confirmUpdateModuleStatus() {
				return confirm(ResourceManager.GetString("ConfirmMessage"));
			}
		// -->
        </script>
    </HEAD>
    <body bottomMargin="0" leftMargin="0" topMargin="0" onload="document.frmApplicationAuditing.btnRunModuleStatusUpdate.focus();"
        rightMargin="0" ms_positioning="FlowLayout">
        <form id="frmApplicationAuditing" method="post" runat="server">
            <table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr vAlign="top" align="center" width="100%">
                    <td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr vAlign="top" align="left" height="100%">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
                    <!-- Body/Conent -->
                     <td class="DataContainer"><Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Application Auditing</Localized:Localizedlabel><br>
                        <table width="100%" align="left" border="0">
                            <tr>
                                <td class="formLabel" colSpan="2"><b><Localized:LocalizedLabel id="lblModuleStatusUpdate" runat="server"></Localized:LocalizedLabel></b>
                                </td>
                            </tr>
                            <tr>
                                <td class="formLabel"><Localized:LocalizedLabel id="lblLastRun" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td><asp:label id="lblModuleStatusUpdateLastRun" runat="server"></asp:label></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><Localized:Localizedbutton id="btnRunModuleStatusUpdate" visible="false" runat="server" cssclass="runButton" text="Run now" onclick="btnRunModuleStatusUpdate_Click"></Localized:Localizedbutton></td>
                            </tr>
                            <tr>
                                <td class="formLabel"><Localized:LocalizedLabel id="lblSqlagentStatus" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td><asp:label id="lblSqlAgentRunningStatus" runat="server">&nbsp;</asp:label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- Footer -->
                <tr vAlign="bottom" align="center">
                    <td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
                </tr>
            </table>
        </form>
    </body>
</HTML>
