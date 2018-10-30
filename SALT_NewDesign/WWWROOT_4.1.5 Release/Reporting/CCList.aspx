<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" CodeBehind="CCList.aspx.cs" Inherits="Bdw.Application.Salt.Web.Reporting.CCList" %>

<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CC List</title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <Localized:LocalizedLabel ID="FirstName" runat="server" Text="First Name"></Localized:LocalizedLabel>
        <asp:TextBox ID="FirstNameTextBox" runat="server"></asp:TextBox>
        <br />
        <Localized:LocalizedLabel ID="LastName" runat="server" Text="Last Name"></Localized:LocalizedLabel>
        <asp:TextBox ID="LastNameTextBox" runat="server"></asp:TextBox>
        <br />
        <Localized:LocalizedButton ID="btnFind" cssclass="generateButton" OnClick="Find_OnClick" runat="server" Text="Find" />
    </div>
    <div>
        <asp:Label ID="FoundUsers" runat="server" Text="" />
        <br />
        <asp:Table runat="server">
            <asp:TableRow>
                <asp:TableCell>
                    <asp:CheckBox ID="SelectAll" Text="Select All" AutoPostBack="true"  
                        runat="server" oncheckedchanged="SelectAll_CheckedChanged" />
                    <asp:CheckBox ID="ClearAll" Text="Clear All" AutoPostBack="true"  
                        runat="server" oncheckedchanged="ClearAll_CheckedChanged" />
                    <asp:GridView ID="CCListUserGrid" AllowPaging="True" AllowSorting="True"
                        CssClass="tablerow2" Width="100%" BorderStyle="Solid" PageSize="15"
                        AutoGenerateColumns="False" OnRowCommand="CCListUserGrid_RowCommand"
                        DataKeyNames="UserID" OnRowDataBound="CCListUserGrid_OnRowDataBound"
                        OnPreRender="CCListUserGrid_PreRender" OnDataBound="CCListUserGrid_DataBound"
                        OnSorted="CCListUserGrid_Sorted" runat="server" >
                        <AlternatingRowStyle CssClass="tablerow1"></AlternatingRowStyle>
                        <RowStyle CssClass="tablerow2"></RowStyle>
		                <headerstyle cssclass="tablerowtop" ForeColor="White"></headerstyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Select">
                                <ItemTemplate>
                                    <asp:CheckBox ID="UserSelector" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="UserID" Visible="false" SortExpression="UserID" />
                            <asp:BoundField DataField="FirstName" SortExpression="FirstName" HeaderText="FirstName" />
                            <asp:BoundField DataField="LastName" SortExpression="LastName" HeaderText="LastName" />
                            <asp:BoundField DataField="UserName" SortExpression="UserName" HeaderText="UserName" />
                            <asp:BoundField DataField="Email" SortExpression="Email" HeaderText="Email" />
                            <asp:TemplateField HeaderText="Add" >
                                <ItemTemplate>
                                    <Localized:LocalizedLinkButton ID="lbtnAdd" runat="server" Text="Add" CommandName="Add" CommandArgument="<%# Container.DataItemIndex %>" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>        
                        <PagerTemplate>
                            <table width="100%">
                                <tr>
                                    <td style="width: 70%">
                                        <asp:DropDownList ID="PageDropDownList" AutoPostBack="true" OnSelectedIndexChanged="PageDropDownList_CCListUserGrid_SelectedIndexChanged"
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
                    <Localized:LocalizedLabel ID="lblUsersNone" visible="false" Text="No Users found" runat="server"></Localized:LocalizedLabel>
                    <Localized:LocalizedButton ID="AddSelected" cssclass="generateButton" runat="server" Text="Add Selected" 
                        onclick="AddSelected_Click" />
                </asp:TableCell>
                <asp:TableCell>
                    <asp:CheckBox ID="SelectAllCC" Text="Select All" AutoPostBack="true"  
                        runat="server" oncheckedchanged="SelectAllCC_CheckedChanged" />
                    <asp:CheckBox ID="ClearAllCC" Text="Clear All" AutoPostBack="true"  
                        runat="server" oncheckedchanged="ClearAllCC_CheckedChanged" />
                    <asp:GridView ID="CCListGrid" Caption="Selected Users" AllowPaging="True" AllowSorting="True"
                        CssClass="tablerow2" Width="100%" BorderStyle="Solid" PageSize="15" 
                        AutoGenerateColumns="False" OnRowCommand="CCListGrid_RowCommand"
                        DataKeyNames="UserID, UserName" OnRowDataBound="CCListGrid_OnRowDataBound"
                        OnPreRender="CCListGrid_PreRender" OnDataBound="CCListGrid_DataBound"
                        OnSorted="CCListGrid_Sorted" runat="server" >
                        <AlternatingRowStyle CssClass="tablerow1"></AlternatingRowStyle>
                        <RowStyle CssClass="tablerow2"></RowStyle>       
		                <headerstyle cssclass="tablerowtop" ForeColor="White"></headerstyle>
                        <Columns>
                            <asp:TemplateField HeaderText="Select">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CCSelector" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="UserID" SortExpression="UserID" Visible="false" />
                            <asp:BoundField DataField="UserName" SortExpression="UserName" HeaderText="UserName" />
                            <asp:TemplateField HeaderText="Remove">
                                <ItemTemplate>
                                    <Localized:LocalizedLinkButton ID="lbtnRemove" runat="server" Text="Remove" CommandName="Remove" CommandArgument="<%# Container.DataItemIndex %>"/>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerTemplate>
                            <table width="100%">
                                <tr>
                                    <td style="width: 70%">
                                        <asp:DropDownList ID="PageDropDownList2" AutoPostBack="true" OnSelectedIndexChanged="PageDropDownList_CCListGrid_SelectedIndexChanged"
                                            runat="server" />
                                        <asp:Label ID="CurrentPageLabel2" ForeColor="Blue" Text="" runat="server" />
                                    </td>
                                    <td style="width: 70%; text-align: right">
                                        <asp:Label ID="MessageLabel" Text="" ForeColor="Blue" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </PagerTemplate>
                    </asp:GridView>
                    <Localized:LocalizedLabel ID="lblCCNone" visible="false" Text="No CC Users found" runat="server"></Localized:LocalizedLabel>
                    <Localized:LocalizedButton ID="RemoveSelected" cssclass="generateButton" runat="server" Text="Remove Selected" 
                        onclick="RemoveSelected_Click" />
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
    </div>
    <div>
        <Localized:LocalizedButton ID="Save" cssclass="generateButton" runat="server" OnClick="Save_OnClick" Text="Save" />
        <Localized:LocalizedButton ID="Cancel" cssclass="generateButton" runat="server" OnClick="Cancel_OnClick" Text="Cancel" />
    </div>
</form>
</body>
</html>
