<%@ Control Language="c#" AutoEventWireup="false" CodeBehind="Login.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Login"
    TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<div style="clear: both">
    <div style="padding-top: 10px; text-align: center;">
        <h4 style="text-transform: uppercase; color: #cccccc; font-size: 2.3em; font-decoration: bold;
            vertical-align: bottom; padding: 0px; margin: 0px;">
            <asp:Literal ID="litLogin" runat="server"></asp:Literal></h4>
    </div>
    <div class="searchbox">
        <div class="content">
            <asp:DropDownList ID="ddlLanguageList" Width="205px" Visible="False" AutoPostBack="True"
                runat="server">
            </asp:DropDownList>
        </div>
        <div>
            <asp:Repeater ID="rptFlag" Visible="False" runat="server">
                <ItemTemplate>
                    <asp:ImageButton ID="imgFlag" runat="server" />&nbsp;
                    <!--- < there must be a single space after the tag. Can't use &nbsp; -->
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="content">
            <b>
                <Localized:LocalizedLiteral ID="litUserName" runat="server"></Localized:LocalizedLiteral></b><br>
            <%--<a href="#" alt="Your username may be an email address, staff ID or a combination of your first and last names. If you are not sure, please select the retrieve your Login Details link below." class="tooltipDemo">  --%>
            <asp:TextBox ID="txtUserName" runat="server" MaxLength="50" CssClass="Login"></asp:TextBox>
        </div>
        <div class="content">
            <b>
                <Localized:LocalizedLiteral ID="litPassword" runat="server"></Localized:LocalizedLiteral></b><br>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="50" CssClass="Login"></asp:TextBox>
        </div>
        <div class="content" style="text-align: center">
            <Localized:LocalizedButton ID="btnLogin" runat="server" Text="Login" CssClass="LoginButton"
                OnClick="btnLogin_Click"></Localized:LocalizedButton>
        </div>
        <div class="content" style="text-align: center">
            <%--<h4><a class="login" href="javascript: fn_void_showPasswordRecovery();" class="Login"><Localized:LocalizedLiteral id="litForgotPassword" runat="server"></Localized:LocalizedLiteral></a></h4>--%>
            <a class="login" href="javascript: fn_void_showPasswordRecovery();">
                <Localized:LocalizedLiteral ID="litForgotPassword" runat="server"></Localized:LocalizedLiteral></a>
            <br />
            <br />
            <a class="login" href="javascript: fn_void_RequestURL();" id="urlRequest" runat="server">
                Sign in with email link</a>
        </div>
    </div>
    <div style="width: 270px;">
        <br>
        <asp:Label ID="lblErrorMessage" runat="server" EnableViewState="False"></asp:Label><br>
        <br>
    </div>
</div>

<script language="javascript">
    var usercontrol = window.document.getElementById('Login1:txtUserName');
    if (usercontrol) usercontrol.focus();
</script>

<%--<style type="text/css">
        .tooltipDemo
        {           
            position: relative;
            display: inline;
            text-decoration: none;
            left: 5px;
            top: 0px;     
        }
        .tooltipDemo:hover:before
        {
            border: solid;
            border-color: transparent #6DA4DB;
            border-width: 6px 6px 6px 0px;
            bottom: 21px;
            content: "";
            left: 155px;
            top: 5px;
            position: absolute;
            z-index: 95;          
        }
        .tooltipDemo:hover:after
        {
            background: #6DA4DB;
           background: #6DA4DB;
            border-radius: 5px;
            color: #fff;
            width: 150px;
            left: 160px;
            top: -5px;           
            content: attr(alt);
            position: absolute;           
            padding: 5px 15px;          
            z-index: 95;           
        }       
    </style>--%>