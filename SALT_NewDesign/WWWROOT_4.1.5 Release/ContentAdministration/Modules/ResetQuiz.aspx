<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="ResetQuiz.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ContentAdministration.Modules.ResetQuiz" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<form id="frmModule" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Reset Quiz Status</Localized:LocalizedLabel>
						<br>
						<Localized:LocalizedHyperLink id="lnkReturnToModuleDetails" runat="server"></Localized:LocalizedHyperLink>
						<br>
						<asp:label id="lblMessage" runat="server" enableviewstate="False" width="300px" CssClass="SuccessMessage"></asp:label>
						<table width="95%" align="left" border="0">
							<TBODY>
								<tr valign="top">
									<td colspan="2" class="formLabel">
										<Localized:LocalizedLabel id="lblUpload" runat="server"></Localized:LocalizedLabel><br>
										<asp:DropDownList id="cboResetUserRange" runat="server">
											<asp:ListItem value="1">Users who took the module quiz</asp:ListItem>
											<asp:ListItem value="2">Users who took the module quiz</asp:ListItem>
											<asp:ListItem value="3">Users who took the module quiz</asp:ListItem>
										</asp:DropDownList>
										<br>
										<br>
										<Localized:LocalizedLabel id="lblOrganisationSelect" runat="server"></Localized:LocalizedLabel><br>
										<div style="BORDER-RIGHT: silver 2px solid; BORDER-TOP: silver 2px solid; OVERFLOW: scroll; BORDER-LEFT: silver 2px solid; BORDER-BOTTOM: silver 2px solid; HEIGHT: 300px; WIDTH: 500px;">
											<asp:CheckBoxList ID="chkOrgList" Runat="server">
											</asp:CheckBoxList>
										</div>
										<br>
										<br>
										<Localized:LocalizedButton ID="btnPreview" enableviewstate="False" Text="Preview Change" CommandArgument="preview" CssClass="saveButton" Runat="server" CausesValidation="False"></Localized:LocalizedButton>
										<br>
										<br>
										<asp:Label ID="lblPreview" CssClass="WarningMessage" Runat="server"></asp:Label>
										<br>
										<asp:Repeater id="rptPreview" Runat="server" EnableViewState="False">
											<HeaderTemplate>
												<table cellpadding="4">
											</HeaderTemplate>
											<ItemTemplate>
													<tr>
														<td align="right"><%# DataBinder.Eval(Container.DataItem, "Users") %></td>
														<td><%# DataBinder.Eval(Container.DataItem, "Orgs") %></td>
													</tr>
											</ItemTemplate>
											<FooterTemplate>
												</table>
											</FooterTemplate>
										</asp:Repeater>
										<br>
										<Localized:LocalizedButton ID="btnResetStatus" visible="false" enableviewstate="False" Text="Reset Status" CssClass="saveButton" width="200px" Runat="server" CausesValidation="False"></Localized:LocalizedButton>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</TBODY></TABLE>
		</form>
	</body>
</HTML>