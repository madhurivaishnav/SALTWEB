<%@ Page Language="c#" CodeBehind="UserDetails.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Users.UserDetails" %>

<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="usermenu" Src="/General/UserControls/Navigation/UserMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title runat="server" id="pagTitle"></title>
    <Style:style id="ucStyle" runat="server">
    </Style:style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <form id="frmUserDetails" method="post" runat="server" defaultbutton="btnSave">
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
            <td class="AdminMenuContainer" width="295px">
                <navigation:usermenu id="ucUserMenu" runat="server">
                </navigation:usermenu>
                <navigation:adminmenu id="ucAdminMenu" runat="server">
                </navigation:adminmenu>
            </td>
            <!-- Body/Conent -->
            <td class="DataContainer">
                <asp:Label ID="lblPageTitle" runat="server" CssClass="pageTitle">User Details</asp:Label><br>
                <table width="75%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <!-- Search Criteria -->
                                <asp:Label ID="lblMessageUnit" runat="server"></asp:Label>
                                <table id="tblSearchCriteria" width="100%" align="left" border="0">
                                    <asp:PlaceHolder ID="plhMainForm" runat="server">
                                        <asp:PlaceHolder ID="plhUnitSelector" runat="server">
                                            <tbody>
                                                <tr>
                                                    <td class="formLabel" width="20%">
                                                        <Localized:LocalizedLabel ID="lblUnit" runat="server">
                                                        </Localized:LocalizedLabel>
                                                    </td>
                                                    <td width="80%">
                                                        <!-- Div to control overflow -->
                                                        <div class="unitControl" nowrap>
                                                            <cc1:TreeView ID="trvUnitsSelector" runat="server" SystemImagesPath="/General/Images/TreeView/"
                                                                NodeText="Unit" OutputStyle="SingleSelection">
                                                            </cc1:TreeView>
                                                            <asp:Label ID="lblUnits" runat="server" Height="18px" Visible="False">Not assigned to a unit.</asp:Label>
                                                            <Localized:LocalizedCustomValidator ID="cvlUnit" runat="server" CssClass="ValidatorMessage"
                                                                ErrorMessage="You must specify the Unit." Display="Dynamic" OnServerValidate="cvlUnit_ServerValidate">
                                                            </Localized:LocalizedCustomValidator></div>
                                                    </td>
                                                </tr>
                                        </asp:PlaceHolder>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblFirstName" Key="cmnFirstName" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtFirstName" runat="server" Width="250px" MaxLength="50"></asp:TextBox>&nbsp;<Localized:LocalizedRequiredFieldValidator
                                                    ID="rfvFirstName" runat="server" CssClass="ValidatorMessage" Display="Dynamic"
                                                    ErrorMessage="You must specify the First Name." ControlToValidate="txtFirstName"></Localized:LocalizedRequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblLastName" Key="cmnLastName" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtLastName" runat="server" Width="250px" MaxLength="50"></asp:TextBox>&nbsp;<Localized:LocalizedRequiredFieldValidator
                                                    ID="rfvLastName" runat="server" CssClass="ValidatorMessage" Display="Dynamic"
                                                    ErrorMessage="You must specify the Last Name." ControlToValidate="txtLastName"></Localized:LocalizedRequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblUserName" Key="cmnUserName" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtUserName" runat="server" Width="250px" MaxLength="100"></asp:TextBox>&nbsp;<Localized:LocalizedRequiredFieldValidator
                                                    ID="rfvUserName" runat="server" CssClass="ValidatorMessage" Display="Dynamic"
                                                    ErrorMessage="You must specify the Username." ControlToValidate="txtUserName"></Localized:LocalizedRequiredFieldValidator><Localized:LocalizedRegularExpressionValidator
                                                        ID="revUserName" runat="server" CssClass="ValidatorMessage" Display="Dynamic"
                                                        ErrorMessage="User Name must be at least 3 characters." ControlToValidate="txtUserName"
                                                        ValidationExpression=".{3,}" designtimedragdrop="111"></Localized:LocalizedRegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblOldPassword" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtOldPassword" runat="server" MaxLength="50" TextMode="Password"></asp:TextBox>&nbsp;
                                                <Localized:LocalizedCustomValidator ID="cvlOldPassword" runat="server" CssClass="ValidatorMessage"
                                                    Display="Dynamic" ErrorMessage='You must specify the "Old Password" when attempting to change the password.'
                                                    ControlToValidate="txtPassword" OnServerValidate="cvlOldPassword_ServerValidate">
                                                </Localized:LocalizedCustomValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblNewPassword" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPassword" runat="server" MaxLength="50" TextMode="Password"></asp:TextBox>&nbsp;
                                                <Localized:LocalizedRequiredFieldValidator ID="rvlPassword" runat="server" CssClass="ValidatorMessage"
                                                    Display="Dynamic" ErrorMessage="You must specify the Password." ControlToValidate="txtPassword">
                                                </Localized:LocalizedRequiredFieldValidator>
                                                <Localized:LocalizedRegularExpressionValidator ID="revNewPassword" runat="server"
                                                    CssClass="ValidatorMessage" Display="Dynamic" ErrorMessage="The New Password must be at least 8 characters."
                                                    ControlToValidate="txtPassword" ValidationExpression=".{8,}">
                                                </Localized:LocalizedRegularExpressionValidator>
                                                <Localized:LocalizedCompareValidator ID="cpvOldPassword" runat="server" CssClass="ValidatorMessage"
                                                    Display="Dynamic" ErrorMessage='"New Password" and "Old Password" cannot be the same.'
                                                    ControlToValidate="txtPassword" designtimedragdrop="114" ControlToCompare="txtOldPassword"
                                                    Operator="NotEqual">
                                                </Localized:LocalizedCompareValidator>
                                                <Localized:LocalizedButton ID="butRamdonPwd" runat="server" Width="150" CssClass="generateButton"
                                                    CausesValidation="False" OnClick="butRamdonPwd_Click"></Localized:LocalizedButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblConfirmPassword" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtConfirmPassword" runat="server" MaxLength="50" TextMode="Password"></asp:TextBox>&nbsp;
                                                <Localized:LocalizedRequiredFieldValidator ID="rvlConfirmPassword" runat="server"
                                                    CssClass="ValidatorMessage" Display="Dynamic" ErrorMessage="You must specify the Confirm Password."
                                                    ControlToValidate="txtConfirmPassword">
                                                </Localized:LocalizedRequiredFieldValidator>
                                                <Localized:LocalizedCustomValidator ID="cvlConfirmPassword" runat="server" CssClass="ValidatorMessage"
                                                    Display="Dynamic" ErrorMessage="Confirm Password is required when attempting to change your password."
                                                    ControlToValidate="txtPassword" OnServerValidate="cvlConfirmPassword_ServerValidate">
                                                </Localized:LocalizedCustomValidator>
                                                <Localized:LocalizedCompareValidator ID="cpvPassword" runat="server" CssClass="ValidatorMessage"
                                                    Display="Dynamic" ErrorMessage="New Password and Confirm Password do not match. Please enter them again."
                                                    ControlToValidate="txtConfirmPassword" designtimedragdrop="113" ControlToCompare="txtPassword">
                                                </Localized:LocalizedCompareValidator><br>
                                                <Localized:LocalizedLabel ID="lblPasswordInstruction" runat="server">Note: leave blank if you do not wish to change password</Localized:LocalizedLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <asp:Label ID="lblCustomClassLabel" runat="server">Grouping</asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="cboCustomClass" runat="server">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblEmail" Key="cmnEmail" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtEmail" runat="server" Width="250px" MaxLength="100"></asp:TextBox>&nbsp;<Localized:LocalizedRequiredFieldValidator
                                                    ID="rfvEmail" runat="server" CssClass="ValidatorMessage" Display="Dynamic" ErrorMessage="You must specify the Email."
                                                    ControlToValidate="txtEmail"></Localized:LocalizedRequiredFieldValidator><Localized:LocalizedRegularExpressionValidator
                                                        ID="revEmail" runat="server" CssClass="ValidatorMessage" Display="Dynamic" ErrorMessage="Email address is not in the correct format. Please enter it again."
                                                        ControlToValidate="txtEmail" ValidationExpression="([a-z]|[A-Z]|[0-9]|\.|-|_|\')+@([a-z]|[A-Z]|[0-9]|\.|-|_)+"></Localized:LocalizedRegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblUserActive" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <Localized:LocalizedCheckBox ID="chkUserStatus" OnCheckedChanged="chkUserStatus_CheckedChanged"
                                                    AutoPostBack="true" runat="server" Checked="True"></Localized:LocalizedCheckBox>
                                                <asp:Label ID="lblUserStatus" runat="server">No User Status</asp:Label>
                                            </td>
                                        </tr>
                                        <asp:PlaceHolder ID="plhNotifications" runat="server">
                                            <tr>
                                                <td class="formLabel">
                                                    <Localized:LocalizedLabel ID="lblNotifyManager" runat="server">
                                                    </Localized:LocalizedLabel>
                                                </td>
                                                <td>
                                                    <Localized:LocalizedCheckBox ID="chkNotifyManager" runat="server" Checked="False">
                                                    </Localized:LocalizedCheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="formLabel">
                                                    <Localized:LocalizedLabel ID="lblEmail2" Key="mgrEmail" runat="server">
                                                    </Localized:LocalizedLabel>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEmail2" runat="server" Width="250px" MaxLength="100"></asp:TextBox>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="formLabel">
                                                    <Localized:LocalizedLabel ID="lblEmailUnitAdmin" runat="server">
                                                    </Localized:LocalizedLabel>
                                                </td>
                                                <td>
                                                    <Localized:LocalizedCheckBox ID="chkEmailUnitAdmin" runat="server" Checked="False">
                                                    </Localized:LocalizedCheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="formLabel">
                                                    <Localized:LocalizedLabel ID="lblEmailOrgAdmin" runat="server">
                                                    </Localized:LocalizedLabel>
                                                </td>
                                                <td>
                                                    <Localized:LocalizedCheckBox ID="chkEmailOrgAdmin" runat="server" Checked="False">
                                                    </Localized:LocalizedCheckBox>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="plhEbookNotification" runat="server">
                                            <tr>
                                                <td class="formLabel">
                                                    <Localized:LocalizedLabel ID="lblEbookNotification" runat="server">
                                                    </Localized:LocalizedLabel>
                                                </td>
                                                <td>
                                                    <Localized:LocalizedCheckBox ID="chkEbookNotification" runat="server" Checked="False">
                                                    </Localized:LocalizedCheckBox>
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblLastLoginLabel" runat="server" Text="Last Logon">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblLastLogin" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblAdminPrivileges" runat="server" Visible="False">Unit Administrator Privileges</Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <cc1:TreeView ID="trvUnitPrivileges" runat="server" OutputStyle="MultipleSelection"
                                                    NodeText="Unit" SystemImagesPath="/General/Images/TreeView/" Visible="False">
                                                </cc1:TreeView>
                                                <Localized:LocalizedLabel ID="lblNoAdminPrivileges" runat="server" Visible="False">No Administrator Privileges.</Localized:LocalizedLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblExternalIDLabel" runat="server">External ID</Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtExternalID" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblUnlock" runat="server" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="chkUnlock" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <Localized:LocalizedLabel ID="lblApplicationAdmin" runat="server" Visible="False">Application Adminstrator</Localized:LocalizedLabel>
                                                <Localized:LocalizedLabel ID="lblOrganisationAdmin" runat="server" Visible="False">Organisation Administrator</Localized:LocalizedLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formLabel">
                                                <Localized:LocalizedLabel ID="lblTimeZone" runat="server" ccsclass="formLabel" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="listTimeZone" runat="server">
                                                </asp:DropDownList>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <Localized:LocalizedButton ID="btnSave" Key="cmnSave" runat="server" CssClass="saveButton"
                                                    Text="Save" OnClick="btnSave_Click" /><br>
                                                <asp:Label ID="lblMessage" EnableViewState="false" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="lnkReturnTo" runat="server" CausesValidation="False" OnClick="lnkReturnTo_Click"></asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr id="trwUserModuleAccess" runat="server">
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <Localized:LocalizedHyperLink ID="lnkModuleAccess" runat="server">
                                                </Localized:LocalizedHyperLink>&nbsp;
                                                <Localized:LocalizedLabel ID="lblModuleMessage" runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <Localized:LocalizedHyperLink ID="lnkReceivedEmails" runat="server"></Localized:LocalizedHyperLink>
                                            </td>
                                        </tr>
                    </tbody>
                    </asp:PlaceHolder></table>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    </TD></TR>
    <!-- Footer -->
    <tr valign="bottom" align="center">
        <td valign="middle" align="center" colspan="2">
            <navigation:footer id="ucFooter" runat="server">
            </navigation:footer>
        </td>
    </tr>
    </TBODY></TABLE></form>
</body>
</html>
