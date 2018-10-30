<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailDefault.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Application.EmailDefault" validateRequest="false" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="cc" Namespace="tinyMCE" Assembly="tinyMCE" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
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
	    function SaveConfirm()
	    {
	        return confirm(ResourceManager.GetString("ConfirmMessage.SaveValue"));
	    }
	    </script>
    </head>
    <body bottomMargin="0" leftMargin="0" topMargin="0" onload="document.frmApplicationAuditing.btnRunModuleStatusUpdate.focus();"
        rightMargin="0" ms_positioning="FlowLayout">
        <form id="frmApplicationAuditing" method="post" runat="server">
            <table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr vAlign="top" align="center" width="100%">
                    <td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr vAlign="top" align="left" height="100%">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
                    <!-- Body/Conent -->
                    <td class="DataContainer"><Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle"></Localized:Localizedlabel><br>
                        <table width="100%" align="left" border="0">
                            <tr>
                                <td>
                                    <asp:datagrid id="dgrConfig" runat="server" autogeneratecolumns="False" gridlines="Horizontal">
                                        <selecteditemstyle cssclass="tablerow2"></selecteditemstyle>
                                        <alternatingitemstyle cssclass="tablerow2"></alternatingitemstyle>
                                        <itemstyle cssclass="tablerow1"></itemstyle>
                                        <headerstyle cssclass="tablerowtop"></headerstyle>
                                        <pagerstyle visible="False"></pagerstyle>
                                        <columns>
                                            <asp:templatecolumn headertext="Name" visible="False">
                                                <itemtemplate>
                                                    <%# DataBinder.Eval(Container.DataItem, "Name").ToString()%>
                                                </itemtemplate>
                                                <edititemtemplate>
                                                    <%# DataBinder.Eval(Container.DataItem, "Name").ToString()%>
                                                </edititemtemplate>
                                            </asp:templatecolumn>
                                            <asp:templatecolumn headertext="Description">
                                                <itemtemplate>
                                                    <%# DataBinder.Eval(Container.DataItem, "Description").ToString()%>
                                                </itemtemplate>
                                                <edititemtemplate>
                                                    <%# DataBinder.Eval(Container.DataItem, "Description").ToString()%>
                                                </edititemtemplate>
                                            </asp:templatecolumn>
                                            <asp:templatecolumn headertext="Value">
                                                <itemtemplate>
                                                    <%# DataBinder.Eval(Container.DataItem, "Value").ToString()%>
                                                </itemtemplate>
                                                <edititemtemplate>
                                                    <%--<textarea cols="50" rows="15" id="txtValue_Edit" name="content" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Value").ToString()%>' >
                                                    </textarea>--%>
                                                    <cc:texteditor runat="server" name="content" id="txtValue_Edit" text='<%# DataBinder.Eval(Container.DataItem, "Value").ToString()%>' Mode="Full" />
                                                    <asp:textbox id="txtValue_Edit2" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Value").ToString()%>' width="100%" >
                                                    </asp:textbox>
                                                </edititemtemplate>
                                            </asp:templatecolumn>
                                            <asp:editcommandcolumn buttontype="LinkButton"  updatetext="Save" canceltext="Cancel" edittext="Customise"
                                                itemstyle-horizontalalign="Center" />
                                        </columns>
                                    </asp:datagrid>
                                </td>
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
