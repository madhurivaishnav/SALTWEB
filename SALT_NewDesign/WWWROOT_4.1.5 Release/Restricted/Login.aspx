<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="uc1" TagName="Login" Src="/General/UserControls/Login.ascx" %>

<%@ Page Language="c#" CodeBehind="Login.aspx.cs" AutoEventWireup="false" Inherits="Bdw.Application.Salt.Web.Login" %>

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
    <%-- <Style:STYLE id="ucStyle" runat="server">
    </Style:STYLE>
--%>
    <script>
			function fn_void_showAbout()
			{
				var objAboutWindow = window.open("/About.aspx", "About", "width=400, height=380, location=no, menubar=no, status=no, toolbar=no, scrollbars=no, resizable=no");
			}
			function fn_void_showPasswordRecovery()
			{
				var objAboutWindow = window.open("/PasswordRecovery.aspx", "About", "width=400, height=295, location=no, menubar=no, status=no, toolbar=no, scrollbars=no, resizable=no");
			}
			function fn_void_RequestURL()
		   {
		       var objAboutWindow = window.open("/PasswordRecovery.aspx?Rdct=UniqueURL", "About", "width=400, height=380, location=no, menubar=no, status=no, toolbar=no, scrollbars=no, resizable=no");
			}
    </script>

    <style type="text/css">
        .wrapper
        {
            position: absolute;
            top: 5%;
            left: 35%; /* transform: translate(-50%, -50%);*/
        }
        .content
        {
            padding-top: 15px;
        }
        #footerShell
        {
            background-color: #ffffff;
            padding: 20px;
            width: 85%;
            text-align: center;
            font-size: 11px;
        }
        #loginbox
        {
            background-color: #ffffff;
            width: 300px;
        }
        #mainColumn
        {
            padding-bottom: 40px;
        }
        input, textarea, select, button
        {
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            width: 183px;
            padding: 0.1rem 0.65rem;
            font-size: 12px;
            background-color: #fff;
            background-image: none;
            background-clip: padding-box;
            border: 1px solid rgba(0, 0, 0, 0.15);
            border-radius: 0.25rem;
            transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
        }
        body
        {
            font-size: 10pt; /* Default font size used throught the application unless overridden by other styles */
            font-family: Arial, Helvetica, sans-serif; /* default font used throught the application unless overridden by other styles */
            color: #333333;
            margin: 0;
            padding: 0;
            background: url('../General/Images/login-background3.jpg' ) no-repeat center center;
            background-position: center center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
        }
        .login
        {
            color: #6689CC;
            font-weight: bold;
            text-decoration: none;
        }
        .LoginButton /* the submit button on the login page */
        {
            border-style: outset;
            border-width: thin;
            padding: 1 3 1 3;
            font-weight: bold;
            font-size: 12px;
            background-color: #6689CC;
            border-radius: 5px;
            width: 85px;
            color: #fff;
        }
        .searchbox
        {
            width: 200px;
            height: 100%;
            background-color: #cccccc;
            border-color: #cccccc;
            border-style: solid;
            border-width: 13px;
            color: #575757;
            text-align: left;
            background-position: center;
            margin: 0 0 0px 35px;
        }
        #logo
        {
             height: 149px;
            background: url(/general/images/Salt-web-logo.png) no-repeat bottom left;
            margin-bottom: 50px;
            width: 395px;margin-left: 30px;
        }
        .WarningMessageLoginPage
        {
            display: inline-block; /* alows the object that this style is attached to to be positioned vertically */
            font-weight: bold;
          
            border: solid 0px #cc3333;
            background-color: none;
            height: 10px;
            margin-left:40px;
            color: #cc3333;
        }
    </style>
</head>
<body>
    <form id="Form1" method="post" runat="server" autocomplete="off">
    <div class="wrapper">
        <!-- Logo-->
        <div id="logo">
        </div>
        <!-- /Logo-->
        <!-- Loginbox -->
        <div id="loginbox">
            <div>
                <uc1:login id="Login1" runat="server" title="tool tip">
                </uc1:login>
            </div>
        </div>
        <!-- /Loginbox -->
        <!-- mainColumn-->
        <div id="mainColumn">
            <ul>
                <h1>
                    <asp:Label ID="lblApplicationName" Visible="false" runat="server" Font-Bold="true"></asp:Label><asp:Label
                        ID="lblTradeMark1" Visible="false" runat="server" CssClass="TradeMarkInlineInheritColour"></asp:Label></h1>
                <table>
                    <tr>
                        <Localized:LocalizedLiteral ID="litCourseList" runat="server"></Localized:LocalizedLiteral>
                    </tr>
                </table>
            </ul>
        </div>
        <!-- /mainColumn -->
        <div id="footerShell">
            <!-- footerWrapper-->
            <div id="footerWrapper">
                <!-- footerLeft -->
                <div id="footerLeft">
                    <Localized:LocalizedLabel ID="lblIntroduction" runat="server"></Localized:LocalizedLabel><br />
                    <div style="padding-top: 10px;">
                        <b>If you require technical support:<asp:Button ID="Button1" runat="server" Text="Button"
                            CssClass="LoginButton" OnClick="Button1_Click" Visible="false" /></b> <a class="prod"
                                href="mailto:support@saltcompliance.com">support@saltcompliance.com</a></div>
                    <div style="padding-top: 10px;">
                        <img src="../general/images/flags_small/au.gif">&nbsp;1800 676 011<img src="../general/images/flags_small/nz.gif"
                            style="margin-left: 20px;">&nbsp;0800 629 691
                        <img src="../general/images/flags_small/sn.jpg" style="margin-left: 0px;">&nbsp;800
                        852 3070</div>
            </div>
            <!-- /footerLeft -->
            <!-- footerRight -->
            <div id="footerRight">
                <p>
                    ©
                    <asp:Label ID="lblCopyrightYear" runat="server"></asp:Label>&nbsp;<asp:HyperLink
                        ID="lnkCompany" Target="_blank" CssClass="Login" runat="server"></asp:HyperLink>
                    &nbsp;|&nbsp;
                    <Localized:LocalizedHyperLink ID="lnkTermsOfUse" CssClass="Login" runat="server"
                        Target="_blank"></Localized:LocalizedHyperLink>&nbsp;|&nbsp;
                    <Localized:LocalizedHyperLink ID="lnkPrivacyPolicy" CssClass="Login" runat="server"
                        Target="_blank"></Localized:LocalizedHyperLink>&nbsp;|&nbsp; <a class="Login" href="javascript: fn_void_showAbout();">
                            <Localized:LocalizedLabel ID="litAbout" runat="server"></Localized:LocalizedLabel>&nbsp;<asp:Label
                                ID="lblApplicationNameSmall" runat="server"></asp:Label>
                            <asp:Label ID="lblTradeMark2" runat="server" CssClass="TradeMarkInlineInheritColour2"></asp:Label></a>
                </p>
            </div>
            <!-- /footerRight -->
        </div>
        <!-- /footerWrapper -->
    </div>
    </div>
    </form>
</body>
</html>
