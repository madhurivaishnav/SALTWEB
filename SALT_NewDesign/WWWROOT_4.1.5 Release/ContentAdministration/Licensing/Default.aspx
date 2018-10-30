<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="Default.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ContentAdministration.Licensing._Default" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
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
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<form id="frmModule" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server"></Localized:LocalizedLabel>
						
						<br>
						<asp:Label ID="lblMessage" EnableViewState="False" Font-Bold="True" Runat="server"></asp:Label>
						
						<asp:Panel ID="panLicense" Runat="server">
						<table cellpadding="6" cellspacing="0" border="1" style="border-collapse: collapse;">
							<tr class="tablerowtop">
								<td style="width: 20px;"></td>
								<td><Localized:LocalizedLabel id="lblCourseName" runat="server"></Localized:LocalizedLabel></td>
								<td><Localized:LocalizedLabel id="lblCurrentPeriod" runat="server"></Localized:LocalizedLabel></td>
								<td><Localized:LocalizedLabel id="lblFuturePeriod" runat="server"></Localized:LocalizedLabel></td>
								<td><Localized:LocalizedLabel id="lblAction" runat="server"></Localized:LocalizedLabel></td>
							</tr>
							<asp:Repeater ID="rptLicense" OnItemDataBound="rptLicense_ItemDataBound" Runat="server">
							<ItemTemplate>
								<tr class="tablerow2">
									<td align="center" id="warningCell" runat="server">&nbsp;</td>
									<td><%# DataBinder.Eval(Container.DataItem, "Name") %></td>
									<td><asp:Label ID="lblDateCurrent" Runat="server"></asp:Label></td>
									<td><asp:Label ID="lblDateFuture" Runat="server"></asp:Label></td>
									<td>
										<Localized:LocalizedHyperlink id="hypEdit" NavigateURL='<%# "Detail.aspx?CourseID=" + DataBinder.Eval(Container.DataItem, "CourseID") %>' runat="server"></Localized:LocalizedHyperlink>
									</td>
								</tr>
							</ItemTemplate>
							<AlternatingItemTemplate>
								<tr class="tablerow1">
									<td align="center" id="warningCell" runat="server">&nbsp;</td>
									<td><%# DataBinder.Eval(Container.DataItem, "Name") %></td>
									<td><asp:Label ID="lblDateCurrent" Runat="server"></asp:Label></td>
									<td><asp:Label ID="lblDateFuture" Runat="server"></asp:Label></td>
									<td>
										<Localized:LocalizedHyperlink id="hypEdit" NavigateURL='<%# "Detail.aspx?CourseID=" + DataBinder.Eval(Container.DataItem, "CourseID") %>' runat="server"></Localized:LocalizedHyperlink>
									</td>
								</tr>							
							</AlternatingItemTemplate>
							</asp:Repeater>
						</table>
						<br /><br />
						<asp:Label ID="lblLegendNote" Runat="server"></asp:Label><br>
						<table cellpadding="6" cellspacing="0" border="1" style="border-collapse: collapse;">
							<tr>
								<td style="background: #D2D2D2;">&nbsp;</td>
								<td><i><Localized:LocalizedLabel ID="lblNormal" Runat="server"></Localized:LocalizedLabel></i></td>
							</tr>
							<tr>
								<td style="background: orange;">&nbsp;</td>
								<td><i><Localized:LocalizedLabel ID="lblExceededWarn" Runat="server"></Localized:LocalizedLabel></i></td>
							</tr>
							<tr>
								<td style="background: red;">&nbsp;</td>
								<td><i><Localized:LocalizedLabel ID="lblExceeded" Runat="server"></Localized:LocalizedLabel></i></td>
							</tr>
							<tr>
								<td align="center" style="background: white; width: 20px;"><b>X</b></td>
								<td><i><Localized:LocalizedLabel ID="lblNoPeriod" Runat="server"></Localized:LocalizedLabel></i></td>
							</tr>
						</table>
						</asp:Panel>
					</td>
				</tr>
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</TBODY></TABLE>
		</form>
	</body>
</HTML>