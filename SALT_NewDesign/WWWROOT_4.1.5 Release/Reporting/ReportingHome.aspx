<%@ Page language="c#" Codebehind="ReportingHome.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.ReportingHome" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">		
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<script type="text/javascript" src="../General/Js/navigationmenu-jquery-latest.min.js"></script>
    <script type="text/javascript" src="../General/Js/navigationmenuscript.js"></script>
	</HEAD>
	<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
		<form id="Form1" method="post" runat="server">
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td align="center" valign="top" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr height="100%" align="left" valign="top">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer">
						<navigation:reportsMenu runat="server" id="ucAdminMenu"></navigation:reportsMenu>
					</td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<!-- Welcom Message-->
						<asp:Label ID="lblReportingWelcome" CssClass="h2" Runat="server"></asp:Label>
					</td>
				</tr>
				<!-- Footer -->
				<tr align="center" valign="bottom">
					<td align="center" valign="middle" colspan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
