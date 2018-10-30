<%@ Page language="c#" Codebehind="UnitDetails.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Unit.UnitDetails" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
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
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
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
						<Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Unit Details</Localized:Localizedlabel><br>
						<table width="98%" align="left" border="0">
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblUnitName" key="cmnUnitName" runat="server"></Localized:LocalizedLabel></td>
								<td>
									<table>
										<tr>
											<td>
												<asp:textbox id="txtName" runat="server" maxlength="100"></asp:textbox><Localized:Localizedrequiredfieldvalidator id="rvldName" runat="server" errormessage="You must specify the Unit name." display="Dynamic"
													controltovalidate="txtName" cssclass="ValidatorMessage"></Localized:Localizedrequiredfieldvalidator>
											</td>
											<td class="formLabel">
												<Localized:LocalizedLabel id="lblUnitID" runat="server"></Localized:LocalizedLabel>
											</td>
											<td>
												<asp:TextBox id="txtUnitID" Runat="server" MaxLength="100" ReadOnly="True"></asp:TextBox>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblStatus" key="cmnStatus" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:dropdownlist id="cboStatus" runat="server">
										<asp:listitem value="1">Active</asp:listitem>
										<asp:listitem value="0">Inactive</asp:listitem>
									</asp:dropdownlist></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblPathwayLabel" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:label id="lblPathway" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td align="left"><Localized:Localizedbutton cssclass="saveButton" id="btnSave" key="cmnSave"  runat="server" text="Save" onclick="btnSave_Click"></Localized:Localizedbutton>&nbsp;<asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblSubUnits" runat="server"></Localized:LocalizedLabel></td>
								<td><cc1:treeview id="trvSubUnits" runat="server" nodetext="Unit" systemimagespath="/General/Images/TreeView/"></cc1:treeview><Localized:Localizedlabel id="lblNoSubUnits" runat="server" visible="False"></Localized:Localizedlabel></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblUsers" runat="server"></Localized:LocalizedLabel></td>
								<td>
									<table id="tblPagination" width="100%" align="left" border="0" runat="server">
										<tbody>
											<tr>
												<td colspan="2"><asp:datagrid id="grdPagination" runat="server" width="100%" allowpaging="True" autogeneratecolumns="False"
														borderstyle="Solid" allowsorting="False" pagesize="3">
														<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
														<itemstyle cssclass="tablerow2"></itemstyle>
														<headerstyle cssclass="tablerowtop"></headerstyle>
														<columns>
															<asp:templatecolumn sortexpression="UserName" headertext="User Name">
																<headerstyle></headerstyle>
																<itemtemplate>
																	<a href='/Administration/Users/UserDetails.aspx?UserID=<%# DataBinder.Eval(Container.DataItem, "UserID")%>'>
																		<%# DataBinder.Eval(Container.DataItem, "UserName")%>
																	</a>
																</itemtemplate>
															</asp:templatecolumn>
															<asp:templatecolumn sortexpression="LastName" headertext="Last Name">
																<headerstyle></headerstyle>
																<itemtemplate>
																	<%# DataBinder.Eval(Container.DataItem, "LastName")%>
																</itemtemplate>
															</asp:templatecolumn>
															<asp:templatecolumn sortexpression="FirstName" headertext="First Name">
																<headerstyle></headerstyle>
																<itemtemplate>
																	<%# DataBinder.Eval(Container.DataItem, "FirstName")%>
																</itemtemplate>
															</asp:templatecolumn>
															<asp:templatecolumn sortexpression="Email" headertext="Email">
																<headerstyle></headerstyle>
																<itemtemplate>
																	<%# DataBinder.Eval(Container.DataItem, "Email")%>
																</itemtemplate>
															</asp:templatecolumn>
														</columns>
														<pagerstyle visible="False"></pagerstyle>
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
										</tbody>
									</table>
									<!-- Pagination --></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblLinks" runat="server"></Localized:LocalizedLabel></td>
								<td>
									<table width="100%" align="left" border="0">
										<tr>
											<td colspan="2"><Localized:Localizedlinkbutton id="lnkImportUsers" runat="server" text="Import Users" causesvalidation="False" onclick="lnkImportUsers_Click"></Localized:Localizedlinkbutton></td>
										</tr>
										<tr>
											<td colspan="2"><Localized:Localizedlinkbutton id="lnkAddNewUser" runat="server" text="Add New User to Unit" causesvalidation="False" onclick="lnkAddNewUser_Click"></Localized:Localizedlinkbutton></td>
										</tr>
										<tr>
											<td><A href="UnitModuleAccess.aspx?UnitID=<%=m_intUnitID%>" ><Localized:LocalizedLiteral id="lnkAssign" runat="server"></Localized:LocalizedLiteral></A></td>
										</tr>
										<tr>
											<td><A href="ComplianceRules.aspx?UnitID=<%=m_intUnitID%>" ><Localized:LocalizedLiteral id="lnkSetRules" runat="server"></Localized:LocalizedLiteral></A></td>
										</tr>
										<tr>
											<td><A href="UnitAdministrators.aspx?UnitID=<%=m_intUnitID%>" ><Localized:LocalizedLiteral id="lnkManagaeUnitAdmin" runat="server"></Localized:LocalizedLiteral></A></td>
										</tr>
									</table>
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
