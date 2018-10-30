<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="criteria" Tagname="reportCriteria" Src="/General/UserControls/ReportCriteria.ascx" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Page language="c#" Codebehind="TrendReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Trend.TrendReport" %>
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
					<td class="DataContainer">
						<navigation:helplink runat="Server" key="9.6" desc="Running Trend Reports?" id="ucHelp" />
						<asp:Label id="lblPageTitle" CssClass="pageTitle" Runat="server" enableviewstate="False">Trend Report</asp:Label><br>
						<asp:label id="lblError" runat="server" Visible="False" ForeColor="#FF0000"></asp:label>
						<table width="98%" align="left" border="0">
							<asp:placeholder id="plhSearchCriteria" runat="server">
								<TBODY>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<cc1:treeview id="trvUnitsSelector" runat="server" OutputStyle="SingleSelection" NodeText="Unit"
												SystemImagesPath="/General/Images/TreeView/"></cc1:treeview>
											<Localized:Localizedlabel id="lblNoSubUnits" runat="server" Visible="False">There are no sub-units</Localized:Localizedlabel></TD>
									</TR>
									<TR>
										<TD class="formLabel"><Localized:LocalizedLabel id="lblCourse" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:DropDownList id="cboCourses" runat="server"></asp:DropDownList></TD>
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
										<TD>&nbsp;</TD>
									</TR>
							</asp:placeholder>
							<asp:placeholder id="plhReportResults" runat="server" Visible="false">
								<TR>
									<TD colSpan="2">
										<criteria:reportcriteria id="ucCriteria" runat="server"></criteria:reportcriteria></TD>
								</TR>
								<TR>
									<TD colSpan="2">
										<asp:DataGrid id="dgrResults" width="100%" Runat="server" gridlines="Horizontal" AutoGenerateColumns="false"
											AllowPaging="True">
											<HeaderStyle HorizontalAlign="left" cssclass="tablerowtop"></HeaderStyle>
											<FooterStyle cssclass="tablerowbot"></FooterStyle>
											<ItemStyle HorizontalAlign="Left" CssClass="tablerow2"></ItemStyle>
											<pagerstyle visible="False"></pagerstyle>
											<AlternatingItemStyle HorizontalAlign="Left" CssClass="tablerow2"></AlternatingItemStyle>
											<Columns>
												<asp:BoundColumn DataField="Unit" HeaderText="Unit" ItemStyle-Width="25%"></asp:BoundColumn>
												<asp:BoundColumn DataField="Module" HeaderText="Module" ItemStyle-Width="20%"></asp:BoundColumn>
												<asp:BoundColumn HeaderStyle-HorizontalAlign="center" DataField="NumOfUsers" HeaderText="Quiz Count"
													ItemStyle-Width="90px" ItemStyle-HorizontalAlign="center"></asp:BoundColumn>
												<asp:TemplateColumn HeaderText="Pass Mark" HeaderStyle-HorizontalAlign="center" ItemStyle-Width="75px"
													ItemStyle-HorizontalAlign="center">
													<ItemTemplate>
														<asp:Table Runat="server" ID="tblQuizPassMark" Width="100%">
															<asp:TableRow Runat="server" ID="tbrQuizPassMark" Width="100%">
																<asp:TableCell Runat="server" ID="tclQuizPassMark" HorizontalAlign="Right">
																	<asp:Label Runat="server" ID="lblQuizPassMark"></asp:Label>
																</asp:TableCell>
																<asp:TableCell Runat="server" ID="tclQuizPassMarkTotal">
													        &nbsp;
													    </asp:TableCell>
															</asp:TableRow>
														</asp:Table>
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:TemplateColumn HeaderText="<nobr>Avg. Score</nobr>">
													<ItemTemplate>
														<asp:Table Runat="server" ID="tblQuizScore" Width="98%" CellSpacing="0" CellPadding="0">
															<asp:TableRow Runat="server" ID="tbrQuizScore" Width="100%">
																<asp:TableCell Runat="server" ID="tclQuizScore">
																	<asp:Label Runat="server" ID="lblQuizScore"></asp:Label>
																</asp:TableCell>
																<asp:TableCell Runat="server" ID="tclQuizTotal" CssClass="BarChartRemainder">&nbsp;</asp:TableCell>
															</asp:TableRow>
														</asp:Table>
													</ItemTemplate>
												</asp:TemplateColumn>
											</Columns>
										</asp:DataGrid>
										<TABLE id="tblPagination" width="100%" border="0" runat="server">
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
										<Localized:LocalizedLinkButton id="lnkReturnToSearchScreen" runat="server" Text="Search again" CausesValidation="False" onclick="lnkReturnToSearchScreen_Click"></Localized:LocalizedLinkButton></TD>
								</TR>
							</asp:placeholder>
						</table>
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
