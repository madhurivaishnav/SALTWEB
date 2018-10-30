<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page language="c#" Codebehind="AdministrationReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Admin.AdministrationReport" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc2" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="cc1" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<style:style id="ucStyle" runat="server"></style:style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
			<script type="text/javascript" src="../../General/Js/navigationmenu-jquery-latest.min.js"></script>
<script type="text/javascript" src="../../General/Js/navigationmenuscript.js"></script>

	</HEAD>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td style="HEIGHT: 31px" valign="top" align="center" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr valign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer" width="30">
						<navigation:reportsmenu id="ucReportsMenu" runat="server"></navigation:reportsmenu>
					</td>
					<!-- Body/Content -->
					<td class="DataContainer" align="left">
						<navigation:helplink runat="Server" key="10.2.1" desc="Running Admin Reports?" id="ucHelp" />
						<asp:label id="lblPageTitle" cssclass="pageTitle" runat="server">Administration Report</asp:label>
						<br>
						<asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
							<asp:panel id="panelSearchCriteria" runat="server">
							<table width="98%" align="left" border="0">
								<TBODY>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<cc2:treeview id="trvUnitsSelector" runat="server" nodetext="Unit" outputstyle="MultipleSelection"
												systemimagespath="/General/Images/TreeView/"></cc2:treeview></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblCourses" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:listbox id="lstCourses" runat="server" width="200px" selectionmode="Multiple" rows="6"></asp:listbox></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblPastCourses" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:listbox id="lstPastCourses" runat="server" width="200px" selectionmode="Multiple" rows="6"></asp:listbox></TD>
									</TR>
									<asp:placeholder id="plhDateEffective" runat="server">
										<TR>
											<TD class="formLabel" style="HEIGHT: 16px">
												<Localized:LocalizedLabel id="lblHistoricDate" runat="server"></Localized:LocalizedLabel></TD>
											<TD style="HEIGHT: 16px">
												<asp:dropdownlist id="lstEffectiveDay" runat="server"></asp:dropdownlist>
												<asp:dropdownlist id="lstEffectiveMonth" runat="server"></asp:dropdownlist>
												<asp:dropdownlist id="lstEffectiveYear" runat="server"></asp:dropdownlist> &nbsp; &nbsp;
												<asp:label ID ="lblTZName" runat ="server" />
										    </TD>
										</TR>
									</asp:placeholder>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblFirstName" runat="server" key="cmnFirstName"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:textbox id="txtFirstName" runat="server" width="200px"></asp:textbox></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblLastName" runat="server" key="cmnLastName"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:textbox id="txtLastName" runat="server" width="200px"></asp:textbox></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblUserName" runat="server" key="cmnUserName"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:textbox id="txtUserName" runat="server" maxlength="100" width="200px"></asp:textbox></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblEmail" runat="server" key="lblEmail"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:textbox id="txtEmail" runat="server" maxlength="300" width="200px"></asp:textbox></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<Localized:Localizedlabel id="lblCustomClassification" runat="server">Grouping Option</Localized:Localizedlabel></TD>
										<TD>
											<asp:dropdownlist id="cboCustomClassification" runat="server" width="200px"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblGroupBy" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:radiobuttonlist id="radGroupBy" runat="server" autopostback="True" onselectedindexchanged="radGroupBy_SelectedIndexChanged">
												<asp:listitem value="UNIT_USER" selected="True">Unit/User</asp:listitem>
												<asp:listitem value="COURSE">Course</asp:listitem>
											</asp:radiobuttonlist></TD>
									</TR>
									<TR id="trSortBy" runat="server">
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblSortBy" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:dropdownlist id="lstWithinUserSort" runat="server" width="200px">
												<asp:listitem value="LAST_NAME" selected="True">Last Name</asp:listitem>
												<asp:listitem value="QUIZ_SCORE">Quiz Score</asp:listitem>
												<asp:listitem value="QUIZ_DATE">Quiz Date</asp:listitem>
											</asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LocalizedLabel id="lblInclInactiveUser" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:checkbox id="chbInclInactiveUser" Runat="server" oncheckedchanged="chbInclInactiveUser_CheckedChanged"></asp:checkbox></TD>
									</TR>
									<TR>
										<TD></TD>
										<TD>
											<Localized:Localizedbutton id="btnGenerate" runat="server" cssclass="generateButton" text="Run Report" onclick="btnGenerate_Click"></Localized:Localizedbutton>&nbsp;
											<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></TD>
									</TR>
								</TBODY>
							</table>
							</asp:panel>
							<!-- place holder for groupBy=UNIT_USER Results -->
							<asp:panel id="panelReportResults" runat="server">
								<cc1:ReportViewer id="rvReport" runat="server" ReportPath="/CurrentAdminReport" onpageindexchanged="btnGenerate_Click"></cc1:ReportViewer>
							</asp:panel>
							<!-- place holder for groupBy=COURSE Results -->
							<asp:panel id="panelReportResultsByCourse" runat="server">
								<cc1:ReportViewer id="rvReportByCourse" runat="server" ReportPath="/CurrentAdminReportByCourse" onpageindexchanged="btnGenerate_Click"></cc1:ReportViewer>
							</asp:panel>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
