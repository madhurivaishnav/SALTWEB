<%@ Register TagPrefix="Style" Tagname="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page language="c#" Codebehind="ArchiveUsers.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Users.ArchiveUsers" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
    <title runat="server" 
id=pagTitle></title>
    <style:style id="ucStyle" runat="server"></style:style>
    <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </HEAD>
  <body MS_POSITIONING="FlowLayout" bottommargin="0" rightmargin="0" leftmargin="0" topmargin="0">
	
    <form id="frmArchiveUsers" method="post" runat="server">
		<table height="100%" width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
			<tr valign="top" align="center" width="100%">
				<td valign="top" align="center" width="100%" colspan="2">
					<navigation:header id="ucHeader" runat="server"></navigation:header>
				</td>
			</tr>
			<tr valign="top" align="left" height="100%">
				<td class="AdminMenuContainer">
					<navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu>
				</td>
				<td class="DataContainer">
					<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Archive User</Localized:Localizedlabel>
					<br>
					<localized:localizedlabel id="lblMessage" runat="server"></localized:localizedlabel>

					
					<table width="100%" align="left" border="0">
						<tr>
							<td>
								&nbsp;
							</td>
						</tr>
						<tr>
							<td>
								<asp:DropDownList ID="cboDay" Runat="server"></asp:DropDownList>
								<asp:DropDownList ID="cboMonth" Runat="server"></asp:DropDownList>
								<asp:DropDownList ID="cboYear" Runat="server"></asp:DropDownList>									
							</td>
						</tr>
						<tr>
							<td>
								<asp:label id="lblError" runat="server"></asp:label></td>
						</tr>
						<tr>
						    <td>
								<Localized:LocalizedLinkButton id="btnPeriodicReport" Visible="false" runat="server" onclick="btnPeriodicReport_Click"/></Localized:LocalizedLinkButton>
							</td>
						</tr>
						<tr>
							<td>	
								<asp:checkbox ID="chkIncludeNewUsers" Runat="server"></asp:checkbox>
								<localized:localizedlabel ID="lblIncludeNewUsers" Runat="server"></localized:localizedlabel>
										
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						
						<tr>
							<td>
								<localized:localizedbutton ID="btnPreview" Runat="server" CssClass="previewButton" onclick="btnPreview_Click"></localized:localizedbutton>
							</td>
						</tr>
						<asp:PlaceHolder ID="plhPreviewUsers" Runat="server">
						<TR>
							<TD>
								<asp:label id=lblUserCount Runat="server"></asp:label><asp:textbox id=txtUserIDs Runat="server" Visible="false"></asp:textbox>
							</TD>
						</TR>
						<TR>
							<TD>
								<asp:datagrid id=dgrResults Runat="server" with="100%" AutoGenerateColumns="false" AllowSorting="true" allowpaging="true" PageSize="50">
													<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
								<itemstyle cssclass="tablerow2"></itemstyle>
								<headerstyle cssclass="tablerowtop"></headerstyle>
								<columns>
									<asp:templatecolumn headertext="Last Login">
										<headerstyle></headerstyle>
										<itemtemplate>
											<asp:Label ID="lblLastLogin" runat="server" />
										</itemtemplate>
									</asp:templatecolumn>
									<asp:templatecolumn headertext="First Name">
										<headerstyle></headerstyle>
										<itemtemplate>
											<%# DataBinder.Eval(Container.DataItem,"FirstName") %>
										</itemtemplate>
									</asp:templatecolumn>
									<asp:templatecolumn headertext="Last Name">
										<headerstyle></headerstyle>
										<itemtemplate>
											<%# DataBinder.Eval(Container.DataItem, "LastName") %>
										</itemtemplate>
									</asp:templatecolumn>
									<asp:templatecolumn headertext="User Name">
										<headerstyle></headerstyle>
										<itemtemplate>
											<%# DataBinder.Eval(Container.DataItem, "Username") %>
										</itemtemplate>
									</asp:templatecolumn>
									
									<asp:templatecolumn headertext="External ID">
										<headerstyle></headerstyle>
										<itemtemplate>
											<%# DataBinder.Eval(Container.DataItem, "ExternalID") %>
										</itemtemplate>
									</asp:templatecolumn>
									
									<asp:templatecolumn headertext="Email">
										<headerstyle></headerstyle>
										<itemtemplate>
											<%# DataBinder.Eval(Container.DataItem, "Email") %>
										</itemtemplate>
									</asp:templatecolumn>
									<asp:templatecolumn headertext="UserID" visible = "false">
										<headerstyle></headerstyle>
										<itemtemplate>
											<%# DataBinder.Eval(Container.DataItem, "UserID") %>
										</itemtemplate>
									</asp:templatecolumn>
			
								</columns>
								</asp:datagrid>
							</TD>
						</TR>
						<TR>
							<TD>&nbsp; </TD>
						</TR>
						<TR>
							<TD>
								<localized:localizedbutton id=btnArchiveUsers runat="server" CssClass="previewButton" visible="false" onclick="btnArchiveUsers_Click"></localized:localizedbutton>
							</TD>
						</TR>
						</asp:PlaceHolder>
					</table>
				</td>	
			</tr>
			<!-- Footer -->
			<tr valign="bottom" align="center">
				<td valign="middle" align="center" colspan="2">
					<navigation:footer id="ucFooter" runat="server"></navigation:footer>
				</td>
			</tr>
		</table>
     </form>
	
  </body>
</HTML>
