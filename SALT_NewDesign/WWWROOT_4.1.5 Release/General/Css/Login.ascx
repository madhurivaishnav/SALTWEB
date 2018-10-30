<%@ Control Language="c#" AutoEventWireup="false" Codebehind="Login.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Login" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<div class="searchbox">
	<h4 style="TEXT-TRANSFORM: uppercase;color: #cccccc; font-size: 2.3em;font-decoration: bold; vertical-align: bottom;"><asp:Literal ID="litLogin" Runat="server"></asp:Literal></h4>


<div class="searchbox" style="width:205px; height:235px; background-color:#cccccc; border-color:#cccccc; border-style:solid; border-width:13px; color:#575757;">	
	<asp:DropDownList ID="ddlLanguageList" Width="205px" Visible="False" AutoPostBack="True" Runat="server"></asp:DropDownList>
        <asp:Repeater ID="rptFlag" Visible="False" Runat="server">
        <ItemTemplate>
	<asp:ImageButton ID="imgFlag" Runat="server" />&nbsp; <!--- < there must be a single space after the tag. Can't use &nbsp; -->
        </ItemTemplate>
        </asp:Repeater>

        <br>
        <br>
	<b><Localized:LocalizedLiteral id="litUserName" runat="server"></Localized:LocalizedLiteral></b><br>
	<asp:textbox id="txtUserName" runat="server" MaxLength="50" CssClass="Login"></asp:textbox><br><br>

	<b><Localized:LocalizedLiteral id="litPassword" runat="server"></Localized:LocalizedLiteral></b><br>
	<asp:textbox id="txtPassword" runat="server" TextMode="Password" MaxLength="50" CssClass="Login"></asp:textbox><br>
        <br>
	<Localized:Localizedbutton id="btnLogin" runat="server" text="Login" cssclass="LoginButton" onclick="btnLogin_Click"></Localized:Localizedbutton><p></p>

        <div class="links" style="text-align:center">
        <h4><a class="login" href="javascript: fn_void_showPasswordRecovery();" class="Login"><Localized:LocalizedLiteral id="litForgotPassword" runat="server"></Localized:LocalizedLiteral></a></h4>
        </div>
        </div>

	<div style="width:231px;">
        <br>
<asp:label id="lblErrorMessage" runat="server" EnableViewState="False"></asp:label><br><br>
</div>
</div>

<div class="clear"></div>

</div>

<script language="javascript">
    //window.document.getElementById('Login1:txtUserName').focus();
</script>