<%@ Page language="c#" Codebehind="CPDHistory.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.CPD.CPDHistory" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<html>
	<head>
		<title>CPDHistory</title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name=vs_defaultClientScript content="JavaScript">
		<meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</head>
	
	<body MS_POSITIONING="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">	
		<form id="Form1" method="post" runat="server">
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<!-- Header -->
                <tr align="center" valign="top" width="100%">
                    <td align="center" valign="top" width="100%" colspan="2">
                        <navigation:header id="ucHeader" runat="server"></navigation:header>
                    </td>
				</tr>
				<tr height="100%" align="left" valign="top">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer" width="50">
						<navigation:reportsMenu runat="server" id="ucLeftMenu"></navigation:reportsMenu>
					</td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">CPD History</Localized:LocalizedLabel><br>
						<asp:Label ID="lblError" Runat="server" CssClass=""></asp:Label>
						<br>
						<asp:PlaceHolder ID ="plhModuleHist" Visible ="False" Runat="server">
							<asp:DataGrid ID="dgrResults" Runat="server" CssClass="DataGridReport" AutoGenerateColumns="False" Width="50%" GridLines="Horizontal">
								<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
								<FooterStyle CssClass="tablerowbot"></FooterStyle>
								<pagerstyle visible="False"></pagerstyle>
								<Columns>
									<asp:BoundColumn DataField="PeriodDesc" HeaderText="Period" ItemStyle-CssClass="tablerow2"></asp:BoundColumn>
									<asp:BoundColumn DataField="Points" HeaderText="Points" ItemStyle-CssClass="tablerow2"></asp:BoundColumn>
								</Columns>
							</asp:DataGrid>
						</asp:PlaceHolder>
						<asp:PlaceHolder ID ="plhProfileHist" Visible ="False" Runat="server">
							<asp:DataGrid ID="dgrProfileHist" Runat="server" CssClass="DataGridReport" AutoGenerateColumns="False" Width="50%" GridLines="Horizontal">
								<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
								<FooterStyle CssClass="tablerowbot"></FooterStyle>
								<pagerstyle visible="False"></pagerstyle>
								<Columns>
									<asp:BoundColumn DataField="PeriodDesc" HeaderText="Period" ItemStyle-CssClass="tablerow2"></asp:BoundColumn>
									<asp:BoundColumn DataField="PointsEarned" HeaderText="Points Earned" ItemStyle-CssClass="tablerow2"></asp:BoundColumn>
									<asp:BoundColumn DataField="PointsRequired" HeaderText="Points Required" ItemStyle-CssClass="tablerow2"></asp:BoundColumn>
								</Columns>
							</asp:DataGrid>							
						</asp:PlaceHolder>
					</td>                    
                </tr>
                <!-- Footer -->
                <tr align="center" valign="bottom">
                    <td align="center" valign="middle" colspan="2">
                        <navigation:footer id="ucFooter" runat="server"></navigation:footer>
                    </td>
                </tr>			
			</table>    
		</form>	
	</body>
</html>
