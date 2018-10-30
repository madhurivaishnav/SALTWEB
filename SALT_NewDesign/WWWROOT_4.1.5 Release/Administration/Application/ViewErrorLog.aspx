<%@ Page language="c#" Codebehind="ViewErrorLog.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.ViewErrorLog" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
    <head>
        <title>Error Log</title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
        <meta name="CODE_LANGUAGE" content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    </head>
    <body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
        <form id="Form2" method="post" runat="server">
            <table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
                <!-- Header -->
                <tr align="center" valign="top" width="100%">
                    <td align="center" valign="top" width="100%" colspan="2">
                        <navigation:header id="Header1" runat="server"></navigation:header>
                    </td>
                </tr>
                <tr height="100%" align="left" valign="top">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer">
                        <navigation:adminmenu id="ucadminMenu" runat="server"></navigation:adminmenu>
                    </td>
                    <!-- Body/Content -->
                    <td class="DataContainer">
                        <asp:label id="lblPageTitle" cssclass="pageTitle" runat="server">View Error Log</asp:label><br>
                        <table align="left" width="100%" border="0">
                            <tr>
                                <td align="left">
                                    <asp:placeholder id="plhErrorLog" runat="server">
                                        <a onclick="window.open('ViewErrorLogLegend.aspx','Legend','height=150,width=220,scrollbars=0')"
                                            href="#">View Legend</a>
                                        <asp:datagrid id="dgErrorLogResults" runat="server" gridlines="Horizontal" autogeneratecolumns="False">
                                            <itemstyle cssclass="tablerow1"></itemstyle>
                                            <alternatingitemstyle cssclass="tablerow2"></alternatingitemstyle>
                                            <headerstyle cssclass="tablerowtop"></headerstyle>
                                            <pagerstyle visible="False"></pagerstyle>
                                            <columns>
                                                <asp:templatecolumn visible="False">
                                                    <itemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "ErrorLogID").ToString()%>
                                                    </itemtemplate>
                                                </asp:templatecolumn>
                                                <asp:templatecolumn visible="False">
                                                    <itemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "ErrorLevel").ToString()%>
                                                    </itemtemplate>
                                                </asp:templatecolumn>
                                                <asp:templatecolumn headertext="Message">
                                                    <itemstyle width="200px"></itemstyle>
                                                    <itemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "Message").ToString()%>
                                                    </itemtemplate>
                                                    <edititemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "Message").ToString()%>
                                                    </edititemtemplate>
                                                </asp:templatecolumn>
                                                <asp:templatecolumn headertext="Details">
                                                    <itemstyle width="150px"></itemstyle>
                                                    <itemtemplate>
                                                    Date:<%# DataBinder.Eval(Container.DataItem, "DateCreated").ToString()%>
                                                    <br>
                                                    Source:<%# DataBinder.Eval(Container.DataItem, "Source").ToString()%>
                                                    <br>
                                                    Module:<%# DataBinder.Eval(Container.DataItem, "Module").ToString()%>
                                                    <br>
                                                    Function:<%# DataBinder.Eval(Container.DataItem, "Function").ToString()%>
                                                </itemtemplate>
                                                    <edititemtemplate>
                                                    Source:<%# DataBinder.Eval(Container.DataItem, "Source").ToString()%>
                                                    <br>
                                                    Module:<%# DataBinder.Eval(Container.DataItem, "Module").ToString()%>
                                                    <br>
                                                    Function:<%# DataBinder.Eval(Container.DataItem, "Function").ToString()%>
                                                </edititemtemplate>
                                                </asp:templatecolumn>
                                                <asp:templatecolumn headertext="Status">
                                                    <itemstyle width="80px"></itemstyle>
                                                    <itemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "ErrorStatusDescription").ToString()%>
                                                    </itemtemplate>
                                                    <edititemtemplate>
                                                        <asp:textbox id="txtErrorStatus" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "ErrorStatus").ToString()%>'>
                                                        </asp:textbox>
                                                        <asp:listbox id="lstErrorStatus" runat="server" datatextfield="ErrorStatusDescription" datavaluefield="ErrorStatusID"
                                                            rows="1" selectionmode="Single"></asp:listbox>
                                                    </edititemtemplate>
                                                </asp:templatecolumn>
                                                <asp:templatecolumn headertext="Level">
                                                    <itemstyle width="80px"></itemstyle>
                                                    <itemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "ErrorLevelDescription").ToString()%>
                                                    </itemtemplate>
                                                    <edititemtemplate>
                                                        <asp:textbox id="txtErrorLevel" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "ErrorLevel").ToString()%>'>
                                                        </asp:textbox>
                                                        <asp:listbox id="lstErrorLevel" runat="server" datatextfield="ErrorLevelDescription" datavaluefield="ErrorLevelID"
                                                            rows="1" selectionmode="Single"></asp:listbox>
                                                    </edititemtemplate>
                                                </asp:templatecolumn>
                                                <asp:templatecolumn headertext="Resolution">
                                                    <itemstyle width="150px"></itemstyle>
                                                    <itemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "Resolution").ToString()%>
                                                    </itemtemplate>
                                                    <edititemtemplate>
                                                        <asp:textbox id="txtResolution" runat="server" textmode="MultiLine" width="100%" height="100px" text='<%# DataBinder.Eval(Container.DataItem, "Resolution").ToString()%>'>
                                                        </asp:textbox>
                                                    </edititemtemplate>
                                                </asp:templatecolumn>
                                                <asp:editcommandcolumn edittext="Edit" canceltext="Cancel" updatetext="Update" headertext="Action"></asp:editcommandcolumn>
                                                <asp:buttoncolumn buttontype="LinkButton" commandname="View" text="View"></asp:buttoncolumn>
                                            </columns>
                                        </asp:datagrid>
                                    </asp:placeholder>
                                    <asp:placeholder id="plhErrorEntry" runat="server" visible="False">
                                        <table cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="tablerowtop" colspan="2">Error</td>
                                            </tr>
                                            <tr class="tablerow1">
                                                <td>Error Log ID</td>
                                                <td>
                                                    <asp:label id="lblErrorLogID" runat="server" width="100%"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow2">
                                                <td>Source</td>
                                                <td>
                                                    <asp:label id="lblSource" runat="server" textmode="MultiLine"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow1">
                                                <td>Module</td>
                                                <td>
                                                    <asp:label id="lblModule" runat="server" textmode="MultiLine"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow2">
                                                <td>Function</td>
                                                <td>
                                                    <asp:label id="lblFunction" runat="server" textmode="MultiLine"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow1">
                                                <td>Code</td>
                                                <td>
                                                    <asp:label id="lblCode" runat="server" textmode="MultiLine"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow2">
                                                <td>Message</td>
                                                <td>
                                                    <asp:label id="lblMessage" runat="server" textmode="MultiLine"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow1">
                                                <td>Stack Trace</td>
                                                <td>
                                                    <asp:label id="lblStackTrace" runat="server" textmode="MultiLine" height="100px"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow2">
                                                <td>Error Level</td>
                                                <td>
                                                    <asp:label id="lblErrorLevel" runat="server"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow1">
                                                <td>Error Status</td>
                                                <td>
                                                    <asp:label id="lblErrorStatus" runat="server"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow2">
                                                <td>Resolution</td>
                                                <td>
                                                    <asp:label id="lblResolution" runat="server" textmode="MultiLine" height="100px"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow1">
                                                <td>DateCreated</td>
                                                <td>
                                                    <asp:label id="lblDateCreated" runat="server"></asp:label></td>
                                            </tr>
                                            <tr class="tablerow2">
                                                <td>DateUpdated</td>
                                                <td>
                                                    <asp:label id="lblDateUpdated" runat="server"></asp:label></td>
                                            </tr>
                                        </table>
                                    </asp:placeholder>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- Footer -->
                <tr align="center" valign="bottom">
                    <td align="center" valign="middle" colspan="2">
                        <navigation:footer id="ucFooter" runat="server"></navigation:footer>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
