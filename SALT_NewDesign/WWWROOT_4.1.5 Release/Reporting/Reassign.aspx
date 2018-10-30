<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reassign.aspx.cs" Inherits="Bdw.Application.Salt.Web.Reporting.Reassign" %>

<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Reassign</title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table cellpadding="5" cellspacing="5">
    <tr>
    <td>
        <Localized:LocalizedLabel ID="FirstName" runat="server" Text="First Name" />
    </td>
    <td>
        <asp:TextBox ID="FirstNameTextBox" runat="server"></asp:TextBox>
    </td>
    </tr>
    <tr>
    <td>
        <Localized:LocalizedLabel ID="LastName" runat="server" Text="Last Name" />
    </td>
    <td>
        <asp:TextBox ID="LastNameTextBox" runat="server"></asp:TextBox>
    </td>
    </tr>
    <tr>
    <td>
        <Localized:LocalizedButton ID="btnFind" cssclass="generateButton" OnClick="Find_OnClick" runat="server" Text="Find" />
    </td>
    <td></td>
    </tr>
    </table>
    </div>
    <br />
    <div>
        <asp:GridView ID="ReassignUserGrid" AllowPaging="True" AllowSorting="True"
            CssClass="tablerow2" Width="100%" BorderStyle="Solid" PageSize="15" 
            AutoGenerateColumns="false" DataKeyNames="UserID"
            OnRowDataBound="ReassignUserGrid_OnRowDataBound" OnDataBound="ReassignUserGrid_DataBound"
            OnPreRender="ReassignUserGrid_PreRender"
            runat="server" >
            <AlternatingRowStyle CssClass="tablerow1"></AlternatingRowStyle>
            <RowStyle CssClass="tablerow2"></RowStyle>
		    <headerstyle cssclass="tablerowtop" ForeColor="White" Font-Size="X-Small"></headerstyle>
            <Columns>
                <asp:TemplateField HeaderText="Select">
                    <ItemTemplate>
                         <input type="radio" name="gvradio" value='<%# Eval("UserID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="UserID" Visible="false" />
                <asp:BoundField DataField="FirstName" HeaderText="FirstName" />
                <asp:BoundField DataField="LastName" HeaderText="LastName" />
                <asp:BoundField DataField="UserName" HeaderText="UserName" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="Type" HeaderText="Administration Level" />
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
        <Localized:LocalizedLabel ID="lblUsersNone" visible="false" Text="No Users found" runat="server"></Localized:LocalizedLabel>
    </div>
    <br />
    <div>
    <table cellpadding="5" cellspacing="5">
    <tr>
    <td>
        <Localized:LocalizedButton ID="Save" cssclass="generateButton" OnClick="Save_OnClick" runat="server" Text="Save" />
        <Localized:LocalizedButton ID="Cancel" cssclass="generateButton" OnClick="Cancel_OnClick" runat="server" Text="Cancel" />
    </td>
    </tr>
    </table>
    </div>
</form>
</body>
</html>
