<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserReceivedEmails.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Users.UserReceivedEmails" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="jScript" TagName="jScript" Src="/General/UserControls/JScript.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server"></Style:Style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
	<meta content="C#" name="CODE_LANGUAGE">
	<meta content="JavaScript" name="vs_defaultClientScript">
	<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<script type="text/javascript">
		//This must be placed on each page where you want to use the client-side resource manager
		var ResourceManager = new RM();
		function RM()
		{
		this.list = new Array();
		};
		RM.prototype.AddString = function(key, value)
		{
		this.list[key] = value;
		};
		RM.prototype.GetString = function(key)
		{
		var result = this.list[key];  
		for (var i = 1; i < arguments.length; ++i)
		{
			result = result.replace("{" + (i-1) + "}", arguments[i]);
		}
		return result;
		};
	</script>
	<script type="text/javascript">
	function ResendConfirm()
	{
	    return confirm(ResourceManager.GetString("ConfirmMessage.Resend"));
	}
	</script>
</head>
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
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server"></Localized:LocalizedLabel><br />
						
						<asp:Label ID="lblMessage" Visible="false" runat="server"></asp:Label><br /><br />
						<table cellspacing="0" rules="all" border="1" id="grdEmails" style="border-style:Solid;width:100%;border-collapse:collapse;">
                            <% rowEmailList = 0; %>
                            <asp:Repeater id="rptEmailList" runat="server" OnItemCommand="rptEmailList_ItemCommand">
                                <HeaderTemplate>
                                <tr class="tablerowtop">
                                <td><Localized:LocalizedLabel id="Grid_DateSent" runat="server"></Localized:LocalizedLabel></td>
                                <td><Localized:LocalizedLabel id="Grid_To" runat="server"></Localized:LocalizedLabel></td>
                                <td><Localized:LocalizedLabel id="Grid_Subject" runat="server"></Localized:LocalizedLabel></td>
                                <td><Localized:LocalizedLabel id="Grid_Body" runat="server"></Localized:LocalizedLabel></td>
                                <td><Localized:LocalizedLabel id="grid_Action" runat="server"></Localized:LocalizedLabel></td>
                                </HeaderTemplate>
                                <ItemTemplate>
                                <%  rowEmailList = (rowEmailList + 1) % 2;
                                    if (rowEmailList == 0)
                                    {  %>
                                <tr class="tablerow1">
                                <% } else {%>
                                <tr class="tablerow2">
                                <% } %>
                                <td><%# DataBinder.Eval(Container, "DataItem.DateCreated") %></td>
                                <td><%# DataBinder.Eval(Container, "DataItem.ToEmail") %></td>
                                <td><%# DataBinder.Eval(Container, "DataItem.subject") %></td>
                                <td><%# DataBinder.Eval(Container, "DataItem.body") %></td>
                                <td><Localized:LocalizedLinkButton id="grid_lnkResend" runat="server" OnClientClick="javascript:return ResendConfirm();" CommandName="ResendEmail" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.emailid") %>'></Localized:LocalizedLinkButton></td>
                                </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
						
						<table width="95%" align="left" border="0">
							<tr>
								<td>&nbsp;</td>
								<td><br /><br />
								<a href="UserDetails.aspx?UserID=<%= m_intUserID%>"><Localized:LocalizedLiteral id="lnkReturn" runat="server"></Localized:LocalizedLiteral></a></td>
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
	</body>
</html>
