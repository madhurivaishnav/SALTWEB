<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="UnitManagement.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.UnitManagement" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <style:style id="ucStyle" runat="server"></style:style>
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
        <script language="JavaScript">
			function MovingConfirm()
			{
				var permissionConfirm;
				
				permissionConfirm = confirm(ResourceManager.GetString("permissionConfirm"));
				if (!permissionConfirm)
				{
					return false;
				}
				if (document.forms[0].chkTopLevel.checked)
				{
					return confirm(ResourceManager.GetString("unitConfirm"));
				}
				else
				{
					return true;
				}
									
			}		
        </script>
    </head>
    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
        <form id="Form1" method="post" runat="server">
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr valign="top" align="center" width="100%">
                    <td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr valign="top" align="left" height="100%" width="100%">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
                    <!-- Body/Content -->
                    <td class="DataContainer">
                        <Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Move Unit</Localized:Localizedlabel><br>
                        <Localized:Localizedlabel id="lblNoSubUnits" cssclass="FeedbackMessage" runat="server" visible="False">There are no sub-units</Localized:Localizedlabel>
                        <asp:placeholder id="plhMainscreen" runat="server">
                            <table width="100%" align="left" border="0">
                                <tr>
                                    <td align="center" colspan="3">
                                        <asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="formLabel"><b><Localized:LocalizedLabel id="lblFrom" runat="server"></Localized:LocalizedLabel></b><br></td>
                                    <td>&nbsp;</td>
                                    <td class="formLabel">
                                        <b><Localized:LocalizedLabel id="lblTo" runat="server"></Localized:LocalizedLabel></b>
                                        <br>
                                        <Localized:Localizedcheckbox id="chkTopLevel" runat="server" text="Top Level"></Localized:Localizedcheckbox>
                                    </td>
                                </tr>
                                <tr>
                                    <td  valign="top">
                                        <cc1:treeview id="trvFromUnit" runat="server" 
                                            systemimagespath="/General/Images/TreeView/" nodetext="Unit"
                                            outputstyle="SingleSelection"></cc1:treeview>
                                    </td>
                                    <td valign="top" align="center">
                                        <Localized:Localizedbutton id="btnMove" runat="server" cssclass="moveButton" text="Move >>" onclick="btnMove_Click"></Localized:Localizedbutton>
                                    </td>
                                    <td valign="top">
                                        <cc1:treeview id="trvToUnit" runat="server" systemimagespath="/General/Images/TreeView/" nodetext="Unit"
                                            outputstyle="SingleSelection"></cc1:treeview>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3"><a href="/Administration/AdministrationHome.aspx"><Localized:LocalizedLiteral id="lnkReturn" key="cmnReturn"  runat="server"></Localized:LocalizedLiteral></a>
                                    </td>
                                    
                                </tr>
                            </table>
                        </asp:placeholder>
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
