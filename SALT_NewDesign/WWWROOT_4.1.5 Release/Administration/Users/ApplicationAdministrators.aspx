<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page language="c#" Codebehind="ApplicationAdministrators.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Users.SALTAdministrators" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
  <HEAD>
		<title runat="server" 
id=pagTitle></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </HEAD>
	<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
		<form id="frmOrgAdmins" method="post" runat="server">
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td align="center" valign="top" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr height="100%" align="left" valign="top">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer">
						<navigation:adminmenu runat="server" id="ucAdminMenu"></navigation:adminmenu>
					</td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server"></Localized:LocalizedLabel><br>
						<table align="left" border="0" width="95%">
							<tr>
								<td>
									<asp:label runat="server" id="lblMessage" EnableViewState="False"></asp:label>
									<!-- Pagination -->
									<table id="tblPagination" width="95%" align="left" border="0" runat="server">
										<tbody>
											<tr>
												<td colspan="2"><asp:datagrid id="grdPagination" runat="server" allowpaging="True" pagesize="3" autogeneratecolumns="False"
														width="100%" borderstyle="Solid">
														<AlternatingItemStyle CssClass="tablerow1"></AlternatingItemStyle>
														<ItemStyle CssClass="tablerow2"></ItemStyle>
														<Columns>
															<asp:TemplateColumn HeaderText="Last Name">
																<headerstyle CssClass="tablerowtop"></HeaderStyle>
																<ItemTemplate>
																	<a href='UserDetails.aspx?UserID=<%# DataBinder.Eval(Container.DataItem, "UserID")%>'>
																		<%# DataBinder.Eval(Container.DataItem, "LastName")%>
																	</a>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn HeaderText="First Name">
																<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "FirstName").ToString()%>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn HeaderText="Email">
																<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "Email").ToString()%>
																</ItemTemplate>
															</asp:TemplateColumn>
														</Columns>
														<PagerStyle Visible="False"></PagerStyle>
													</asp:datagrid></td>
											</tr>
                                            <tr id="trPagination" runat="server">
                                                <td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                                </td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
                                            </tr>
										</tbody>
										<tr>
											<td colspan="2">
												<a href="UserDetails.aspx?UserID=-1"><Localized:LocalizedLiteral id="lnkAddAdmin" runat="server"></Localized:LocalizedLiteral></a>
											</td>
										</tr>
										<tr>
											<td>
												<a href="/Administration/AdministrationHome.aspx"><Localized:LocalizedLiteral id="lnkReturnLink" key="cmnReturn" runat="server"></Localized:LocalizedLiteral></a>
											</td>
										</tr>
									</table>
									<!-- Pagination -->
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
