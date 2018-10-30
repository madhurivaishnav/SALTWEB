<%@ Page language="c#" Codebehind="OrgModAccess.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.OrgModAccess" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
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
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
		<form id="form1" method="post" runat="server">
			<table id="Table1" height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center"
				border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td width="90%">
						<Localized:Localizedlabel id="lblPageTitle" Runat="server" CssClass="pageTitle">Organisation Module Access</Localized:Localizedlabel><br>

						<table cellspacing="0" rules="all" border="1" cellpadding="4" style="border-style:Solid;width:100%;border-collapse:collapse;">
							<tr class="tablerowtop">
								<td><Localized:LocalizedLabel id="lblOrganisation" runat="server"></Localized:LocalizedLabel></td>
								<td><Localized:LocalizedLabel id="lblPolicyBuilder" runat="server"></Localized:LocalizedLabel></td>
							</tr>
							<asp:Repeater ID="rptAccess" Runat="server">
							<ItemTemplate>
								<tr class="tablerow2">
									<td><%# DataBinder.Eval(Container.DataItem, "OrganisationName") %></td>
									<td><asp:CheckBox ID="chkPolicyBuilder" Checked='<%# DataBinder.Eval(Container, "DataItem.PolicyBuilder") %>' Runat="server"></asp:CheckBox></td>
								</tr>
							</ItemTemplate>
							<AlternatingItemTemplate>
								<tr class="tablerow1">
									<td><%# DataBinder.Eval(Container.DataItem, "OrganisationName") %></td>
									<td><asp:CheckBox ID="chkPolicyBuilder" Checked='<%# DataBinder.Eval(Container, "DataItem.GrantAccess") %>'  Runat="server"></asp:CheckBox></td>
								</tr>
							</AlternatingItemTemplate>
							</asp:Repeater>
						</table>
						<Localized:LocalizedButton ID="butSaveAll" Runat="server"></Localized:LocalizedButton>
					</td>
				</tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
