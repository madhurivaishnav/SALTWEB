<%@ Page language="c#" Codebehind="UserSearch.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Users.UserSearch" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="jScript" TagName="jScript" Src="/General/UserControls/JScript.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<style:style id="ucStyle" runat="server"></style:style>
		<jScript:jScript id="ucJScript" runat="server"></JScript:JScript>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout"
		onload="try{document.frmUnitSearch.txtFirstName.focus();}catch(e){}">
		<form id="frmUnitSearch" method="post" runat="server">
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
						<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">User Search</Localized:Localizedlabel><br>
						<Localized:Localizedlabel id="lblNoSubUnits" runat="server" visible="False">There are no units.</Localized:Localizedlabel>
						<table width="95%" align="left" border="0">
							<!-- Search Criteria -->
							<asp:placeholder id="plhCriteria" runat="server">
								<TBODY>
									<TR>
										<TD>
											<TABLE id="tblSearchCriteria" width="100%" align="left" border="0" runat="server">
												<TR>
													<TD class="formLabel" width="30%">
														<Localized:LocalizedLabel id="lblUnit" runat="server"></Localized:LocalizedLabel></TD>
													<TD width="70%">
														<cc1:treeview id="trvUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/"
															nodetext="Unit" outputstyle="MultipleSelection"></cc1:treeview></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblFirstName" runat="server" key="cmnFirstName"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtFirstName" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblLastName" runat="server" key="cmnLastName"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtLastName" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblUserName" runat="server" key="cmnUserName"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtUsername" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblEmail" runat="server" key="lblEmail"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtEmail" runat="server" maxlength="300"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblUserID" runat="server" key="cmnUserID"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtUserID" runat="server" maxlength="10"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblShowInactive" runat="server"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:checkbox id="chkInactiveUsers" runat="server" checked="False"></asp:checkbox></TD>
												</TR>
												
												<TR>
													<TD>&nbsp;</TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
													<TD align="left">
														<P>
															<Localized:Localizedbutton id="btnFind" runat="server" cssclass="findButton" text="Search" onclick="btnFind_Click"></Localized:Localizedbutton>&nbsp;
															<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></P>
													</TD>
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
										<asp:label id="lblUserCount" runat="server" Visible="False"></asp:label>
										<asp:datagrid id="grdResults" runat="server" width="100%" allowpaging="True" allowsorting="True"
											autogeneratecolumns="False">
											<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
											<itemstyle cssclass="tablerow2"></itemstyle>
											<headerstyle cssclass="tablerowtop"></headerstyle>
											<columns>
											    <asp:templatecolumn sortexpression="UserID" ItemStyle-Width="120px" headertext="User ID">
													<headerstyle></headerstyle>
													<itemtemplate>
														<a href='UserDetails.aspx?UserID=<%# DataBinder.Eval(Container.DataItem, "UserID")%>'>
															<%# DataBinder.Eval(Container.DataItem, "UserID")%>
														</a>
													</itemtemplate>
												</asp:templatecolumn>
												<asp:templatecolumn sortexpression="LastName" headertext="Last Name">
													<headerstyle></headerstyle>
													<itemtemplate>
														<a href='UserDetails.aspx?UserID=<%# DataBinder.Eval(Container.DataItem, "UserID")%>'>
															<%# DataBinder.Eval(Container.DataItem, "LastName")%>
														</a>
													</itemtemplate>
												</asp:templatecolumn>
												<asp:templatecolumn sortexpression="FirstName" headertext="First Name">
													<headerstyle></headerstyle>
													<itemtemplate>
														<%# DataBinder.Eval(Container.DataItem, "FirstName")%>
													</itemtemplate>
												</asp:templatecolumn>
												<asp:templatecolumn sortexpression="LastLogin" headertext="Last Login">
													<headerstyle></headerstyle>
													<itemtemplate>
														<asp:Label ID="lblLastLogin" runat="server" />
													</itemtemplate>
												</asp:templatecolumn>
												<asp:templatecolumn sortexpression="Pathway" headertext="Unit Pathway">
													<itemtemplate>
														<%# DataBinder.Eval(Container.DataItem, "Pathway")%>
													</itemtemplate>
												</asp:templatecolumn>
											</columns>
											<pagerstyle mode="NumericPages" position="Bottom"></pagerstyle>
										</asp:datagrid></TD>
								</TR>
							</asp:placeholder></table>
					</td>
				</tr>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
				</TBODY></table>
		</form>
	</body>
</HTML>
