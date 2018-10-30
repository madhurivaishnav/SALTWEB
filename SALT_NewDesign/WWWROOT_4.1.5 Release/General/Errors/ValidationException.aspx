<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Page language="c#" Codebehind="ValidationException.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.General.Errors.ValidationException" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    <HEAD>
        <title id="pagTitle" runat="server"></title>
        <Style:Style id="ucStyle" runat="server"></Style:Style>
        <meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
        <meta name="CODE_LANGUAGE" Content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    </HEAD>
    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
        <form id="frmErrorHandler" runat="server">
            <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
                <!-- Header -->
                <tr align="center" valign="top" width="100%">
                    <td align="center" valign="top" width="100%">
                        <navigation:header id="ucHeader" runat="server"></navigation:header>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table align="center" width="100%" border="0" cellspacing="0" cellpadding="10">
                            <tr>
                                <td class="secondary"><img width="1" height="10" src="Image/transparent.gif" border="0"></td>
                                <td><Localized:Localizedlabel id="lblPageTitle" Runat="server" CssClass="pageTitle">System Error</Localized:Localizedlabel><br>
                                </td>
                            <tr valign="top">
                                <td><img width="1" height="150" src="Image/transparent.gif" border="0"></td>
                                <td>
                                    <span class="DisplayMessage">
                                        <br>
                                        <Localized:LocalizedLiteral id="litError" runat="server"></Localized:LocalizedLiteral>
                                    </span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- Footer -->
                <tr align="center" valign="bottom">
                    <td align="center" valign="bottom">
                        <navigation:footer id="ucFooter" runat="server"></navigation:footer>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</HTML>
