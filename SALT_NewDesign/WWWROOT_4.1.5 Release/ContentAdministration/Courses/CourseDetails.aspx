<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="CourseDetails.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ContentAdministration.Courses.ModifyCourse" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
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
                    result = result.replace("{" + (i - 1) + "}", arguments[i]);
                }
                return result;
            };
	    </script>
	    <script type="text/javascript">
	        function DeleteConfirm() {
	            return confirm(ResourceManager.GetString("ConfirmMessage.DeleteEBook"));
	        }
	        function NotifyUsersConfirm() {
	            return confirm(ResourceManager.GetString("ConfirmMessage.NotifyUsers"));
	        }
	    </script>
    </head>

    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout"
        onload="try{document.frmCourse.btnSave.focus();}catch(e){}">
        <form id="frmCourse" method="post" runat="server">
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr valign="top" align="center" width="100%">
                    <td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr valign="top" align="left" height="100%">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
                    <!-- Body/Conent -->
                    <td class="DataContainer"><Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">Course Details</Localized:Localizedlabel><br>
                        <Localized:Localizedlabel id="lblNoCourses" cssclass="FeedbackMessage" runat="server" visible="False">There are no courses</Localized:Localizedlabel>
                        <asp:placeholder id="plhMainScreen" runat="server">
                            <table width="95%" align="left" border="0">
                                <tr>
                                    <td class="formLabel"><Localized:LocalizedLabel id="lblCources" runat="server"></Localized:LocalizedLabel></td>
                                    <td>
                                        <asp:dropdownlist id="cboCourses" runat="server" autopostback="True" width="300" onselectedindexchanged="cboCourses_SelectedIndexChanged"></asp:dropdownlist></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td class="FeedbackMessage" align="left">
                                    <Localized:LocalizedLiteral id="litFeedbackMessage" runat="server"></Localized:LocalizedLiteral>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="formLabel"><Localized:LocalizedLabel id="lblName" key="cmnName" runat="server"></Localized:LocalizedLabel></td>
                                    <td>
                                        <asp:textbox id="txtName" runat="server" width="300" maxlength="100"></asp:textbox>
                                        <Localized:Localizedrequiredfieldvalidator id="rvldName" runat="server" cssclass="ValidatorMessage" controltovalidate="txtName"
                                            display="Dynamic" errormessage="You must specify the Course Name."></Localized:Localizedrequiredfieldvalidator></td>
                                </tr>
                                <tr>
                                    <td class="formLabel"><Localized:LocalizedLabel id="lblNotes" runat="server"></Localized:LocalizedLabel></td>
                                    <td>
                                        <asp:textbox id="txtNotes" runat="server" width="300" height="100" textmode="MultiLine"></asp:textbox>
                                        
                                        <Localized:Localizedrequiredfieldvalidator id="Requiredfieldvalidator1" runat="server" cssclass="ValidatorMessage" controltovalidate="txtNotes"
                                            display="Dynamic" errormessage="You must specify the Course Notes."></Localized:Localizedrequiredfieldvalidator></td>
                                </tr>
                                <tr>
                                    <td class="formLabel"><Localized:LocalizedLabel id="lblStatus" key="cmnStatus" runat="server"></Localized:LocalizedLabel></td>
                                    <td>
                                        <asp:dropdownlist id="cboStatus" runat="server">
                                            <asp:listitem value="1">Active</asp:listitem>
                                            <asp:listitem value="0">Inactive</asp:listitem>
                                        </asp:dropdownlist></td>
                                </tr>
                                <tr>
                                    <td class="formLabel"><Localized:LocalizedLabel id="lblEBook" runat="server"></Localized:LocalizedLabel></td>
                                    <td><br />
                                    <asp:label id="lblNoUploadedFile" runat="server"></asp:label>
                                    <asp:HyperLink ID="hypFile" runat="server"></asp:HyperLink><span style="margin-left: 50px;"><asp:label id="lblEBookDateUploaded" runat="server" /></span><span style="margin-left: 20px;"><Localized:LocalizedLinkButton ID="lnkDeleteEBook" OnClientClick="javascript:return DeleteConfirm();" OnClick="lnkDeleteEBook_Click" runat="server" /></span><br />
                                    
                                    <input style="margin: 15px 0px;" id="UploadFile_EBook" type="file" name="UploadFile_EBook" runat="server" /><asp:label id="lblUploadMessage" runat="server" enableviewstate="False" /><br />
                                    <Localized:LocalizedLinkButton ID="chkNotifyUsers" OnClientClick="javascript:return NotifyUsersConfirm();" OnClick="lnkNotifyUsers_Click" runat="server" /><br /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formLabel"><Localized:LocalizedLabel id="lblModules" runat="server"></Localized:LocalizedLabel></td>
                                    <td rowspan="2">
                                        <asp:datagrid id="grdModules" runat="server" width="90%" borderstyle="Solid" autogeneratecolumns="False"
                                            pagesize="5" allowpaging="True">
                                            <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                                            <itemstyle cssclass="tablerow2"></itemstyle>
                                            <columns>
                                                <asp:templatecolumn visible="False">
                                                    <headerstyle cssclass="tablerowtop"></headerstyle>
                                                    <itemtemplate>
                                                        <%# DataBinder.Eval(Container.DataItem, "ModuleID")%>
                                                    </itemtemplate>
                                                </asp:templatecolumn>
                                                <asp:templatecolumn headertext="Name">
                                                    <headerstyle cssclass="tablerowtop"></headerstyle>
                                                    <itemtemplate>
                                                        <a href='/ContentAdministration/Modules/ModuleDetails.aspx?ModuleID=<%# DataBinder.Eval(Container.DataItem, "ModuleID")%>'>
                                                            <%# DataBinder.Eval(Container.DataItem, "Name")%>
                                                        </a>
                                                    </itemtemplate>
                                                </asp:templatecolumn>
                                                <asp:buttoncolumn itemstyle-horizontalalign="center" text="Move Up" buttontype="LinkButton" commandname="MoveUp"
                                                    headerstyle-cssclass="tablerowtop" itemstyle-width="20%"></asp:buttoncolumn>
                                                <asp:buttoncolumn itemstyle-horizontalalign="center" text="Move Down" buttontype="LinkButton" commandname="MoveDown"
                                                    headerstyle-cssclass="tablerowtop" itemstyle-width="20%"></asp:buttoncolumn>
                                            </columns>
                                            <pagerstyle visible="False"></pagerstyle>
                                        </asp:datagrid></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td align="left">
                                        <Localized:Localizedbutton id="btnSave" key="cmnSave"  runat="server" cssclass="saveButton" text="Save" onclick="btnSave_Click"></Localized:Localizedbutton>&nbsp;
                                        <asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="2">
                                        <Localized:Localizedlinkbutton id="lnkReturnToAdminHomepage" key="cmnReturn" runat="server"
                                            causesvalidation="False" text="Return to Administration Homepage" onclick="lnkReturnToAdminHomepage_Click"></Localized:Localizedlinkbutton></td>
                                </tr>
                            </table>
                        </asp:placeholder>
                    </td>
                </tr>
                <!-- Footer -->
                <tr valign="bottom" align="center">
                    <td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
                </tr>
            </table>
        </form>
    </body>
</html>
