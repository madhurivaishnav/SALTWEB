<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="QuizSummary.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.QuizSummary" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
        <meta name="CODE_LANGUAGE" content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    </head>
    <body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
        <form id="Form2" method="post" runat="server">
            <table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
                <!-- Header -->
                <tr align="center" valign="top" width="100%">
                    <td align="center" valign="top" width="100%" colspan="2">
                        <navigation:header id="Header1" runat="server"></navigation:header>
                    </td>
                </tr>
                <tr height="100%" align="left" valign="top">
                    <!-- Left Navigation -->
                    <td class="ReportMenuContainer">
                        <navigation:reportsmenu id="ucReportsMenu" runat="server"></navigation:reportsmenu>
                    </td>
                    <!-- Body/Conent -->
                    <td>
                        <navigation:helplink runat="Server" key="10.1.2" desc="Examining Quiz Answers?" id="ucHelp" />
                        <Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Quiz Summary</Localized:Localizedlabel><br>
                        <asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
                        <asp:datagrid id="dgrQuizHeader" runat="server" width="95%" allowsorting="True" borderstyle="Solid"
                            autogeneratecolumns="False" allowpaging="false">
                            <headerstyle cssclass="tablerowtop"></headerstyle>
                            <footerstyle cssclass="tablerowbot"></footerstyle>
                            <itemstyle cssclass="tablerow2"></itemstyle>
                            <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                            <pagerstyle visible="False"></pagerstyle>
                            <columns>
                                <asp:boundcolumn datafield="Module" headertext="Module" itemstyle-width="33%"></asp:boundcolumn>
                                <asp:boundcolumn datafield="FullName" headertext="Name"></asp:boundcolumn>
                                <asp:boundcolumn datafield="QuizScore" headertext="Quiz Score" dataformatstring="{0}%"></asp:boundcolumn>
                            </columns>
                        </asp:datagrid>
                        <br>
                        <br>
                        <asp:datagrid id="dgrQuizSummary" runat="server" autogeneratecolumns="False" width="95%" gridlines="Horizontal">
                            <headerstyle cssclass="tablerowtop"></headerstyle>
                            <footerstyle cssclass="tablerowbot"></footerstyle>
                            <pagerstyle visible="False"></pagerstyle>
                            <itemstyle cssclass="tablerow2"></itemstyle>
                            <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                            <pagerstyle visible="False"></pagerstyle>
                            <columns>
                                <asp:boundcolumn datafield="Question" headertext="Question" itemstyle-verticalalign="Top" itemstyle-font-bold="True"
                                    itemstyle-width="40%"></asp:boundcolumn>
                                <asp:boundcolumn datafield="CorrectAnswer" headertext="Correct Answers" itemstyle-verticalalign="Top">
                                    <itemstyle width="20%"></itemstyle>
                                </asp:boundcolumn>
                                <asp:boundcolumn datafield="GivenAnswer" headertext="Your Answer" itemstyle-verticalalign="Top">
                                    <itemstyle width="20%"></itemstyle>
                                </asp:boundcolumn>
                                <asp:boundcolumn visible="False" datafield="Correct"></asp:boundcolumn>
                                <asp:templatecolumn headertext="Correct">
                                    <headerstyle horizontalalign="Center"></headerstyle>
                                    <itemstyle horizontalalign="Center"></itemstyle>
                                    <itemtemplate>
                                        <asp:image id="imgCorrect" runat="server" imageurl="" itemstyle-width="20%"></asp:image>
                                    </itemtemplate>
                                </asp:templatecolumn>
                            </columns>
                        </asp:datagrid>
                        <br>
                        <Localized:Localizedhyperlink navigateurl="/" id="lnkHome" runat="server">Exit</Localized:Localizedhyperlink>
                        <asp:hyperlink navigateurl="javascript:window.history.back(1);" id="lnkPreviousScreen" runat="server">Previous Page</asp:hyperlink>
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
