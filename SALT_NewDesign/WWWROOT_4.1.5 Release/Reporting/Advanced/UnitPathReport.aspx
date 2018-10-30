<%@ Register TagPrefix="cc1" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="cc2" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Page language="c#" Codebehind="UnitPathReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.UnitPathReport" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
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
		<script type="text/javascript" src="../../General/Js/navigationmenu-jquery-latest.min.js"></script>
<script type="text/javascript" src="../../General/Js/navigationmenuscript.js"></script>

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
                                                                <navigation:helplink id="ucHelp" runat="Server" desc="" key="10.2.8"></navigation:helplink>
								<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Unit Path Report</Localized:Localizedlabel>
								<BR>
								<asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
							</asp:PlaceHolder>
							<BR>
							<TABLE id="Table1" cellSpacing="1" cellPadding="1" width="95%" align="left" border="0">
								<TR>
									<TD style="WIDTH: 147px" vAlign="top"><STRONG><Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></STRONG></TD>
									<TD>
										<cc2:TreeView id="trvUnitPath" runat="server" SystemImagesPath="/General/Images/TreeView/" OutputStyle="MultipleSelection"></cc2:TreeView></TD>
								</TR>
								<TR>
									<TD style="WIDTH: 147px; HEIGHT: 21px"><STRONG><Localized:LocalizedLabel id="lblInactiveUnits" runat="server"></Localized:LocalizedLabel></STRONG></TD>
									<TD style="HEIGHT: 21px">
										<asp:CheckBox id="chkIncludeInactiveUnits" runat="server"></asp:CheckBox></TD>
								</TR>
								<TR>
									<TD style="WIDTH: 147px"></TD>
									<TD>
										<Localized:LocalizedButton id="btnShowUnits" runat="server" Text="Run Report" onclick="btnShowUnits_Click"></Localized:LocalizedButton></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="panelReport" runat="server">
							<cc1:ReportViewer id="rvReport" runat="server" ReportPath="/UnitPathReport"></cc1:ReportViewer>
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
