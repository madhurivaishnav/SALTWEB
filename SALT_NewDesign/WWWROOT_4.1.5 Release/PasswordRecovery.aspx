<%@ Page language="c#" Codebehind="PasswordRecovery.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.PasswordRecovery" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en" >
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <style:style id="ucStyle" runat="server"></style:style>
    </head>
    <body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" ms_positioning="FlowLayout">
        <form id="frmMain" method="post" runat="server">
            <table cellspacing="0" cellpadding="0" width="400px" border="0">
                <tr>
                    <td class="Banner"><img height="0" src="/general/images/transparent.gif" width="401px"></td>
                </tr>
                <tr>
                    <td align="center">
                        <!-- email table -->
                        <table cellspacing="0" cellpadding="0" width="100%" border="0">
                            <tr class="info">
                                <td>
									<Localized:LocalizedLabel id="lblText" runat="server"></Localized:LocalizedLabel>
                                </td>
                            </tr>
                            <tr class="password">
                                <td>
                                    <asp:label id="lblMessage" runat="server" Width="250px" ></asp:label>
                                    <asp:textbox id="txtEmail" runat="server" width="350px"></asp:textbox><br>
                                    <Localized:Localizedbutton text="Email Password" runat="server" id="btnRecover" cssclass="sendButton" onclick="btnRecover_Click"></Localized:Localizedbutton></td>
                            </tr>
                        </table>
                        <!-- end email table --></td>
                </tr>
            </table>
            <p align="center"><a href="javascript: this.close();"><img src="/general/images/close.gif" width="114" height="32" border="0"></a></p>
            <p>&nbsp;</p>
        </form>
    </body>
</html>
