<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PeriodicReportListControl.ascx.cs" Inherits="Bdw.Application.Salt.Web.Reporting.PeriodicReportListControl" %>
<%@ Register TagPrefix="GridExport" TagName="ESDataSetExport" Src="/General/UserControls/EmergingControls/DataSetExport.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<div>
    <GridExport:ESDataSetExport runat="server" id="GridExport"  ></GridExport:ESDataSetExport> 
    <asp:Table ID="Table1" Width="100%" runat="server">
        <asp:TableRow HorizontalAlign="Center">
            <asp:TableCell HorizontalAlign="Right">
                <asp:DropDownList ID="ExportTypes" runat="server" OnSelectedIndexChanged="topFileType_Changed"  AutoPostBack="true">
                    <asp:ListItem>CSV</asp:ListItem>
                    <asp:ListItem>XLS</asp:ListItem>
                    <asp:ListItem>PDF</asp:ListItem>
                </asp:DropDownList>
            </asp:TableCell>
            <asp:TableCell HorizontalAlign="Left">
                <Localized:LocalizedButton ID="btnExport" runat="server" cssclass="generateButton" Text="Export"  OnClick="btnExport2_OnClick" />
            </asp:TableCell>
        </asp:TableRow>
    </asp:Table>
</div>
<div>
    <Localized:LocalizedCheckBox ID="SelectAll" Text="Select All" AutoPostBack="true"  
        runat="server" oncheckedchanged="SelectAll_CheckedChanged" />
    <Localized:LocalizedCheckBox ID="ClearAll" Text="Clear All" AutoPostBack="true"  
        runat="server" oncheckedchanged="ClearAll_CheckedChanged" />
</div>
<div>
    <asp:GridView ID="PeriodicReportsGrid" AllowPaging="true" AllowSorting="true"
        CssClass="tablerow2" Width="100%" BorderStyle="Solid" PageSize="15" AutoGenerateColumns="false"
        DataKeyNames="ScheduleID, UserID" OnDataBound="PeriodicReportsGrid_DataBound" 
        OnPreRender="PeriodicReportsGrid_PreRender" OnRowDataBound="PeriodicReportsGrid_OnRowDataBound"
        OnSorted="PeriodicReportsGrid_Sorted" runat="server">
        <AlternatingRowStyle CssClass="tablerow1"></AlternatingRowStyle>
        <RowStyle CssClass="tablerow2"></RowStyle>
		<headerstyle cssclass="tablerowtop" ForeColor="White" Font-Size="X-Small"></headerstyle>
        <Columns>
            <asp:TemplateField HeaderText="Select" >
                <ItemTemplate>
                    <asp:CheckBox ID="ReportSelector" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ScheduleID" Visible="false" />
            <asp:BoundField DataField="ReportID" Visible="false" />
            <asp:BoundField DataField="UserID" Visible = "false" />
            <asp:HyperLinkField DataTextField="ReportTitle" HeaderText="ReportTitle" SortExpression="ReportTitle"
                 DataTextFormatString="{0:n}" DataNavigateUrlFields="ScheduleID, ReportID" 
                DataNavigateUrlFormatString="~/Reporting/PeriodicReport.aspx?scheduleid={0}&ReportID={1}"/>
            <asp:BoundField DataField="ReportName" HeaderText="ReportName" SortExpression="ReportName" />
            <asp:BoundField DataField="ReportFrequency" HeaderText="ReportFrequency" SortExpression="ReportFrequency" />
            <asp:BoundField DataField="DateCreated" HeaderText="DateCreated" SortExpression="DateCreated" />
            <asp:BoundField DataField="ReportStartDate" HeaderText="ReportStartDate" SortExpression="ReportStartDate" />
            <asp:BoundField DataField="ReportEndDate" HeaderText="ReportEndDate" SortExpression="ReportEndDate" />
            <asp:BoundField DataField="NextRun" HeaderText="NextRun" SortExpression="NextRun" />
            <asp:BoundField DataField="Username" HeaderText="Report Owner" SortExpression="Username" />
            <asp:BoundField DataField="Type" HeaderText="Administration Level" SortExpression="Type" />
            <asp:BoundField DataField="CCUser" HeaderText="Report Delivered To" SortExpression="CCUser" />
        </Columns>
        <PagerTemplate>
            <table width="100%">
                <tr>
                    <td style="width: 70%">
                        <asp:DropDownList ID="PageDropDownList" AutoPostBack="true" OnSelectedIndexChanged="PageDropDownList_SelectedIndexChanged"
                            runat="server" />
                        <asp:Label ID="CurrentPageLabel" ForeColor="Blue" Text="" runat="server" />
                    </td>
                    <td style="width: 70%; text-align: right">
                        <asp:Label ID="MessageLabel" Text="" ForeColor="Blue" runat="server" />
                    </td>
                </tr>
            </table>
        </PagerTemplate>
    </asp:GridView>
    <Localized:LocalizedLabel ID="lblNoneFound" Visible="false" Text="No Periodic Reports found" runat="server" />
</div>

<asp:ObjectDataSource ID="ReportDataSource" runat="server" EnablePaging="true" SelectCountMethod="SelectCount"
    SelectMethod="SelectAllReports" SortParameterName="sSortType" MaximumRowsParameterName="iMaximumRows"
    StartRowIndexParameterName="iBeginRowIndex" TypeName="Bdw.Application.Salt.Web.Reporting.PeriodicReportListControl">


</asp:ObjectDataSource>
<asp:ObjectDataSource ID="ReportUserDataSource" runat="server" EnablePaging="true" SelectCountMethod="SelectCountUser"
    SelectMethod="SelectAllReportsUser" SortParameterName="sSortType" MaximumRowsParameterName="iMaximumRows"
    StartRowIndexParameterName="iBeginRowIndex" TypeName="Bdw.Application.Salt.Web.Reporting.PeriodicReportListControl">
    <SelectParameters>
        <asp:Parameter Name="Username" Type="String" />
    </SelectParameters>
</asp:ObjectDataSource>


<div>
    <Localized:LocalizedButton ID="DeleteSelected" runat="server" cssclass="generateButton" Text="Delete Selected" OnClick="DeleteSelected_OnClick" />
    <Localized:LocalizedButton ID="ReassignSelected" runat="server" cssclass="generateButton" OnClick="ReassignSelected_Click" Text="Reassign Selected" />
</div>
<div>
    <asp:Table Width="100%" runat="server">
        <asp:TableRow HorizontalAlign="Center" runat = "server">
            <asp:TableCell HorizontalAlign="Right">
                <asp:DropDownList ID="ExportType2" runat="server" OnTextChanged="bottomFileType_Changed" AutoPostBack="true">
                    <asp:ListItem>CSV</asp:ListItem>
                    <asp:ListItem>XLS</asp:ListItem>
                    <asp:ListItem>PDF</asp:ListItem>
                </asp:DropDownList>
            </asp:TableCell>
            <asp:TableCell HorizontalAlign="Left">
                <Localized:LocalizedButton ID="btnExport2" runat="server" cssclass="generateButton" Text="Export" OnClick="btnExport2_OnClick"/>
            </asp:TableCell>
        </asp:TableRow>
    </asp:Table>
</div>
<div>
    <Localized:LocalizedButton ID="btnNewReport" runat="server" cssclass="generateButton" Text="New" OnClick="btnNewReport_OnClick" />
    <Localized:LocalizedLabel ID="lblSelect" runat="server" Text="Select Report Type" />
    <asp:DropDownList ID="listReports" AutoPostBack="true" runat="server">
    </asp:DropDownList>
</div>