<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="criteria" Tagname="reportCriteria" Src="/General/UserControls/ReportCriteria.ascx" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Page trace="false" language="c#" Codebehind="CompletedUsersReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.CompletedUsers.CompletedUsersReport" %>
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
					<td class="DataContainer"><navigation:helplink id="ucHelp" runat="Server" desc="Running Completed Users Reports?" key="9.7"></navigation:helplink>
					<asp:label id="lblPageTitle" runat="server" cssclass="pageTitle">Completed Users Report</asp:label><br>
						<!-- place holder for search critera --><asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
						<table width="98%" align="left" border="0">
							<asp:placeholder id="plhSearchCriteria" runat="server"> <!-- unit selector -->
								<TBODY>
									<TR>
										<TD class="formLabel" vAlign="top"><Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<cc1:treeview id="trvUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/"
												nodetext="Unit" outputstyle="MultipleSelection"></cc1:treeview></TD>
									</TR>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblCourse" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:dropdownlist id="cboCourse" runat="server" width="200px"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblStatus" key="cmnStatus" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:radiobuttonlist id="optStatus" runat="server">
												<asp:listitem value="true" selected="True">Complete</asp:listitem>
												<asp:listitem value="false">Incomplete</asp:listitem>
											</asp:radiobuttonlist></TD>
									</TR>
									<TR>
										<TD class="formLabel" style="HEIGHT: 16px"><Localized:LocalizedLabel id="lblHistoric" runat="server"></Localized:LocalizedLabel></TD>
										<TD style="HEIGHT: 16px">
											<asp:dropdownlist id="lstEffectiveDay" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveMonth" runat="server"></asp:dropdownlist>
											<asp:dropdownlist id="lstEffectiveYear" runat="server"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD>&nbsp;</TD>
									</TR>
									<TR>
										<TD></TD>
										<TD>
											<Localized:Localizedbutton id="btnRunReport" runat="server" cssclass="generateButton" text="Run Report" onclick="btnRunReport_Click"></Localized:Localizedbutton>&nbsp;
											<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></TD>
									</TR> <!-- / place holder for search critera -->
							</asp:placeholder>
							<!-- place holder for Results --><asp:placeholder id="plhReportResults" runat="server">
								<TR>
									<TD colSpan="2">
										<criteria:reportCriteria id="ucCriteria" runat="server"></criteria:reportCriteria></TD>
								</TR>
								<TR>
									<TD colSpan="2">
										<asp:datagrid id="dgrResults" runat="server" width="100%" allowsorting="True" autogeneratecolumns="False"
											allowpaging="True">
											<headerstyle cssclass="tablerowtop"></headerstyle>
											<footerstyle cssclass="tablerowbot"></footerstyle>
											<itemstyle cssclass="tablerow2"></itemstyle>
											<alternatingitemstyle cssclass="tablerow2"></alternatingitemstyle>
											<pagerstyle visible="False"></pagerstyle>
											<columns>
												<asp:boundcolumn datafield="UnitPathway" headertext="Unit" itemstyle-width="40%"></asp:boundcolumn>
												<asp:boundcolumn datafield="Name" headertext="Name"></asp:boundcolumn>
											</columns>
											<pagerstyle visible="False"></pagerstyle>
										</asp:datagrid>
										<TABLE id="tblPagination" width="98%" border="0" runat="server">
                                            <tr id="trPagination" runat="server">
                                                <td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                                </td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
                                            </tr>
										</TABLE>
										<BR>
										<Localized:Localizedlinkbutton id="lnkReturnToSearchScreen" runat="server" text="Return to Search Screen" causesvalidation="False" onclick="lnkReturnToSearchScreen_Click">Search again</Localized:Localizedlinkbutton></TD>
								</TR> <!-- / place holder for Results --></asp:placeholder></table>
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
