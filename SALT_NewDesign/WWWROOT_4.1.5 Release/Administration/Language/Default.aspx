<%@ Page language="c#" Codebehind="Default.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Language._Default" EnableViewState="true" %>
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
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					 <td class="DataContainer">
						<!-- Body/Conent -->
							<asp:label id="lblPageTitle" Runat="server" CssClass="pageTitle">Select Language</asp:label><br>
							<asp:DropDownList ID="ddlLanguageList" DataTextField="RecordName" DataValueField="RecordID" Width="200px" Runat="server"></asp:DropDownList>
							&nbsp;<asp:Button ID="butAddLanguage" Text="Add" CssClass="addButton" Width="80px" Runat="server" />
							<p></p>
							<div style="text-align: center;">
							<asp:Button ID="butSave" Text="Save List" CssClass="addButton" Runat="server"></asp:Button>
							</div>
							<asp:Repeater ID="grdLanguageList" Runat="server" >
							<HeaderTemplate>
								<table class="tablerowtop" border=1 cellspacing="0" style="border-style:Solid;width:100%;border-collapse:collapse;">
									<tr>
										<td>Language</td>
										<td>User Active</td>
										<td>Admin Active</td>
										<td>Commit</td>
									</tr>
							</HeaderTemplate>
							<ItemTemplate>
									<tr class="tablerow2">
										<td><asp:hyperlink id="hypLang" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.RecordName") %>' /></td>
										<td><asp:checkbox ID="chkUser" Checked='<%# DataBinder.Eval(Container, "DataItem.ShowUser") %>' ToolTip='<%# DataBinder.Eval(Container, "DataItem.RecordID") %>' runat="server" /></td>
										<td><asp:checkbox ID="chkAdmin" Checked='<%# DataBinder.Eval(Container, "DataItem.ShowAdmin") %>' ToolTip='<%# DataBinder.Eval(Container, "DataItem.RecordID") %>' runat="server" /></td>
										<td><asp:LinkButton ID="lnkCommit" Runat="server" Text="Commit" OnCommand="lnkCommit_Command" Visible="False" /></td>
									</tr>
							</ItemTemplate>
							<AlternatingItemTemplate>
									<tr class="tablerow1">
										<td><asp:hyperlink id="hypLang" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.RecordName") %>' /></td>
										<td><asp:checkbox ID="chkUser" Checked='<%# DataBinder.Eval(Container, "DataItem.ShowUser") %>' ToolTip='<%# DataBinder.Eval(Container, "DataItem.RecordID") %>' runat="server" /></td>
										<td><asp:checkbox ID="chkAdmin" Checked='<%# DataBinder.Eval(Container, "DataItem.ShowAdmin") %>' ToolTip='<%# DataBinder.Eval(Container, "DataItem.RecordID") %>' runat="server" /></td>
										<td><asp:LinkButton ID="lnkCommit" Runat="server" Text="Commit" OnCommand="lnkCommit_Command" Visible="False" /></td>
									</tr>
							</AlternatingItemTemplate>
							<FooterTemplate>
								</table>
							</FooterTemplate>
							</asp:Repeater>
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