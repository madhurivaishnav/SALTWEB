<%@ Page language="c#" Codebehind="PolicyBuilderReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Policy.PolicyBuilderReportForm" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="criteria" Tagname="reportCriteria" Src="/General/UserControls/ReportCriteria.ascx" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="cc2" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<style:style id="ucStyle" runat="server"></style:style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
		<form id="PolicyBuilderReportForm" method="post" runat="server">
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
					<td align="left" class="DataContainer">
					    <asp:placeholder id="plhTitle" runat="server">
							<navigation:helplink runat="Server" key="10.2.1" desc="Running Admin Reports?" id="ucHelp" />
							<asp:label id="lblPageTitle" cssclass="pageTitle" runat="server">Policy Builder Report</asp:label>
							<br>
						</asp:placeholder>
						<asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
						<table width="98%" align="left" border="0">
							<!-- place holder for search critera --><asp:placeholder id="plhSearchCriteria" runat="server">
								<tbody> 
									<tr>
										<td class="formLabel">
											<Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel><br />
											<Localized:LocalizedLabel id="lblUnits2" runat="server"></Localized:LocalizedLabel></td>
										<td>
											<cc1:treeview id="trvUnitsSelector" runat="server" nodetext="Unit" outputstyle="MultipleSelection"
												systemimagespath="/General/Images/TreeView/"></cc1:treeview></td>
									</tr>

									<tr>
										<td class="formLabel">
											<Localized:LocalizedLabel id="lblPolicy" runat="server"></Localized:LocalizedLabel></td>
										<td>
											<asp:listbox id="lstPolicy" runat="server" width="200px" selectionmode="Multiple" rows="6"></asp:listbox></td>
									</tr>
									<tr>
										<td style="WIDTH: 150px">&nbsp;</td>
									</tr>
									<tr>
									<td class="formLabel"><Localized:LocalizedLabel id="lblDateRange" runat="server"></Localized:LocalizedLabel>
										</td>
										<td ><Localized:LocalizedLabel id="lblBetween" runat="server"></Localized:LocalizedLabel>
											<asp:dropdownlist id="lstEffectiveDay" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveMonth" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveYear" runat="server"></asp:dropdownlist>&nbsp;
											     <Localized:LocalizedLabel id="lblAnd" runat="server"></Localized:LocalizedLabel>&nbsp;
											<asp:DropDownList id="lstEffectiveToDay" runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstEffectiveToMonth" runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstEffectiveToYear" runat="server"></asp:DropDownList></td>
									</tr>
									
									<tr>
										<td class="formLabel">
											<Localized:LocalizedLabel id="lblAcceptance" runat="server"></Localized:LocalizedLabel></td>
										<td>
											<asp:radiobuttonlist id="radAcceptance" runat="server" >
												<asp:listitem value="ACCEPTED">Accepted</asp:listitem>
												<asp:listitem value="NOT_ACCEPTED">Not&nbsp;Accepted</asp:listitem>
												<asp:listitem value="BOTH" selected="True">Both</asp:listitem>
											</asp:radiobuttonlist></td>
									</tr>
									
									<tr>
										<td class="formLabel">
											<Localized:LocalizedLabel id="lblInclInactiveUser" runat="server"></Localized:LocalizedLabel></td>
										<td>
											<asp:checkbox id="chbInclInactiveUser" Runat="server" oncheckedchanged="chbInclInactiveUser_CheckedChanged"></asp:checkbox></td>
									</td>
																		
									<tr>
										<td style="WIDTH: 150px">&nbsp;</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<Localized:Localizedbutton id="btnGenerate" runat="server" cssclass="generateButton" text="Run Report" onclick="btnGenerate_Click"></Localized:Localizedbutton>&nbsp;
											<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></td>
									</tr>
								</tbody>
							<!-- / place holder for search critera --></asp:placeholder>
							<!-- place holder for Results --><asp:placeholder id="plhReportResults" runat="server">
								<TR>
									<TD colSpan="2">
										<cc2:ReportViewer id="rvReport" runat="server" ReportPath="/Policies" onpageindexchanged="rvReport_PageIndexChanged"></cc2:ReportViewer></TD>
								</TR>
							</asp:placeholder>
							<!-- / place holder for Results -->
						</table>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
