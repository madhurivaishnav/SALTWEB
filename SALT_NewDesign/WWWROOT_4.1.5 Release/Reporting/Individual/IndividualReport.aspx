<%@ Page Language="c#" CodeBehind="IndividualReport.aspx.cs" AutoEventWireup="True"
    EnableSessionState="True" Inherits="Bdw.Application.Salt.Web.Reporting.Individual.IndividualReport" %>

<%@ Register TagPrefix="navigation" TagName="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="usermenu" Src="/General/UserControls/Navigation/UserMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C#">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <script type="text/javascript" src="../../General/Js/navigationmenu-jquery-latest.min.js"></script>
<script type="text/javascript" src="../../General/Js/navigationmenuscript.js"></script>
</head>
<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
    <form id="Form1" method="post" runat="server">
    <table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
        <!-- Header -->
        <tr align="center" valign="top" width="100%">
            <td align="center" valign="top" width="100%" colspan="2">
                <navigation:header id="ucHeader" runat="server">
                </navigation:header>
            </td>
        </tr>
        <tr height="100%" align="left" valign="top">
            <!-- Left Navigation -->
            <td class="ReportMenuContainer" width="10%">
                <navigation:usermenu id="ucUserMenu" runat="server">
                </navigation:usermenu>
                <navigation:reportsMenu runat="server" id="ucLeftMenu">
                </navigation:reportsMenu>
            </td>
            <!-- Body/Conent -->
            <td class="DataContainer" align="right">
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <asp:Panel ID="Panel1" runat="server">
                                <navigation:helplink runat="Server" key="10.1" desc="Running Personal Reports?" id="ucHelp" />
                                <Localized:LocalizedLabel ID="lblPageTitle" CssClass="pageTitle" runat="server">Personal Report</Localized:LocalizedLabel>
                                &nbsp;&nbsp;<Localized:LocalizedButton ID="btnCPDExportpdf" runat="server" CssClass="saveButton"
                                    Key="btnExportpdf" CausesValidation="False" OnClick="btnCPDExportpdf_Click" /><br>
                                <asp:Label ID="lblError" runat="server" CssClass=""></asp:Label>
                                <br>
                                <asp:DataGrid ID="dgrResults" runat="server" CssClass="DataGridReport" AutoGenerateColumns="False"
                                    Width="98%" GridLines="Horizontal" AllowPaging="True" ShowFooter="True">
                                    <HeaderStyle CssClass="tablerowtop"></HeaderStyle>
                                    <FooterStyle CssClass="tablerowbot"></FooterStyle>
                                    <PagerStyle Visible="False"></PagerStyle>
                                    <Columns>
                                        <asp:BoundColumn DataField="CourseName" HeaderText="Course"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Module" ItemStyle-CssClass="tablerow2">
                                            <ItemTemplate>
                                                <a href='/Reporting/QuizHistory.aspx?UserID=<%# DataBinder.Eval(Container.DataItem,"UserID").ToString() + "&ModuleID=" + DataBinder.Eval(Container.DataItem,"ModuleID").ToString()%>'>
                                                    <%# DataBinder.Eval(Container.DataItem,"ModuleName").ToString()%>
                                                </a>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LessonStatus" HeaderText="Lesson Status" ItemStyle-CssClass="tablerow2">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="QuizStatus" HeaderText="Quiz Status" ItemStyle-CssClass="tablerow2">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="QuizScore" HeaderText="Score" HeaderStyle-HorizontalAlign="center"
                                            ItemStyle-CssClass="tablerow2" ItemStyle-HorizontalAlign="center" DataFormatString="{0}%">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="QuizPassMark" HeaderText="Pass Mark" HeaderStyle-HorizontalAlign="center"
                                            ItemStyle-CssClass="tablerow2" ItemStyle-HorizontalAlign="center" DataFormatString="{0}%">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="ModuleName" Visible="False"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="ModuleID" Visible="False"></asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <table>
                                    <tr>
                                        <td align="right">
                                            <asp:DataGrid ID="dgrTotals" runat="server" AutoGenerateColumns="False" Width="98%"
                                                ShowHeader="False" CssClass="DataGridReport">
                                                <Columns>
                                                    <asp:TemplateColumn></asp:TemplateColumn>
                                                    <asp:TemplateColumn></asp:TemplateColumn>
                                                    <asp:TemplateColumn></asp:TemplateColumn>
                                                    <asp:TemplateColumn></asp:TemplateColumn>
                                                    <asp:TemplateColumn></asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="Summ"></asp:BoundColumn>
                                                    <asp:TemplateColumn></asp:TemplateColumn>
                                                    <asp:TemplateColumn></asp:TemplateColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                        </td>
                                    </tr>
                                </table>
                                <table id="tblPagination" width="98%" border="0" runat="server">
                                    <tr id="trPagination" runat="server">
                                        <td align="left">
                                            <Localized:LocalizedLiteral ID="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:DropDownList
                                                ID="cboPage" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cboPage_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            &nbsp;<Localized:LocalizedLiteral ID="Localizedliteral1" runat="server" Key="litOf" />&nbsp;<asp:Label
                                                ID="lblPageCount" runat="server">3</asp:Label>:
                                            <asp:Label ID="lblCurrentPageRecordCount" runat="server">30 - 40</asp:Label>&nbsp;<Localized:LocalizedLiteral
                                                ID="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:Label ID="lblTotalRecordCount"
                                                    runat="server">81</asp:Label>&nbsp;
                                            <Localized:LocalizedLiteral ID="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                        </td>
                                        <td align="right">
                                            <Localized:LocalizedLinkButton ID="btnPrev" runat="server" CausesValidation="False"
                                                OnClick="btnPrev_Click">&lt;&lt; Prev</Localized:LocalizedLinkButton>&nbsp;&nbsp;
                                            <Localized:LocalizedLinkButton ID="btnNext" runat="server" CausesValidation="False"
                                                OnClick="btnNext_Click">Next&gt;&gt;</Localized:LocalizedLinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top: 50px;" id="tdevent" runat="server">
                            <Localized:LocalizedLabel ID="lblCPDEventProfile" CssClass="pageTitle" runat="server">Event Report</Localized:LocalizedLabel>
                            &nbsp;&nbsp;<Localized:LocalizedButton ID="btnExportpdf" runat="server" CssClass="saveButton"
                                Key="btnExportpdf" CausesValidation="False" OnClick="btnExportpdf_Click" />
                            <br>
                            <asp:Label ID="lblEventError" runat="server" CssClass=""></asp:Label>
                            <br />
                            <asp:DataGrid ID="dgrEvent" runat="server" CssClass="DataGridReport" AutoGenerateColumns="False"
                                Width="98%" GridLines="Horizontal" AllowPaging="True" ShowFooter="True">
                                <HeaderStyle CssClass="tablerowtop"></HeaderStyle>
                                <FooterStyle CssClass="tablerowbot"></FooterStyle>
                                <PagerStyle Visible="False"></PagerStyle>
                                <Columns>
                                    <asp:BoundColumn DataField="EventName" HeaderText="Event Name"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="EventItem" HeaderText="Event Item" ItemStyle-CssClass="tablerow2">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="FileStatus" HeaderText="FileStatus" ItemStyle-CssClass="tablerow2">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="Points" HeaderText="Points" ItemStyle-CssClass="tablerow2">
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="EventID" Visible="False"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="EventPeriodID" Visible="False"></asp:BoundColumn>
                                </Columns>
                            </asp:DataGrid>
                            <table>
                                <tr>
                                    <td align="right">
                                        <asp:DataGrid ID="dgrEventTotals" runat="server" AutoGenerateColumns="False" Width="98%"
                                            ShowHeader="False" CssClass="DataGridReport">
                                            <Columns>
                                                <asp:TemplateColumn></asp:TemplateColumn>
                                                <asp:TemplateColumn></asp:TemplateColumn>
                                                <asp:TemplateColumn></asp:TemplateColumn>
                                                <asp:TemplateColumn></asp:TemplateColumn>
                                                <asp:TemplateColumn></asp:TemplateColumn>
                                                <asp:BoundColumn DataField="Summ"></asp:BoundColumn>
                                                <asp:TemplateColumn></asp:TemplateColumn>
                                                <asp:TemplateColumn></asp:TemplateColumn>
                                            </Columns>
                                        </asp:DataGrid>
                                    </td>
                                    <tr>
                            </table>
                            <table id="tblEventPagination" width="98%" border="0" runat="server">
                                <tr id="trEventPagination" runat="server">
                                    <td align="left">
                                        <Localized:LocalizedLiteral ID="litEventPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:DropDownList
                                            ID="cboEventPage" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cboEventPage_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        &nbsp;<Localized:LocalizedLiteral ID="LocalizedEventliteral1" runat="server" Key="litEventOf" />&nbsp;<asp:Label
                                            ID="lblEventPageCount" runat="server">3</asp:Label>:
                                        <asp:Label ID="lblEventCurrentPageRecordCount" runat="server">30 - 40</asp:Label>&nbsp;<Localized:LocalizedLiteral
                                            ID="litEventOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:Label ID="lblEventTotalRecordCount"
                                                runat="server">81</asp:Label>&nbsp;
                                        <Localized:LocalizedLiteral ID="litEventDisplayed" runat="server"></Localized:LocalizedLiteral>
                                    </td>
                                    <td align="right">
                                        <Localized:LocalizedLinkButton ID="btnEventPrev" runat="server" CausesValidation="False"
                                            OnClick="btnEventPrev_Click">&lt;&lt; Prev</Localized:LocalizedLinkButton>&nbsp;&nbsp;
                                        <Localized:LocalizedLinkButton ID="btnEventNext" runat="server" CausesValidation="False"
                                            OnClick="btnEventNext_Click">Next&gt;&gt;</Localized:LocalizedLinkButton>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <!-- Footer -->
        <tr align="center" valign="bottom">
            <td align="center" valign="middle" colspan="2">
                <navigation:footer id="ucFooter" runat="server">
                </navigation:footer>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
