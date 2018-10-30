<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="About.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.about" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
    <HEAD>
        <title id="pagTitle" runat="server"></title>
        <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
        <meta name="CODE_LANGUAGE" Content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <Style:Style id="ucStyle" runat="server"></Style:Style>
    </HEAD>
    <body MS_POSITIONING="FlowLayout" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <form id="frmMain" method="post" runat="server">
            <table width="400" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="Banner"><img Src="/general/images/transparent.gif" width="401" height="0"></td>
                </tr>
                <tr>
                    <td class="about">
                        <p>
                            <strong>
                                <asp:Label ID="lblApplicationName" Runat="server" />
                                v<asp:Label ID="lblVersion" Runat="server" />
                                <br>
                            </strong>
                            <Localized:LocalizedLabel id="lblBuiltOnNet" runat="server"></Localized:LocalizedLabel>
                            <br>
                            ©
                            <asp:Label ID="lblCopyrightYear" Runat="server" />
                            <asp:Label ID="lblBrandingCompanyName" Runat="server"></asp:Label>
                            <br>
                            <Localized:LocalizedLabel id="lblMoreInformation" runat="server"></Localized:LocalizedLabel>
                            <asp:HyperLink id="lnkCompanyWebsite" runat="server"></asp:HyperLink>.
                        </p>
                        <p>
                            <Localized:LocalizedLabel id="lblProductLicensedTo" runat="server"></Localized:LocalizedLabel>
                            <asp:Label ID="lblLicencedTo" Runat="server" />
                            <br>
                        </p>
                        <p>
                        <Localized:LocalizedLabel id="lblWarningMessage" runat="server"></Localized:LocalizedLabel>
                        </p>
                        
						<p align="center"><a href="javascript: this.close();"><img Src="/general/images/close.gif" width="114" height="32" border="0"></a></p>
						<p>&nbsp;</p>
                    </td>
                </tr>
            </table>

        </form>
    </body>
</HTML>
