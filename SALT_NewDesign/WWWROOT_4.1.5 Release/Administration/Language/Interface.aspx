<%@ Page language="c#" Codebehind="Interface.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Language.Interface" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title>Language Translation > Select Language</title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
		<form id="form1" method="post" runat="server">
			<table id="Table1" height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server" visible="false"></navigation:adminmenu></td>
					 <td class="DataContainer">
						<!-- Body/Conent -->
						<asp:label id="lblPageTitle" Runat="server" CssClass="pageTitle">Select Interface</asp:label><br>
						<a href="default.aspx">All Languages</a> &gt; <asp:Label ID="lblSelectedLanguage" Runat="server" />
						<p></p>
						<asp:datagrid id="grdInterfaceList" runat="server" width="100%" borderstyle="Solid" autogeneratecolumns="False" DataKeyField="RecordID">
							<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
							<itemstyle cssclass="tablerow2"></itemstyle>
							<headerstyle cssclass="tablerowtop"></headerstyle>
							<Columns>
								<asp:templatecolumn headertext="Title">
									<headerstyle></headerstyle>
									<itemstyle horizontalalign="left"></itemstyle>
									<itemtemplate>
										<asp:label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.PageTitle") %>' ID="Label1" NAME="Label1"/>
									</itemtemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="Interface" >
									<itemstyle horizontalalign="Left" Font-Name="Courier New"></itemstyle>
									<itemtemplate>
										<asp:linkbutton runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.RecordName") %>' CommandName="RESOURCE" ID="lnkInterface"/>
									</itemtemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="Interface Type">
									<headerstyle></headerstyle>
									<itemstyle horizontalalign="left"></itemstyle>
									<itemtemplate>
										<asp:label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.InterfaceType") %>' />
									</itemtemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="Commit">
									<headerstyle></headerstyle>
									<itemstyle horizontalalign="Center"></itemstyle>
									<itemtemplate>
										<asp:LinkButton ID="lnkCommit" Runat="server" Text="Commit" CommandName="COMMIT" visible="False" />
									</itemtemplate>
								</asp:TemplateColumn>
							</Columns>
							
						</asp:DataGrid>
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