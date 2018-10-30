<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Page language="c#" Codebehind="ErrorHandler.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.WebErrorHandler.ErrorHandler" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<style:style id="ucStyle" runat="server"></style:style>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" marginwidth="0" marginheight="0">
		<form id="frmErrorHandler" runat="server">
			<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%">
						<!-- header control --><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr>
					<td>
						<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
							<tr>
								<td class="secondary"><IMG height="10" src="Image/transparent.gif" width="1" border="0"></td>
								<td><Localized:Localizedlabel id="lblPageTitle" CssClass="pageTitle" Runat="server">System Error</Localized:Localizedlabel><br>
								</td>
							<tr vAlign="top">
								<td><IMG height="150" src="Image/transparent.gif" width="1" border="0"></td>
								<td><span class="DisplayMessage">
									<Localized:LocalizedLiteral id="litError1" runat="server"></Localized:LocalizedLiteral>
										<br>
										<br>
										<strong>&nbsp;&nbsp;<font color="#ff0033"><asp:label id="lblErrorDetails" runat="server"></asp:label></font></strong>
										<br>
										<br>
										<Localized:LocalizedLiteral id="litError2" runat="server"></Localized:LocalizedLiteral>
										<br>
										<br>
										<Localized:LocalizedLiteral id="litError3" runat="server"></Localized:LocalizedLiteral>
										<asp:hyperlink id="lnkSupport" runat="server"></asp:hyperlink>. </span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="bottom" align="center">
						<!-- footer control --><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
