<%@ Control Language="c#" AutoEventWireup="True" CodeBehind="OrgLogo.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Navigation.OrgLogo"
    TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<div id="NoPrint" name="NoPrint" nowrap="nowrap" width="100%">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr valign="top" id="trOrganisationHeader">
            <td>
                  <% if (isSaltAdmin)
                   { %>
                <img class="HomePageOrgImage" id="imgHeaderAdmin" height="63" border="0" runat="server">
                <% }
                   else
                   {%>
                <img class="HomePageOrgImage" id="imgHeader" height="63" border="0" runat="server" >
                <% } %>                    
            </td>
        </tr>
    </table>
   
</div>
