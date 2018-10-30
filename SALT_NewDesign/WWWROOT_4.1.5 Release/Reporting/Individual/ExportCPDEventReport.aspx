<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExportCPDEventReport.aspx.cs"
    Inherits="Bdw.Application.Salt.Web.Reporting.Individual.ExportCPDEventReport" %>

<%--<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>--%>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title id="pagTitle" runat="server"></title>
   <%-- <Style:Style id="ucStyle" runat="server">--%>
   <%-- </Style:Style>--%>
   
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
<body>
    <form id="Form1" method="post" runat="server">
    <Localized:LocalizedLabel ID="lblPageTitle" CssClass="pageTitle" runat="server" >Personal Report</Localized:LocalizedLabel>
    <br>
    <br>
    <br>
    <asp:Label ID="lblError" runat="server" CssClass=""></asp:Label>
    <asp:DataGrid ID="dgrEvent" runat="server" CssClass="DataGridReport" AutoGenerateColumns="False"
        Width="98%" GridLines="Horizontal" AllowPaging="false" ShowFooter="True">
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
    </form>
</body>
</html>
