<%@ Page language="c#" Codebehind="SummaryReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Admin.SummaryReport" %>
<%@ Register TagPrefix="criteria" Tagname="reportCriteria" Src="/General/UserControls/ReportCriteria.ascx" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
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
				<tr align="center" valign="top" width="100%">
					<td style="HEIGHT: 31px" vAlign="top" align="center" width="100%" colSpan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer" width="30">
						<navigation:reportsMenu id="ucReportsMenu" runat="server"></navigation:reportsMenu>
					</td>
					<!-- Body/Content -->
					<td align="left" class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Summary Report</Localized:LocalizedLabel>
						<br>
						<asp:label id="lblError" runat="server" ForeColor="#FF0000"></asp:label>
						<TABLE width="98%" align="left" border="0">
							<asp:placeholder id="plhSearchCriteria" runat="server">
								<TBODY>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<cc1:treeview id="trvUnitsSelector" runat="server" NodeText="Unit" OutputStyle="MultipleSelection"
												SystemImagesPath="/General/Images/TreeView/"></cc1:treeview></TD>
									</TR>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblCourses" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:ListBox id="lstCourses" runat="server" SelectionMode="Multiple" Rows="6" Width="200px"></asp:ListBox></TD>
									</TR>
									<asp:placeholder id="plhDateEffective" runat="server">
										<TR>
											<TD class="formLabel" style="HEIGHT: 16px"><Localized:LocalizedLabel id="lblHistoric" runat="server"></Localized:LocalizedLabel></TD>
											<TD style="HEIGHT: 16px">
												<asp:DropDownList id="lstEffectiveDay" Runat="server"></asp:DropDownList>
												<asp:DropDownList id="lstEffectiveMonth" Runat="server"></asp:DropDownList>
												<asp:DropDownList id="lstEffectiveYear" Runat="server"></asp:DropDownList></TD>
										</TR>
									</asp:placeholder>
									<TR>
										<TD></TD>
										<TD>
											<Localized:LocalizedButton id="btnGenerate" runat="server" CssClass="generateButton" Text="Run Report" onclick="btnGenerate_Click"></Localized:LocalizedButton>&nbsp;
											<Localized:LocalizedButton id="btnReset" Runat="server" CssClass="resetButton" Text="Reset" onclick="btnReset_Click"></Localized:LocalizedButton></TD>
									</TR>
							</asp:placeholder>
							<!-- place holder for Results -->
							<asp:placeholder id="plhReportResults" runat="server">
								<TR>
									<TD colSpan="2">
										<criteria:reportCriteria id="ucCriteria" runat="server"></criteria:reportCriteria></TD>
								</TR>
								<TR>
									<TD colSpan="2">
										<asp:datagrid id="dgrResults" runat="server" width="100%" allowsorting="True" autogeneratecolumns="False"
											allowpaging="True">
											<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
											<FooterStyle CssClass="tablerowbot"></FooterStyle>
											<pagerstyle visible="False"></pagerstyle>
											<ItemStyle></ItemStyle>
											<AlternatingItemStyle></AlternatingItemStyle>
											<Columns>
												<asp:BoundColumn DataField="UserID" Visible="False"></asp:BoundColumn>
												<asp:BoundColumn DataField="ModuleID" Visible="False"></asp:BoundColumn>
											</Columns>
										</asp:datagrid>
										<TABLE id="tblPagination" width="98%" border="0" runat="server">
                                            <tr id="trPagination" runat="server">
                                                <td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                                </td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
                                            </tr>
										</TABLE>
										<asp:LinkButton id="lnkReturnToSearchScreen" runat="server" Text="Return to Search Screen" CausesValidation="False" onclick="lnkReturnToSearchScreen_Click">Search Again</asp:LinkButton></TD>
								</TR>
							</asp:placeholder></TABLE>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
				</TBODY></table>
		</form>
	</body>
</HTML>
