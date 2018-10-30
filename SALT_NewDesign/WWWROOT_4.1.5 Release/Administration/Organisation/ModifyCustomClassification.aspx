<%@ Page language="c#" Codebehind="ModifyCustomClassification.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.ModifyCustomClassification" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
        <meta name="CODE_LANGUAGE" content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
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
			function disableConfirm()
			{
				return confirm(ResourceManager.GetString("ConfirmMessage"));
			}
        </script>
    </head>
    <body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
        <form id="frmModifyLinks" method="post" runat="server">
            <table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
                <!-- Header -->
                <tr align="center" valign="top" width="100%">
                    <td align="center" valign="top" width="100%" colspan="2">
                        <navigation:header id="ucHeader" runat="server"></navigation:header>
                    </td>
                </tr>
                <tr height="100%" align="left" valign="top">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer">
                        <navigation:adminmenu runat="server" id="ucAdminMenu"></navigation:adminmenu>
                    </td>
                    <!-- Body/Conent -->
                    <td width="100%">
                        <asp:label id="lblPageTitle" cssclass="pageTitle" runat="server">Modify Clasification Options (For Grouping Users)</asp:label><br>
                        <table align="left" border="0" width="80%">
                            <tr>
                                <td>
                                    <asp:label runat="server" id="lblMessage"></asp:label>
                                    <table cellspacing="0" rules="all" border="1" width="100%" style="BORDER-COLLAPSE:collapse">
                                        <tr class="tablerowtop">
                                            <td colspan="2">
												<Localized:LocalizedLabel id="lblAddValue" runat="server"></Localized:LocalizedLabel>
                                            </td>
                                        </tr>
                                        <tr class="tablerow1">
                                            <td width="30%"><Localized:LocalizedLabel id="lblValue" runat="server"></Localized:LocalizedLabel></td>
                                            <td width="70%">
                                                <asp:textbox id="txtValue" runat="server" maxlength="100" width="95%"></asp:textbox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <Localized:Localizedbutton id="btnAdd" runat="server" text="Add Value" cssclass="addButton" onclick="btnAdd_Click"></Localized:Localizedbutton>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- Pagination -->
                                    <table id="tblPagination" width="100%" align="left" border="0" runat="server">
                                        <tbody>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:datagrid id="grdPagination" runat="server" width="100%" autogeneratecolumns="False" allowsorting="True"
                                                        allowpaging="True">
                                                        <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                                                        <itemstyle cssclass="tablerow2"></itemstyle>
                                                        <columns>
                                                            <asp:templatecolumn headertext="Classification Value" visible="true" itemstyle-width="80%">
                                                                <headerstyle cssclass="tablerowtop" width="250" height="25"></headerstyle>
                                                                <itemtemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "Value").ToString()%>
                                                                </itemtemplate>
                                                                <edititemtemplate>
                                                                    <asp:textbox runat="server" id="txtName" textmode="SingleLine" maxlength="50" text='<%# DataBinder.Eval(Container.DataItem, "Value").ToString()%>'>
                                                                    </asp:textbox>
                                                                </edititemtemplate>
                                                            </asp:templatecolumn>
                                                            <asp:templatecolumn headertext="Active" visible="true">
                                                                <headerstyle cssclass="tablerowtop" width="50" height="25"></headerstyle>
                                                                <itemtemplate>
                                                                    <asp:checkbox runat="server" id="chkActiveDisabled" checked='<%# DataBinder.Eval(Container.DataItem, "Active")%>' enabled="False">
                                                                    </asp:checkbox>
                                                                </itemtemplate>
                                                                <edititemtemplate>
                                                                    <asp:checkbox runat="server" id="chkActiveEnabled" checked='<%# DataBinder.Eval(Container.DataItem, "Active")%>' enabled="True" >
                                                                    </asp:checkbox>
                                                                </edititemtemplate>
                                                            </asp:templatecolumn>
                                                            <asp:editcommandcolumn buttontype="LinkButton" updatetext="Update" canceltext="Cancel" edittext="Modify"
                                                                headerstyle-cssclass="tablerowtop" headertext="Action" headerstyle-width="50"></asp:editcommandcolumn>
                                                        </columns>
                                                        <pagerstyle mode="NumericPages" position="Bottom"></pagerstyle>
                                                    </asp:datagrid></td>
                                            </tr>
                                        </tbody>
                                        <tr>
                                            <td colspan="3">
                                                <Localized:Localizedlinkbutton runat="server" id="lnkReturnToOrgAdmin" text="Return to Organisation Administration" onclick="lnkReturnToOrgAdmin_Click"></Localized:Localizedlinkbutton>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- Pagination -->
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- Footer -->
                <tr align="center" valign="bottom">
                    <td align="center" valign="middle" colspan="2">
                        <navigation:footer id="ucFooter" runat="server"></navigation:footer>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
