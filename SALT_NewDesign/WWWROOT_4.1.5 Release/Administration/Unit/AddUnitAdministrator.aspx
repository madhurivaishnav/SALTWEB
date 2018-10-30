<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Page language="c#" Codebehind="AddUnitAdministrator.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Unit.AddUnitAdministrator" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

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
		<form id="Form1" method="post" runat="server">
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
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Add Unit Administrator</Localized:LocalizedLabel><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td>
									<table width="100%" align="left" border="0">
										<tr>
											<td align="center" colSpan="2"><asp:label id="lblMessage" runat="server" EnableViewState="False"></asp:label></td>
										</tr>
										<tr>
											<td class="formLabel"><Localized:LocalizedLabel id="lblFirstName" key="cmnFirstName" runat="server"></Localized:LocalizedLabel></td>
											<td><asp:textbox id="txtFirstName" runat="server" MaxLength="50"></asp:textbox></td>
										</tr>
										<tr>
											<td class="formLabel"><Localized:LocalizedLabel id="lblLastName" key="cmnLastName" runat="server"></Localized:LocalizedLabel></td>
											<td><asp:textbox id="txtLastName" runat="server" MaxLength="50"></asp:textbox></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td align="left"><Localized:Localizedbutton CssClass="findButton" id="btnFind" runat="server" Text="Find" onclick="btnFind_Click"></Localized:Localizedbutton></td>
										<tr>
											<td>&nbsp;</td>
											<td><a href="UnitAdministrators.aspx?UnitID=<%= m_intUnitID%>"><Localized:LocalizedLiteral id="lnkReturn" runat="server"></Localized:LocalizedLiteral></a></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td><a href="UnitDetails.aspx?UnitID=<%= m_intUnitID%>"><Localized:LocalizedLiteral id="cmnReturnUnitDetails" runat="server"></Localized:LocalizedLiteral></a></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table id="tblPagination" width="100%" align="left" border="0" runat="server">
										<TBODY>
											<tr>
												<td class="formLabel"><Localized:LocalizedLiteral id="lblSearchResults" runat="server"></Localized:LocalizedLiteral>
												</td>
											</tr>
											<tr>
												<td colSpan="2"><asp:datagrid id="grdPagination" runat="server" width="100%" allowpaging="True" autogeneratecolumns="False"
														borderstyle="Solid" allowsorting="True">
														<AlternatingItemStyle CssClass="tablerow1"></AlternatingItemStyle>
														<ItemStyle CssClass="tablerow2"></ItemStyle>
														<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
														<Columns>
															<asp:TemplateColumn>
																<HeaderStyle Width="1%"></HeaderStyle>
																<ItemStyle HorizontalAlign="Center"></ItemStyle>
																<ItemTemplate>
																	<input type="radio" name="UserID" value='<%# DataBinder.Eval(Container.DataItem, "UserID")%>'>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn SortExpression="UserName" HeaderText="User Name">
																<headerstyle></HeaderStyle>
																<ItemTemplate>
																	<a href='/Administration/Users/UserDetails.aspx?UserID=<%# DataBinder.Eval(Container.DataItem, "UserID")%>'>
																		<%# DataBinder.Eval(Container.DataItem, "UserName")%>
																	</a>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn SortExpression="LastName" HeaderText="Last Name">
																<headerstyle></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "LastName")%>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn SortExpression="FirstName" HeaderText="First Name">
																<headerstyle></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "FirstName")%>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn SortExpression="Pathway" HeaderText="Pathway">
																<headerstyle></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "Pathway")%>
																</ItemTemplate>
															</asp:TemplateColumn>
														</Columns>
														<PagerStyle Visible="False"></PagerStyle>
													</asp:datagrid></td>
											</tr>
                                            <tr class="tablerowbot" id="trPagination" runat="server">
                                                <td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                                </td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
                                            </tr>
											<tr>
												<td colSpan="2">&nbsp;
												</td>
											</tr>
											<tr>
												<td align="center" colSpan="2">
												<Localized:Localizedbutton CssClass="addButton" id="btnAdd" runat="server" Text="Add Administrator" Width="120px" onclick="btnAdd_Click"></Localized:Localizedbutton>
												<Localized:Localizedcheckbox id="chkAdminSub" runat="server" Text="Administer Sub-units"></Localized:Localizedcheckbox></td>
											</tr>
										</TBODY>
									</table>
									<!-- Pagination --></td>							</tr>
						</table>
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
