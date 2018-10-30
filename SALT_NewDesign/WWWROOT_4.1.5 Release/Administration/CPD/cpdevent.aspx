<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cpdevent.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.CPD.cpdevent" %>

<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title runat="server" id="pagTitle"></title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <Style:STYLE id="ucStyle" runat="server">
    </Style:STYLE>
   
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <script language="javascript" type="text/javascript">
        function popitup(url) {
        newwindow=window.open("../../ViewEvent.aspx?term=n&FileID=" + url,'name','height=600px,width=750px ,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes');
        if (window.focus) {newwindow.focus()}
        return false;
        }
   
      function Confirm() {
          var confirm_value = document.createElement("INPUT");
          confirm_value.type = "hidden";
          confirm_value.name = "confirm_value";
          if (confirm("Do you want to save data?")) {
              confirm_value.value = "Yes";
          } else {
              confirm_value.value = "No";
          }
          document.forms[0].appendChild(confirm_value);
      }

    </script>

</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <iframe id="PreventTimeout" src="/PreventTimeout.aspx" frameborder="no" width="0"
        height="0" runat="server" />
    <form id="frmPolicyDefault" method="post" runat="server">
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
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
            <td class="AdminMenuContainer">
                <navigation:adminmenu id="ucAdminMenu" runat="server">
                </navigation:adminmenu>
            </td>
            <!-- Body/Content -->
             <td class="DataContainer">
                <asp:Panel ID="panTitle" runat="server">
                    <table width="100%">
                        <tr>
                            <td>
                                <Localized:LocalizedLabel ID="lblPageTitle" runat="server" CssClass="pageTitle"></Localized:LocalizedLabel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblMessage" runat="server" Font-Bold="True" EnableViewState="False"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="panCPD" runat="server">
                    <table style="border-collapse: collapse" cellspacing="0" cellpadding="1" border="0"
                        width="100%">
                        <tr>
                            <td>
                                <asp:DataGrid ID="dgrCPD" runat="server" runat="server" AutoGenerateColumns="False"
                                    Width="100%" AllowPaging="True" >
                                    <SelectedItemStyle CssClass="tablerow2"></SelectedItemStyle>
                                    <AlternatingItemStyle CssClass="tablerow2"></AlternatingItemStyle>
                                    <ItemStyle CssClass="tablerow1"></ItemStyle>
                                    <HeaderStyle CssClass="tablerowtop"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Event ID" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEventID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EventID").ToString()%>'
                                                    Width="100%"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Profile Period ID" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEventPeriodID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EventPeriodID").ToString()%>'
                                                    Width="100%"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Event Name">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "EventName").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Assign to a CPD Profile" >
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "ProfileName").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="CPD Event Date" >
                                            <ItemTemplate>
                                                <asp:Label ID="lblCurrentDate" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Future Eventdate" >
                                            <ItemTemplate>
                                                <asp:Label ID="lblFutureDate" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Start Time" >
                                            <ItemTemplate>
                                                <asp:Label ID="lblStarttime" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="End Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblendtime" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Event Type" HeaderStyle-Width="170px">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "EventType").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Required Points">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "points").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Event Provider">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "EventProvider").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Event Location">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "EventLocation").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                       <%--  <asp:TemplateColumn HeaderText="Allow User to Upload File" HeaderStyle-Width="50px">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "AllowUser").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderText="File">
                                            <ItemTemplate>
                                              <a href="#">  <%# DataBinder.Eval(Container.DataItem, "FileName").ToString()%></a>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderText="Total Assignees">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "TotalUser").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Assign Event">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "Assignevent").ToString()%>&nbsp;
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="File">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "Files").ToString()%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--<asp:EditCommandColumn ButtonType="LinkButton" UpdateText="Save" HeaderText="Edit"
                                            CancelText="Cancel" EditText="Edit"></asp:EditCommandColumn>--%>
                                        <asp:TemplateColumn HeaderText="Action">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lnkedit" Text="Edit" runat="server" CommandName="Edit" CommandArgument="Edit"></asp:LinkButton>
                                                <asp:LinkButton ID="lnkcopy" Text="Copy" runat="server" CommandName="Copy" CommandArgument="Copy"></asp:LinkButton>
                                                <asp:LinkButton ID="lnkDelete" Text="Delete" runat="server" CommandName="Delete"
                                                    CommandArgument="Delete" OnClientClick="Confirm()"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle Visible="true"></PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <br>
                </asp:Panel>
                <table width="100%">
                    <tr>
                        <td align="right">
                            <a href="/Administration/CPD/AddCPDEventType.aspx" target="popup" onclick="window.open('/Administration/CPD/AddCPDEventType.aspx','popup','width=600px,height=600px'); return false;">
                                <Localized:LocalizedLiteral ID="lnkAddEventType" runat="server" Key="lnkAddEventType"></Localized:LocalizedLiteral>
                            </a>&nbsp; &nbsp; &nbsp;
                            <Localized:LocalizedButton ID="btnCreateEvent" runat="server" Width="150px" CssClass="saveButton"
                                Text="Create New Profile" Key="btnCreateProfile" OnClick="btnCreateEvent_Click">
                            </Localized:LocalizedButton>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <a href="/Administration/AdministrationHome.aspx">
                                <Localized:LocalizedLiteral ID="lnkReturnLink" runat="server" Key="cmnReturn"></Localized:LocalizedLiteral></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
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
