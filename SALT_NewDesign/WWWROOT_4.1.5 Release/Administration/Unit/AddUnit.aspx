<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="AddUnit.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Unit.AddUnit" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
	<head>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</head>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout" onload="document.frmAddUnit.txtName.focus();">
		<form id="frmAddUnit" method="post" runat="server">
			<table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr valign="top" align="center" width="100%">
					<td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr valign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Add Unit</Localized:Localizedlabel><br>
						<table width="98%" align="left" border="0">
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblUnitHier" runat="server"></Localized:LocalizedLabel></td>
								<td>
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td>
												<asp:radiobuttonlist id="optUnitLevel" runat="server" cellpadding="0" cellspacing="0">
													<asp:listitem value="1" selected="True">Create a top level unit</asp:listitem>
													<asp:listitem value="2">Create a sub unit of...</asp:listitem>
												</asp:radiobuttonlist>
											</td>
										</tr>
										<tr>
											<td>
												<cc1:treeview id="trvParentUnit" runat="server" outputstyle="SingleSelection" nodetext="Unit"
													systemimagespath="/General/Images/TreeView/"></cc1:treeview>
											</td>
										</tr>
									</table>
									<Localized:Localizedcustomvalidator id="cvldParentUnit" runat="server" controltovalidate="optUnitLevel" display="Dynamic"
										cssclass="ValidatorMessage" errormessage="CustomValidator" onservervalidate="cvldParentUnit_ServerValidate"></Localized:Localizedcustomvalidator>
								</td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblUnitName" key="cmnUnitName" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:textbox id="txtName" runat="server" maxlength="100" size="40"></asp:textbox>
								&nbsp;<Localized:Localizedrequiredfieldvalidator id="rvldName" runat="server" controltovalidate="txtName" cssclass="ValidatorMessage"
										display="Dynamic" errormessage=""></Localized:Localizedrequiredfieldvalidator></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblStatus" key="cmnStatus" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:dropdownlist id="cboStatus" runat="server">
										<asp:listitem value="1">Active</asp:listitem>
										<asp:listitem value="0">Inactive</asp:listitem>
									</asp:dropdownlist></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td align="left"><Localized:Localizedbutton cssclass="saveButton" id="btnSave" key="cmnSave"  runat="server" text="Save" onclick="btnSave_Click"></Localized:Localizedbutton>&nbsp;<asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
							</tr>
						</table>
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
