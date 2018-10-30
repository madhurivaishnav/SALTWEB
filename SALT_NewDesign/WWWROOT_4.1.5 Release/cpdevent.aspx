<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cpdevent.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.CPD.cpdevent1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title runat="server" id="pagTitle"></title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <script language="javascript" type="text/javascript">
function popitup(url) {
newwindow=window.open("../../ViewEvent.aspx?term=n&FileID=" + url,'name','height=900px,width=750px ,toolbar=no,location=no,status=no,menubar=no,scrollbars=no');
if (window.focus) {newwindow.focus()}
return false;
}</script>

</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <%--	<IFRAME id="PreventTimeout" src="/PreventTimeout.aspx" frameBorder=no width=0 height=0 runat="server" />--%>
    <form id="frmPolicyDefault" method="post" runat="server">
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <!-- Header -->
        <tr valign="top" align="center" width="100%">
            <td valign="top" align="center" width="100%" colspan="2">
                <navigation:header id="ucHeader" runat="server">
                </navigation:header>
            </td>
        </tr>
        <tr valign="top" align="left" height="100%">
            <!-- Left Navigation -->
            <td class="AdminMenuContainer"><div style="width:295px;">&nbsp;</div>
                <navigation:adminmenu id="ucAdminMenu" runat="server">
                </navigation:adminmenu>
            </td>
            <!-- Body/Content -->
            <td class="DataContainer">
                <asp:Panel ID="panTitle" runat="server">
                    <table width="100%">
                        <tr>
                            <td>
                                <asp:Label ID="lblPageTitle" runat="server" CssClass="pageTitle"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblMessage" runat="server" Font-Bold="True" EnableViewState="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblMessageGap" runat="server" Font-Bold="True" EnableViewState="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ValidationSummary ID="CPDValidationSummary" runat="server" DisplayMode="BulletList"
                                    EnableViewState="False" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="panCPD" runat="server">
                    <asp:Panel ID="panEnabled" runat="server">
                        <table width="100%" cellpadding="1" cellspacing="1">
                            <tr>
                                <td width="25.5%">
                                    <Localized:LocalizedLabel ID="lblEvent" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEventName" runat="server" MaxLength="100" Width="150px" />
                                    &nbsp;
                                    <Localized:LocalizedCustomValidator ID="cvEventName" runat="server" Text="*" Enabled="true"
                                        OnServerValidate="cvEventName_ServerValidate" />
                                </td>
                            </tr>
                            
                             <tr>
                                <td width="25.5%">
                                    <Localized:LocalizedLabel ID="lblEventItem" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEventItem" runat="server" MaxLength="100" Width="150px" />
                                    &nbsp;
                                    <Localized:LocalizedCustomValidator ID="cvEventItem" runat="server" Text="*" Enabled="true"
                                        OnServerValidate="cvEventItem_ServerValidate" />
                                </td>
                            </tr>
                            
                            <tr>
                                <td>
                                    <Localized:LocalizedLabel ID="lblCPDEventProfile" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlCPDProfile" runat="server" Width="154px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <Localized:LocalizedLabel ID="lblCPDEventType" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlEventType" runat="server" Width="154px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <Localized:LocalizedLabel ID="lblEventLocation" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEventLocation" runat="server" Width="150px" />
                                    &nbsp;
                                    <Localized:LocalizedCustomValidator ID="cvEventLocation" runat="server" Text="*"
                                        Enabled="true" OnServerValidate="cvEventLocation_ServerValidate" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <Localized:LocalizedLabel ID="lblEventProvider" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEventProvider" runat="server" Width="150px" />
                                    &nbsp;
                                    <Localized:LocalizedCustomValidator ID="cvEventProvider" runat="server" Text="*"
                                        Enabled="true" OnServerValidate="cvEventProvider_ServerValidate" />
                                </td>
                            </tr>
                            <%--<tr>
                                <td>
                                    <Localized:LocalizedLabel ID="lblEventFilename" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:TextBox ID="txtfilename" runat="server" Width="150px" />
                                </td>
                            </tr>--%>
                            <tr>
                                <td width="250" nowrap>
                                    <Localized:LocalizedLabel ID="lblExistingFile" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td>
                                    <%--<asp:HyperLink ID="hypFile" runat="server"></asp:HyperLink><asp:Label ID="lblNoFile" runat="server"></asp:Label>--%>
                                    <asp:GridView runat="server" ID="gvFile" AutoGenerateColumns="false" AllowPaging="True"
                                        OnRowCancelingEdit="gvFile_RowCancelingEdit" DataKeyNames="FileID" CellPadding="4"
                                        OnRowEditing="gvFile_RowEditing" OnRowUpdating="gvFile_RowUpdating" OnRowDeleting="gvFile_RowDeleting"
                                        HeaderStyle-CssClass="tablerowtop">
                                        <RowStyle CssClass="tablerow1" />
                                        <AlternatingRowStyle CssClass="tablerow2" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Sr.No" HeaderStyle-Width="200px">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblId" runat="server" Text='<%#Container.DataItemIndex+1%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Id" Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblImgId" runat="server" Text='<%#Eval("FileID")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Name" HeaderStyle-Width="200px" >
                                                <ItemTemplate>
                                                    <a style="cursor:pointer;" onclick="return popitup(<%# Eval("FileID") %>)">
                                                        <asp:Label ID="lblImageName" runat="server" Text='<%# GetFilename(Eval("FileName").ToString())%>'></asp:Label></a>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:FileUpload ID="FileUpload1" runat="server" />
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderStyle-Width="150px">
                                                <ItemTemplate>
                                                    <%-- <asp:LinkButton ID="LkB1" runat="server" CommandName="Edit">Edit</asp:LinkButton>--%>
                                                    <asp:LinkButton ID="LkB11" runat="server" CommandName="Delete">Delete</asp:LinkButton>
                                                </ItemTemplate>
                                                <%--  <EditItemTemplate>
                                                    <asp:LinkButton ID="LkB2" runat="server" CommandName="Update">Update</asp:LinkButton>
                                                    <asp:LinkButton ID="LkB3" runat="server" CommandName="Cancel">Cancel</asp:LinkButton>
                                                </EditItemTemplate>--%>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <Localized:LocalizedLabel ID="lbluploadfile" runat="server" Font-Bold="true" />
                                </td>
                                <td>
                                    <asp:FileUpload ID="UploadFile" runat="server" Multiple="Multiple" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <Localized:LocalizedLabel ID="lblRequiredPoints" runat="server" Font-Bold="true"></Localized:LocalizedLabel>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCurrentPoints" runat="server" Width="50px"></asp:TextBox>
                                    &nbsp;
                                    <Localized:LocalizedCustomValidator ID="cvCurrentPoints" runat="server" Text="*"
                                        Enabled="true" OnServerValidate="cvCurrentPoints_ServerValidate" />
                                    <Localized:LocalizedLabel ID="lblRequiredPointsHeading" runat="server" Key="lblRequiredPointsHeading">
                                    </Localized:LocalizedLabel>&nbsp;&nbsp;
                                    <asp:Label ID="lblavailablepoint" runat="server"></asp:Label>
                                   
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <br />
                    <asp:Label ID="lblNoPeriod" runat="server" />
                    <asp:Panel ID="panPeriod" runat="server" BorderWidth="1px" BorderColor="Silver" Width="99%">
                        <table width="100%" cellpadding="1" cellspacing="1">
                            <tr>
                                <td>
                                    <asp:Label ID="lblMultiPeriod" runat="server" Font-Bold="True"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <table width="100%" cellpadding="1" cellspacing="1">
                            <tr>
                                <td width="20px">
                                </td>
                                <td width="24%">
                                    <Localized:LocalizedLabel ID="lblEventPeriod" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td colspan="2">
                                    <asp:DropDownList ID="ddlCurrentDateStartDay" runat="server">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlCurrentDateStartMonth" runat="server">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlCurrentDateStartYear" runat="server">
                                    </asp:DropDownList>
                                    <asp:Label ID="lblCurrentTo1" runat="server"></asp:Label>
                                    <asp:DropDownList ID="ddlCurrentDateEndDay" runat="server">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlCurrentDateEndMonth" runat="server">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlCurrentDateEndYear" runat="server">
                                    </asp:DropDownList>
                                    &nbsp;
                                    <Localized:LocalizedCustomValidator ID="cvCurrentDate" runat="server" Text="*" Enabled="true"
                                        OnServerValidate="cvCurrentDate_ServerValidate" />
                                </td>
                            </tr>
                            <tr>
                                <td width="25px">
                                    &nbsp;
                                </td>
                                <td>
                                    <Localized:LocalizedLabel ID="lblEventstarttime" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td colspan="2">
                                    <asp:DropDownList ID="ddlCurrentDateStartHour" runat="server">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlCurrentDateStartMinute" runat="server">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td width="25px">
                                    &nbsp;
                                </td>
                                <td>
                                    <Localized:LocalizedLabel ID="lblEventendtime" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td colspan="2">
                                    <asp:DropDownList ID="ddlCurrentDateEndHour" runat="server">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlCurrentDateEndMinute" runat="server">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <br />
                    <asp:Panel ID="panButtons" runat="server" Width="99%">
                        <table width="100%" cellpadding="1" cellspacing="1">
                            <tr>
                                <td align="right">
                                    <Localized:LocalizedButton ID="btnSaveEvent" runat="server" CssClass="saveButton"
                                        Key="btnSaveProfile" Text="Save Event" CausesValidation="true" OnClick="btnSaveEvent_Click" />
                                    &nbsp;
                                    <Localized:LocalizedButton ID="btnCancel" runat="server" CssClass="saveButton" Key="btnBack"
                                        CausesValidation="false" OnClick="btnCancel_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <br />
                    <asp:Panel ID="panBackToCPDProfile" runat="server" Width="99%">
                        <table width="100%" cellpadding="1" cellspacing="1">
                            <tr>
                                <td align="right">
                                    <a href="/Administration/CPD/CPDDefault.aspx">
                                        <Localized:LocalizedLiteral ID="lnkReturnLink" runat="server" Key="CPDReturn"></Localized:LocalizedLiteral></a>
                                    &nbsp;&nbsp;
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </asp:Panel>
            </td>
        </tr>
        <tr valign="bottom" align="center">
            <td valign="middle" align="center" colspan="2">
                <navigation:footer id="ucFooter" runat="server">
                </navigation:footer>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
