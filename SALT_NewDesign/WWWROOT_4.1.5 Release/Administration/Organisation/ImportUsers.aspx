<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Page language="c#" Codebehind="ImportUsers.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.ImportUsers" %>
<%@ Register TagPrefix="uc" TagName="import" Src="/General/UserControls/ImportUsers.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
		<form id="frmImportUsers" method="post" runat="server">
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td align="center" valign="top" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<!-- Left Navigation -->
				<tr height="100%" align="left" valign="top">
					<td class="AdminMenuContainer">
						<navigation:adminMenu runat="server" id="ucAdminMenu"></navigation:adminMenu>
					</td>
					<!-- Body/Content -->
					 <td class="DataContainer">
						<table width="95%" align="left" border="0">
						    <tr>
						        <td>
						            <Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Import Users</Localized:LocalizedLabel><br>
						        </td>
						    </tr>
						    <tr>
						        <td>
						            <uc:import id="ucImport" runat="server"></uc:import>
						        </td>
						    </tr>
						</table>
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
