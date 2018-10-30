<%@ Page  language="c#" Codebehind="ApplicationDependencies.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.ApplicationDependencies" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Dependency Checking</title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout" onload="document.frmApplicationDependencies.txtToEmail.focus();">
		<form id="frmApplicationDependencies" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="Header1" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucadminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					 <td class="DataContainer">
						<asp:Label id="lblPageTitle" CssClass="pageTitle" Runat="server">Application Dependencies</asp:Label><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td align="center" colSpan="2"><asp:label id="lblMessage" runat="server"  EnableViewState="False"></asp:label></td>
							</tr>
							<tr class="tablerow1">
								<td class="formLabel">Database Version</td>
								<td><asp:label id="lblDatabaseVersion" runat="server"></asp:label></td>
							</tr>
							<tr class="tablerow2">
								<td class="formLabel">Operating System</td>
								<td><asp:label id="lblOperatingSystem" runat="server"></asp:label></td>
							</tr>
							<tr class="tablerow1">
								<td class="formLabel">Computer System</td>
								<td><asp:label id="lblComputerSystem" runat="server"></asp:label></td>
							</tr>
							<tr class="tablerow2">
								<td class="formLabel">System Processor</td>
								<td><asp:label id="lblSystemProcessor" runat="server"></asp:label></td>
							</tr>
							<tr class="tablerow1">
								<td class="formLabel">.Net Framework Version</td>
								<td>
									<asp:Label id="lblFrameworkVersion" runat="server"></asp:Label></td>
							</tr>
							<tr class="tablerow2">
								<td class="formLabel">IIS Version</td>
								<td>
									<asp:Label id="lblIISVersion" runat="server"></asp:Label></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td class="formLabel">
									<b>Email Report Configuration</b>
								</td>
							</tr>
							<tr class="tablerow1">
								<td class="formLabel">To</td>
								<td>
									<asp:TextBox id="txtToEmail" runat="server" MaxLength="100"></asp:TextBox>
									<asp:RegularExpressionValidator id="vldToEmail" runat="server" ErrorMessage="Invalid email address" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
										ControlToValidate="txtToEmail" CssClass="ValidatorMessage" Display="None" ></asp:RegularExpressionValidator>
									<asp:RequiredFieldValidator id="rvlToEmail" runat="server" ErrorMessage="Please enter an email address" ControlToValidate="txtToEmail"
										CssClass="ValidatorMessage" Display="None" ></asp:RequiredFieldValidator>
								</td>
							</tr>
							<tr class="tablerow2">
								<td class="formLabel">Subject</td>
								<td><asp:Label id="lblSubject" runat="server">Email checking from [Insert Application Name]</asp:Label>
								</td>
							</tr>
							<tr class="tablerow1">
								<td class="formLabel">MailServer</td>
								<td>
									<asp:label id="lblMailServer" runat="server"></asp:label></td>
							</tr>
							<tr class="tablerow2">
								<td class="formLabel">Body</td>
								<td>
									<asp:TextBox id="txtBody" runat="server" TextMode="MultiLine"></asp:TextBox></td>
							</tr>
							<tr>
								<td colspan="2">
									<asp:ValidationSummary id="vldSummary" runat="server"></asp:ValidationSummary></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><asp:Button CssClass="sendButton" id="btnSend" runat="server" Text="Send" onclick="btnSend_Click"></asp:Button></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td></td>
								<td colspan="2">
									<a href="/Administration/AdministrationHome.aspx">Return to Administration Homepage</a>
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
