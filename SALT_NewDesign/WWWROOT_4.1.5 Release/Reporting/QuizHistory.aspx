<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="QuizHistory.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.QuizHistory" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
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
		<form id="frmHistory" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="header" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer"><navigation:reportsmenu id="ucReportsMenu" runat="server"></navigation:reportsmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<navigation:helplink runat="Server" key="10.1.1" desc="Examining Quiz Histories?" id="ucHelp" />
						<Localized:LocalizedLabel id="lblPageTitle" Runat="server" CssClass="pageTitle">Quiz History</Localized:LocalizedLabel><br>
						<asp:Label ID="lblStatus" Runat="server"></asp:Label>
						<asp:datagrid id="dgrQuizHistory" runat="server" Width="95%" AutoGenerateColumns="False">
							<ItemStyle CssClass="TableRow1"></ItemStyle>
							<AlternatingItemStyle CssClass="TableRow2"></AlternatingItemStyle>
							<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
							<FooterStyle CssClass="tablerowbot"></FooterStyle>
							<Columns>
								<asp:BoundColumn DataField="QuizSessionID" Visible="False"></asp:BoundColumn>
								<asp:BoundColumn DataField="Status" HeaderText="Status">
									<HeaderStyle HorizontalAlign="Left"></HeaderStyle>
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:BoundColumn>
								<asp:HyperLinkColumn DataTextField="DateCreated" DataTextFormatString="{0:dd/MM/yyyy}" DataNavigateUrlField="QuizSessionID"
									DataNavigateUrlFormatString="QuizSummary.aspx?QuizSessionID={0}" HeaderText="Summary" HeaderStyle-Width="150px"></asp:HyperLinkColumn>
								<asp:TemplateColumn HeaderText="Pass Mark" HeaderStyle-Width="80px">
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
								<asp:TemplateColumn HeaderText="Your Mark">
									<ItemTemplate>
										<asp:Table Runat="server" ID="tblQuizScore" Width="98%" CellSpacing="0" CellPadding="0">
											<asp:TableRow Runat="server" ID="tbrQuizScore" Width="100%">
												<asp:TableCell Runat="server" ID="tclQuizScore">
													<asp:Label Runat="server" ID="lblQuizScore"></asp:Label>
												</asp:TableCell>
												<asp:TableCell Runat="server" ID="tclQuizTotal" CssClass="BarChartRemainder">
														&nbsp;
													</asp:TableCell>
											</asp:TableRow>
										</asp:Table>
									</ItemTemplate>
								</asp:TemplateColumn>
							</Columns>
						</asp:datagrid><br>
						<a href="javascript:window.history.back(1);" runat="server"><Localized:LocalizedLiteral id="lnkReturn" runat="server"></Localized:LocalizedLiteral></a>
					</td>
				</tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td align="center" valign="middle" colspan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
