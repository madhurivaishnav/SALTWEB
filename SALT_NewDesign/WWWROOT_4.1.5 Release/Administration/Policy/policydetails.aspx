<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>

<%@ Page Language="c#" Codebehind="policydetails.aspx.cs" AutoEventWireup="True"
    Inherits="Bdw.Application.Salt.Web.Administration.Policy.policydetails" %>

<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:STYLE id="ucStyle" runat="server">
    </Style:STYLE>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <script language="javascript">
		//This must be placed on each page where you want to use the client-side resource manager
		var ResourceManager = new RM();
		function RM()
		{
		this.list = new Array();
		};
		RM.prototype.AddString = function(key, value)
		{
		this.list[key] = value;
		};
		RM.prototype.GetString = function(key)
		{
		var result = this.list[key];  
		for (var i = 1; i < arguments.length; ++i)
		{
			result = result.replace("{" + (i-1) + "}", arguments[i]);
		}
		return result;
		};
    </script>

    <script language="JavaScript">
		function ConfirmUpload()
		{
			return confirm(ResourceManager.GetString("ConfirmUpload"));
			//return confirm("Warning:This action will change the module access of users in this Unit. Are you sure you wish to proceed?");
		}
    </script>

</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <IFRAME id="PreventTimeout" src="/PreventTimeout.aspx" frameBorder=no width=0 height=0 runat="server" />
    <form id="frmPolicyDetails" method="post" enctype="multipart/form-data" runat="server">
        <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
            border="0">
            <!-- Header -->
            <tr valign="top" align="center" width="100%">
                <td valign="top" align="center" width="100%" colspan="2">
                    <navigation:header id="ucHeader" runat="server">
                    </navigation:header></td>
            </tr>
            <tr valign="top" align="left" height="100%">
                <!-- Left Navigation -->
                <td class="AdminMenuContainer">
                    <navigation:adminmenu id="ucAdminMenu" runat="server">
                    </navigation:adminmenu></td>
                <!-- Body/Content -->
                <td class="DataContainer">
                    <table width="100%">
                        <tr>
                            <td>
                                <Localized:LOCALIZEDLABEL id="lblPageTitle" Runat="server" CssClass="pageTitle">
                                </Localized:LOCALIZEDLABEL></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblMessage" runat="server" EnableViewState="False" Font-Bold="True"></asp:Label></td>
                        </tr>
                    </table>
                    <br>
                    <asp:Panel ID="panPolicy" runat="server">
                        <table width="100%">
                            <tr>
                                <td width="250" nowrap>
                                    <Localized:LOCALIZEDLABEL id="lblName" Runat="server">
                                    </Localized:LOCALIZEDLABEL>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtName" runat="server" Width="300px"></asp:TextBox>&nbsp;
                                    <Localized:LOCALIZEDREQUIREDFIELDVALIDATOR id="rfvName" runat="server" CssClass="ValidatorMessage"
                                        ControlToValidate="txtName" ErrorMessage="You must specify the Policy Name.">
                                    </Localized:LOCALIZEDREQUIREDFIELDVALIDATOR><asp:Label ID="lblPolicyName" runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td width="250" nowrap>
                                    <Localized:LOCALIZEDLABEL id="lblStatus" Runat="server">
                                    </Localized:LOCALIZEDLABEL></td>
                                <td>
                                    <asp:DropDownList ID="ddlStatus" runat="server" Width="100px">
                                        <asp:ListItem Value="1">Active</asp:ListItem>
                                        <asp:ListItem Value="0">Inactive</asp:ListItem>
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td width="250" nowrap>
                                    <Localized:LOCALIZEDLABEL id="lblUserAcceptance" Runat="server">
                                    </Localized:LOCALIZEDLABEL></td>
                                <td>
                                    <asp:Label ID="lblUsersAccepted" runat="server"></asp:Label><asp:Label ID="lblTotalUsers"
                                        runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td width="250" nowrap>
                                    <Localized:LOCALIZEDLABEL id="lblExistingFile" Runat="server">
                                    </Localized:LOCALIZEDLABEL></td>
                                <td rowspan="2">
                                    <asp:HyperLink ID="hypFile" runat="server"></asp:HyperLink><asp:Label ID="lblNoFile"
                                        runat="server"></asp:Label></td>
                            </tr>
                        </table>
                        <br>
                        <table width="100%">
                            <tr>
                                <td width="250" style="height: 25px">
                                </td>
                                <td style="height: 25px">
                                    <input id="UploadFile" type="file" name="UploadFile" runat="server"></td>
                            </tr>
                            <tr>
                                <td width="250" rowspan="2" style="height: 25px">
                                </td>
                                <td rowspan="2">
                                    <asp:Label ID="lblUploadFile" runat="server"></asp:Label></td>
                            </tr>
                        </table>
                        <table width="100%">
                            <tr>
                                <td width="250" nowrap>
                                    <Localized:localizedlabel id="lblConfirmationMsg" runat="server" /></td>
                                <td rowspan="2">
                                    <asp:TextBox ID="txtConfirmationMsg" runat="server" Width="300px" /></td>
                            </tr>
                        </table>
                        <br>
                        <asp:Panel ID="panUpload" runat="server">
                            <table width="100%">
                                <tr>
                                    <td width="250">
                                    </td>
                                    <td>
                                        <Localized:LocalizedLinkButton id="lnkResetUsers" runat="server" onclick="lnkResetUsers_Click">
                                        </Localized:LocalizedLinkButton></td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <table width="100%">
							<tr>
								<td width="250">
                                </td>
                                <td>
									<Localized:LocalizedCheckBox id="chkAssignAllUsers" runat="server" />
                                </td>
							</tr>
                        </table>
                        <table width="100%">
                            <tr>
                                <td width="250">
                                </td>
                                <td>
                                    <Localized:LOCALIZEDBUTTON id="btnSavePolicy" runat="server" CssClass="saveButton"
                                        key="cmnSave" Text="Save" onclick="btnSavePolicy_Click" />&nbsp;
                                    <Localized:LOCALIZEDBUTTON id="btnCancel" runat="server" CssClass="saveButton" key="cmnCancel"
                                        Text="Cancel" CausesValidation="false" onclick="btnCancel_Click" /></td>
                            </tr>
                        </table>
                        <br>
                        <asp:Panel ID="panTabs" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td width="250">
                                    </td>
                                    <td>
                                        <Localized:localizedLinkButton id="lnkAssignUnits" Runat="server" CausesValidation="False" onclick="lnkAssignUnits_Click" />
                                        &nbsp;|&nbsp;
                                        <Localized:localizedLinkButton id="lnkAssignUsers" Runat="server" CausesValidation="False" onclick="lnkAssignUsers_Click" />
                                        &nbsp;|&nbsp;
                                        <Localized:localizedLinkButton id="lnkViewUsers" Runat="server" CausesValidation="False" onclick="lnkViewUsers_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panAssignUnits" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <Localized:localizedLabel id="lblAssignUnits" runat="server" CssClass="pageTitle" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panAssignUsers" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <Localized:localizedLabel id="lblAssignUsers" runat="server" CssClass="pageTitle" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="150px" style="vertical-align: top">
                                    </td>
                                    <td>
                                        <asp:Label ID="lblUserMessage" runat="server" Visible="False" /></td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panViewUsers" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <Localized:localizedLabel id="lblViewUsers" runat="server" CssClass="pageTitle" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panUnitSelect" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td width="150px" style="vertical-align: top">
                                        <Localized:localizedLabel id="lblSelectUnits" runat="server" font-bold="true" />
                                    </td>
                                    <td>
                                        <cc1:treeview id="trvUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/"
                                            nodetext="Unit" outputstyle="MultipleSelection" />
                                        <asp:Label ID="lblUnitMessage" runat="server" Visible="False" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panAssign" runat="server" Width="99%">
                            <br />
                            <table width="100%">
                                <tr>
                                    <td width="150px">
                                    </td>
                                    <td align="right">
                                        <asp:Label ID="lblUnitAssignMessage" runat="server" Visible="True" />
                                        <Localized:localizedButton id="btnAssign" runat="server" CssClass="SaveButton" key="cmnAssign"
                                            causesvalidation="false" onclick="btnAssign_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panUserUnitSelect" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td width="150px" style="vertical-align: top">
                                        <Localized:localizedLabel id="lblSelectUserUnits" runat="server" font-bold="true" />
                                    </td>
                                    <td>
                                        <cc1:treeview id="trvUserUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/"
                                            nodetext="Unit" outputstyle="MultipleSelection" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panUnitSaveAll" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td width="150px">
                                    </td>
                                    <td align="right">
                                        <Localized:localizedButton id="btnUnitSaveAll" runat="server" CssClass="SaveButton"
                                            key="btnSaveAll" causesvalidation="false" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panUserDetails" runat="server" Width="99%">
                            <table>
                                <tr>
                                    <td width="150px">
                                        <Localized:localizedLabel id="cmnFirstName" runat="server" font-bold="true" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFirstName" runat="server" Width="200px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="150px">
                                        <Localized:localizedLabel id="cmnLastName" runat="server" font-bold="true" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtLastName" runat="server" Width="200px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="150px">
                                        <Localized:localizedLabel id="cmnUserName" runat="server" font-bold="true" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtUserName" runat="server" Width="200px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="150px">
                                        <Localized:localizedLabel id="cmnEmail" runat="server" font-bold="true" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtEmail" runat="server" Width="200px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td width="150px">
                                        <Localized:localizedLabel id="lblExternalID" runat="server" font-bold="true" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtExternalId" runat="server" Width="200px" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panSearchReset" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td width="150px">
                                    </td>
                                    <td align="right">
                                        <Localized:localizedButton id="btnSearch" runat="server" CssClass="SaveButton" key="btnSearch"
                                            causesvalidation="false" onclick="btnSearch_Click" />
                                        &nbsp;
                                        <Localized:localizedButton id="btnReset" runat="server" CssClass="SaveButton" key="btnReset"
                                            causesvalidation="false" onclick="btnReset_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panUserSearchMessage" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td width="150px">
                                    </td>
                                    <td>
                                        <asp:Label ID="lblNoUsers" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panUserSearchResults" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <asp:Label ID="lblUserCount" runat="server" Visible="False"></asp:Label>
                                        <asp:DataGrid ID="grdResults" runat="server" Width="100%" AutoGenerateColumns="False"
                                            AllowSorting="True" AllowPaging="True">
                                            <AlternatingItemStyle CssClass="tablerow1"></AlternatingItemStyle>
                                            <ItemStyle CssClass="tablerow2"></ItemStyle>
                                            <HeaderStyle CssClass="tablerowtop"></HeaderStyle>
                                            <Columns>
                                                <asp:TemplateColumn SortExpression="Pathway" HeaderText="Unit Pathway">
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "Pathway")%>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn SortExpression="LastName" HeaderText="Last Name">
                                                    <HeaderStyle></HeaderStyle>
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "LastName")%>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn SortExpression="FirstName" HeaderText="First Name">
                                                    <HeaderStyle></HeaderStyle>
                                                    <ItemTemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "FirstName")%>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderText="Assign">
                                                    <HeaderStyle></HeaderStyle>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkAssign" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "Granted")%>'
                                                            EnableViewState="True" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="UserID" HeaderText="UserID" Visible="False">
                                                    <HeaderStyle CssClass="tablerowtop" Width="250" Height="25"></HeaderStyle>
                                                </asp:BoundColumn>
                                            </Columns>
                                            <PagerStyle Mode="NumericPages" Position="Bottom"></PagerStyle>
                                        </asp:DataGrid>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panUserList" runat="server" Width="99%">
                            User List
                        </asp:Panel>
                        <asp:Panel ID="panUserSaveAll" runat="server" Width="99%">
                            <table width="100%">
                                <tr>
                                    <td width="150px">
                                    </td>
                                    <td align="right">
                                        <asp:Label ID="lblUserAssignMessage" runat="server" Visible="False" />
                                        <Localized:localizedButton id="btnUserSaveAll" runat="server" CssClass="SaveButton"
                                            key="btnSaveAll" causesvalidation="false" onclick="btnUserSaveAll_Click" />
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
                    </navigation:footer></td>
            </tr>
        </table>
    </form>
</body>
</html>
