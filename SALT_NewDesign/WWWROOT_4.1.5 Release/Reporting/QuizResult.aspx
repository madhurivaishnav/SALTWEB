<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="QuizResult.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.QuizResult" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
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
    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
        <form id="frmLinks" method="post" runat="server">
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr valign="top" align="center" width="100%">
                    <td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr height="100%" align="left" valign="top">
                    <td class="ReportMenuContainer">&nbsp;</td>
                    <td class="DataContainer">
                        <Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">You have now completed your quiz</Localized:Localizedlabel><br>
                        <asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
                        <table width="95%" align="left" border="0">
                            <tr>
                                <td>
                                    <asp:label id="lblPassed" runat="server">Well done, you passed</asp:label>
                                    <asp:label id="lblFailed" runat="server">You have failed</asp:label>
                                </td>
                                <td rowspan="4" id="tdImage" runat="server" width="50%" height="396px">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <asp:Label id="lblPassMarkText" runat="server"></asp:Label>
                               </td>
                            </tr>
                            <tr>
                                <td><Localized:LocalizedLabel id="lblViewQuizStatus" runat="server"></Localized:LocalizedLabel></td>
                            </tr>
                            <tr>
                                <td><Localized:Localizedhyperlink id="lnkQuizSummaryReport" runat="server">Quiz Summary Report</Localized:Localizedhyperlink></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr valign="bottom" align="center">
                    <td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
                </tr>
            </table>
        </form>
    </body>
</html>
