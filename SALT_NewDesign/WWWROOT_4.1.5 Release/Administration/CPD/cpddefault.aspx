<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page language="c#" Codebehind="cpddefault.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.CPD.cpddefault" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<META http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<STYLE:STYLE id="ucStyle" runat="server"></STYLE:STYLE>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<IFRAME id="PreventTimeout" src="/PreventTimeout.aspx" frameBorder=no width=0 height=0 runat="server" />
		<form id="frmPolicyDefault" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Content -->
					 <td class="DataContainer"><asp:panel id="panTitle" Runat="server">
							<TABLE width="100%">
								<TR>
									<TD>
										<Localized:LocalizedLabel id="lblPageTitle" Runat="server" CssClass="pageTitle"></Localized:LocalizedLabel></TD>
								</TR>
								<TR>
									<TD>
										<asp:Label id="lblMessage" Runat="server" Font-Bold="True" EnableViewState="False"></asp:Label></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="panCPD" Runat="server">
							<TABLE style="BORDER-COLLAPSE: collapse" cellSpacing="0" cellPadding="1" border="1">
								<TR>
									<TD>
										<asp:DataGrid id="dgrCPD" runat="server" Runat="server" autogeneratecolumns="False">
											<SelectedItemStyle CssClass="tablerow2"></SelectedItemStyle>
											<AlternatingItemStyle CssClass="tablerow2"></AlternatingItemStyle>
											<ItemStyle CssClass="tablerow1"></ItemStyle>
											<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
											<Columns>
												<asp:TemplateColumn HeaderText="Profile ID" Visible="False">
													<ItemTemplate>
														<asp:label ID="lblProfileID" Runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ProfileID").ToString()%>' width="100%"></asp:Label>
													</ItemTemplate>													
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="Profile Period ID" Visible="False">
													<ItemTemplate>
														<asp:label ID="lblProfilePeriodID" Runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ProfilePeriodID").ToString()%>' width="100%"></asp:Label>
													</ItemTemplate>													
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="Profile Name">
													<ItemTemplate>
														<%# DataBinder.Eval(Container.DataItem, "ProfileName").ToString()%>
													</ItemTemplate>													
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="Current Period">
													<ItemTemplate>
														<asp:Label ID="lblCurrentDate" Runat="server"></asp:Label>
													</ItemTemplate>													
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="Future Period">
													<ItemTemplate>
														<asp:Label ID="lblFutureDate" Runat="server"></asp:Label>
													</ItemTemplate>													
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="Status">
													<ItemTemplate>
														<%# DataBinder.Eval(Container.DataItem, "ProfileStatus").ToString()%>
													</ItemTemplate>													
												</asp:TemplateColumn>
												<asp:EditCommandColumn ButtonType="LinkButton" UpdateText="Save" HeaderText="Action" CancelText="Cancel"
													EditText="Edit"></asp:EditCommandColumn>
											</Columns>
											<PagerStyle Visible="False"></PagerStyle>
										</asp:DataGrid></TD>
								</TR>
							</TABLE>
							<BR>
							<BR>
						</asp:panel>
						<TABLE width="100%">
							<tr>
								<td align="right"><LOCALIZED:LOCALIZEDBUTTON id="btnCreateProfile" runat="server" width="150px" CssClass="saveButton" Text="Create New Profile"
										key="btnCreateProfile" onclick="btnCreateProfile_Click"></LOCALIZED:LOCALIZEDBUTTON></td>
							</tr>
							<tr>
								<td><A href="/Administration/AdministrationHome.aspx"><LOCALIZED:LOCALIZEDLITERAL id="lnkReturnLink" runat="server" key="cmnReturn"></LOCALIZED:LOCALIZEDLITERAL></A></td>
							</tr>
						</TABLE>
					</td>
				</tr>
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
