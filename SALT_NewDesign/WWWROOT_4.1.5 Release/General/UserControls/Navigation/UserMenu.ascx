<%@ Control Language="c#" AutoEventWireup="True" Codebehind="UserMenu.ascx.cs" 

Inherits="Bdw.Application.Salt.Web.General.UserControls.Navigation.UserMenu" 

TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<div id="NoPrint" name="NoPrint">
<!-- Org Image -->
	<asp:placeholder id="phdOrgImage" Runat="server" Visible="False">
		
			<table width="295px" cellspacing="0" cellpadding="0"  align="left"            border="0">
				<tr align="left">
					<td>
					<% if (isSaltAdmin)
                     { %>
					<img class="HomePageOrgImageAdmin" id="imgHeaderAdmin" height="63" border="0" runat="server" visible="false">
					<% }
                    else
                    {%>
					<IMG class="HomePageOrgImage" id="imgHeader" height="63" border="0" runat="server" visible="false">	
					<% } %>
					</td>	
				</tr>
			</table>
			<div id="UserMenuNavigation" style="float:left;">
				<ul  style="float:left; margin:0px; padding:0px;">
					<li class="UserMenuHeading" style="display:none;"><localized:localizedLabel id="lblSaltEnterprise" runat="server"  /></li>
					<li class="UserMenuLinks"  style="display:none;"><localized:localizedLinkButton id="lnkHome" runat="server" cssclass="UserMenuLinks" href="/Default.aspx" /></li>
					<li class="UserMenuLinks"><localized:localizedLinkButton id="lnkMyTraining" runat="server" cssclass="UserMenuLinks" href="/MyTraining.aspx" /></li>
					<li class="UserMenuLinks"><localized:localizedLinkButton id="lnkMyReport" runat="server" cssclass="UserMenuLinks" href="/Reporting/Individual/IndividualReport.aspx" /></li>
				</ul>
			</div>	

    </asp:placeholder>
   
</div>