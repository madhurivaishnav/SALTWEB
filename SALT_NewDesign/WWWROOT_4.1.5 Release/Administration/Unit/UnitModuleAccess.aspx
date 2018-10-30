<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="jScript" TagName="jScript" Src="/General/UserControls/JScript.ascx" %>
<%@ Page language="c#" Codebehind="UnitModuleAccess.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Unit.UnitModuleAccess" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<jScript:jScript id="ucJScript" runat="server"></JScript:JScript>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<script type="text/javascript">
		    //This must be placed on each page where you want to use the client-side resource manager
		    var ResourceManager = new RM();
		    function RM() {
		        this.list = new Array();
		    };
		    RM.prototype.AddString = function(key, value) {
		        this.list[key] = value;
		    };
		    RM.prototype.GetString = function(key) {
		        var result = this.list[key];
		        for (var i = 1; i < arguments.length; ++i) {
		            result = result.replace("{" + (i - 1) + "}", arguments[i]);
		        }
		        return result;
		    };
		</script>
		<script type="text/javascript">
		    function SaveConfirm() {
		        return confirm(ResourceManager.GetString("ConfirmMessage"));
		        //return confirm("Warning:This action will change the module access of users in this Unit. Are you sure you wish to proceed?");
		    }

		</script>
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
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
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
						<Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Assign Modules to Unit</Localized:Localizedlabel><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td class="formLabel" width="20%"><Localized:LocalizedLabel id="lblUnitNameLabel" key="cmnUnitName" runat="server"></Localized:LocalizedLabel>
								</td>
								<td style="HEIGHT: 16px" width="80%"><asp:label id="lblUnitName" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblCourseLabel" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:dropdownlist id="cboCourse" runat="server" autopostback="True" onselectedindexchanged="cboCourse_SelectedIndexChanged"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblModList" runat="server"></Localized:LocalizedLabel></td>
								<td><table cellspacing="0" rules="all" border="1" id="grdModules" style="border-style:Solid;width:100%;border-collapse:collapse;">
                                    <% rowModuleList = 0; %>
                                    <asp:Repeater id="rptModuleList" runat="server">
                                        <HeaderTemplate>
                                        <tr class="tablerowtop"><td><Localized:LocalizedLabel id="grid_ModuleName" runat="server"></Localized:LocalizedLabel></td>
                                        <td align="center"><Localized:LocalizedLabel id="grid_GrantAccess" runat="server"></Localized:LocalizedLabel></td></tr>
                                        </HeaderTemplate>
												<itemtemplate>
                                        <%  rowModuleList = (rowModuleList + 1) % 2;
                                            if (rowModuleList == 0)
                                            {  %>
                                        <tr class="tablerow1">
                                        <% } else {%>
                                        <tr class="tablerow2">
                                        <% } %>
                                        <td><%# DataBinder.Eval(Container, "DataItem.Name") %></td>
                                        <td><div class="moduleList_checkbox"><input type="checkbox" name="chkGrantedModule" value='<%# DataBinder.Eval(Container, "DataItem.ModuleID") %>' <%# GetGrantStatus(DataBinder.Eval(Container, "DataItem.Granted")) %> /></div><div class="moduleList_checkboxText"></div></td>
                                        </tr>
												</itemtemplate>
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
								<td class="formLabel"><Localized:LocalizedLabel id="lblGrantAll" runat="server"></Localized:LocalizedLabel></td>
								<td>
									<asp:CheckBox ID="chbIsInherit" Runat="server" Visible="True"></asp:CheckBox>
								</td>
							</tr>
							<!-- end new control -->
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><Localized:Localizedbutton cssclass="saveButton" id="btnSave" key="cmnSave" runat="server" text="Save" onclick="btnSave_Click"></Localized:Localizedbutton>&nbsp;<asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><a href="UnitDetails.aspx?UnitID=<%= m_intUnitID%>"><Localized:LocalizedLiteral id="lnkReturnUnitDetails" key="cmnReturnUnitDetails" runat="server"></Localized:LocalizedLiteral></a></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2">
									<asp:label id="litMessage2" runat="server"></asp:label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
		</FORM>
	</body>
</HTML>
