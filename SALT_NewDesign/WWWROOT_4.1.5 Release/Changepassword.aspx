<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="uc1" TagName="Login" Src="/General/UserControls/Login.ascx" %>

<%@ Page Language="c#" CodeBehind="Changepassword.aspx.cs" AutoEventWireup="false"
    Inherits="Bdw.Application.Salt.Web.Changepassword" %>

<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <title id="pagTitle" runat="server"></title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <Style:STYLE id="ucStyle" runat="server">
    </Style:STYLE>
    <style>
    .LoginButton1
    {
    	background-color:#809DD6;
    	}
    </style>
</head>
<body>
    <form id="Form1" method="post" runat="server" autocomplete="off">
    <!-- contentShell-->
    <div id="contentShell">
        <!-- contentWrapper-->
        <div id="contentWrapper">
            <div class="clear">
            </div>
            <!-- tertiaryColumn-->
            <div id="tertiaryColumn">
                <!-- Loginbox -->
                <div id="loginbox">
                    <div class="searchbox">
                        <h4 style="text-transform: uppercase; color: #cccccc; font-size: 2.3em; font-decoration: bold;
                            vertical-align: bottom;">
                            <asp:Literal ID="litLogin" runat="server"></asp:Literal></h4>
                        <div id="divchangepassword" runat=server visible=false class="searchbox" style="width: 205px; height: 235px; background-color: #cccccc;
                            border-color: #cccccc; border-style: solid; border-width: 13px; color: #575757;">
                            <div>
                                <asp:DropDownList ID="ddlLanguageList" Width="205px" Visible="False" AutoPostBack="True"
                                    runat="server">
                                </asp:DropDownList>
                                <asp:Repeater ID="rptFlag" Visible="False" runat="server">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgFlag" runat="server" />&nbsp;
                                        <!--- < there must be a single space after the tag. Can't use &nbsp; -->
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div>
                                <b>
                                    <Localized:LocalizedLiteral ID="litUserName" runat="server"></Localized:LocalizedLiteral></b>
                                <br>
                                <asp:TextBox ID="txtUserName" runat="server" MaxLength="50" CssClass="Login"></asp:TextBox></a>
                                <br>
                                <br>
                            </div>
                            <div>
                                <b>
                                    <Localized:LocalizedLiteral ID="litPassword" runat="server"></Localized:LocalizedLiteral></b><br>
                                <asp:TextBox ID="txtPassword" runat="server" MaxLength="50" TextMode="Password" CssClass="Login"></asp:TextBox>&nbsp;
                                <Localized:LocalizedRequiredFieldValidator ID="rvlPassword" runat="server" CssClass="ValidatorMessage"
                                    Display="Dynamic" ErrorMessage="You must specify the Password." ControlToValidate="txtPassword">
                                </Localized:LocalizedRequiredFieldValidator>
                                <Localized:LocalizedRegularExpressionValidator ID="revNewPassword" runat="server"
                                    CssClass="ValidatorMessage" Display="Dynamic" ErrorMessage="The New Password must be at least 8 characters."
                                    ControlToValidate="txtPassword" ValidationExpression=".{8,}">
                                </Localized:LocalizedRegularExpressionValidator>
                                <br>
                                <br>
                            </div>
                            <div>
                                <b>
                                    <Localized:LocalizedLiteral ID="lblConfirmPassword" runat="server" Text="Confirm Password"></Localized:LocalizedLiteral></b><br>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" MaxLength="50" TextMode="Password"
                                    CssClass="Login"></asp:TextBox>
                                <Localized:LocalizedRequiredFieldValidator ID="rvlConfirmPassword" runat="server"
                                    CssClass="ValidatorMessage" Display="Dynamic" ErrorMessage="You must specify the Confirm Password."
                                    ControlToValidate="txtConfirmPassword">
                                </Localized:LocalizedRequiredFieldValidator>
                                <Localized:LocalizedCustomValidator ID="cvlConfirmPassword" runat="server" CssClass="ValidatorMessage"
                                    Display="Dynamic" ErrorMessage="Confirm Password is required when attempting to change your password."
                                    ControlToValidate="txtConfirmPassword" OnServerValidate="cvlConfirmPassword_ServerValidate">
                                </Localized:LocalizedCustomValidator>
                                <Localized:LocalizedCompareValidator ID="cpvPassword" runat="server" CssClass="ValidatorMessage"
                                    Display="Dynamic" ErrorMessage="New Password and Confirm Password do not match. Please enter them again."
                                    ControlToValidate="txtConfirmPassword" designtimedragdrop="113" ControlToCompare="txtPassword">
                                </Localized:LocalizedCompareValidator><br>
                                <br>
                                <br>
                            </div>
                            <div>
                                <Localized:LocalizedButton ID="btnChangePassword" runat="server" Text="Login" CssClass="LoginButton1"
                                    OnClick="btnChangePassword_Click" Visible="false" ></Localized:LocalizedButton><p>
                                    </p>
                            </div>
                        </div>
                        <div style="width: 231px;">
                            <br>
                            <asp:Label ID="lblErrorMessage" runat="server" EnableViewState="False"></asp:Label><br>
                            <br>
                        </div>
                    </div>
                    <!-- /Loginbox -->
                    <!-- Logo-->
                    <div id="logo">
                    </div>
                    <!-- /Logo-->
                    <!-- mainColumn-->
                    <div id="mainColumn">
                        <ul>
                            <h1>
                                <asp:Label ID="lblApplicationName" Visible="false" runat="server" Font-Bold="true"></asp:Label><asp:Label
                                    ID="lblTradeMark1" Visible="false" runat="server" CssClass="TradeMarkInlineInheritColour"></asp:Label></h1>
                            <Localized:LocalizedLabel ID="lblIntroduction" runat="server"></Localized:LocalizedLabel>
                            <br>
                            <br>
                            <br>
                            <table>
                                <tr>
                                    <Localized:LocalizedLiteral ID="litCourseList" runat="server"></Localized:LocalizedLiteral>
                                </tr>
                            </table>
                        </ul>
                    </div>
                    <!-- /mainColumn -->
                </div>
                <!-- /tertiaryColumn -->
                <div class="clear">
                </div>
            </div>
            <!-- /contentWrapper -->
        </div>
        <!-- /contentShell -->
        <!-- footerShell-->
        <div id="footerShell">
            <!-- footerWrapper-->
            <div id="footerWrapper">
                <!-- footerLeft -->
                <div id="footerLeft">
                    <p>
                        <p>
                            <%--<b>If you require technical support:<asp:Button ID="Button1" runat="server" Text="Button"
                                OnClick="Button1_Click" /></b>--%>
                            <br />
                            <a class="prod" href="mailto:support@saltcompliance.com">support@saltcompliance.com</a>
                            <br />
                            <img src="../general/images/flags_small/au.gif" />&nbsp;1800 676 011<img src="../general/images/flags_small/nz.gif"
                                style="margin-left: 20px;" />&nbsp;0800 629 691
                            <br />
                            &nbsp;</br></p>
                    </p>
                </div>
                <!-- /footerLeft -->
                <!-- footerRight -->
                <div id="footerRight">
                    <p style="color: #000">
                        ©
                        <asp:Label ID="lblCopyrightYear" runat="server"></asp:Label>&nbsp;<asp:HyperLink
                            ID="lnkCompany" Target="_blank" runat="server"></asp:HyperLink>
                        &nbsp;|&nbsp;
                        <Localized:LocalizedHyperLink ID="lnkTermsOfUse" runat="server" Target="_blank"></Localized:LocalizedHyperLink>&nbsp;|&nbsp;
                        <Localized:LocalizedHyperLink ID="lnkPrivacyPolicy" runat="server" Target="_blank"></Localized:LocalizedHyperLink>&nbsp;|&nbsp;
                        <a href="javascript:fn_void_showAbout();">
                            <Localized:LocalizedLabel ID="litAbout" runat="server"></Localized:LocalizedLabel>&nbsp;<asp:Label
                                ID="lblApplicationNameSmall" runat="server"></asp:Label>
                            <asp:Label ID="lblTradeMark2" runat="server" CssClass="TradeMarkInlineInheritColour2"></asp:Label></a>
                    </p>
                </div>
                <!-- /footerRight -->
            </div>
            <!-- /footerWrapper -->
        </div>
        <!-- /footerShell -->
    </form>
</body>
</html>
