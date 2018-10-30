<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeZone.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.TimeZone" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register assembly="Uws.Framework.WebControl" namespace="Uws.Framework.WebControl" tagprefix="cc1" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">

<html>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<script language="javascript">
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
		<script language="JavaScript" type="text/javascript">
		    function SaveConfirm() {
		        return confirm(ResourceManager.GetString("ConfirmMessage"));
		        //return confirm("Warning:This action will change the module access of users in this Unit. Are you sure you wish to proceed?");
		    }

		</script>				
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
	
		<form id="form1" method="post" runat="server">
			<table id="Table1" height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:Localizedlabel id="lblPageTitle" Runat="server" CssClass="pageTitle">Periodic Report Delivery</Localized:Localizedlabel><br>


						<table cellspacing="0" rules="all" border="0" style="width:100%;border-collapse:collapse;">
						
                                 <TR>
    									<td class="formLabel">
											<Localized:LocalizedLabel id="lblServerTimeZone" runat="server" ccsclass="formLabel" />
										</td>
									    <TD align=right>
											<asp:dropdownlist id="listTimeZone" Runat="server" ></asp:dropdownlist>
                                            
                                        </TD>
                                 </TR>	
                                 <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                                 <tr><td>&nbsp;</td><td>&nbsp;</td></tr>   
                                 <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                                 <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                                 <tr><td align="center" colspan="2" width="30%">Existing User Defined TimeZones</td></tr>
                                            <tr>
                                                <td align="center" colspan="2">
                                                    <asp:datagrid id="dtgTimezone" runat="server" width="30%" 
                                                        autogeneratecolumns="False" borderstyle="Solid"  
                                                        AllowPaging="True" onpageindexchanged="onPageIndexChanged" >
                                                        <PagerStyle HorizontalAlign="Left" Mode="NumericPages" />
                                                        <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                                                        <itemstyle cssclass="tablerow2"></itemstyle>
                                                        <columns>
                                                            
                                                            
                                                            <asp:TemplateColumn HeaderText="TimeZone">
                                                                <headerstyle cssclass="tablerowtop" width="100" height="25"></headerstyle>
                                                                <itemstyle horizontalalign="left"></itemstyle>
                                                                 <ItemTemplate>
                                                                 <asp:HyperLink ID="hyLink" Text='<%# DataBinder.Eval(Container.DataItem, "WrittenName") %>' NavigateUrl='<%#"TimeZoneEdit.aspx?timeZoneId="+DataBinder.Eval(Container.DataItem, "TimeZoneID") %>' Runat="server"></asp:HyperLink>
                                                                     </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            
                                                        </columns>
                                                    </asp:datagrid>
                                                </td>
                                            </tr>
                                           
                                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>

                                           <tr>
                                                <td align="center" colspan="2" width="30%">
                                                    <Localized:LocalizedButton ID="btnNew" Runat="server" OnClick="btnNew_Click" ></Localized:LocalizedButton>
                                                </td>
                                           </tr>

                                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                                           
                                           <tr>
                                                <td align="center" colspan="2" width="30%">
                                                    <Localized:LocalizedButton ID="btnImport" Runat="server" OnClick="btnImport_Click" ></Localized:LocalizedButton>
                                                </td>
                                           </tr>
                                           
                                           
                                           
                                 


                    </table>
                    <asp:label runat="server" id="lblMessage" enableviewstate="False"></asp:label></td></tr><!-- Footer --><tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</html>
