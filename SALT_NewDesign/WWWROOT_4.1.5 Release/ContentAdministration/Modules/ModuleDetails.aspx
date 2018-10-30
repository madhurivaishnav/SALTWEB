<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="ModuleDetails.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ContentAdministration.Modules.ModuleDetails" %>
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
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout"
		onload="document.frmModule.txtName.focus();">
		<form id="frmModule" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Module Details</Localized:LocalizedLabel><br>
						<table width="95%" align="left" border="0">
							<TBODY>
								<tr>
									<td class="formLabel"><Localized:LocalizedLabel id="lblName" key="cmnName" runat="server"></Localized:LocalizedLabel></td>
									<td><asp:textbox id="txtName" runat="server" MaxLength="100" Width="300"></asp:textbox><Localized:Localizedrequiredfieldvalidator id="rvldName" runat="server" ErrorMessage="Please enter a Module Name to proceed"
											Display="Dynamic" ControlToValidate="txtName" CssClass="ValidatorMessage"></Localized:Localizedrequiredfieldvalidator></td>
								</tr>
								<tr>
									<td class="formLabel"><Localized:LocalizedLabel id="lblDescription" runat="server"></Localized:LocalizedLabel></td>
									<td><asp:textbox id="txtDescription" runat="server" TextMode="MultiLine" rows="10" columns="50" Width="300"></asp:textbox></td>
								</tr>
								<tr>
									<td class="formLabel"><Localized:LocalizedLabel id="lblStatus" key="cmnStatus" runat="server"></Localized:LocalizedLabel></td>
									<td><asp:dropdownlist id="cboStatus" runat="server">
											<asp:ListItem Value="1">Active</asp:ListItem>
											<asp:ListItem Value="0">Inactive</asp:ListItem>
										</asp:dropdownlist></td>
								</tr>
								
								
								<!-- end business requirement 3 -->
								
								<tr>
									<td class="formLabel"><Localized:LocalizedLabel id="lblToolBook" runat="server"></Localized:LocalizedLabel></td>
									<td>
										<table width="100%" align="left" border="0" cellpadding=0 cellspacing=0>
											<tr>
												<td width="100%"><asp:label id="lblLessonDetails" runat="server"></asp:label>
												</td>
											</tr>
											<tr>
												<td width="100%"><asp:label id="lblQuizDetails" runat="server"></asp:label>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								
								<!-- business requirement: 6 -->
								<!-- TODO: implement the actual functionalities -->
								<tr>
									<td class="formLabel">
										<Localized:LocalizedLabel id="lblQuizWorkSite" runat="server"></Localized:LocalizedLabel>
									</td>
									<td>
										<asp:label id="lblQWorksiteMsg" runat="server"></asp:label>
										<asp:TextBox ID="txtQWorksiteID" Runat="server" Visible="False" MaxLength="50"></asp:TextBox>
										<Localized:Localizedrequiredfieldvalidator id="rfvQWorksiteID" runat="server" ErrorMessage="* Required"
											Display="Static" ControlToValidate="txtQWorksiteID" CssClass="ValidatorMessage" Enabled="False"></Localized:Localizedrequiredfieldvalidator>
									</td>
								</tr>
								<tr>
									<td class="formLabel">
										<Localized:LocalizedLabel id="lblLessionWorkSite" runat="server"></Localized:LocalizedLabel>
									</td>
									<td>
										<asp:label id="lblLWorksiteMsg" runat="server"></asp:label>
										<asp:TextBox ID="txtLWorksiteID" Runat="server" Visible="False" MaxLength="50"></asp:TextBox>
										<Localized:Localizedrequiredfieldvalidator id="rfvLWorksiteID" runat="server" ErrorMessage="* Required"
											Display="Static" ControlToValidate="txtLWorksiteID" CssClass="ValidatorMessage" Enabled="False"></Localized:Localizedrequiredfieldvalidator>
									</td>
								</tr>
								<tr>
									<td class="formLabel">
										<Localized:LocalizedLabel id="lblQuickFact" runat="server"></Localized:LocalizedLabel>
									</td>
									<td>
										<asp:label id="lblQFWorksiteMsg" runat="server"></asp:label>
										<asp:TextBox ID="txtQFWorksiteID" Runat="server" Visible="False" MaxLength="50"></asp:TextBox>
										<Localized:Localizedrequiredfieldvalidator id="rfvQFWorksiteID" runat="server" ErrorMessage="* Required"
											Display="Static" ControlToValidate="txtQFWorksiteID" CssClass="ValidatorMessage" Enabled="False"></Localized:Localizedrequiredfieldvalidator>
									</td>
								</tr>

								<tr>
									<td></td>
									<td align="left">
										<Localized:Localizedbutton CssClass="saveButton" id="btnSave" key="cmnSave"  runat="server" Text="Save" onclick="btnSave_Click"></Localized:Localizedbutton>
										&nbsp;
										<asp:label id="lblMessage" runat="server" enableviewstate="False" width="300px"></asp:label>
									</td>
								</tr>
								<tr>
									<td colspan="2"></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										<Localized:Localizedlinkbutton runat="server" id="lnkUploadContent" text="Upload New Content" 
											CausesValidation="False" onclick="lnkUploadContent_Click"></Localized:Localizedlinkbutton>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										<Localized:Localizedhyperlink runat="server" id="lnkResetLesson" text="Reset Lesson Status" 
											CausesValidation="False"></Localized:Localizedhyperlink>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										<Localized:Localizedhyperlink runat="server" id="lnkResetQuiz" text="Reset Quiz Status" 
											CausesValidation="False"></Localized:Localizedhyperlink>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>
										<Localized:Localizedlinkbutton runat="server" id="lnkReturnToCourseDetail" text="Return to Course Details"
											CausesValidation="False" onclick="lnkReturnToCourseDetail_Click"></Localized:Localizedlinkbutton>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</TBODY></TABLE>
		</form>
	</body>
</HTML>
