<%@ Control Language="c#" AutoEventWireup="True" Codebehind="Footer.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Navigation.Footer" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<div id="NoPrint" name="NoPrint">
    <p class="footer">
        ©
        <asp:Label ID="lblCopyRightYear" runat="server" />&nbsp;<asp:HyperLink Runat="server" Target="_blank" id="lnkCompany"></asp:HyperLink>
    </p>
    <asp:Panel ID="panLanguageAdmin" Visible="False" Runat="server">
		Language: 
		<asp:DropDownList ID="ddlLanguageList" DataTextField="RecordName" DataValueField="LangCode" Runat="server" AutoPostBack="True">
	    
		</asp:DropDownList>
		&nbsp;
		View Language Translation in <asp:DropDownList ID="ddlLanguagePreviewMode" Runat="server" AutoPostBack="True">
		<asp:ListItem Value="0">Committed Mode</asp:ListItem>
		<asp:ListItem Value="1">Uncommitted Mode</asp:ListItem>
		</asp:DropDownList>
    </asp:Panel>
</div>
