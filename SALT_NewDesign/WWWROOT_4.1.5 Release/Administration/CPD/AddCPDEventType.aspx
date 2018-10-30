<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCPDEventType.aspx.cs"
    Inherits="Bdw.Application.Salt.Web.Administration.CPD.AddCPDEventType" %>

<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C#">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title></title>
</head>
<body>
    <form id="frmAddEventType" runat="server">
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <tr valign="top" align="left" height="100%">
            <td>
                <Localized:LocalizedLabel ID="lblPageTitle" CssClass="pageTitle" runat="server">Add Event Type</Localized:LocalizedLabel><br>
                <table width="98%" align="left" border="0">
                    <tr>
                        <td class="formLabel">
                            <Localized:LocalizedLabel ID="lblEventTypeName" Key="lblEventTypeName" runat="server">Event Type Name</Localized:LocalizedLabel>
                        </td>
                        <td>
                            <asp:TextBox ID="txtEventTypeName" runat="server" MaxLength="100" size="40"></asp:TextBox>
                            &nbsp;<Localized:LocalizedRequiredFieldValidator ID="rvldEventTypeName" runat="server"
                                ControlToValidate="txtEventTypeName" CssClass="ValidatorMessage" Display="Dynamic"
                                ErrorMessage="" ValidationGroup="EType"></Localized:LocalizedRequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="formLabel">
                            <Localized:LocalizedLabel ID="lblStatus" Key="lblStatus" runat="server"></Localized:LocalizedLabel>
                        </td>
                        <td>
                            <asp:DropDownList ID="cboStatus" runat="server">
                                <asp:ListItem Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">Inactive</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td align="left">
                            <Localized:LocalizedButton CssClass="saveButton" ID="btnSave" Key="btnSave" runat="server"
                                Text="Save" OnClick="btnSave_Click" ValidationGroup="EType"></Localized:LocalizedButton>&nbsp;<asp:Label
                                    ID="lblMessage" runat="server" EnableViewState="False"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:GridView runat="server" ID="gvImage" AutoGenerateColumns="false" AllowPaging="true" OnPageIndexChanging="OnPageIndexChanging" 
                                OnRowCancelingEdit="gvImage_RowCancelingEdit" DataKeyNames="EventTypeId" CellPadding="4"
                                OnRowEditing="gvImage_RowEditing" OnRowUpdating="gvImage_RowUpdating" OnRowDeleting="gvImage_RowDeleting"
                                HeaderStyle-CssClass="tablerowtop" Width="100%">
                                <RowStyle CssClass="tablerow1" />
                                <AlternatingRowStyle CssClass="tablerow2" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Sr.No" HeaderStyle-Width="10px">
                                        <ItemTemplate>
                                            <asp:Label ID="lblId" runat="server" Text='<%#Container.DataItemIndex+1%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Id" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblImgId" runat="server" Text='<%#Eval("EventTypeId")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name" HeaderStyle-Width="200px">
                                        <ItemTemplate>
                                            <asp:Label ID="lblImageName" runat="server" Text='<%# Eval("EventTypeName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtImageName" runat="server" Text='<%# Eval("EventTypeName") %>' CausesValidation="false"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-Width="50px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit">Edit</asp:LinkButton>
                                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete">Delete</asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update">Update</asp:LinkButton>
                                            <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel">Cancel</asp:LinkButton>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
