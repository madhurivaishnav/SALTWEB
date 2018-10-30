<%@ Control Language="c#" AutoEventWireup="false" Codebehind="Login.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Login" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<div id="contentRight">
 <br>
 <h4 style="TEXT-TRANSFORM: uppercase;"><asp:Literal ID="litLogin" Runat="server" Visible="False"></asp:Literal></h4>
	<div id="contentField">
	<Localized:LocalizedLiteral id="litUserName" runat="server"></Localized:LocalizedLiteral><br>
	<asp:textbox id="txtUserName" runat="server" MaxLength="60" CssClass="Login"></asp:textbox>
        </div>

        <div id="contentField">
	<Localized:LocalizedLiteral id="litPassword" runat="server"></Localized:LocalizedLiteral><br>
	<asp:textbox id="txtPassword" runat="server" TextMode="Password" MaxLength="60" CssClass="Login"></asp:textbox><br>
        </div>

        <div id="contentError">
	<asp:label id="lblErrorMessage" runat="server" EnableViewState="False"></asp:label>
	</div>
	<Localized:Localizedbutton id="btnLogin" runat="server" text="Login" cssclass="LoginButton" style="TEXT-TRANSFORM: uppercase;"></Localized:Localizedbutton>
</div>

<div id="contentLeft">

<asp:DropDownList ID="ddlLanguageList" Width="205px" Visible="False" AutoPostBack="True" Runat="server"></asp:DropDownList>
<asp:Repeater ID="rptFlag" Visible="False" Runat="server">
<ItemTemplate>
	<asp:ImageButton ID="imgFlag" Runat="server" />&nbsp; <!--- < there must be a single space after the tag. Can't use &nbsp; -->
</ItemTemplate>
</asp:Repeater>

<h5><a href="javascript: fn_void_showPasswordRecovery();" class="Login"><Localized:LocalizedLiteral id="litForgotPassword" runat="server" visible="false"></Localized:LocalizedLiteral></a></h5>
</div>

<!--<div class="clear"></div>
<div class="links">
</div>-->

		
<script language="javascript">
    window.document.getElementById('Login1:txtUserName').focus();
</script>