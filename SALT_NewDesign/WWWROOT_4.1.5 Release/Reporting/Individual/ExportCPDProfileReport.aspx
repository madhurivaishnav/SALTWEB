<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExportCPDProfileReport.aspx.cs"
    EnableSessionState="True" Inherits="Bdw.Application.Salt.Web.Reporting.Individual.ExportCPDProfileReport" %>

<%--<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>--%>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <%--   <Style:Style id="ucStyle" runat="server">
    </Style:Style>--%>
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C#">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <style type="text/css">
        body, td
        {
            font-size: 8pt; /* Default font size used throught the application unless overridden by other styles */
            font-family: Arial, Helvetica, sans-serif; /* default font used throught the application unless overridden by other styles */
            color: #333333;
        }
        .pageTitle
        {
            font-weight: bold;
            font-size: 16px;
        }
        user agent stylesheet td, th
        {
            display: table-cell;
            vertical-align: inherit;
        }
        .tablerowtop
        {
            background-color: #1A506A;
            font-weight: bold;
            color: #333333;
            padding-left: 10px;
            background-color: #cccccc;
        }
        .tablerow2Selected
        {
            background-color: #ececec;
            padding: 10px;
            font-weight: bold;
            padding-left: 10px;
        }
        .tablerow2
        {
            background-color: #ececec;
            padding: 10px;
            padding-left: 10px;
        }
        .tablerow1
        {
            background-color: #F3F9FC;
            padding: 10px;
            padding-left: 10px;
        }
    </style>
</head>
<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
    <form id="Form1" method="post" runat="server">
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <asp:Panel ID="Panel1" runat="server">
                    <Localized:LocalizedLabel ID="lblPageTitle" CssClass="pageTitle" runat="server">Personal Report</Localized:LocalizedLabel>
                    <br>
                    <asp:Label ID="lblError" runat="server" CssClass=""></asp:Label>
                    <br>
                    <asp:DataGrid ID="dgrResults" runat="server" CssClass="DataGridReport" AutoGenerateColumns="False"
                        Width="98%" GridLines="Horizontal" AllowPaging="false" ShowFooter="true">
                        <HeaderStyle CssClass="tablerowtop"></HeaderStyle>
                        <FooterStyle CssClass="tablerowbot"></FooterStyle>
                        <PagerStyle Visible="False"></PagerStyle>
                        <Columns>
                            <asp:BoundColumn DataField="CourseName" HeaderText="Course"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderText="Module" ItemStyle-CssClass="tablerow2">
                                <ItemTemplate>
                                    <%# DataBinder.Eval(Container.DataItem,"ModuleName").ToString()%>
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
                    </table>
                    <table id="tblPagination" width="98%" border="0" runat="server" style="display: none;">
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
    </table>
    </form>
</body>
</html>
