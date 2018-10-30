<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PeriodicReportInactiveListControl.ascx.cs" Inherits="Bdw.Application.Salt.Web.Reporting.PeriodicReportInactiveListControl" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<div>
    <Localized:LocalizedCheckBox ID="SelectAll" Text="Select All" AutoPostBack="true"  
        runat="server" oncheckedchanged="SelectAll_CheckedChanged" />
    <Localized:LocalizedCheckBox ID="ClearAll" Text="Clear All" AutoPostBack="true"  
        runat="server" oncheckedchanged="ClearAll_CheckedChanged" />
</div>
<div>
    <asp:GridView ID="PeriodicReportsGrid" AllowPaging="true" AllowSorting="true"
        CssClass="tablerow2" Width="100%" BorderStyle="Solid" PageSize="15" AutoGenerateColumns="false"
        DataKeyNames="ScheduleID, UserID, ReportID" OnDataBound="PeriodicReportsGrid_DataBound" 
        OnPreRender="PeriodicReportsGrid_PreRender" OnRowDataBound="PeriodicReportsGrid_OnRowDataBound"
        OnRowCommand="PeriodicReportsGrid_RowCommand" OnRowDeleting="PeriodicReportsGrid_RowDeleting"
        OnRowUpdating="PeriodicReportsGrid_RowUpdating" runat="server">
        <AlternatingRowStyle CssClass="tablerow1"></AlternatingRowStyle>
        <RowStyle CssClass="tablerow2"></RowStyle>
		<headerstyle cssclass="tablerowtop" ForeColor="White" Font-Size="X-Small"></headerstyle>
        <Columns>
            <asp:TemplateField HeaderText="Select">
                <ItemTemplate>
                    <asp:CheckBox ID="ReportSelector" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ScheduleID" Visible="false" />
            <asp:BoundField DataField="UserID" Visible = "false" />
            <asp:BoundField DataField="ReportID" Visible="false" />
            <asp:HyperLinkField DataTextField="ReportTitle" HeaderText="ReportTitle" SortExpression="ReportTitle"
                 DataTextFormatString="{0:n}" DataNavigateUrlFields="ScheduleID, ReportID" 
                DataNavigateUrlFormatString="~/Reporting/PeriodicReport.aspx?scheduleid={0}&ReportID={1}"/>
            <asp:BoundField DataField="Username" HeaderText="Report Owner" SortExpression="Report Owner" />
            <asp:BoundField DataField="ReportName" HeaderText="ReportName" SortExpression="ReportName" />
            <asp:BoundField DataField="ReportFrequency" HeaderText="ReportFrequency" SortExpression="ReportFrequency" />
            <asp:ButtonField HeaderText="Delete" ButtonType="Link" Text="Delete" CommandName="Delete" />
            <asp:ButtonField HeaderText="Re-assign" ButtonType="Link" Text="Re-assign" CommandName="Reassign" />
        </Columns>
        <PagerTemplate>
            <table width="100%">
                <tr>
                    <td style="width: 70%">
                        <asp:DropDownList ID="PageDropDownList" AutoPostBack="true" OnSelectedIndexChanged="PageDropDownList_SelectedIndexChanged"
                            runat="server" />
                        <Localized:LocalizedLabel ID="CurrentPageLabel" ForeColor="Blue" Text="" runat="server" />
                    </td>
                    <td style="width: 70%; text-align: right">
                        <Localized:LocalizedLabel ID="MessageLabel" Text="" ForeColor="Blue" runat="server" />
                    </td>
                </tr>
            </table>
        </PagerTemplate>
    </asp:GridView>
    <Localized:LocalizedLabel ID="lblNoneFound" Visible="false" Text="No Periodic Reports found" runat="server" />
</div>

<asp:ObjectDataSource ID="ReportDataSource" runat="server" EnablePaging="true" SelectCountMethod="SelectCount"
    SelectMethod="SelectAllReports" SortParameterName="sSortType" MaximumRowsParameterName="iMaximumRows"
    StartRowIndexParameterName="iBeginRowIndex" TypeName="Bdw.Application.Salt.Web.Reporting.PeriodicReportInactiveListControl">
    <SelectParameters>
        <asp:SessionParameter Name="InactivatedUsernames" SessionField="InactivatedUsernames" />
    </SelectParameters>
</asp:ObjectDataSource>

<asp:ObjectDataSource ID="ReportEmailsDataSource" runat="server" EnablePaging="true" SelectCountMethod="SelectCountEmails"
    SelectMethod="SelectAllReportsEmails" SortParameterName="sSortType" MaximumRowsParameterName="iMaximumRows"
    StartRowIndexParameterName="iBeginRowIndex" TypeName="Bdw.Application.Salt.Web.Reporting.PeriodicReportInactiveListControl">
    <SelectParameters>
        <asp:SessionParameter Name="InactivatedEmails" SessionField="InactivatedEmails" />
    </SelectParameters>
</asp:ObjectDataSource>

<asp:ObjectDataSource ID="ReportUserDataSource" runat="server" EnablePaging="true" SelectCountMethod="SelectCountUser"
    SelectMethod="SelectAllReportsUser" SortParameterName="sSortType" MaximumRowsParameterName="iMaximumRows"
    StartRowIndexParameterName="iBeginRowIndex" TypeName="Bdw.Application.Salt.Web.Reporting.PeriodicReportInactiveListControl">
    <SelectParameters>
        <asp:Parameter Name="Username" Type="String" />
    </SelectParameters>
</asp:ObjectDataSource>


<div>
    <Localized:LocalizedButton ID="DeleteSelected" runat="server" cssclass="generateButton" Text="Delete Selected" OnClick="DeleteSelected_OnClick" />
    <Localized:LocalizedButton ID="ReassignSelected" runat="server" cssclass="generateButton" OnClick="ReassignSelected_Click" Text="Reassign Selected" />
</div>
<br />
<br />
<div>
    <Localized:LocalizedButton ID="Save" cssclass="generateButton" runat="server" OnClick="Save_OnClick" Text="Save" />
    <Localized:LocalizedButton ID="Cancel" cssclass="generateButton" runat="server" OnClick="Cancel_OnClick" Text="Cancel" />
</div>