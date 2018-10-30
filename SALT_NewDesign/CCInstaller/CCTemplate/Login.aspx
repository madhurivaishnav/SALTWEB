<%@ Register TagPrefix="Style" TagName="Style" Src="General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="uc1" TagName="Login" Src="General/UserControls/Login.ascx" %>
<%@ Page language="c#" Codebehind="Login.aspx.cs" AutoEventWireup="false" Inherits="Bdw.Application.Salt.Web.Login" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<STYLE:STYLE id="ucStyle" runat="server"></STYLE:STYLE>
		<script>
			function fn_void_showAbout()
			{
				var objAboutWindow = window.open("/About.aspx", "About", "width=400, height=380, location=no, menubar=no, status=no, toolbar=no, scrollbars=no, resizable=no");
			}
			function fn_void_showPasswordRecovery()
			{
				var objAboutWindow = window.open("/PasswordRecovery.aspx", "About", "width=400, height=295, location=no, menubar=no, status=no, toolbar=no, scrollbars=no, resizable=no");
			}
			
		</script>

	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server" autocomplete="off">
		<!-- contentShell-->

		 <div id="contentShell">

			<div id="contentWrapper">

                          <div id="contentHeader">
                          <h1>
                             <asp:label id="lblApplicationName" runat="server" visible="false"></asp:label>
                             <asp:label id="lblTradeMark1" Visible="False" runat="server" cssclass="TradeMarkInlineInheritColour"></asp:label>
                          </h1>
                          </div>
                          <!-- /contentHeader -->

                        <uc1:login id="Login1" runat="server"></uc1:login>

			</div>
			<!-- /contentWrapper -->

		</div>
		<!-- /contentShell -->

		<!-- footerShell-->
		<div id="footerShell">

			<!-- footerWrapper -->
			<!--<div id="footerWrapper">

				<!-- footerLeft -->
				<div id="footerLeft">
					<p>
						©
						<asp:label id="lblCopyrightYear" runat="server"></asp:label>&nbsp;<asp:hyperlink id="lnkCompany" Target="_blank" CssClass="Login" Runat="server"></asp:hyperlink>
						&nbsp;|&nbsp;
						<Localized:Localizedhyperlink id="lnkTermsOfUse" CssClass="Login" Runat="server" target="_blank"></Localized:Localizedhyperlink>&nbsp;|&nbsp;
						<Localized:Localizedhyperlink id="lnkPrivacyPolicy" CssClass="Login" Runat="server" target="_blank"></Localized:Localizedhyperlink>&nbsp;|&nbsp;
						<A class="Login" href="javascript: fn_void_showAbout();"><Localized:LocalizedLabel id="litAbout" runat="server"></Localized:LocalizedLabel>&nbsp;<asp:label id="lblApplicationNameSmall" runat="server"></asp:label>
						<asp:label id="lblTradeMark2" runat="server" cssclass="TradeMarkInlineInheritColour2" visible="false"></asp:label></A>
                                        </p>
				</div>
				<!-- /footerLeft -->
				<!-- footerRight -->
				<!--<div id="footerRight">
					<p></p>
				</div>
				<!-- /footerRight -->

			<!--</div>
			<!-- /footerWrapper -->

		</div>
		<!-- /footerShell -->
		</form>
	</body>
</HTML>
