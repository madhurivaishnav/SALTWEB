<%@ Register TagPrefix="Style" TagName="Style" Src="General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="uc1" TagName="Login" Src="General/UserControls/Login.ascx" %>
<%@ Page language="c#" Codebehind="Login.aspx.cs" AutoEventWireup="false" Inherits="Bdw.Application.Salt.Web.Login" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

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
				var objAboutWindow = window.open("/PasswordRecovery.aspx", "About", "width=300, height=295, location=no, menubar=no, status=no, toolbar=no, scrollbars=no, resizable=no");
			}
			
		</script>


	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server" autocomplete="off">


		<!-- contentShell-->
		<div id="contentShell">

			<!-- contentWrapper-->
			<div id="contentWrapper">

				<div class="clear"></div>

					<!-- tertiaryColumn-->
				<div id="tertiaryColumn">
				<!-- Loginbox -->
				<div id="loginbox">
					<div class="searchbox">
						
						<uc1:login id="Login1" runat="server"></uc1:login>
					

	
					</div>
				<!-- /Loginbox -->
				<!-- Logo-->
				<div id="logo"></div>
				<!-- /Logo-->
				<!-- mainColumn-->
				<div id="mainColumn">
					<ul>
						<h1><asp:label id="lblApplicationName" visible="false" runat="server" font-bold="true"></asp:label><asp:label id="lblTradeMark1" visible="false" runat="server" cssclass="TradeMarkInlineInheritColour"></asp:label></h1>
						<Localized:LocalizedLabel id="lblIntroduction" runat="server"></Localized:LocalizedLabel>
						<BR>
						
						<br>
						<br>
					
						<table>
							<tr>
							<Localized:LocalizedLiteral id="litCourseList" runat="server"></Localized:LocalizedLiteral>
							</tr>
						</table>
					</ul>
				</div>
				<!-- /mainColumn -->
</div>
				<!-- /tertiaryColumn -->

				
				<div class="clear"></div>

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

					<p><b>If you require technical support:</b>
					<br/><a class="prod" href="mailto:support@saltcompliance.com">support@saltcompliance.com</a>
					<br/><img src="general/images/flags_small/au.gif"/>&nbsp;1800 676 011
					<br/>&nbsp;</br></p>

					</p>
				</div>
				<!-- /footerLeft -->
				<!-- footerRight -->
				<div id="footerRight">
					<p>
						©
						<asp:label id="lblCopyrightYear" runat="server"></asp:label>&nbsp;<asp:hyperlink id="lnkCompany" Target="_blank" CssClass="Login" Runat="server"></asp:hyperlink>
						&nbsp;|&nbsp;
						<Localized:Localizedhyperlink id="lnkTermsOfUse" CssClass="Login" Runat="server" target="_blank"></Localized:Localizedhyperlink>&nbsp;|&nbsp;
						<Localized:Localizedhyperlink id="lnkPrivacyPolicy" CssClass="Login" Runat="server" target="_blank"></Localized:Localizedhyperlink>&nbsp;|&nbsp;
						<A class="Login" href="javascript: fn_void_showAbout();"><Localized:LocalizedLabel id="litAbout" runat="server"></Localized:LocalizedLabel>&nbsp;<asp:label id="lblApplicationNameSmall" runat="server"></asp:label>
						<asp:label id="lblTradeMark2" runat="server" cssclass="TradeMarkInlineInheritColour2"></asp:label></A>
					</p>
				</div>
				<!-- /footerRight -->

			</div>
			<!-- /footerWrapper -->

		</div>
		<!-- /footerShell -->
		</form>
	</body>
</HTML>
