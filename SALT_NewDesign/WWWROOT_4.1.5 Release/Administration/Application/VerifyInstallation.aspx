<%@ Page language="c#" Codebehind="VerifyInstallation.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.VerifyInstallation" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
    <head>
        <title>VerifyInstallation</title>
        <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
        <meta name="CODE_LANGUAGE" content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    </head>
    <body ms_positioning="FlowLayout">
        <form id="Form1" method="post" runat="server">
        <h1>Verifying Installation</h1>
            <asp:table id="tblResults" runat="server" backcolor="#e0e0e0" cellspacing="0" bordercolor="#000000" borderstyle="Solid" borderwidth="1" width="80%">
                <asp:tablerow backcolor="#6666ff" forecolor="#FFFFFF">
                    <asp:tablecell>Success</asp:tablecell>
                    <asp:tablecell>Condition</asp:tablecell>
                    <asp:tablecell>Message</asp:tablecell>
                </asp:tablerow>
            </asp:table>
        </form>
    </body>
</html>
