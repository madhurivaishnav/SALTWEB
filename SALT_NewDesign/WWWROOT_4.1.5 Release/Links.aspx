<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>

<%@ Page Language="c#" CodeBehind="Links.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Links" %>

<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <form id="frmLinks" method="post" runat="server">
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <!--tbody-->
        <!-- Header -->
        <tr>
            <td valign="top">
                <table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                    <tr valign="top" align="center" width="100%">
                        <td valign="top" align="center" width="100%">
                            <navigation:header id="ucHeader" runat="server">
                            </navigation:header>
                        </td>
                    </tr>
                </table>
                <!-- Body/Content -->
                <table width="100%" height="80%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class="AdminMenuContainer"><div style="width:295px;">&nbsp;</div>
                        </td>
                        <td valign="top" class="DataContainer" >
                            <table width="100%%" align="left" border="0">
                                <!-- Body/Conent -->
                                <tr>
                                    <td>
                                        <Localized:LocalizedLabel ID="lblPageTitle" CssClass="pageTitle" runat="server">Links</Localized:LocalizedLabel>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" align="left" border="0">
                                            <tr>
                                                <td>
                                                    <asp:Repeater ID="rptLinks" runat="server">
                                                        <ItemTemplate>
                                                            <tr class="tablerow1" valign="top" id="TableRow" runat="server">
                                                                <td width="20%">
                                                                    <asp:Label ID="lblCategory" runat="server">
									            <%# DataBinder.Eval(Container.DataItem, "Caption")%>
                                                                    </asp:Label>
                                                                </td>
                                                                <td align="left" class="module" valign="top">
                                                                    <!-- Link -->
                                                                    <asp:HyperLink runat="server" ID="lnkURL" Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "URL") %>'>
												<%# DataBinder.Eval(Container.DataItem, "Caption")%>
                                                                    </asp:HyperLink>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table width="100%" align="right" border="0">
                    <!-- Footer -->
                    <tr valign="bottom" align="center">
                        <td valign="middle" align="center" colspan="2">
                            <navigation:footer id="ucFooter" runat="server">
                            </navigation:footer>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
