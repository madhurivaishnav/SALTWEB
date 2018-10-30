<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Page language="c#" Codebehind="OrganisationConfiguration.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.OrganisationConfiguration" ValidateRequest="false"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="cc" Namespace="tinyMCE" Assembly="tinyMCE" %>
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        
<%--        <script type="text/javascript" src="\General\Js\tiny_mce\tiny_mce.js"></script>
        <script type="text/javascript">
            tinyMCE.init({
                // General options
                mode: "textareas",
                theme: "advanced",
                plugins: "autolink,lists,spellchecker,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,imagemanager,filemanager",

                // Theme options
                theme_advanced_buttons1: "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
                theme_advanced_buttons2: "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
                theme_advanced_buttons3: "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
                theme_advanced_buttons4: "insertlayer,moveforward,movebackward,absolute,|,styleprops,spellchecker,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,blockquote,pagebreak,|,insertfile,insertimage",
                theme_advanced_toolbar_location: "top",
                theme_advanced_toolbar_align: "left",
                theme_advanced_statusbar_location: "bottom",
                theme_advanced_resizing: true,
                width: "100%",
                height: "400"
            });
        </script>--%>
    </head>
    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
        <form id="frmModifyLinks" method="post" runat="server">
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr valign="top" align="center" width="100%">
                    <td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr valign="top" align="left" height="100%">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
                    <!-- Body/Content -->
                   <td class="DataContainer">
                        <Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Configuration Values</Localized:Localizedlabel><br>
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
                                            <asp:templatecolumn headertext="Use Application Default Value">
                                                <itemstyle horizontalalign="Center"></itemstyle>
                                                <headerstyle horizontalalign="Center"></headerstyle>
                                                <itemtemplate>
                                                    <asp:checkbox id="chkDefault" enabled="False" runat="server" checked='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "default"))%>'>
                                                    </asp:checkbox>
                                                </itemtemplate>
                                            </asp:templatecolumn>
                                            <asp:templatecolumn visible="False">
                                                <itemtemplate>
                                                    <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "default"))%>
                                                </itemtemplate>
                                                <edititemtemplate>
                                                    <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "default"))%>
                                                </edititemtemplate>
                                            </asp:templatecolumn>
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
                                            <asp:buttoncolumn buttontype="LinkButton" text="Revert To Default" commandname="Delete" itemstyle-horizontalalign="Center" />
                                        </columns>
                                    </asp:datagrid>
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
