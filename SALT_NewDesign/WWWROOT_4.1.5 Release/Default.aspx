<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Import Namespace="Bdw.Application.Salt.Web.Utilities" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="navigation" TagName="usermenu" Src="/General/UserControls/Navigation/UserMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="OrgLogo" Src="/General/UserControls/Navigation/OrgLogo.ascx" %>

<%@ Page Language="c#" CodeBehind="Default.aspx.cs" Trace="false" AutoEventWireup="True"
    Inherits="Bdw.Application.Salt.Web.Default" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title runat="server" id="pagTitle"></title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <Style:STYLE id="ucStyle" runat="server">
    </Style:STYLE>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout"
    class="QuizHomePageBgColor">
    <form id="frmHome" method="post" runat="server">
    <!-- Header -->
    <table width="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
        <tr valign="top" align="center" width="100%">
            <td valign="top" align="center" width="100%">
                <navigation:header id="ucHeader" runat="server">
                </navigation:header>
            </td>
        </tr>
    </table>
    <!-- / Header -->
    <!-- Body/Content -->
    <table width="100%" height="80%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <tr>
            <td class="AdminMenuContainer">
                <navigation:UserMenu id="ucUserMenu" runat="server">
                </navigation:UserMenu>
            </td>
            <td valign="top" class="DataContainer" style="padding-right: 30px;">
                <table cellpadding="0" cellspacing="0" align="left" border="0" width="100%">
                    <tr>
                        <td style="min-height: 800px; height: 800px;" valign="top">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td width="90%">
                                        <table cellpadding="0" cellspacing="0" align="left" border="0">
                                            <tr>
                                                <td valign="top">
                                                    <div class="HomepageWelcome">
                                                        <Localized:LocalizedLabel ID="lblPageTitle" runat="server" CssClass="pageTitle">
                                                        </Localized:LocalizedLabel>
                                                        <asp:Label ID="lblHomepagePersonalisation" runat="server" CssClass="HomePageWelcome"></asp:Label>&nbsp;<asp:Label
                                                            ID="lblHomepageWelcome" runat="server" CssClass="HomePageWelcome"></asp:Label></div>
                                                    <!-- / home page welcome -->
                                                    <!-- Org Notes -->
                                                    <div class="orgNotes">
                                                        <asp:Label ID="lblOrgNotesTitle" runat="server" CssClass="HomePageNotesTitle"></asp:Label><asp:Label
                                                            ID="lblOrgNotes" runat="server" CssClass="HomePageNotes"></asp:Label></div>
                                                    <!-- / Org Notes -->
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="10%" valign="top" align="right">
                                        <navigation:OrgLogo id="ucOrgLogo" runat="server">
                                        </navigation:OrgLogo>
                                    </td>
                                </tr>
                            </table>
                            <!-- home page welcome -->
                        </td>
                    </tr>
                    <tr>
                        <!-- Footer -->
                        <table width="100%" cellspacing="0" cellpadding="0" align="center" border="0">
                            <tr valign="bottom" align="center">
                                <td valign="bottom" align="center">
                                    ©
                                    <asp:Label ID="lblCopyRightYear" runat="server"></asp:Label>&nbsp;<asp:HyperLink
                                        runat="server" Target="_blank" ID="lnkCompany"></asp:HyperLink>
                                    <br>
                                    <asp:Label ID="lblApplicationName" runat="server" CssClass="ApplicationNameInline"></asp:Label><asp:Label
                                        ID="lblTradeMark" runat="server" CssClass="TradeMarkInline"></asp:Label>
                                    <asp:Label ID="lblHomePageFooter" runat="server"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
