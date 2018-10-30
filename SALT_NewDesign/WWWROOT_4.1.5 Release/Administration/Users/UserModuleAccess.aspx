<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="UserModuleAccess.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Users.UserModuleAccess" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="jScript" TagName="jScript" Src="/General/UserControls/JScript.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<jScript:jScript id="ucJScript" runat="server"></JScript:JScript>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <script type="text/javascript">
            var total = 0;
            var current = 0;

            $(document).ready(function() {
                $('input[name=chkGrantedModule]').each(function() {
                    if ($(this).is(':checked'))
                        current++;

                    total++;
                });

                if (total == current)
                    $('input[name=chkGrantedModuleAll]').prop('checked', true);
                else
                    $('input[name=chkGrantedModuleAll]').prop('checked', false);

                $('input[name=chkGrantedModuleAll]').click(function() {
                    if ($(this).is(':checked')) {
                        $('input[name=chkGrantedModule]').prop('checked', true);
                        current = total;
                    } else {
                        $('input[name=chkGrantedModule]').prop('checked', false);
                        current = 0;
                    }
                });

                $('input[name=chkGrantedModule]').click(function() {
                    if ($(this).is(':checked'))
                        current++;
                    else
                        current--;

                    if (total == current)
                        $('input[name=chkGrantedModuleAll]').prop('checked', true);
                    else
                        $('input[name=chkGrantedModuleAll]').prop('checked', false);
                });
            });
        </script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<form id="Form1" method="post" runat="server">
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
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">User - Module Access</Localized:LocalizedLabel><br />
						<table width="95%" align="left" border="0">
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblUserName" key="cmnUserName" runat="server"></Localized:LocalizedLabel>
								</td>
								<td ><asp:label id="lblName" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblCourse" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:dropdownlist id="cboCourse" runat="server" AutoPostBack="True" onselectedindexchanged="cboCourse_SelectedIndexChanged"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblModuleList" runat="server"></Localized:LocalizedLabel></td>
								<td><table cellspacing="0" rules="all" border="1" id="grdModules" style="border-style:Solid;width:100%;border-collapse:collapse;">
                                    <% rowModuleList = 0; %>
                                    <asp:Repeater id="rptModuleList" runat="server">
                                        <HeaderTemplate>
                                        <tr class="tablerowtop"><td><Localized:LocalizedLabel id="grid_ModuleName" runat="server"></Localized:LocalizedLabel></td>
                                        <td align="center"><Localized:LocalizedLabel id="grid_GrantAccess" runat="server"></Localized:LocalizedLabel></td></tr>
                                        </HeaderTemplate>
												<ItemTemplate>
                                        <%  rowModuleList = (rowModuleList + 1) % 2;
                                            if (rowModuleList == 0)
                                            {  %>
                                        <tr class="tablerow1">
                                        <% } else {%>
                                        <tr class="tablerow2">
                                        <% } %>
                                        <td><%# DataBinder.Eval(Container, "DataItem.Name") %></td>
                                        <td align="center">
                                        <div class="moduleList_checkbox"><input type="checkbox" name="chkGrantedModule" value='<%# DataBinder.Eval(Container, "DataItem.ModuleID") %>' <%# GetGrantStatus(DataBinder.Eval(Container, "DataItem.Granted")) %> /></div><div class="moduleList_checkboxText"></div></td>
                                        </tr>
												</ItemTemplate>
                                        <FooterTemplate>
                                        <tr class="tablerowbot"><td></td>
                                        <td align="center">
                                        <div class="moduleList_checkbox"><input type="checkbox" name="chkGrantedModuleAll" value="" /></div><div class="moduleList_checkboxText"><Localized:LocalizedLabel id="lblSelectAllModules" runat="server"></Localized:LocalizedLabel></div></td></tr>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    </table>
                                </td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><Localized:Localizedbutton CssClass="saveButton" id="btnSave" key="cmnSave"  runat="server" Text="Save" onclick="btnSave_Click"></Localized:Localizedbutton><asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
							</tr>
							<tr>
								<td colSpan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><a href="UserDetails.aspx?UserID=<%= m_intUserID%>"><Localized:LocalizedLiteral id="lnkReturn" runat="server"></Localized:LocalizedLiteral></a></td>
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
		</FORM>
	</body>
</HTML>
