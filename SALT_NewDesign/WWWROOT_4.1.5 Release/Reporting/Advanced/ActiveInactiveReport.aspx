<%@ Page trace="false" language="c#" Codebehind="ActiveInactiveReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Advanced.ActiveInactiveReport" %>
<%@ Register TagPrefix="cc2" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="dialogs" Tagname="EScalendar" Src="../../General/UserControls/EmergingControls/EmergingSystemsCalendar.ascx" %>

<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>

  <SCRIPT LANGUAGE=JAVASCRIPT SRC="../../General/js/ESDateTime.js">

  </SCRIPT>
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
					<td><asp:placeholder id="plhTitle" runat="server">
							<navigation:helplink id="ucHelp" runat="Server" key="9.7" desc="Running Licensing Reports?"></navigation:helplink>
							<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Licensing Report</Localized:Localizedlabel>
							<BR>
							<asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
						</asp:placeholder>
						<table width="95%" align="left" border="0">
							<!-- place holder for search critera --><asp:placeholder id="plhSearchCriteria" runat="server"><!-- unit selector -->
								<TBODY>
									<TR>
										<TD class="formLabel" style="WIDTH: 178px" vAlign="top"><STRONG><Localized:LocalizedLabel id="lblCourse" runat="server"></Localized:LocalizedLabel><BR>
											</STRONG>
										</TD>
										<TD>
											<asp:ListBox id="cboCourse" runat="server" Height="250px" Width="230px" SelectionMode="Multiple"></asp:ListBox></TD>
									</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 178px"><STRONG><Localized:LocalizedLabel id="lblAllUsers" runat="server"></Localized:LocalizedLabel></STRONG></TD>
										<TD></TD>
									</TR>
									<TR><dialogs:EScalendar runat="server" id="Calendar1"  ></dialogs:EScalendar>	</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 178px"><STRONG><Localized:LocalizedLabel id="lblUserCreate" runat="server"></Localized:LocalizedLabel></STRONG></TD>
										<TD>
											<P>
												<asp:dropdownlist id="lstFromDay" runat="server" onchange ="javascript:verifyDate(lstFromDay, lstFromMonth, lstFromYear, localizedBadDateMsg)"></asp:dropdownlist>
												<asp:dropdownlist id="lstFromMonth" runat="server" onchange ="javascript:verifyDate(lstFromDay, lstFromMonth, lstFromYear, localizedBadDateMsg)"></asp:dropdownlist>
												<asp:dropdownlist id="lstFromYear" runat="server" onchange ="javascript:verifyDate(lstFromDay, lstFromMonth, lstFromYear, localizedBadDateMsg)"></asp:dropdownlist>
												<img src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(lstFromDay, lstFromMonth, lstFromYear)" />  </P>                                               
                                                    <Localized:LocalizedButton  id="localizedBadDateMsg" height = "1px" Width = "1px" BorderStyle="None"  runat="server"> </Localized:LocalizedButton>
													    


										</TD>
									</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 178px"><STRONG><Localized:LocalizedLabel id="lblUserCreate2" runat="server"></Localized:LocalizedLabel></STRONG></TD>
										<TD>
											<P>
												<asp:dropdownlist id="lstToDay" runat="server" onchange ="javascript:verifyDate(lstToDay, lstToMonth, lstToYear, localizedBadDateMsg)"></asp:dropdownlist>
												<asp:dropdownlist id="lstToMonth" runat="server" onchange ="javascript:verifyDate(lstToDay, lstToMonth, lstToYear, localizedBadDateMsg)"></asp:dropdownlist>
												<asp:dropdownlist id="lstToYear" runat="server" onchange ="javascript:verifyDate(lstToDay, lstToMonth, lstToYear, localizedBadDateMsg)"></asp:dropdownlist>
												<img src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(lstToDay, lstToMonth, lstToYear)" />                                                 
</P>
										</TD>
									</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 178px"><STRONG><Localized:LocalizedLabel id="lblIncludeInactive" runat="server"></Localized:LocalizedLabel></STRONG></TD>
										<TD><asp:checkbox id="chbInclInactiveUser" Runat="server"></asp:checkbox></TD>
									</TR>
									<TR>
										<TD style="WIDTH: 178px">&nbsp;</TD>
									</TR>
									<TR>
										<TD style="WIDTH: 178px"></TD>
										<TD>
											<Localized:Localizedbutton id="btnRunReport" runat="server" cssclass="generateButton" text="Run Report" onclick="btnRunReport_Click"></Localized:Localizedbutton>&nbsp;
											<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></TD>
									</TR> <!-- / place holder for search critera --></asp:placeholder>
							<!-- place holder for Results --><asp:placeholder id="plhReportResults" runat="server">
								<TR>
									<TD colSpan="2">
										<cc2:ReportViewer id="rvReport" runat="server" ReportPath="/ActiveInactiveReport" onpageindexchanged="rvReport_PageIndexChanged"></cc2:ReportViewer></TD>
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
