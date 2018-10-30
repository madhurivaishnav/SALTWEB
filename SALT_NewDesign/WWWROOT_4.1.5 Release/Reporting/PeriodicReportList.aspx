<%@ Page Language="c#" CodeBehind="PeriodicReportList.aspx.cs" AutoEventWireup="True"
    Inherits="Bdw.Application.Salt.Web.Reporting.PeriodicReportList" %>

<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="reportsmenu" Src="/General/UserControls/Navigation/reportsmenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Reference Control = "/Reporting/PeriodicReportListControl.ascx" %>
<%@ Reference Control = "/Reporting/PeriodicReportInactiveListControl.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register Assembly="Uws.Framework.WebControl" Namespace="Uws.Framework.WebControl" TagPrefix="cc1" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" >
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <script type="text/javascript" src="../../General/Js/navigationmenu-jquery-latest.min.js"></script>
<script type="text/javascript" src="../../General/Js/navigationmenuscript.js"></script>

		<script language="javascript">
		    //This must be placed on each page where you want to use the client-side resource manager
		    var ResourceManager = new RM();
		    function RM() {
		        this.list = new Array();
		    };
		    RM.prototype.AddString = function(key, value) {
		        this.list[key] = value;
		    };
		    RM.prototype.GetString = function(key) {
		        var result = this.list[key];
		        for (var i = 1; i < arguments.length; ++i) {
		            result = result.replace("{" + (i - 1) + "}", arguments[i]);
		        }
		        return result;
		    };   
		</script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <form id="form1" method="post" runat="server">
    <table id="Table1" height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <!-- Header -->
        <tr valign="top" align="center" width="100%">
            <td valign="top" align="center" width="100%" colspan="2">
                <navigation:header id="ucHeader" runat="server">
                </navigation:header>
            </td>
        </tr>
        <tr valign="top" align="left" height="100%">
            <!-- Left Navigation -->
            <td class="ReportMenuContainer"><navigation:reportsmenu id="ucLeftMenu" runat="server"></navigation:reportsmenu></td>
            <!-- Body/Conent -->
            <td class="DataContainer">
                <Localized:LocalizedLabel ID="lblPageTitle" runat="server" CssClass="pageTitle">Periodic Report Delivery</Localized:LocalizedLabel><br>
                <table ID="periodicReportPage" cellspacing="0" rules="all" border="0" style="width: 100%; border-collapse: collapse;">
                    <tr>
                        <td class="formLabel" colspan="2">
                            <asp:Table ID="Table3" runat="server" Height="100%" Width="100%" BorderStyle="None"
                                BorderWidth="0px" Style="position: relative; z-index: 1; left: 0px; top: 0px;
                                height: 0px; width: 0px">
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="TheGrid">
                                    <asp:TableCell ID="TableCell54" runat="server">
                                        <asp:PlaceHolder ID="PeriodicReportListHolder" runat="server">
                                        </asp:PlaceHolder>
                                    </asp:TableCell>
                                </asp:TableRow>
                            </asp:Table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <!-- Footer -->
        <tr valign="bottom" align="center">
            <td valign="middle" align="center" colspan="2">
                <navigation:footer id="ucFooter" runat="server">
                </navigation:footer>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
