<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Page language="c#" Codebehind="ModifyLinks.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.ModifyLinks" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<script language="javascript">
		//This must be placed on each page where you want to use the client-side resource manager
		var ResourceManager = new RM();
		function RM()
		{
		this.list = new Array();
		};
		RM.prototype.AddString = function(key, value)
		{
		this.list[key] = value;
		};
		RM.prototype.GetString = function(key)
		{
		var result = this.list[key];  
		for (var i = 1; i < arguments.length; ++i)
		{
			result = result.replace("{" + (i-1) + "}", arguments[i]);
		}
		return result;
		};
		</script>
		<script language="JavaScript">
			function deleteConfirm()
			{
				return confirm(ResourceManager.GetString("ConfirmMessage"));
			}
		</script>
	</HEAD>
	<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
		<form id="frmModifyLinks" method="post" runat="server">
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td align="center" valign="top" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr height="100%" align="left" valign="top">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer">
						<navigation:adminmenu runat="server" id="ucAdminMenu"></navigation:adminmenu>
					</td>
					<!-- Body/Conent -->
					 <td class="DataContainer">
						<Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Modify Links</Localized:Localizedlabel><br>
						<table align="left" border="0" width="95%">
							<tr>
								<td>
									<asp:label runat="server" id="lblMessage" enableviewstate="False"></asp:label>
									<table cellspacing="0" rules="all" border="1" width="100%" style="BORDER-COLLAPSE:collapse">
										<tr class="tablerowtop">
											<td colspan="2"><Localized:LocalizedLabel id="lblAddLink" runat="server"></Localized:LocalizedLabel></td>
										</tr>
										<tr class="tablerow1">
											<td><Localized:LocalizedLabel id="lblCaption" runat="server"></Localized:LocalizedLabel></td>
											<td><asp:textbox id="txtAddCaption" runat="server" maxlength="100" width="300px"></asp:textbox></td>
										</tr>
										<tr class="tablerow2">
											<td><Localized:LocalizedLabel id="lblURL" runat="server"></Localized:LocalizedLabel></td>
											<td><asp:textbox id="txtAddURL" runat="server" maxlength="200" width="300px"></asp:textbox>
												<br>
												<Localized:LocalizedLiteral id="litNote" runat="server"></Localized:LocalizedLiteral>
											</td>
										</tr>
										<tr class="tablerow1">
											<td><Localized:LocalizedLabel id="litShowDIsclaimer" runat="server"></Localized:LocalizedLabel></td>
											<td><asp:checkbox id="chkAddDisclaimer" runat="server"></asp:checkbox></td>
										</tr>
										<tr>
											<td colspan="2">
												<Localized:Localizedbutton id="btnAdd" runat="server" text="Add Link" cssclass="addButton" onclick="btnAdd_Click"></Localized:Localizedbutton>
											</td>
										</tr>
									</table>
									<br>
							<tr>
								<td>
									<asp:datagrid id="grdResults" runat="server" width="100%" autogeneratecolumns="False" allowsorting="True"
										allowpaging="True">
										<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
										<itemstyle cssclass="tablerow2"></itemstyle>
										<columns>
											<asp:templatecolumn headertext="Link Caption" visible="true">
												<headerstyle cssclass="tablerowtop" width="250"></headerstyle>
												<itemtemplate>
													<%# DataBinder.Eval(Container.DataItem, "Caption").ToString()%>
												</itemtemplate>
												<edititemtemplate>
													<asp:textbox runat="server" id="txtCaption" width="95%" textmode="MultiLine" maxlength="100" Text='<%# DataBinder.Eval(Container.DataItem, "Caption").ToString()%>'>
													</asp:textbox>
													<asp:TextBox ID="txtLinkOrder" Text='<%# DataBinder.Eval(Container.DataItem, "LinkOrder").ToString()%>' Width="0" Runat="server"></asp:TextBox>
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:templatecolumn headertext="Url" visible="true">
												<headerstyle cssclass="tablerowtop" width="250"></headerstyle>
												<itemtemplate>
													<%# DataBinder.Eval(Container.DataItem, "Url").ToString()%>
												</itemtemplate>
												<edititemtemplate>
													<asp:textbox runat="server" id="txtUrl" width="95%" textmode="MultiLine" maxlength="200" Text='<%# DataBinder.Eval(Container.DataItem, "Url").ToString()%>'>
													</asp:textbox>
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:templatecolumn headertext="Show Disclaimer" visible="true">
												<headerstyle cssclass="tablerowtop" horizontalalign="center" width="150"></headerstyle>
												<itemstyle horizontalalign="center"></itemstyle>
												<itemtemplate>
													<asp:checkbox runat="server" id="chkShowDisclaimerDisabled" checked='<%# DataBinder.Eval(Container.DataItem, "ShowDisclaimer")%>' enabled="False">
													</asp:checkbox>
												</itemtemplate>
												<edititemtemplate>
													<asp:checkbox runat="server" id="chkShowDisclaimerEnabled" checked='<%# DataBinder.Eval(Container.DataItem, "ShowDisclaimer")%>' enabled="True">
													</asp:checkbox>
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:editcommandcolumn buttontype="LinkButton" updatetext="Update" canceltext="Cancel" edittext="Modify"
												headerstyle-cssclass="tablerowtop" headerstyle-width="50"></asp:editcommandcolumn>
											<asp:buttoncolumn text="Delete" buttontype="LinkButton" commandname="Delete" headerstyle-cssclass="tablerowtop"></asp:buttoncolumn>
											<asp:TemplateColumn HeaderText="Sort">
												<headerstyle cssclass="tablerowtop" horizontalalign="center" width="40"></headerstyle>
												<ItemTemplate>
												<center>
													<nobr>
													<asp:LinkButton ID="lnkUp" Runat="server" Font-Name="WingDings">é</asp:LinkButton>
													
													<asp:LinkButton ID="lnkDown" Runat="server" Font-Name="WingDings">ê</asp:LinkButton>
													</nobr>
													</center>
												</ItemTemplate>
											</asp:TemplateColumn>
										</columns>
										<pagerstyle mode="NumericPages" position="Bottom"></pagerstyle>
									</asp:datagrid>
								</td>
							</tr>
							<tr>
								<td>
									<a href="/Administration/AdministrationHome.aspx"><Localized:LocalizedLiteral id="lnkReturn" key="cmnReturn"  runat="server"></Localized:LocalizedLiteral></a>
								</td>
							</tr>
						</table>
					</td>
					<!-- /Body/Conent -->
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
</HTML>
