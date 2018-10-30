<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Page language="c#" Codebehind="LicensingReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.LicensingReport" %>
<%@ Register TagPrefix="cc2" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="cc1" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<STYLE:STYLE id="ucStyle" runat="server"></STYLE:STYLE>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer"><navigation:reportsmenu id="ucAdminMenu" runat="server"></navigation:reportsmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<!-- Welcom Message--><asp:panel id="panelReportParams" runat="server">
							<asp:PlaceHolder id="plhTitle" runat="server">
								<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Licensing Report</Localized:Localizedlabel>
								<BR>
								<asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
							</asp:PlaceHolder>
							<BR>
							<asp:Panel ID="panCourse" Runat="server">
							<table cellpadding="6" cellspacing="0" border="1" style="border-collapse: collapse;">
							<tr class="tablerowtop">
								<td><Localized:LocalizedLabel id="lblCourseName" runat="server"></Localized:LocalizedLabel></td>
								<td><Localized:LocalizedLabel id="lblPeriod" runat="server"></Localized:LocalizedLabel></td>
								<td><Localized:LocalizedLabel id="lblAction" runat="server"></Localized:LocalizedLabel></td>
							</tr>
							<asp:Repeater ID="rptList" Runat="server">
							<ItemTemplate>
								<tr class="tablerow2">
									<td><%# DataBinder.Eval(Container.DataItem, "Name") %></td>
									<td>
										<asp:DropDownList ID="ddlPeriod" Runat="server">
										</asp:DropDownList>
									</td>
									<td>
										<Localized:LocalizedLinkButton id="lnkReportPeriod" runat="server">Run Report</Localized:LocalizedLinkButton>
									</td>
								</tr>
							</ItemTemplate>
							<AlternatingItemTemplate>
								<tr class="tablerow1">
									<td><%# DataBinder.Eval(Container.DataItem, "Name") %></td>
									<td>
										<asp:DropDownList ID="ddlPeriod" Runat="server">
										</asp:DropDownList>
									</td>
									<td>
										<Localized:LocalizedLinkButton id="lnkReportPeriod" runat="server">Run Report</Localized:LocalizedLinkButton>
									</td>
								</tr>							
							</AlternatingItemTemplate>
							</asp:Repeater>
							<tr>
								<td colspan="3" style="text-align: right;">
									<Localized:LocalizedButton id="butRunAll" runat="server"></Localized:LocalizedButton>
									<br>
									<Localized:LocalizedLabel id="lblNote" runat="server"></Localized:LocalizedLabel>
								</td>
							</tr>
							</table>
							</asp:Panel>
						</asp:panel><asp:panel id="panelReport" runat="server">
							<cc1:ReportViewer id="rvReport" runat="server" ReportPath="/LicensingReport"></cc1:ReportViewer>
						</asp:panel></td>
				</tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
