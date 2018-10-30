<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Page language="c#" Codebehind="UnitAdministrators.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Unit.UnitAdministrators" %>
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
		<script language="javascript">
		//This must be placed on each page where you want to use the client-side resource manager
		var ResourceManager = new RM();
		function RM()
		{
		this.list = new Array();
		};
		RM.prototype.AddString = function(key, value)
		{
		this.list[key] = value;
		};
		RM.prototype.GetString = function(key)
		{
		var result = this.list[key];  
		for (var i = 1; i < arguments.length; ++i)
		{
			result = result.replace("{" + (i-1) + "}", arguments[i]);
		}
		return result;
		};
		</script>
		<SCRIPT LANGUAGE="JavaScript">
		function RemovingConfirm(userName)
		{
			return confirm(ResourceManager.GetString("RemoveMessage", userName));
		}
		</SCRIPT>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr align="center" vAlign="top" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer">
						<navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu>
					</td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Unit Administration</Localized:LocalizedLabel><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td>
									<b><Localized:LocalizedLabel id="lblUnitAdmin" runat="server"></Localized:LocalizedLabel></b>
								</td>
							</tr>
							<tr>
								<td>
									<table id="tblPagination" width="100%" align="left" border="0" runat="server">
										<TBODY>
											<tr>
												<td colSpan="2">
													<asp:datagrid id="grdPagination" runat="server" allowsorting="True" borderstyle="Solid" width="100%"
														autogeneratecolumns="False" allowpaging="True">
														<AlternatingItemStyle CssClass="tablerow1"></AlternatingItemStyle>
														<ItemStyle CssClass="tablerow2"></ItemStyle>
														<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
														<Columns>
															<asp:TemplateColumn SortExpression="UserName" HeaderText="User Name">
																<headerstyle></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "UserName")%>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn SortExpression="LastName" HeaderText="Last Name">
																<HeaderStyle Width="15%"></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "LastName")%>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn SortExpression="FirstName" HeaderText="First Name">
																<HeaderStyle Width="15%"></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "FirstName")%>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn SortExpression="Email" HeaderText="Email">
																<headerstyle></HeaderStyle>
																<ItemTemplate>
																	<%# DataBinder.Eval(Container.DataItem, "Email")%>
																</ItemTemplate>
															</asp:TemplateColumn>
															<asp:TemplateColumn>
																<headerstyle></HeaderStyle>
																<ItemTemplate>
																	<asp:LinkButton runat="server" Text="Remove" id="btnRemove" CommandName="Delete" CausesValidation="false"></asp:LinkButton>
																</ItemTemplate>
															</asp:TemplateColumn>
														</Columns>
														<PagerStyle Visible="False"></PagerStyle>
													</asp:datagrid>
												</td>
											</tr>
                                            <tr class="tablerowbot" id="trPagination" runat="server">
                                                <td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                                </td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
                                            </tr>
										</TBODY>
									</table>
									<!-- Pagination -->
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
							</tr>
							<tr>
								<td>
									<a href="AddUnitAdministrator.aspx?UnitID=<%=m_intUnitID%>"><Localized:LocalizedLiteral id="lnkReturn" runat="server"></Localized:LocalizedLiteral></a>
								</td>
							</tr>
							<tr>
								<td><a href="UnitDetails.aspx?UnitID=<%= m_intUnitID%>"><Localized:LocalizedLiteral id="lnkReturnUser" key="cmnReturnUnitDetails"  runat="server"></Localized:LocalizedLiteral></a></td>
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
		</FORM>
	</body>
</HTML>
