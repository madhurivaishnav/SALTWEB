<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="cc2" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="criteria" TagName="reportCriteria" Src="/General/UserControls/ReportCriteria.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page Language="c#" Codebehind="CPDReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.CPD.CPDReport" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<Style:style id="ucStyle" runat="server"></Style:style>
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td style="HEIGHT: 31px" valign="top" align="center" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr valign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer" width="30">
						<navigation:reportsmenu id="ucReportsMenu" runat="server"></navigation:reportsmenu>
					</td>
					<!-- Body/Content -->
					<td align="left" class="DataContainer">
						<asp:PlaceHolder ID="plhTitle" runat="server">
							<Localized:LocalizedLabel id="lblPageTitle" runat="server" CssClass="pageTitle"></Localized:LocalizedLabel>
							<BR>
							<asp:Label id="lblError" runat="server" ForeColor="#FF0000"></asp:Label>
						</asp:PlaceHolder>
						<asp:ValidationSummary ID="vsCPDProfileReport" Runat="server" DisplayMode="BulletList" EnableViewState="False" />
						<table width="98%" align="left" border="0">
							<asp:PlaceHolder ID="plhSearchCriteria" runat="server">
								<TBODY>
									<TR>
										<TD style="WIDTH: 151px" vAlign="top"><STRONG>
												<Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></STRONG></TD>
										<TD>
											<cc1:TreeView id="trvUnitPath" runat="server" OutputStyle="MultipleSelection" SystemImagesPath="/General/Images/TreeView/"
												NodeText="Unit"></cc1:TreeView></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<Localized:LOCALIZEDLABEL id="lblProfile" runat="server"></Localized:LOCALIZEDLABEL></TD>
										<TD>
											<asp:DropDownList id="cboProfile" runat="server" Width="200px" AutoPostBack="True" onselectedindexchanged="cboProfile_SelectedIndexChanged"></asp:DropDownList>&nbsp;&nbsp;
											<asp:RequiredFieldValidator id="rfvProfile" runat="server" Enabled="true" Text="*" ErrorMessage="Please select a profile"
												ControlToValidate="cboProfile"></asp:RequiredFieldValidator></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<Localized:LOCALIZEDLABEL id="lblPeriod" runat="server"></Localized:LOCALIZEDLABEL></TD>
										<TD>
											<asp:DropDownList id="cboPeriod" runat="server" Width="200px"></asp:DropDownList></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LOCALIZEDLABEL id="lblFirstName" runat="server" key="cmnFirstName"></Localized:LOCALIZEDLABEL></TD>
										<TD>
											<asp:TextBox id="txtFirstName" runat="server" Width="200px"></asp:TextBox></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LOCALIZEDLABEL id="lblLastName" runat="server" key="cmnLastName"></Localized:LOCALIZEDLABEL></TD>
										<TD>
											<asp:TextBox id="txtLastName" runat="server" Width="200px"></asp:TextBox></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LOCALIZEDLABEL id="lblUserName" runat="server" key="cmnUserName"></Localized:LOCALIZEDLABEL></TD>
										<TD>
											<asp:TextBox id="txtUserName" runat="server" Width="200px"></asp:TextBox></TD>
									</TR>
									<TR>
										<TD class="formLabel">
											<Localized:LOCALIZEDLABEL id="lblShortFallUsers" runat="server"></Localized:LOCALIZEDLABEL></TD>
										<TD>
											<asp:CheckBox id="chbShortFallUsers" runat="server"></asp:CheckBox></TD>
									</TR>
									<TR>
										<TD></TD>
										<TD>
											<Localized:LOCALIZEDBUTTON id="btnGenerate" runat="server" text="Run Report" cssclass="generateButton"></Localized:LOCALIZEDBUTTON>&nbsp;
											<Localized:LOCALIZEDBUTTON id="btnReset" runat="server" text="Reset" cssclass="resetButton"></Localized:LOCALIZEDBUTTON></TD>
									</TR>
							</asp:PlaceHolder>
							<!-- place holder for Results -->
							<asp:PlaceHolder ID="plhReportResults" runat="server">
								<TR>
									<TD colSpan="2">
										<cc2:ReportViewer id="rvReport" runat="server" ReportPath="/CPDReport"></cc2:ReportViewer></TD>
								</TR>
							</asp:PlaceHolder>
							<!-- / place holder for Results -->
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
				</TBODY></table>
		</form>
	</body>
</HTML>
