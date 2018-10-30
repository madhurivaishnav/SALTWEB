<%@ Page language="c#" Codebehind="AddCourse.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ContentAdministration.Courses.AddCourse" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
  <head>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </head>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout" onload="document.frmCourse.txtName.focus();">
		<form id="frmCourse" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer"><Localized:Localizedlabel id="lblPageTitle" Runat="server" CssClass="pageTitle">Add Course</Localized:Localizedlabel><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblName" key="cmnName" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:textbox id="txtName" runat="server" MaxLength="100" Width="300"></asp:textbox><Localized:Localizedrequiredfieldvalidator id="rvldName" runat="server" ControlToValidate="txtName" Display="Dynamic" ErrorMessage="You must specify the Course Name." CssClass="ValidatorMessage"></Localized:Localizedrequiredfieldvalidator></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblNotes" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:textbox id="txtNotes" runat="server" maxlength="1000" Height="100" Width="300" TextMode="MultiLine"></asp:textbox><Localized:Localizedrequiredfieldvalidator id="rvldCourseNotes" runat="server" ErrorMessage="You must specify the Course Notes."
										Display="Dynamic" ControlToValidate="txtNotes" CssClass="ValidatorMessage"></Localized:Localizedrequiredfieldvalidator></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblStatus" key="cmnStatus" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:dropdownlist id="cboStatus" runat="server">
										<asp:ListItem Value="1">Active</asp:ListItem>
										<asp:ListItem Value="0">Inactive</asp:ListItem>
									</asp:dropdownlist></td>
							</tr>
							<tr>
								<td colspan="2"></td>
							</tr>
							<tr>
								<td vAlign="top"></td>
								<td><Localized:Localizedbutton id="btnSave" key="cmnSave"  runat="server" CssClass="saveButton" Text="Save" onclick="btnSave_Click"></Localized:Localizedbutton><asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
							<tr>
								<td colspan="2"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><Localized:Localizedlinkbutton id="lnkReturnToAdminHomepage" key="cmnReturn" runat="server"
										text="Return to Administration Homepage" CausesValidation="False" onclick="lnkReturnToAdminHomepage_Click"></Localized:Localizedlinkbutton></td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</html>
