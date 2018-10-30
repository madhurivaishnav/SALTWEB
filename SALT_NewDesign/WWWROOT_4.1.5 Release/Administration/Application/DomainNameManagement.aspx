<%@ Page language="c#" Codebehind="DomainNameManagement.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.DomainNameManagement" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title>Domain Name Management</title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
		<form id="frmDomain" method="post" runat="server">
			<table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr valign="top" align="center" width="100%">
					<td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr valign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					 <td class="DataContainer">
						<asp:label id="lblPageTitle" cssclass="pageTitle" runat="server">Domain Name Management</asp:label><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td align="left" colspan="2"><asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
							</tr>
							<tr>
								<td colspan="2"><asp:datagrid id="grdDataList" runat="server" borderstyle="Solid" autogeneratecolumns="False"
										width="80%">
										<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
										<itemstyle cssclass="tablerow2"></itemstyle>
										<headerstyle cssclass="tablerowtop"></headerstyle>
										<columns>
											<asp:templatecolumn headertext="Organisation" visible="true">
												<headerstyle></headerstyle>
												<itemtemplate>
													<asp:label id="lblName" runat="server">
														<%# DataBinder.Eval(Container.DataItem, "OrganisationName").ToString()%>
													</asp:label>
												</itemtemplate>
											</asp:templatecolumn>
											<asp:templatecolumn headertext="Domain Name" visible="true">
												<headerstyle></headerstyle>
												<itemtemplate>
													<%# DataBinder.Eval(Container.DataItem, "DomainName").ToString()%>
												</itemtemplate>
												<edititemtemplate>
													<asp:textbox runat="server" id="txtDomainName" width="95%" maxlength="255" text='<%# DataBinder.Eval(Container.DataItem, "DomainName").ToString()%>'>
													</asp:textbox>
													<asp:requiredfieldvalidator id="rvlDomainName" runat="server" errormessage="* Required" controltovalidate="txtDomainName"
														cssclass="ValidatorMessage" display="Dynamic"></asp:requiredfieldvalidator>
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:editcommandcolumn buttontype="LinkButton" updatetext="Update" canceltext="Cancel" edittext="Modify"
												headertext="Action">
												<headerstyle></headerstyle>
											</asp:editcommandcolumn>
										</columns>
										<pagerstyle visible="False"></pagerstyle>
									</asp:datagrid></td>
							</tr>
							<tr>
								<td>
									<a href="/Administration/AdministrationHome.aspx">Return to Administration Homepage</a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
