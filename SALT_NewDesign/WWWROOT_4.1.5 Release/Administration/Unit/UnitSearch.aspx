<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Page language="c#" Codebehind="UnitSearch.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Unit.UnitSearch" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<style:style id="ucStyle" runat="server"></style:style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottommargin="0" leftmargin="0" topmargin="0" onload="try{document.frmUnitSearch.txtUnitName.focus();}catch(e){};"
		rightmargin="0" ms_positioning="FlowLayout">
		<form id="frmUnitSearch" method="post" runat="server" defaultbutton="btnFind">
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
						<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Unit Search</Localized:Localizedlabel><br>
						<Localized:Localizedlabel id="lblNoSubUnits" runat="server" cssclass="FeedbackMessage" visible="False">There are no units.</Localized:Localizedlabel>
						<table width="98%" align="left" border="0">
							<tbody>
								<asp:placeholder id="plhCriteria" runat="server">
									<TR>
										<TD><!-- Search Criteria -->
											<TABLE id="tblSearchCriteria" width="100%" align="left" border="0" runat="server">
												<TR>
													<TD class="formLabel" width="30%">
														<Localized:LocalizedLabel id="lblUnitHier" runat="server"></Localized:LocalizedLabel></TD>
													<TD width="70%">
														<cc1:treeview id="trvUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/"
															nodetext="Unit" outputstyle="MultipleSelection"></cc1:treeview></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblUnitName" runat="server" key="cmnUnitName"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtUnitName" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblUnitID" runat="server" key="cmnUnitID"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtUnitID" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblShowInactive" runat="server"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:checkbox id="chkInactiveUnits" runat="server" checked="False"></asp:checkbox></TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
													<TD align="left">
														<Localized:Localizedbutton id="btnFind" runat="server" cssclass="findButton" text="Find" onclick="btnFind_Click"></Localized:Localizedbutton>&nbsp;
														<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
													<TD>
														<asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
													<TD><A href="/Administration/AdministrationHome.aspx">
															<Localized:LocalizedLiteral id="lnkReturn" runat="server" key="cmnReturn"></Localized:LocalizedLiteral></A></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
								</asp:placeholder>
								<asp:placeholder id="plhResults" runat="server">
									<TR>
										<TD>
											<asp:label id="lblUnitCount" runat="server" Visible="False"></asp:label>
											<asp:datagrid id="grdResults" runat="server" width="100%" autogeneratecolumns="False" allowsorting="True"
												allowpaging="True">
												<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
												<itemstyle cssclass="tablerow2"></itemstyle>
												<headerstyle cssclass="tablerowtop"></headerstyle>
												<columns>
												    <asp:templatecolumn sortexpression="UnitID" ItemStyle-Width="120px" headertext="Unit ID">
														<headerstyle></headerstyle>
														<itemtemplate>
															<a href='UnitDetails.aspx?UnitID=<%# DataBinder.Eval(Container.DataItem, "UnitID")%>'>
																<%# DataBinder.Eval(Container.DataItem, "UnitID")%>
															</a>
														</itemtemplate>
													</asp:templatecolumn>
													<asp:templatecolumn sortexpression="Name" headertext="Name">
														<headerstyle></headerstyle>
														<itemtemplate>
															<a href='UnitDetails.aspx?UnitID=<%# DataBinder.Eval(Container.DataItem, "UnitID")%>'>
																<%# DataBinder.Eval(Container.DataItem, "Name")%>
															</a>
														</itemtemplate>
													</asp:templatecolumn>
													<asp:templatecolumn sortexpression="Pathway" headertext="Pathway">
														<itemtemplate>
															<%# DataBinder.Eval(Container.DataItem, "Pathway")%>
														</itemtemplate>
													</asp:templatecolumn>
												</columns>
												<pagerstyle mode="NumericPages" position="Bottom"></pagerstyle>
											</asp:datagrid></TD>
									</TR>
								</asp:placeholder>
							</tbody>
						</table>
					</td>
					<!-- /Body/Conent -->
				</tr>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
