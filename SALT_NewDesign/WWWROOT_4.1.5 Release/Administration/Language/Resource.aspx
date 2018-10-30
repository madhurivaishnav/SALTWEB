<%@ Page language="c#" Codebehind="Resource.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Language.Resource" SmartNavigation="true" ValidateRequest="false" %>
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
						<asp:label id="lblPageTitle" Runat="server" CssClass="pageTitle">Resource</asp:label><br>
						<a href="default.aspx">All Languages</a>
						 &gt; 
						<asp:LinkButton ID="lnkInterface" Runat="server" />
						 &gt; 
						<asp:DropDownList ID="ddlLanguageList" Runat="server" DataValueField="RecordID" DataTextField="RecordName" AutoPostBack="True" />
						<asp:Label ID="lblSelectedInterface" Runat="server" />
						<p></p>
						<asp:Label id="lblMessage" Runat="server"></asp:Label>
						<asp:datagrid id="grdResourceList" runat="server" width="100%" borderstyle="Solid" autogeneratecolumns="False" DataKeyField="LangResourceID">
							<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
							<itemstyle cssclass="tablerow2" VerticalAlign="Top"></itemstyle>
							<headerstyle cssclass="tablerowtop"></headerstyle>
							<Columns>
								<asp:templatecolumn headertext="Resource Name" >
									<itemstyle horizontalalign="Left" Font-Name="Courier New"></itemstyle>
									<itemtemplate>
										<asp:label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.LangResourceName") %>' />
									</itemtemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="Type" >
									<itemstyle horizontalalign="Left"></itemstyle>
									<itemtemplate>
										<asp:label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ResourceType") %>' ID="Label3"/>
									</itemtemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="English Value">
									<headerstyle></headerstyle>
									<itemstyle horizontalalign="left"></itemstyle>
									<itemtemplate>
										<asp:label runat="server" Text='<%# System.Web.HttpUtility.HtmlEncode((string)DataBinder.Eval(Container, "DataItem.EnglishValue")) %>' ID="Label1"/>
									</itemtemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="Translated Value">
									<headerstyle></headerstyle>
									<itemstyle horizontalalign="left"></itemstyle>
									<itemtemplate>
										<asp:label ID="lblOtherValue" runat="server" />
									</itemtemplate>
									<EditItemTemplate>
										<asp:Label ID="lblOtherLangValueID" Runat="server" Visible="False" />
										<asp:TextBox ID="txtOtherValue" Runat="server" Width="400px" Height="150px" TextMode="MultiLine" Wrap="True" />
									</EditItemTemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="Comment" >
									<itemstyle horizontalalign="Left"></itemstyle>
									<itemtemplate>
										<asp:label runat="server" Text='<%# System.Web.HttpUtility.HtmlEncode((string)DataBinder.Eval(Container, "DataItem.Comment")) %>' ID="Label4"/>
										<asp:label id="lblRecordLock" runat="server" Visible="False" />
									</itemtemplate>
								</asp:TemplateColumn>
								<asp:templatecolumn headertext="Commit">
									<itemstyle horizontalalign="Center"></itemstyle>
									<itemtemplate>
										<asp:LinkButton ID="lnkCommit" Runat="server" Text="Commit" CommandName="COMMIT" />
									</itemtemplate>
									<EditItemTemplate>
										<asp:Label ID="lblCommit" Runat="server" Text="Commit" Visible="False" />
									</EditItemTemplate>
								</asp:TemplateColumn>
								<asp:editcommandcolumn buttontype="LinkButton" updatetext="Update" headertext="Action" canceltext="Cancel"
									edittext="Modify" >
									<headerstyle></headerstyle>
								</asp:editcommandcolumn>
							</Columns>
							
						</asp:DataGrid>
						
						<!-- Add spacing at bottom of page so "Modify" link and SMartNavigation line up better -->
						<p>&nbsp;</p>
						<p>&nbsp;</p>
						<p>&nbsp;</p>
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