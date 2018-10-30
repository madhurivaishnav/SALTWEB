<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page language="c#" Codebehind="policydefault.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Policy.policydefault" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<META http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<iframe id="refresh" src="policydefault.aspx" frameborder=0 width=0 height=0 runat="server"></iframe>
		<form id="frmPolicyDefault" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Content -->
					<td class="DataContainer">
						<asp:Panel ID="panTitle" Runat="server">
							<TABLE width="100%">
								<TR>
									<TD>
										<Localized:LocalizedLabel id="lblPageTitle" Runat="server" CssClass="pageTitle"></Localized:LocalizedLabel></TD>
								</TR>
								<TR>
									<TD>
										<asp:Label id="lblMessage" Runat="server" EnableViewState="False" Font-Bold="True"></asp:Label></TD>
								</TR>															
							</TABLE>
						</asp:Panel>
						<asp:Panel ID="panPolicy" Runat="server">
							<TABLE style="BORDER-COLLAPSE: collapse" cellSpacing="0" cellPadding="6" border="1">
								<TR class="tablerowtop">									
									<TD>
										<Localized:LocalizedLabel id="lblPolicyName" runat="server"></Localized:LocalizedLabel></TD>
									<TD>
										<Localized:LocalizedLabel id="lblFileName" runat="server"></Localized:LocalizedLabel></TD>
									<TD>
										<Localized:LocalizedLabel id="lblActive" runat="server"></Localized:LocalizedLabel></TD>
									<TD>
										<Localized:LocalizedLabel id="lblAction" runat="server"></Localized:LocalizedLabel></TD>
								</TR>
								<asp:Repeater id="rptPolicy" Runat="server" OnItemDataBound="rptPolicy_ItemDataBound">
									<ItemTemplate>
										<tr class="tablerow2">
											<td>
												<%# DataBinder.Eval(Container.DataItem, "PolicyName") %>
											</td>
											<td>
												<asp:HyperLink ID="hypPolicyFile" Runat="server">
													<%# DataBinder.Eval(Container.DataItem, "PolicyFileName") + " (" + DataBinder.Eval(Container.DataItem, "PolicyFileSize") + ")" %>
												</asp:HyperLink></td>
											<td>
												<asp:checkbox id="chkStatus" Enabled="False" runat="server" checked='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Active"))%>'>
												</asp:checkbox></td>
											<td>
												<asp:LinkButton id="lnkModify" runat="server">
												</asp:LinkButton>
											</td>
											<td id="tdPolicyID" runat="server">
												<asp:Label ID="lblPolicyID" Runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PolicyID").ToString()%>' />
											</td>
										</tr>
									</ItemTemplate>
									<AlternatingItemTemplate>
										<tr class="tablerow1">
											<td>
												<%# DataBinder.Eval(Container.DataItem, "PolicyName") %>
											</td>
											<td>
												<asp:HyperLink ID="hypPolicyFile" Runat="server">
													<%# DataBinder.Eval(Container.DataItem, "PolicyFileName") + " (" + DataBinder.Eval(Container.DataItem, "PolicyFileSize") + ")" %>
												</asp:HyperLink></td>
											<td>
												<asp:checkbox id="chkStatus" Enabled="False" runat="server" checked='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Active"))%>'>
												</asp:checkbox></td>
											<td>
												<asp:LinkButton id="lnkModify" runat="server">
												</asp:LinkButton>
											</td>
											<td id="tdPolicyID" runat="server">
												<asp:Label ID="lblPolicyID" Runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PolicyID").ToString()%>' />
											</td>
										</tr>
									</AlternatingItemTemplate>
								</asp:Repeater>
							</TABLE>
							<BR>
							<BR>
						</asp:Panel>
						<Table width="100%">
						<TR>
							<TD align="right">
								<Localized:Localizedbutton id="btnAddPolicy" runat="server" CssClass="saveButton" key="btnAddPolicy" Text="Add New Policy" onclick="btnAddPolicy_Click"></Localized:Localizedbutton>&nbsp; 
								&nbsp; &nbsp; &nbsp;</TD>
						</TR>
						<tr>
							<td><A href="/Administration/AdministrationHome.aspx"><LOCALIZED:LOCALIZEDLITERAL id="Localizedliteral2" runat="server" key="cmnReturn"></LOCALIZED:LOCALIZEDLITERAL></A></td>
						</tr>	
						</Table>
					</td>					
				</tr>				
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
