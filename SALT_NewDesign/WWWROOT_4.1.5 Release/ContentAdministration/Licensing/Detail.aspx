<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>

<%@ Page Language="c#" Codebehind="Detail.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ContentAdministration.Licensing.Detail" %>

<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <form id="frmModule" method="post" runat="server">
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
                <!-- Body/Conent -->
                <td class="DataContainer">
                    <Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">
                    </Localized:LocalizedLabel>
                    <asp:Label ID="lblCourseName" CssClass="pageTitle" runat="server"></asp:Label>
                    <br>
                    <a href="Default.aspx">
                        <Localized:LocalizedLabel id="lblBackToCoarseList" Runat="server">
                        </Localized:LocalizedLabel></a>
                    <br />
                    <br />
                    <asp:ValidationSummary ID="validationSummary" runat="server"></asp:ValidationSummary>
                    <asp:Label ID="lblMessage" EnableViewState="False" Font-Bold="True" runat="server"></asp:Label>
                    <table cellpadding="4" cellspacing="0" border="0" width="100%">
                        <asp:Panel ID="panFuture" Visible="False" runat="server">
                            <asp:CustomValidator ID="cvFutureValidation" Text="*" Enabled="true" runat="server"></asp:CustomValidator>
                            <!-- NEXT ROW -->
                            <tr>
                                <td colspan="2">
                                    <hr color="black" />
                                </td>
                            </tr>
                            <tr valign="top">
                                <td style="background-color: white; width: 20px;">
                                    &nbsp;</td>
                                <td>
                                    <table cellpadding="4" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <font color="red"><b>[<Localized:LocalizedLabel id="lblFutureLicensePeriod" key="lblFutureLicensePeriod"
                                                    Runat="server"></Localized:LocalizedLabel>]</b></font></td>
                                        </tr>
                                        <tr valign="top">
                                            <th align="right" width="200">
                                                <Localized:LocalizedLabel id="cmnLicenses1" key="cmnLicenses" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </th>
                                            <td colspan="2">
                                                <asp:TextBox ID="txtFutureLicenseNumber" Width="50px" runat="server"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvFutureLicenseNumber" ControlToValidate="txtFutureLicenseNumber"
                                                    ErrorMessage="[Future License Period] number is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>
                                                <asp:RangeValidator ID="rvFutureLicenseNumber" ControlToValidate="txtFutureLicenseNumber"
                                                    ErrorMessage="[Future License Period] number must be a number" MinimumValue="0"
                                                    MaximumValue="9999" Text="*" Type="Integer" Enabled="true" runat="server"></asp:RangeValidator>
                                                <br />
                                                <asp:CheckBox ID="chkFutureLicenseWarnEmail" runat="server" />
                                                <Localized:LocalizedLabel id="cmnUserWarning1" key="cmnUserWarning" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtFutureLicenseWarnNumber" Width="50px" runat="server"></asp:TextBox>
                                                <asp:RangeValidator id="rvFutureLicenseWarnNumber" ControlToValidate="txtFutureLicenseWarnNumber"
													MinimumValue="0" MaximumValue="9999" Type="Integer" Text="*" Enabled="true" runat="server"/>
                                                <Localized:LocalizedLabel id="cmnUsers2" key="cmnUsers" Runat="server">
                                                </Localized:LocalizedLabel>
                                                
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="cmnLicensePeriod1" key="cmnLicensePeriod" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td colspan="2">
                                                <asp:DropDownList ID="ddlFutureDateStartDay" runat="server" />
                                                <asp:DropDownList ID="ddlFutureDateStartMonth" runat="server" />
                                                <asp:DropDownList ID="ddlFutureDateStartYear" runat="server" />
                                                to
                                                <asp:DropDownList ID="ddlFutureDateEndDay" runat="server" />
                                                <asp:DropDownList ID="ddlFutureDateEndMonth" runat="server" />
                                                <asp:DropDownList ID="ddlFutureDateEndYear" runat="server" />
                                                <br />
                                                <br />
                                                <asp:CheckBox ID="chkFutureExpiryWarnEmail" runat="server" />
                                                <Localized:LocalizedLabel id="cmnExpiryWarning1" key="cmnExpiryWarning" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:DropDownList ID="ddlFutureDateWarnDay" runat="server" />
                                                <asp:DropDownList ID="ddlFutureDateWarnMonth" runat="server" />
                                                <asp:DropDownList ID="ddlFutureDateWarnYear" runat="server" />
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="cmnSaltRep1" key="cmnSaltRep" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <Localized:LocalizedLabel id="cmnName1" key="cmnName" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtFutureRepNameSalt" Width="125px" runat="server"></asp:TextBox>&nbsp;<asp:RequiredFieldValidator
                                                    ID="rfvFutureRepNameSalt" ControlToValidate="txtFutureRepNameSalt" ErrorMessage="[Future License Period] Salt Rep Name is required"
                                                    Text="*" Enabled="true" runat="server"></asp:RequiredFieldValidator>
                                                &nbsp;&nbsp;
                                                <Localized:LocalizedLabel id="cmnEmail1" key="cmnEmail" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtFutureRepEmailSalt" Width="200px" runat="server"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvFutureRepEmailSalt" ControlToValidate="txtFutureRepEmailSalt"
                                                    ErrorMessage="[Future License Period] Salt Rep Email is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="revFutureRepEmailSalt" runat="server" CssClass="ValidatorMessage"
                                                    Display="Static" ErrorMessage="[Future License Period] Email address is not in the correct format."
                                                    Text="*" Enabled="true" ControlToValidate="txtFutureRepEmailSalt" ValidationExpression="([a-z]|[A-Z]|[0-9]|\.|-|_|\')+@([a-z]|[A-Z]|[0-9]|\.|-|_)+"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="cmnOrgRep1" key="cmnOrgRep" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <Localized:LocalizedLabel id="cmnName2" key="cmnName" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtFutureRepNameOrg" Width="125px" runat="server"></asp:TextBox>
                                                &nbsp;<asp:RequiredFieldValidator ID="rfvFutureRepNameOrg" ControlToValidate="txtFutureRepNameOrg"
                                                    ErrorMessage="[Future License Period] Org Rep Name is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>&nbsp;&nbsp;
                                                <Localized:LocalizedLabel id="cmnEmail2" key="cmnEmail" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtFutureRepEmailOrg" Width="200px" runat="server"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvFutureRepEmailOrg" ControlToValidate="txtFutureRepEmailOrg"
                                                    ErrorMessage="[Future License Period] Org Rep Email is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="revFutureRepEmailOrg" runat="server" CssClass="ValidatorMessage"
                                                    Display="Static" ErrorMessage="[Future License Period] Email address is not in the correct format."
                                                    Text="*" Enabled="true" ControlToValidate="txtFutureRepEmailOrg" ValidationExpression="([a-z]|[A-Z]|[0-9]|\.|-|_|\')+@([a-z]|[A-Z]|[0-9]|\.|-|_)+"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="lblEmailLanguage1" key="lblEmailLanguage" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlFutureLangCode" DataTextField="RecordName" DataValueField="LangCode"
                                                    runat="server">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align: right;">
                                                <Localized:localizedButton ID="btnDeleteFuturePeriod" Text="Delete Future License Period"
                                                    CausesValidation="False" runat="server" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </asp:Panel>
                        <!-- NEW ROW -->
                        <asp:Panel ID="panCurrent" Visible="False" runat="server">
                            <asp:CustomValidator ID="cvCurrentValidation" Text="*" Enabled="true" runat="server"></asp:CustomValidator>
                            <tr>
                                <td colspan="2">
                                    <hr color="black" />
                                </td>
                            </tr>
                            <tr valign="top">
                                <td id="currentWarnCell" style="background-color: #D2D2D2; width: 20px;" runat="server">
                                    &nbsp;</td>
                                <td>
                                    <table cellpadding="4" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <font color="green"><b>[<Localized:LocalizedLabel id="lblCurrentLicensePeriod" key="lblCurrentLicensePeriod"
                                                    Runat="server"></Localized:LocalizedLabel>]</b></font></td>
                                        </tr>
                                        <tr valign="top">
                                            <th align="right" width="200">
                                                <Localized:LocalizedLabel id="cmnLicenses2" key="cmnLicenses" Runat="server">
                                                </Localized:LocalizedLabel><br />
                                                <font size="-2">(total used / archived / allowed)</font></th>
                                            <td colspan="2">
                                                <font color="blue" size="3">
                                                <asp:Label ID="lblLicenseUsed" runat="server"></asp:Label></font> / <font color="red" size="3">
                                                <asp:Label ID="lblLicenseArchived" runat="server" /></font> /
                                                <asp:TextBox Width="50px" runat="server" ID="txtCurrentLicenseNumber"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvCurrentLicenseNumber" ControlToValidate="txtCurrentLicenseNumber"
                                                    ErrorMessage="Current License Number is required" Text="*" Enabled="true" runat="server"></asp:RequiredFieldValidator>
                                                <asp:RangeValidator ID="rvCurrentLicenseNumber" ControlToValidate="txtCurrentLicenseNumber"
                                                    ErrorMessage="[Current License Period] number must be a number" MinimumValue="0"
                                                    MaximumValue="9999" Type="Integer" Text="*" Enabled="true" runat="server"></asp:RangeValidator>
                                                <br />
                                                <asp:CheckBox ID="chkCurrentLicenseWarnEmail" runat="server" />
                                                <Localized:LocalizedLabel id="cmnUserWarning2" key="cmnUserWarning" Runat="server"></Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtCurrentLicenseWarnNumber" Width="50px" runat="server"></asp:TextBox>
                                                <asp:RangeValidator id="rvCurrentLicenseWarnNumber" ControlToValidate="txtCurrentLicenseWarnNumber"
													MinimumValue="0" MaximumValue="9999" Type="Integer" Text="*" Enabled="true" runat="server"/>                                                
                                                <Localized:LocalizedLabel id="cmnUsers1" key="cmnUsers" Runat="server"></Localized:LocalizedLabel>
                                                <br />
                                                <br />
                                                <Localized:LocalizedLabel id="cmnLastEmail1" key="cmnLastEmail" Runat="server"></Localized:LocalizedLabel>
                                                <asp:Label ID="lblCurrentDateLicenseWarnEmailSent" runat="server"></asp:Label>
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="cmnLicensePeriod2" key="cmnLicensePeriod" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td colspan="2">
                                                <asp:Label ID="lblCurrentDateStart" runat="server"></asp:Label>
                                                to
                                                <asp:DropDownList ID="ddlCurrentDateEndDay" runat="server" />
                                                <asp:DropDownList ID="ddlCurrentDateEndMonth" runat="server" />
                                                <asp:DropDownList ID="ddlCurrentDateEndYear" runat="server" />
                                                <br />
                                                <br />
                                                <asp:CheckBox ID="chkCurrentExpiryWarnEmail" runat="server" />
                                                <Localized:LocalizedLabel id="cmnExpiryWarning2" key="cmnExpiryWarning" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:DropDownList ID="ddlCurrentDateWarnDay" runat="server" />
                                                <asp:DropDownList ID="ddlCurrentDateWarnMonth" runat="server" />
                                                <asp:DropDownList ID="ddlCurrentDateWarnYear" runat="server" /> 
                                                <br />
                                                <br />
                                                <Localized:LocalizedLabel id="cmnLastEmail2" key="cmnLastEmail" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:Label ID="lblCurrentDateExpiryWarnEmailSent" runat="server"></asp:Label>
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="cmnSaltRep2" key="cmnSaltRep" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <Localized:LocalizedLabel id="cmnName3" key="cmnName" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtCurrentRepNameSalt" Width="125px" MaxLength="200" runat="server"></asp:TextBox>
                                                &nbsp;<asp:RequiredFieldValidator ID="rfvCurrentRepNameSalt" ControlToValidate="txtCurrentRepNameSalt"
                                                    ErrorMessage="[Current License Period] Salt Rep Name is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>&nbsp;&nbsp;
                                                <Localized:LocalizedLabel id="cmnEmail3" key="cmnEmail" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtCurrentRepEmailSalt" Width="200px" MaxLength="200" runat="server"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvCurrentRepEmailSalt" ControlToValidate="txtCurrentRepEmailSalt"
                                                    ErrorMessage="[Current License Period] Salt Rep Email is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="revCurrentRepEmailSalt" runat="server" Text="*"
                                                    Enabled="true" CssClass="ValidatorMessage" Display="Static" ErrorMessage="[Current License Period] Email address is not in the correct format."
                                                    ControlToValidate="txtCurrentRepEmailSalt" ValidationExpression="([a-z]|[A-Z]|[0-9]|\.|-|_|\')+@([a-z]|[A-Z]|[0-9]|\.|-|_)+"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="cmnOrgRep2" key="cmnOrgRep" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <Localized:LocalizedLabel id="cmnName4" key="cmnName" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtCurrentRepNameOrg" Width="125px" MaxLength="200" runat="server"></asp:TextBox>
                                                &nbsp;<asp:RequiredFieldValidator ID="rfvCurrentRepNameOrg" ControlToValidate="txtCurrentRepNameOrg"
                                                    ErrorMessage="[Current License Period] Org Rep Name is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>
                                                    &nbsp;&nbsp;
                                                <Localized:LocalizedLabel id="cmnEmail4" key="cmnEmail" Runat="server">
                                                </Localized:LocalizedLabel>
                                                <asp:TextBox ID="txtCurrentRepEmailOrg" Width="200px" MaxLength="200" runat="server"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvCurrentRepEmailOrg" ControlToValidate="txtCurrentRepEmailOrg"
                                                    ErrorMessage="[Current License Period] Org Rep Email is required" Text="*" Enabled="true"
                                                    runat="server"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="revCurrentRepEmailOrg" runat="server" CssClass="ValidatorMessage"
                                                    Display="Static" ErrorMessage="[Current License Period] Email address is not in the correct format."
                                                    Text="*" Enabled="true" ControlToValidate="txtCurrentRepEmailOrg" ValidationExpression="([a-z]|[A-Z]|[0-9]|\.|-|_|\')+@([a-z]|[A-Z]|[0-9]|\.|-|_)+"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr valign="top">
                                            <td align="right">
                                                <Localized:LocalizedLabel id="lblEmailLanguage2" key="lblEmailLanguage" Runat="server">
                                                </Localized:LocalizedLabel>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlCurrentLangCode" DataTextField="RecordName" DataValueField="LangCode"
                                                    runat="server">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <hr color="black" />
                                </td>
                            </tr>
                            <!-- this validator must be contained in panFuture and must appear at the end of the validation order -->
                            <asp:CustomValidator ID="cvFinalValidation" Text="*" Enabled="true" runat="server"></asp:CustomValidator>
                        </asp:Panel>
                    </table>
                    <table cellpadding="8" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td style="text-align: right;">
                            <Localized:LocalizedLabel id="lblNoLicenses" key="lblNoLicenses" Visible="False" Runat="server"></Localized:LocalizedLabel>&nbsp;&nbsp;&nbsp;
                                <Localized:localizedButton ID="btnNewLicensePeriod" Text="New License Period" Visible="False"
                                    CausesValidation="False" runat="server" />
                                <br>
                                <Localized:localizedButton ID="btnSaveAll" Text="Save All" Visible="False" CausesValidation="False" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr valign="bottom" align="center">
                <td valign="middle" align="center" colspan="2">
                    <navigation:footer id="ucFooter" runat="server">
                    </navigation:footer></td>
            </tr>
            </TBODY></table>
    </form>
</body>
</html>
