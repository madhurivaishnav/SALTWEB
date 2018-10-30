<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Control Language="c#" AutoEventWireup="True" Codebehind="SelectOrganisation.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Navigation.SelectOrganisation" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<table runat="server" id="tblOrganisation" cellspacing="0" cellpadding="0" align="left"
	border="0" style="background-color:#fff;">
	<tr>
		<td style="padding:5px;"><b><Localized:LocalizedLabel id="lblSelectOrganisation" runat="server">Select Organisation</Localized:LocalizedLabel></b>
		</td>
	</tr>
	<tr>
		<td align="left">
		 <div class="ddl">
			<asp:dropdownlist id="cboOrganisationName" runat="server" autopostback="true" CssClass="AdminMenu" onselectedindexchanged="cboOrganisationName_SelectedIndexChanged"></asp:dropdownlist>
			</div>
			<br />
		</td>
	</tr>
</table>
