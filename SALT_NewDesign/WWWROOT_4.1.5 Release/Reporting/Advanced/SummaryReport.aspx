<%@ Page language="c#" Codebehind="SummaryReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Advanced.SummaryReport" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="cc2" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
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
		<form id="Form2" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer"><navigation:reportsmenu id="ucLeftMenu" runat="server"></navigation:reportsmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer"><asp:placeholder id="plhTitle" runat="server">
							<navigation:helplink id="ucHelp" runat="Server" desc="Running Summary Report?" key="10.2.5"></navigation:helplink>
							<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Summary Report</Localized:Localizedlabel>
							<BR>
							<asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
						</asp:placeholder>
						<table width="98%" align="left" border="0">
							<!-- place holder for search critera --><asp:placeholder id="plhSearchCriteria" runat="server"><!-- unit selector -->
								<TBODY>
									<TR>
										<TD class="formLabel" vAlign="top"><Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<cc1:treeview id="trvUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/"
												nodetext="Unit" outputstyle="MultipleSelection"></cc1:treeview></TD>
									</TR>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblCourses" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:dropdownlist id="cboCourse" runat="server" width="200px"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD class="formLabel" style="HEIGHT: 16px"><Localized:LocalizedLabel id="lblHistoric" runat="server"></Localized:LocalizedLabel></TD>
										<TD style="HEIGHT: 16px">
											<asp:dropdownlist id="lstEffectiveDay" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveMonth" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveYear" runat="server"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 200px; HEIGHT: 61px">
											<Localized:Localizedlabel id="lblCustomClassification" runat="server"></Localized:Localizedlabel></TD>
										<TD>
											<asp:dropdownlist id="cboCustomClassification" runat="server" width="200px"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblReportType" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:radiobuttonlist id="optReportType" runat="server">
												<asp:ListItem Value="Table" Selected="True">Table</asp:ListItem>
												<asp:ListItem Value="StackedColumn">Stacked Column Chart</asp:ListItem>
												<asp:ListItem Value="StackedBar">Stacked Bar Chart</asp:ListItem>
												<asp:ListItem Value="Pie">Pie Chart</asp:ListItem>
											</asp:radiobuttonlist></TD>
									</TR>
									<TR>
										<TD colSpan="2">&nbsp;
										</TD>
									</TR>
									<TR>
										<TD></TD>
										<TD>
											<Localized:Localizedbutton id="btnRunReport" runat="server" cssclass="generateButton" text="Run Report" onclick="btnRunReport_Click"></Localized:Localizedbutton>&nbsp;
											<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></TD>
									</TR> <!-- / place holder for search critera --></asp:placeholder>
							<!-- place holder for Results --><asp:placeholder id="plhReportResults" runat="server">
								<TR>
									<TD colSpan="2">
										<cc2:ReportViewer id="rvReport" runat="server" ReportPath="/SummaryReport" onpageindexchanged="rvReport_PageIndexChanged"></cc2:ReportViewer></TD>
								</TR>
							</asp:placeholder>
							<!-- / place holder for Results --></table>
					</td>
				</tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
				</TBODY></table>
		</form>
	</body>
</HTML>
