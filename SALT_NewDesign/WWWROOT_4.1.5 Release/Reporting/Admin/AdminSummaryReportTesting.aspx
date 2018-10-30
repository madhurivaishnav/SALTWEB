<%@ Page language="c#" Codebehind="AdminSummaryReportTesting.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Admin.AdminSummaryReportTesting" %>
<%@ Register TagPrefix="cc2" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title id="pagTitle" runat="server"></title>
    <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </head>
  <body MS_POSITIONING="FlowLayout">
	
    <form id="Form1" method="post" runat="server">
			<table>
			<asp:placeholder id="plhReportResults" runat="server">
				<TR>
					<TD colSpan="2">
					<cc2:ReportViewer id="rvReport" runat="server" ReportPath="/AdminTestingReport"></cc2:ReportViewer></TD>
					</TR>
			</asp:placeholder>
			</table>
     </form>
	
  </body>
</html>
