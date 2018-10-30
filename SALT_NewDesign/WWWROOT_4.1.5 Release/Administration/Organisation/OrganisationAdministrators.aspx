<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="OrganisationAdministrators.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.OrganisationAdministrators" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
    <HEAD>
        <title id="pagTitle" runat="server"></title>
        <Style:Style id="ucStyle" runat="server"></Style:Style>
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
			function removeConfirm(strName)
			{
			    return confirm(ResourceManager.GetString("RemoveConfirm", strName));
			}
        </script>
    </HEAD>
    <body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
        <form id="frmOrgAdmins" method="post" runat="server">
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
                    <td class="DataContainer">
                        <Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Organisation Administrators</Localized:Localizedlabel><br>
                        <table align="left" border="0">
                            <tr>
                                <td>
                                    <asp:label runat="server" id="lblMessage" enableviewstate="False"></asp:label>
                                    <!-- Pagination -->
                                    <table id="tblPagination" width="95%" align="left" border="0" runat="server">
                                        <tbody>
                                            <tr>
                                                <td colspan="2"><asp:datagrid id="grdPagination" runat="server" allowpaging="True" pagesize="3" autogeneratecolumns="False"
                                                        width="100%" borderstyle="Solid" allowsorting="False">
                                                        <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                                                        <itemstyle cssclass="tablerow2"></itemstyle>
                                                        <columns>
                                                            <asp:templatecolumn headertext="First Name" visible="true">
                                                                <headerstyle cssclass="tablerowtop" width="200"></headerstyle>
                                                                <itemtemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "FirstName").ToString()%>
                                                                </itemtemplate>
                                                            </asp:templatecolumn>
                                                            <asp:templatecolumn headertext="Last Name" visible="true">
                                                                <headerstyle cssclass="tablerowtop" width="200"></headerstyle>
                                                                <itemtemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "LastName").ToString()%>
                                                                </itemtemplate>
                                                            </asp:templatecolumn>
                                                            <asp:templatecolumn headertext="Email" visible="true">
                                                                <headerstyle cssclass="tablerowtop" width="300"></headerstyle>
                                                                <itemtemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "Email").ToString()%>
                                                                </itemtemplate>
                                                            </asp:templatecolumn>
                                                            <asp:buttoncolumn text="Remove" buttontype="LinkButton" commandname="Remove" headerstyle-cssclass="tablerowtop" headertext="Remove Administrator" headerstyle-width="100"></asp:buttoncolumn>
                                                        </columns>
                                                        <pagerstyle visible="False"></pagerstyle>
                                                    </asp:datagrid></td>
                                            </tr>
                                            <tr id="trPagination" runat="server">
                                                <td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                                </td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
                                            </tr>
										</tbody>
                                        <tr>
                                            <td colspan="2">
                                                <Localized:Localizedlinkbutton runat="server" id="lnkAddOrganisationAdministrator" text="Add Organisation Administrator" onclick="lnkAddOrganisationAdministrator_Click"></Localized:Localizedlinkbutton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a href="/Administration/AdministrationHome.aspx"><Localized:LocalizedLiteral id="lnkReturn" key="cmnReturn"  runat="server"></Localized:LocalizedLiteral></a>
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
</HTML>
