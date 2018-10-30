<%@ Page language="c#" Codebehind="AddOrganisationAdministrator.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.AddOrganisationAdministrator" %>
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
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout" onload="document.frmAddOrgAdmins.txtFirstName.focus();">
		<form id="frmAddOrgAdmins" method="post" runat="server">
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
					 <td class="DataContainer">
					<Localized:Localizedlabel id="lblPageTitle" Runat="server" CssClass="pageTitle">Add Organisation Administrator</Localized:Localizedlabel><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td><asp:label id="lblMessage" runat="server"  EnableViewState="False"></asp:label>
									<!-- Pagination -->
									<table id="Table3" width="55%" align="left" border="0">
										<tr>
											<td class="formLabel"><Localized:LocalizedLabel id="lblFirstName" key="cmnFirstName" runat="server"></Localized:LocalizedLabel>&nbsp;</td>
											<td><asp:textbox id="txtFirstName" runat="server" maxlength="50"></asp:textbox></td>
										</tr>
										<tr>
											<td class="formLabel"><Localized:LocalizedLabel id="lblLastName" key="cmnLastName" runat="server"></Localized:LocalizedLabel>&nbsp;</td>
											<td><asp:textbox id="txtLastName" runat="server" maxlength="50"></asp:textbox></td>
										</tr>
										<tr>
											<td></td>
											<td><Localized:Localizedbutton id="btnFind" runat="server" CssClass="findButton" text="Find" onclick="btnFind_Click"></Localized:Localizedbutton></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table id="tblPagination" width="95%" align="left" border="0" runat="server">
										<tbody>
											<tr>
												<td colSpan="2"><asp:datagrid id="grdPagination" runat="server" width="100%" allowsorting="True" borderstyle="Solid"
														autogeneratecolumns="False" pagesize="3" allowpaging="True">
														<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
														<itemstyle cssclass="tablerow2"></itemstyle>
														<columns>
															<asp:templatecolumn headertext="First Name" visible="true" sortexpression="FirstName">
																<headerstyle cssclass="tablerowtop" width="200"></headerstyle>
																<itemtemplate>
																	<%# DataBinder.Eval(Container.DataItem, "FirstName").ToString()%>
																</itemtemplate>
															</asp:templatecolumn>
															<asp:templatecolumn headertext="Last Name" visible="true" sortexpression="LastName">
																<headerstyle cssclass="tablerowtop" width="200"></headerstyle>
																<itemtemplate>
																	<%# DataBinder.Eval(Container.DataItem, "LastName").ToString()%>
																</itemtemplate>
															</asp:templatecolumn>
															<asp:templatecolumn headertext="Email" visible="true" sortexpression="Email">
																<headerstyle cssclass="tablerowtop" width="300"></headerstyle>
																<itemtemplate>
																	<%# DataBinder.Eval(Container.DataItem, "Email").ToString()%>
																</itemtemplate>
															</asp:templatecolumn>
															<asp:buttoncolumn text="Add" buttontype="LinkButton" commandname="Add" headerstyle-cssclass="tablerowtop"
																headertext="Add Administrator" headerstyle-width="100"></asp:buttoncolumn>
														</columns>
														<pagerstyle visible="False"></pagerstyle>
													</asp:datagrid></td>
											</tr>
											<tr class="tablerowbot" id="trPagination" runat="server">
												<td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral2" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
													<asp:label id="lblCurrentPageRecordCount" runat="server">30</asp:label>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
													<Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
												</td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
											</tr>
										</tbody>
									</table>
									<!-- Pagination --></td>
							</tr>
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
