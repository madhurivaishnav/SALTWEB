<%@ Page language="c#" Codebehind="EmailSentReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Advanced.EmailSentReport" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="cc2" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="cc1" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
    <HEAD>
        <title id="pagTitle" runat="server"></title>
        <Style:Style id="ucStyle" runat="server"></Style:Style>
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <script type="text/javascript" src="../../General/Js/navigationmenu-jquery-latest.min.js"></script>
<script type="text/javascript" src="../../General/Js/navigationmenuscript.js"></script>

		<script type="text/javascript">
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
			result = result.replace("{" + (i-1) + "}", arguments[i]);
		}
		return result;
		};
		</script>
	<script type="text/javascript">
	    function ResendConfirm() {
	        return confirm(ResourceManager.GetString("ConfirmMessage.Resend"));
			}
        </script>
    </HEAD>
    <body bottomMargin="0" leftMargin="0" topMargin="0" onload="document.frmApplicationAuditing.cboFromDay.focus();"
        rightMargin="0" ms_positioning="FlowLayout">
        <form id="frmApplicationAuditing" method="post" runat="server">
            <table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr vAlign="top" align="center" width="100%">
                    <td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr vAlign="top" align="left" height="100%">
                    <!-- Left Navigation -->
        			<td class="ReportMenuContainer">
						<navigation:reportsmenu id="ucLeftMenu" runat="server"></navigation:reportsmenu>
					</td>
                    <!-- Body/Conent -->
                    <td width="90%">
						 <Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Email Sent Report</Localized:Localizedlabel><br />

						  <asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label><br /><br />
						  <table width="100%" align="left" border="0">
                            <tr>
                                <td align="center" colSpan="2"></td>
                            </tr>
                            <tr>
                            <td class="formLabel">
                            <Localized:LocalizedLabel id="lblSearchEmailSent" runat="server" />
                            </td>
                            </tr>
                            <tr height="5px" > 
                            </tr>
                            <tr>
                                <td class="formLabel">
                               
                                <Localized:LocalizedLabel id="lblDateFrom" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td><asp:dropdownlist id="cboFromDay" runat="server"></asp:dropdownlist><asp:dropdownlist id="cboFromMonth" runat="server"></asp:dropdownlist><asp:dropdownlist id="cboFromYear" runat="server"></asp:dropdownlist></td>
                            </tr>
                            <tr>
                                <td class="formLabel">
                                <Localized:LocalizedLabel id="lblDateTo" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td><asp:dropdownlist id="cboToDay" runat="server"></asp:dropdownlist>
                                <asp:dropdownlist id="cboToMonth" runat="server"></asp:dropdownlist>
                                <asp:dropdownlist id="cboToYear" runat="server"></asp:dropdownlist></td>
                            </tr>
                            <tr>
                                <td class="formLabel">
                               <Localized:LocalizedLabel id="lblRecip" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td><asp:textbox id="txtToEmail" runat="server" maxlength="50"></asp:textbox></td>
                            </tr>
                            <tr>
                                <td class="formLabel">
                                <Localized:LocalizedLabel id="lblSubject" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td><asp:textbox id="txtSubject" runat="server" maxlength="50"></asp:textbox></td>
                            </tr>
                            <tr>
                                <td class="formLabel">
                                <Localized:LocalizedLabel id="lblBody" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td><asp:textbox id="txtBody" runat="server" maxlength="100" textmode="MultiLine"></asp:textbox></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                               
                                <Localized:LocalizedButton ID="btnFind" Runat="server" CssClass="findButton"  Text="Find" onclick="btnFind_Click"></Localized:LocalizedButton>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:label id="lblSearchMessage" visible="False" runat="server"></asp:label>
                                    <br>
                                    <A href="/Administration/AdministrationHome.aspx">
                                   <Localized:LocalizedLiteral id="lnkReturn" key="cmnReturn"  runat="server"></Localized:LocalizedLiteral>
                                    </A>
                                </td>
                            </tr>
                            <tr>
                                <td colSpan="2"> <!-- Pagination -->
                                    <table id="tblPagination" width="100%" align="left" border="0" runat="server">
                                        <tbody>
                                            <tr>
                                                <td colSpan="2"><asp:datagrid id="grdPagination" runat="server" width="100%" allowsorting="True" borderstyle="Solid"
                                                        autogeneratecolumns="False" allowpaging="True">
                                                        <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                                                        <itemstyle cssclass="tablerow2"></itemstyle>
                                                        <headerstyle cssclass="tablerowtop"></headerstyle>
                                                        <columns>
                                                            <asp:boundcolumn datafield="DateCreated" sortexpression="DateCreated" headertext="Date Sent">
                                                                <headerstyle></headerstyle>
                                                            </asp:boundcolumn>
                                                            <asp:boundcolumn datafield="ToEmail" sortexpression="ToEmail" headertext="To">
                                                                <headerstyle></headerstyle>
                                                            </asp:boundcolumn>
                                                            <asp:boundcolumn datafield="Subject" sortexpression="Subject" headertext="Subject">
                                                                <headerstyle></headerstyle>
                                                            </asp:boundcolumn>
                                                            <asp:boundcolumn datafield="Body" sortexpression="Body" headertext="Body">
                                                                <headerstyle></headerstyle>
                                                            </asp:boundcolumn>
                                                            <asp:buttoncolumn headertext="Action" buttontype="LinkButton"
                                                                text="Resend" commandname="Resend" itemstyle-horizontalalign="Center" />
                                                        </columns>
                                                        <pagerstyle visible="False"></pagerstyle>
                                                    </asp:datagrid></td>
                                            </tr>
                                            <tr class="tablerowbot" id="trPagination" runat="server">
                                                <td align="left">
													<Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral> &nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;
													<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;
													<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>

                                                </td>
                                                <td align="right">
                                                
                                                <Localized:LocalizedLinkButton ID="btnPrev" runat="server" CausesValidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:LocalizedLinkButton>&nbsp;&nbsp;
                                               
                                                <Localized:LocalizedLinkButton ID="btnNext" Runat="server" CausesValidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:LocalizedLinkButton>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <!-- Pagination --></td>
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
</HTML>
