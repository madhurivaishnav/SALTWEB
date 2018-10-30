<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="CourseAccess.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.CourseAccess" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>

<HTML>
  <HEAD>
        <title runat="server" id=pagTitle></title>
        <Style:Style id="ucStyle" runat="server"></Style:Style>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </HEAD>
    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout" onload="try{document.frmCourseAccess.btnSave.focus();}catch(e){};">
        <form id="frmCourseAccess" method="post" runat="server">
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr valign="top" align="center" width="100%">
                    <td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr valign="top" align="left" height="100%">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
                    <!-- Body/Conent -->
                     <td class="DataContainer">
                        <Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Course Access</Localized:Localizedlabel><br>
                        <table align="left" border="0" width="100%">
                            <tr>
                                <td>
                                    <!-- Pagination -->
                                    <table width="95%" align="left" border="0">
                                        <tbody>
                                            <tr>
                                                <td align="left" colspan="2">
                                                    <asp:datagrid id="dtgCourse" runat="server" width="100%" autogeneratecolumns="false" borderstyle="Solid">
                                                        <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                                                        <itemstyle cssclass="tablerow2"></itemstyle>
                                                        <columns>
                                                            <asp:boundcolumn datafield="Name" headertext="Course Name">
                                                                <headerstyle cssclass="tablerowtop" width="250" height="25"></headerstyle>
                                                            </asp:boundcolumn>
                                                            <asp:templatecolumn headertext="Allow Access">
                                                                <headerstyle cssclass="tablerowtop" width="100" height="25"></headerstyle>
                                                                <itemstyle horizontalalign="Center"></itemstyle>
                                                                <itemtemplate>
                                                                    <input type="checkbox" name="chkGrantedCourse" value='<%# DataBinder.Eval(Container, "DataItem.CourseID") %>' <%# GetGrantStatus(DataBinder.Eval(Container, "DataItem.Granted")) %>>
                                                                </itemtemplate>
                                                            </asp:templatecolumn>
                                                        </columns>
                                                    </asp:datagrid></td>
                                            </tr>
                                            <tr><td>&nbsp;</td></tr>
                                            <tr>
                                                <td>
                                                    <Localized:Localizedbutton cssclass="saveButton" id="btnSave" key="cmnSave"  runat="server" text="Save" onclick="btnSave_Click"></Localized:Localizedbutton>
                                                    <asp:label runat="server" id="lblMessage" enableviewstate="False"></asp:label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <a href="/Administration/AdministrationHome.aspx"><Localized:LocalizedLiteral id="lnkReturn" key="cmnReturn"  runat="server"></Localized:LocalizedLiteral></a>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
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
        </form></FORM>
    </body>
</HTML>
