<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Page language="c#" Codebehind="TrendReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Advanced.TrendReport" %>
<%@ Register TagPrefix="cc2" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
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
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr valign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer"><navigation:reportsMenu id="ucReportsMenu" runat="server"></navigation:reportsMenu></td>
					<!-- Body/Content -->
					<td class="DataContainer"><asp:placeholder id="plhTitle" runat="server">
							<navigation:helplink id="ucHelp" runat="Server" desc="Running Trend Reports?" key="10.2.6"></navigation:helplink>
							<Localized:LocalizedLabel id="lblPageTitle" enableviewstate="False" Runat="server" CssClass="pageTitle">Trend Report</Localized:LocalizedLabel>
							<BR>
							<asp:label id="lblError" runat="server" ForeColor="#FF0000" Visible="False"></asp:label>
						</asp:placeholder>
						<table width="98%" align="left" border="0">
							<asp:placeholder id="plhSearchCriteria" runat="server">
								<TBODY>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLiteral id="lblUnits" runat="server"></Localized:LocalizedLiteral></TD>
										<TD>
											<cc1:treeview id="trvUnitsSelector" runat="server" SystemImagesPath="/General/Images/TreeView/"
												NodeText="Unit" OutputStyle="MultipleSelection"></cc1:treeview></TD>
									</TR>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLiteral id="lblCourse" runat="server"></Localized:LocalizedLiteral></TD>
										<TD>
											<asp:DropDownList id="cboCourse" runat="server"></asp:DropDownList></TD>
									</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 200px"><Localized:LocalizedLiteral id="lblTrendDate" runat="server"></Localized:LocalizedLiteral>
										</TD>
										<TD style="Heigh: 20px" vAlign="top"><Localized:LocalizedLiteral id="lblBetween" runat="server"></Localized:LocalizedLiteral>
											<asp:dropdownlist id="lstEffectiveDay" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveMonth" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveYear" runat="server"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="lblAnd" runat="server"></Localized:LocalizedLiteral>
											<asp:DropDownList id="lstEffectiveToDay" runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstEffectiveToMonth" runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstEffectiveToYear" runat="server"></asp:DropDownList></TD>
									</TR>
									<TR>
										<TD colSpan="2">&nbsp;
										</TD>
									</TR>
									<TR>
										<TD></TD>
										<TD>
											<Localized:LocalizedButton id="btnGenerate" runat="server" CssClass="generateButton" Text="Run Report" onclick="btnGenerate_Click"></Localized:LocalizedButton>&nbsp;
											<Localized:LocalizedButton id="btnReset" Runat="server" CssClass="resetButton" Text="Reset" onclick="btnReset_Click"></Localized:LocalizedButton></TD>
									</TR>
							</asp:placeholder>
							<asp:placeholder id="plhReportResults" runat="server" Visible="false">
								<TR>
									<TD colSpan="2">
										<cc2:ReportViewer id="rvReport" runat="server" ReportPath="/TrendReport" onpageindexchanged="rvReport_PageIndexChanged"></cc2:ReportViewer></TD>
								</TR>
							</asp:placeholder></table>
					</td>
				</tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr>
				</TBODY></table>
		</form>
	</body>
</HTML>
